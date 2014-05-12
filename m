Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:25612 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758562AbaELN0Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 09:26:25 -0400
Message-ID: <5370CBFF.8060206@broadcom.com> (sfid-20140512_152628_750709_A7FA29CF)
Date: Mon, 12 May 2014 15:26:23 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Subject: P2P GO operating channel width
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes, Jouni,

I was wondering how to configure the bandwidth of the operating channel 
in P2P-GO scenario. In nl80211.c I do see the use of .set_ap_chanwidth() 
callback. Reading the spec it seems the operating channel is exchanged 
during GO negotiation, but I do not see any reference about the 
bandwidth. It does exchange the operating class and I found some info in 
p2p_supplicant.c (see below). I am just not sure how this is configured 
to the driver, ie. what nl80211 commands will be used.

Gr. AvS
--8<------------------------------------------------------------
static struct p2p_oper_class_map op_class[] = {
	{ HOSTAPD_MODE_IEEE80211G, 81, 1, 13, 1, BW20 },
#if 0 /* Do not enable HT40 on 2 GHz for now */
	{ HOSTAPD_MODE_IEEE80211G, 83, 1, 9, 1, BW40PLUS },
	{ HOSTAPD_MODE_IEEE80211G, 84, 5, 13, 1, BW40MINUS },
#endif
	{ HOSTAPD_MODE_IEEE80211A, 115, 36, 48, 4, BW20 },
	{ HOSTAPD_MODE_IEEE80211A, 124, 149, 161, 4, BW20 },
	{ HOSTAPD_MODE_IEEE80211A, 116, 36, 44, 8, BW40PLUS },
	{ HOSTAPD_MODE_IEEE80211A, 117, 40, 48, 8, BW40MINUS },
	{ HOSTAPD_MODE_IEEE80211A, 126, 149, 157, 8, BW40PLUS },
	{ HOSTAPD_MODE_IEEE80211A, 127, 153, 161, 8, BW40MINUS },
	{ HOSTAPD_MODE_IEEE80211A, 128, 36, 161, 4, BW80 },
	{ -1, 0, 0, 0, 0, BW20 }
};
