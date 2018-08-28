Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 7.mo68.mail-out.ovh.net ([46.105.63.230]:44065 "EHLO
        7.mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbeH1XFg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 19:05:36 -0400
Received: from player763.ha.ovh.net (unknown [10.109.146.19])
        by mo68.mail-out.ovh.net (Postfix) with ESMTP id 99741F1686
        for <linux-wireless@vger.kernel.org>; Tue, 28 Aug 2018 21:02:38 +0200 (CEST)
Subject: Re: [PATCH v6 1/3] nl80211: Add ATOMIC_KEY_REPLACE API
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
References: <20180814104255.4183-1-alexander@wetzel-home.de>
 <20180814104255.4183-2-alexander@wetzel-home.de>
 <1535446026.5895.5.camel@sipsolutions.net>
 <4cc30aa2-6235-f76c-485f-48fac8af3c1a@wetzel-home.de>
 <1535472226.5895.58.camel@sipsolutions.net>
From: Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <e75b4c84-2183-8f77-e9ca-38950a2b3cdc@wetzel-home.de> (sfid-20180828_211236_933859_57A84394)
Date: Tue, 28 Aug 2018 21:02:26 +0200
MIME-Version: 1.0
In-Reply-To: <1535472226.5895.58.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 28.08.18 um 18:03 schrieb Johannes Berg:
> On Tue, 2018-08-28 at 18:00 +0200, Alexander Wetzel wrote:
> 
>>> If you have a flag here, why say "userspace must not" rather than just
>>> outright prevent userspace from doing it?
>>
>> The userspace must not but currently of course is doing exactly that.
>> Enforcing the new requirement would therefore cause user visible
>> regressions till all drivers have been updated or the updated userspace
>> software is deployed on all systems... Both will take years.
>>
>> So the current approach is keep backward compatibility to not break
>> rekeys for users it's currently working for.
> 
> Yeah but is it really working for them? They might have it "working",
> but leak some frames in clear, like we said? So it might work for all
> they notice, but leak frames once a while? I don't see how that's better
> really.

The %DISABLE_KEY and %SET_KEY commands are now much closer together and
mac80211 is stopping handing over frames needing the key till %SET_KEY
has been completed and we call flush() when the driver has implemented
it. So to still leak clear text packets a driver must have botched up
%DISABLE_KEY and not offering flush() to have a chance to still leak
clear text and even then should only leak a fraction of the packets it
would leak unpatched.
Of course that's still far from ideal and I the secure decision would be
to accept the user visible impact (e.g. prompting for the PSK again or
needing ~30s for the wlan to reconnect). But then my understanding was,
that the kernel never must break the userspace and we don't have that
option.

>From a high level point it looks like we only have these choices from
where we are today

1) Accept rekeys even when the driver is not signaling support for it,
   allowing the drivers and the userspace to catch up to API changes.
   (And then start enforcing it when it looks safe to do so.)

2) Deny rekey, fundamentally changing how the issue looks for users
   currently using rekeys. (Which may be none or millions, no data
   available. But there are some EAP Enterprise systems from Cisco
   having that enabled by default.)

3) Do not fix anything - not even the parts we can - and continue to
   wait for "Extended Key ID for Individually Addressed Frames" to
   catch on.

4) Implement complex code able to trick different userspaces into the
   desired behavior (and probably failing for unknown ones).

This is basically resuming the discussion we had with the v2 version of
the patch, so here the relevant part of our older discussion:

>>>> So I think we're probably better off accepting the set_key but not
>>>> actually using it, and instead disconnecting... even if that's awkward
>>>> and should come with a big comment :-)
>>>
>>> Instead of returning an error I'll change the code to accept the rekey
>>> but do nothing with it. (Basically delete the new key and keep the old
>>> active).
>>> And of course calling ieee80211_set_disassoc() prior to return
"success".
>>
>> Right. Did you handle/consider modes other than BSS/P2P client btw?
>
> I've tested that on a client only and it's already not working. Problem
> is, that with ieee80211_set_disassoc() we just dump the association in
> the kernel and are not informing the userspace, so the state machine is
> stuck in "connected" but the STA is unable to communicate.
>
> I also tried ieee80211_mgd_deauth():
> While better this is basically the same behaviour as returning an error
> on key replace. By setting the error code to inactivity at least
> wpa_supplicant was actually starting to reconnect, unfortunatelly
> set_key then failes since we purged the assosication in the kernel. (Or
> that's my best interpretation from the logs). Networkmanager then again
> prompted for the password...
>
> I started experimenting with just signals to the userspace, but then
> paused... Trying to control the state machine with spoofed errors trying
> to trigger an "desireable" action can't be the way forward, can it?
>
> Even if we get that working changes or different implementations in
> userspace may well break it.
>
> I now think we only have two reasonable ways forward:
>
> 1) The user friendly one: If the userspace does not know about the new
> API just print a error message and do the insecure key replace. With
> potential clear text packet leaks and connection freezes.
>
> 2) The secure way: Report an error on key install and accept that users
> will encounter new problems when they are using rekeys with the old API
> with "old" userspace software.
>
> Since we have this issue in the kernel at least as long as we have
> mac80211 I would vote for 1) here. Fix mac80211 and add a new way for
> the userspace to to securely replace the keys and detect when this is
> not possible. Then get the userspace software updated to act
> accordingly, finally preventing the clear text packet leaks.
>
> After some time we can then decide to reject insecure rekeys, burning
> only those who use kernels much newer than the userspace.
>
> Does this sound like an reasonable approch or should I go back figuring
> out how to trick the userspace to reconnect without user
> notification/intervention?

My current preference is how the patch v6 is working and I'm quite sure
there is no acceptable way to trick the userspace.
Am I wrong here and we should try something different?

Alexander
