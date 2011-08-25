Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60822 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab1HYSRK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 14:17:10 -0400
Received: by pzk37 with SMTP id 37so2854080pzk.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 11:17:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f72a42677c7419161cc9b7f79d93e812@secure.sipsolutions.net>
References: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
 <1314236452-7226-2-git-send-email-thomas@cozybit.com> <f72a42677c7419161cc9b7f79d93e812@secure.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 25 Aug 2011 11:16:50 -0700
Message-ID: <CAPjQAd_Wxpu=Kt6+PKcffNiqredMpPZ2-xWrq_jSsSCzNLBvZQ@mail.gmail.com> (sfid-20110825_201714_809425_5CCE4666)
Subject: Re: [PATCH 1/9] mac80211: Fix RCU pointer dereference in mesh_path_discard_frame()
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 24, 2011 at 7:08 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 24 Aug 2011 18:40:44 -0700, Thomas Pedersen wrote:
>
>>                da = hdr->addr3;
>>                ra = hdr->addr1;
>> +               rcu_read_lock();
>>                mpath = mesh_path_lookup(da, sdata);
>> +               rcu_read_unlock();
>>                if (mpath)
>>                        sn = ++mpath->sn;
>>                mesh_path_error_tx(sdata->u.mesh.mshcfg.element_ttl,
>> skb->data,
>
> You've got to be kidding. Didn't I just explain RCU :)

The patch was prepared before your RCU session :(
Just to confirm I got it right before we resubmit: given that not only
the path table accessed inside mesh_path_lookup() but also the mpaths
themselves are RCU protected, the right fix should have been

               da = hdr->addr3;
               ra = hdr->addr1;
+             rcu_read_lock();
               mpath = mesh_path_lookup(da, sdata);
               if (mpath)
                       sn = ++mpath->sn;
+             rcu_read_unlock();
               mesh_path_error_tx(sdata->u.mesh.mshcfg.element_ttl, skb->data,

Correct?

Thanks!

Javier
