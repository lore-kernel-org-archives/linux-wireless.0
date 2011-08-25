Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:33944 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab1HYTFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 15:05:09 -0400
Received: by pzk37 with SMTP id 37so2920492pzk.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 12:05:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <98bfce172924dfc22c4e69fbfb5e117a@secure.sipsolutions.net>
References: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
 <1314236452-7226-2-git-send-email-thomas@cozybit.com> <f72a42677c7419161cc9b7f79d93e812@secure.sipsolutions.net>
 <CAPjQAd_Wxpu=Kt6+PKcffNiqredMpPZ2-xWrq_jSsSCzNLBvZQ@mail.gmail.com>
 <5d9c06a899229693c241d11aeb88dc90@secure.sipsolutions.net>
 <CAPjQAd9gdreTe-wYFV+fg7X9opZ-m4EeBiqM5r_nBQ_jNrV_zA@mail.gmail.com> <98bfce172924dfc22c4e69fbfb5e117a@secure.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 25 Aug 2011 12:04:49 -0700
Message-ID: <CAPjQAd_MLEsPH9mrLeW01=_SehhXvajSGPJnx9wxguS+gS+Lxw@mail.gmail.com> (sfid-20110825_210514_029535_8555BB5F)
Subject: Re: [PATCH 1/9] mac80211: Fix RCU pointer dereference in mesh_path_discard_frame()
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 25, 2011 at 11:48 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 25 Aug 2011 11:45:11 -0700, Javier Cardona wrote:
>>
>> On Thu, Aug 25, 2011 at 11:21 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>>>
>>> On Thu, 25 Aug 2011 11:16:50 -0700, Javier Cardona wrote:
>>>>
>>>> On Wed, Aug 24, 2011 at 7:08 PM, Johannes Berg
>>>> <johannes@sipsolutions.net> wrote:
>>>>>
>>>>> On Wed, 24 Aug 2011 18:40:44 -0700, Thomas Pedersen wrote:
>>>>>
>>>>>>                da = hdr->addr3;
>>>>>>                ra = hdr->addr1;
>>>>>> +               rcu_read_lock();
>>>>>>                mpath = mesh_path_lookup(da, sdata);
>>>>>> +               rcu_read_unlock();
>>>>>>                if (mpath)
>>>>>>                        sn = ++mpath->sn;
>>>>>>                mesh_path_error_tx(sdata->u.mesh.mshcfg.element_ttl,
>>>>>> skb->data,
>>>>>
>>>>> You've got to be kidding. Didn't I just explain RCU :)
>>>>
>>>> The patch was prepared before your RCU session :(
>>>> Just to confirm I got it right before we resubmit: given that not only
>>>> the path table accessed inside mesh_path_lookup() but also the mpaths
>>>> themselves are RCU protected, the right fix should have been
>>>>
>>>>               da = hdr->addr3;
>>>>               ra = hdr->addr1;
>>>> +             rcu_read_lock();
>>>>               mpath = mesh_path_lookup(da, sdata);
>>>>               if (mpath)
>>>>                       sn = ++mpath->sn;
>>>> +             rcu_read_unlock();
>>>>               mesh_path_error_tx(sdata->u.mesh.mshcfg.element_ttl,
>>>> skb->data,
>>>>
>>>> Correct?
>>>
>>> Frankly, I'm not sure, since you modify the mpath->sn you probably need
>>> to
>>> hold a real lock, otherwise ++mpath->sn can race against itself in this
>>> very
>>> function.
>>
>> Oh, I see.  That's a different issue from what I was originally trying
>> to fix (unprotected access to the path table inside the lookup
>> function).  But you are completely right.  Changing the math sequence
>> number requires taking the mpath state lock:
>>
>>             da = hdr->addr3;
>>             ra = hdr->addr1;
>> +           rcu_read_lock();
>>             mpath = mesh_path_lookup(da, sdata);
>> -             if (mpath)
>> +             if (mpath) {
>> +                    spin_lock_bh(&mpath->state_lock);
>>                      sn = ++mpath->sn;
>> +                    spin_unlock_bh(&mpath->state_lock);
>> +           }
>> +           rcu_read_unlock();
>>             mesh_path_error_tx(sdata->u.mesh.mshcfg.element_ttl,
>> skb->data,
>
> Seems about right to me, but I don't know about all the locking :)

After your RCU session I went back to the path table module and
reviewed the locking.  That's what triggered some the patches on the
set:
http://thread.gmane.org/gmane.linux.kernel.wireless.general/75812/focus=75816
http://thread.gmane.org/gmane.linux.kernel.wireless.general/75812/focus=75818
http://thread.gmane.org/gmane.linux.kernel.wireless.general/75812/focus=75820

Mesh path tables and mpaths are protected by RCU.
The internal state of each mpath is protected by mpath->state_lock.
And there's a lock for each bucket on the mesh path tables.

Thanks!

Javier
