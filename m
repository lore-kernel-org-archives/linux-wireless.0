Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:33697 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371AbcGHPWJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 11:22:09 -0400
Received: by mail-pa0-f66.google.com with SMTP id ts6so7986128pac.0
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jul 2016 08:22:08 -0700 (PDT)
Subject: Re: [PATCH 0/5] Improve wireless netdev detection
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1467875330-7835-1-git-send-email-denkenz@gmail.com>
 <1467973953.4837.3.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <577FC51E.7010901@gmail.com> (sfid-20160708_172231_331185_AFBB8572)
Date: Fri, 8 Jul 2016 10:22:06 -0500
MIME-Version: 1.0
In-Reply-To: <1467973953.4837.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 07/08/2016 05:32 AM, Johannes Berg wrote:
> On Thu, 2016-07-07 at 02:08 -0500, Denis Kenzior wrote:
>> The current mechanism to detect hot-plug / unplug of wireless devices
>> is
>> somewhat arcane.  One has to listen to NEW_WIPHY/DEL_WIPHY events
>> over
>> nl80211 as well as RTM_NEWLINK / RTM_DELLINK events over rtnl, then
>> somehow find a correlation between these events.  This involves
>> userspace
>> sending GET_INTERFACE or GET_WIPHY commands to the kernel, which
>> incurs
>> additional roundtrips.
>>
>> This patch series proposes that NEW_INTERFACE and DEL_INTERFACE
>> events are
>> always emitted, regardless of whether a netdev was added/removed by
>> the
>> driver or explicitly via NEW_INTERFACE/DEL_INTERFACE commands.
>>
>> One side effect of this approach is that multiple
>> NEW_INTERFACE/DEL_INTERFACE
>> events might be generated for P2P interfaces.  Once when a wdev is
>> created
>> or destroyed, and once when the associated p2p netdev is connecte or
>> disconnected.
>
> I think you got some things mixed up. Are you talking of P2P GO/client
> interfaces, which have netdevs, but are really the same as AP/BSS
> client and thus the issue here would affect the others? Or are you
> talking about the P2P-Device wdev? but that has no netdev.

Apologies, I've only been looking at the kernel side for several days, 
so my understanding is still incomplete.

I was looking at mac80211/iface.c: ieee80211_if_add() which seems to 
handle NL80211_IFTYPE_P2P_DEVICE specially by not creating/registering a 
net_device object.  For some reason I thought that this object was 
registered somewhere later, but my understanding was incorrect.  So the 
entire 'side effect' paragraph above does not apply.

Are you okay with the general approach?  Are there any locking issues I 
might be overlooking?

>
>> It is likely that only the caller of P2P oriented
>> NEW_INTERFACE / DEL_INTERFACE commands is interested in the status of
>> these
>> operations.  E.g. the caller is / should be using SOCKET_OWNER
>> attribute.
>> Thus one possibility is to not emit NEW_INTERFACE/DEL_INTERFACE
>> events in
>> such cases.
>>
>
> The breaking up of patches is also confusing. You seem to be
> introducing things in the first, then breaking them again, and then
> fixing them?

Sorry, this was meant to be posted as an RFC.

First patch just introduces a notification utility.  The rest of the 
patches were broken up for ease of review.

>
> Couldn't the whole thing be done in one or maybe two (new/del)
> patch(es)?

Sure, I can squash them together however you like.

>
> (You obviously also need to sign off your patches, see the kernel
> Documentation/)
>

Apologies, still working the kinks out of my environment setup.

Regards,
-Denis

