Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tranquility.mcc.ac.uk ([130.88.200.145]:61520 "EHLO
	tranquility.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbXKUOYg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 09:24:36 -0500
Message-ID: <47443F78.60701@gentoo.org> (sfid-20071121_142439_779059_03D13906)
Date: Wed, 21 Nov 2007 14:23:52 +0000
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, David Miller <davem@davemloft.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Daniel Drake <dsd@gentoo.org>, jt@hpl.hp.com
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
References: <4740DF47.4040206@hotmail.com> <20071119.002755.77617097.davem@davemloft.net> <1195484582.8642.18.camel@johannes.berg> <20071119180423.GA19250@bougret.hpl.hp.com> <47443035.1070702@hotmail.com> <474432E8.90304@hotmail.com>
In-Reply-To: <474432E8.90304@hotmail.com>
Content-Type: multipart/mixed;
 boundary="------------050902090205070007060302"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050902090205070007060302
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Shaddy Baddah wrote:
> Interestingly, after performing the above actions, I am now getting 
> additional log messages:
> 
> SoftMAC: Open Authentication completed with GG:GG:GG:GG:GG:GG
> Kernel unaligned access at TPC[100df410] 
> ieee80211softmac_handle_assoc_response]
> Kernel unaligned access at TPC[100df548] 
> ieee80211softmac_handle_assoc_response]

This one doesn't include any offsets, did the line get cut off?

I'm spoilt by the luxuries of i386/x86_64 and am not clear on exactly 
what forms an unaligned access. I am wondering if this line is causing it:

	network = ieee80211softmac_get_network_by_bssid_locked(mac, 
resp->header.addr3);

addr3 is offset 20 bytes in the struct and is 6 bytes long. Because 20 
is not evenly divisible by 6 does that make it an unaligned access?

Is there any documentation I can read on this topic? In my current 
uneducated state I'm likely to write further code with these problems...

> ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
> Kernel unaligned access at TPC[100d03ec] ieee80211_copy_snap+0x74/0x78 
> [ieee802]
> Kernel unaligned access at TPC[100d03ec] ieee80211_copy_snap+0x74/0x78 
> [ieee802]
> Kernel unaligned access at TPC[100d03ec] ieee80211_copy_snap+0x74/0x78 
> [ieee802]
> Kernel unaligned access at TPC[100d03ec] ieee80211_copy_snap+0x74/0x78 
> [ieee802]
> Kernel unaligned access at TPC[100d03ec] ieee80211_copy_snap+0x74/0x78 
> [ieee802]

This one should be fixed by the attached patch. Sorry for not sending it 
sooner, the contributor has not yet solved all problems and I was 
waiting to see if more patches would come.

> Kernel unaligned access at TPC[100ee624] do_rx+0x394/0x5ec [zd1211rw]
> Kernel unaligned access at TPC[100ee62c] do_rx+0x39c/0x5ec [zd1211rw]
> Kernel unaligned access at TPC[100ee638] do_rx+0x3a8/0x5ec [zd1211rw]
> Kernel unaligned access at TPC[100ee668] do_rx+0x3d8/0x5ec [zd1211rw]
> Kernel unaligned access at TPC[100ee670] do_rx+0x3e0/0x5ec [zd1211rw]

These might be solved by the patch David sent to the list a few days ago 
(thanks!). Have you applied it? If you can confirm it helps I will send 
it up through John.

Thanks,
Daniel


--------------050902090205070007060302
Content-Type: text/plain;
 name="ieee80211-copy-snap.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ieee80211-copy-snap.patch"

[PATCH] ieee80211: fix unaligned access in ieee80211_copy_snap

From: Daniel Drake <dsd@gentoo.org>

Based on a patch from Jun Sun.

Signed-off-by: Daniel Drake <dsd@gentoo.org>

diff --git a/net/ieee80211/ieee80211_tx.c b/net/ieee80211/ieee80211_tx.c
index a4c3c51..6d06f13 100644
--- a/net/ieee80211/ieee80211_tx.c
+++ b/net/ieee80211/ieee80211_tx.c
@@ -144,7 +144,8 @@ static int ieee80211_copy_snap(u8 * data, u16 h_proto)
 	snap->oui[1] = oui[1];
 	snap->oui[2] = oui[2];
 
-	*(u16 *) (data + SNAP_SIZE) = htons(h_proto);
+	h_proto = htons(h_proto);
+	memcpy(data + SNAP_SIZE, &h_proto, sizeof(u16));
 
 	return SNAP_SIZE + sizeof(u16);
 }

--------------050902090205070007060302--
