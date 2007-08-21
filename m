Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:33404 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808AbXHUE7h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 00:59:37 -0400
Message-ID: <46CA7127.1070904@lwfinger.net>
Date: Mon, 20 Aug 2007 23:59:19 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>, Michael Buesch <mb@bu3sch.de>,
	Michael Wu <flamingice@sourmilk.net>,
	Jiri Benc <jbenc@suse.cz>,
	Volker Braun <volker.braun@physik.hu-berlin.de>
Subject: Re: [RFC] mac80211: fix software decryption
References: <1187346385.23489.157.camel@johannes.berg>
In-Reply-To: <1187346385.23489.157.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> When doing key selection for software decryption, mac80211 gets
> a few things wrong: it always uses pairwise keys if configured,
> even if the frame is addressed to a multicast address. Also, it
> doesn't allow using a key index of zero if a pairwise key has
> also been found.
> 
> This patch changes the key selection code to be (more) in line
> with the 802.11 specification. I have confirmed that with this,
> multicast frames are correctly decrypted and I've tested with
> WEP as well.
> 
> While at it, I've cleaned up the semantics of the hardware flags
> IEEE80211_HW_WEP_INCLUDE_IV and IEEE80211_HW_DEVICE_HIDES_WEP
> and clarified them in the mac80211.h header; it is also now
> allowed to set the IEEE80211_HW_DEVICE_HIDES_WEP option even if
> it only applies to frames that have been decrypted by the hw,
> unencrypted frames must be dropped but encrypted frames that
> the hardware couldn't handle can be passed up unmodified.
> 
> Support for group keys in IBSS mode is pending until we figure
> out how to handle that. It will also, like with VLANs, require
> a hardware encryption API change.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> 
> ---
> Michael, you should really get rid of IEEE80211_HW_DEVICE_HIDES_WEP
> in b43, otherwise you'll have to start dropping unencrypted
> frames and handle 802.1X callbacks and stuff to guarantee
> proper operation.
> 
> I would be much in favour of removing the option completely,
> it's IMHO misused in b43 and no other driver uses it.
> 
> Volker, can you test whether this patch (possibly together with
> yours removing privacy and key index checking) helps with your
> dynamic WEP? I think it should.
> 
> Larry, could you verify that this gets rid of your messages? It
> does for me but then I'm using CCMP and not TKIP so maybe there's
> something special again.

Using the large patch you sent me plus the one that fixed the crash due to usage after freeing, I 
can now connect using both WPA and WEP. My settings for the hw->flags is

        hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
                     IEEE80211_HW_DEVICE_HIDES_WEP | IEEE80211_HW_WEP_INCLUDE_IV;

With WPA, I no longer get those messages; however, I get a lot of those "No ProbeResp" messages with 
a subsequent reassociation rather often as shown in my log fragment below:

Aug 20 23:49:21 larrylap kernel: eth1: No ProbeResp from current AP 00:1a:70:46:ba:b1 - assume out 
of range
Aug 20 23:49:22 larrylap kernel: eth1: No STA entry for own AP 00:1a:70:46:ba:b1
Aug 20 23:49:22 larrylap kernel: eth1: Initial auth_alg=0
Aug 20 23:49:22 larrylap kernel: eth1: authenticate with AP 00:1a:70:46:ba:b1
Aug 20 23:49:22 larrylap kernel: eth1: RX authentication from 00:1a:70:46:ba:b1 (alg=0 transaction=2 
status=0)
Aug 20 23:49:22 larrylap kernel: eth1: authenticated
Aug 20 23:49:22 larrylap kernel: eth1: associate with AP 00:1a:70:46:ba:b1
Aug 20 23:49:22 larrylap kernel: eth1: RX ReassocResp from 00:1a:70:46:ba:b1 (capab=0x431 status=0 
aid=1)
Aug 20 23:49:22 larrylap kernel: eth1: associated
Aug 20 23:50:23 larrylap kernel: eth1: No ProbeResp from current AP 00:1a:70:46:ba:b1 - assume out 
of range
Aug 20 23:50:24 larrylap kernel: eth1: No STA entry for own AP 00:1a:70:46:ba:b1
Aug 20 23:50:24 larrylap kernel: eth1: Initial auth_alg=0
Aug 20 23:50:24 larrylap kernel: eth1: authenticate with AP 00:1a:70:46:ba:b1
Aug 20 23:50:24 larrylap kernel: eth1: RX authentication from 00:1a:70:46:ba:b1 (alg=0 transaction=2 
status=0)
Aug 20 23:50:24 larrylap kernel: eth1: authenticated
Aug 20 23:50:24 larrylap kernel: eth1: associate with AP 00:1a:70:46:ba:b1
Aug 20 23:50:24 larrylap kernel: eth1: RX ReassocResp from 00:1a:70:46:ba:b1 (capab=0x431 status=0 
aid=1)
Aug 20 23:50:24 larrylap kernel: eth1: associated

Thanks,

Larry


