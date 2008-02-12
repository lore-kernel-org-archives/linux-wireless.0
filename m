Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3235 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbYBLRCi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2008 12:02:38 -0500
Date: Tue, 12 Feb 2008 11:26:45 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@web.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Tomas Winkler <tomasw@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: give burst time in txop rather than
	0.1msec units
Message-ID: <20080212162645.GD3051@tuxdriver.com> (sfid-20080212_170242_811197_419EB254)
References: <1202658578.11481.4.camel@johannes.berg> <200802111952.30964.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <200802111952.30964.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 11, 2008 at 07:52:30PM +0100, Christian Lamparter wrote:
> and off-topic: please merge another older patch. (see attachment)
> >Re: [PATCH split 4/8] fix 'and' typo's in wireless/p54common
> >Date: 26.10.2007 22:13
> >From: Roel Kluin <12o3l@tiscali.nl>
> >To: linux-wireless@vger.kernel.org
> >=20
> > =A0 =A0 =A0 Fix priority mistakes similar to '!x & y' in wireless/p=
54common
> >=A0 =A0=20
> > =A0 =A0 =A0 Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
>          Acked-by: Christian Lamparter <chunkeey@web.de>

> diff --git a/drivers/net/wireless/p54common.c b/drivers/net/wireless/=
p54common.c
> index 1437db0..8ee1453 100644
> --- a/drivers/net/wireless/p54common.c
> +++ b/drivers/net/wireless/p54common.c
> @@ -374,7 +374,7 @@ static void p54_rx_frame_sent(struct ieee80211_hw=
 *dev, struct sk_buff *skb)
>  			if ((entry_hdr->magic1 & cpu_to_le16(0x4000)) !=3D 0)
>  				pad =3D entry_data->align[0];
>=20
> -			if (!status.control.flags & IEEE80211_TXCTL_NO_ACK) {
> +			if (!(status.control.flags & IEEE80211_TXCTL_NO_ACK)) {
>  				if (!(payload->status & 0x01))
>  					status.flags |=3D IEEE80211_TX_STATUS_ACK;
>  				else
>=20

This is part of the commit here:

commit f59d9782751bf1a2c51e7e1e9f614ffec35fb52e
Author: Roel Kluin <12o3l@tiscali.nl>
Date:   Fri Oct 26 21:51:26 2007 +0200

    wireless: fix '!x & y' typo's

    Fix priority mistakes similar to '!x & y'

    Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

Hth!

--=20
John W. Linville
linville@tuxdriver.com
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
