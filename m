Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:46612 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689Ab2LLWQh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 17:16:37 -0500
Received: by mail-ie0-f181.google.com with SMTP id 16so3044107iea.12
        for <linux-wireless@vger.kernel.org>; Wed, 12 Dec 2012 14:16:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355346934.9708.17.camel@jlt4.sipsolutions.net>
References: <CAMcMvshyr6p2dqv-4YKW3=ZqLXskqvOtR9E4+UGOM4pzzJumgg@mail.gmail.com>
	<1355346934.9708.17.camel@jlt4.sipsolutions.net>
Date: Wed, 12 Dec 2012 14:09:11 -0800
Message-ID: <CAMcMvsid-g4LticD+LcpvP4jaEQrsYy09gjcqtt0=_PMxFuxtQ@mail.gmail.com> (sfid-20121212_231648_581476_AA70B705)
Subject: Re: Question about "authorized state" test in tx.c
From: Paul Stewart <pstew@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 12, 2012 at 1:15 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2012-12-12 at 13:08 -0800, Paul Stewart wrote:
>> The "unauthorized port" test in ieee80211_subif_start_xmit reads as follows:
>>
>>         /*
>>          * Drop unicast frames to unauthorised stations unless they are
>>          * EAPOL frames from the local station.
>>          */
>>         if (unlikely(!ieee80211_vif_is_mesh(&sdata->vif) &&
>>                      !is_multicast_ether_addr(hdr.addr1) && !authorized &&
>>                      (cpu_to_be16(ethertype) != sdata->control_port_protocol ||
>>                       !ether_addr_equal(sdata->vif.addr, skb->data + ETH_ALEN)))
>> ) {
>> #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
>>                 net_info_ratelimited("%s: dropped frame to %pM (unauthorized por
>> t)\n",
>>                                     dev->name, hdr.addr1);
>> #endif
>>
>>   [...]
>>
>> Was it explicitly meant to allow multicast/broadcast frames while not
>> authorized?  I'm starting to see isolated cases in packet traces where
>> APs deauth clients due to errant broadcasts being sent during/before
>> the 4-way handshake, after association.  Are there situations where
>> these broadcasts / multicasts should be allowed, or would it be
>> acceptable to drop the multicast check?  The change which introduced
>> it is
>> 7d185b8bb17eac9e9d673eb483ded0fbf0b28b97, but I don't quite understand
>> it since if we're not authenticated to the AP, should we still be
>> allowed to send (non-authentication) traffic to it?
>
> That commit was meant for AP mode, and in managed mode hdr.addr1 should
> never be a multicast address. Any idea how that happens?

Good point.  I mistook that for the Ethernet addr1.  Moreover, looking
at the packet capture, this is a "from DS to STA" frame, which implies
I compeltely mistook where this frame originated from (either that or
something much stranger is happening).  Needless to say, I should look
a lot more closely at this before presuming that the problem lies
here.

--
Paul
>
> johannes
>
