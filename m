Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:58631 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbYBKSwl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2008 13:52:41 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] mac80211: give burst time in txop rather than 0.1msec units
Date: Mon, 11 Feb 2008 19:52:30 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1202658578.11481.4.camel@johannes.berg>
In-Reply-To: <1202658578.11481.4.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ulJsH4zixaEefeb"
Message-Id: <200802111952.30964.chunkeey@web.de> (sfid-20080211_185245_836655_540EB93F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_ulJsH4zixaEefeb
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 10 February 2008 16:49:38 Johannes Berg wrote:

> Michael (Wu), the p54 driver has some values that differ from
> the 802.11 spec, is that intentional?
>

> +	/*
> +	 * FIXME: The default values in the spec (IEEE 802.11
> +	 *	  7.3.2.19 Table 37) are 47, 94, 0, 0, why use
> +	 *	  47, 94, 63, 0 here? Also, the default AIFS
> +	 *	  values (second parameter) are 2, 2, 3, 7...
> +	 */
Well, these values are the defaults of the original driver from conexant.
As far as I know it has something to do with the "proprietary" frameburst
feature (aka PRISM NITRO)...=20

So on-topic: IEEE 802.11 defaults are fine. Drop the "FIXME".=20

> +	P54_SET_QUEUE(vdcf->queue[0], 0x0002, 0x0003, 0x0007, 47);
> +	P54_SET_QUEUE(vdcf->queue[1], 0x0002, 0x0007, 0x000f, 94);
> +	P54_SET_QUEUE(vdcf->queue[2], 0x0003, 0x000f, 0x03ff, 0);
> +	P54_SET_QUEUE(vdcf->queue[3], 0x0007, 0x000f, 0x03ff, 0);

and off-topic: please merge another older patch. (see attachment)
>Re: [PATCH split 4/8] fix 'and' typo's in wireless/p54common
>Date: 26.10.2007 22:13
>From: Roel Kluin <12o3l@tiscali.nl>
>To: linux-wireless@vger.kernel.org
>=20
> =C2=A0 =C2=A0 =C2=A0 Fix priority mistakes similar to '!x & y' in wireles=
s/p54common
>=C2=A0 =C2=A0=20
> =C2=A0 =C2=A0 =C2=A0 Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
         Acked-by: Christian Lamparter <chunkeey@web.de>

--Boundary-00=_ulJsH4zixaEefeb
Content-Type: text/x-diff;
  charset="utf-8";
  name="roel-kluin-p54-negprio.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="roel-kluin-p54-negprio.patch"

diff --git a/drivers/net/wireless/p54common.c b/drivers/net/wireless/p54common.c
index 1437db0..8ee1453 100644
--- a/drivers/net/wireless/p54common.c
+++ b/drivers/net/wireless/p54common.c
@@ -374,7 +374,7 @@ static void p54_rx_frame_sent(struct ieee80211_hw *dev, struct sk_buff *skb)
 			if ((entry_hdr->magic1 & cpu_to_le16(0x4000)) != 0)
 				pad = entry_data->align[0];

-			if (!status.control.flags & IEEE80211_TXCTL_NO_ACK) {
+			if (!(status.control.flags & IEEE80211_TXCTL_NO_ACK)) {
 				if (!(payload->status & 0x01))
 					status.flags |= IEEE80211_TX_STATUS_ACK;
 				else


--Boundary-00=_ulJsH4zixaEefeb--
