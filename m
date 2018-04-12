Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-tai-02.qualcomm.com ([103.229.16.227]:13732 "EHLO
        alexa-out-tai-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751777AbeDLDhk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Apr 2018 23:37:40 -0400
From: Wen Gong <wgong@qti.qualcomm.com>
To: Brian Norris <briannorris@chromium.org>,
        Wen Gong <wgong@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: RE: [PATCH] ath10k: Convert wow pattern from 802.3 to 802.11
Date: Thu, 12 Apr 2018 03:31:14 +0000
Message-ID: <48274f9d6abb4f36afcda8e7c71194a9@aptaiexm02f.ap.qualcomm.com> (sfid-20180412_053747_342252_0C8C391E)
References: <1522379899-31969-1-git-send-email-wgong@codeaurora.org>
 <20180411231304.GA121875@rodete-desktop-imager.corp.google.com>
In-Reply-To: <20180411231304.GA121875@rodete-desktop-imager.corp.google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I will move the convert graph from comments to code.
And new graph like this:
/**
+ * Convert a 802.3 format to a 802.11 format.
+ *         +------------+-----------+--------+----------------+
+ * 802.3:  |dest mac(6B)|src mac(6B)|type(2B)|     body...    |
+ *         +------------+-----------+--------+----------------+
+ *                |__         |_______    |____________  |________
+ *                   |                |                |          |
+ *         +--+------------+----+-----------+---------------+-----------+
+ * 802.11: |4B|dest mac(6B)| 6B |src mac(6B)|  8B  |type(2B)|  body...  |
+ *         +--+------------+----+-----------+---------------+-----------+
+ */
+static void ath10k_wow_convert_8023_to_80211
+					(struct cfg80211_pkt_pattern *new,
+					const struct cfg80211_pkt_pattern *old)


And the 444 bytes on stack will remain since the comments is: "we can go wi=
th this until somebody runs into a real problem"

Thanks
Gong Wen

> -----Original Message-----
> From: ath10k [mailto:ath10k-bounces@lists.infradead.org] On Behalf Of
> Brian Norris
> Sent: Thursday, April 12, 2018 7:13 AM
> To: Wen Gong <wgong@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org; ath10k@lists.infradead.org
> Subject: Re: [PATCH] ath10k: Convert wow pattern from 802.3 to 802.11
>=20
> Hi,
>=20
> On Fri, Mar 30, 2018 at 11:18:19AM +0800, Wen Gong wrote:
> > When trying to set wow wakeup patterns it fails with this command:
> >
> > iw phyxx wowlan enable patterns offset xx+ IP address xx.xx.xx.xx
> >
> > The reason is that the wow pattern from upper layer is in 802.3 format
> > for this case, it need to convert it to 802.11 format. The input
> > offset parameter is used for 802.3, but the actual offset firmware
> > need depends on rx_decap_mode, so that it needs to be recalculated.
> > Pattern of 802.3 packet is not same with 802.11 packet. If the
> > rx_decap_mode is ATH10K_HW_TXRX_NATIVE_WIFI, then firmware will
> > receive data packet with 802.11 format from hardware.
> >
> > Convert graph:
> > -----------------------------------------------------------------------
> > 802.3  |dest mac(6B)|src mac(6B)|type(2B)|     body...    |
> >              |__         |_______    |_____________  |___________
> >                 |                |                 |             |
> > 802.11 |4B|dest mac(6B)| 6B |src mac(6B)|  8B  |type(2B)|  body...  |
> > ----------------------------------------------------------------------
> > -
>=20
> It feels like this could go into the code comments? Or at least some shor=
t
> version of it. (But hey, text is cheap, and who doesn't love ASCII
> art?)
>=20
> >
> > Tested with QCA6174 hw3.0 with firmware
> > WLAN.RM.4.4.1-00099-QCARMSWPZ-1, but this will also affect QCA9377.
> > This has always failed, so it's not a regression with new firmware
> > releases.
> >
> > Signed-off-by: Wen Gong <wgong@codeaurora.org>
> > ---
> >  drivers/net/wireless/ath/ath10k/wmi.h |   4 ++
> >  drivers/net/wireless/ath/ath10k/wow.c | 128
> > ++++++++++++++++++++++++++++++++--
> >  2 files changed, 126 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath10k/wmi.h
> > b/drivers/net/wireless/ath/ath10k/wmi.h
> > index c7b30ed..389f9c7 100644
> > --- a/drivers/net/wireless/ath/ath10k/wmi.h
> > +++ b/drivers/net/wireless/ath/ath10k/wmi.h
> > @@ -6724,6 +6724,10 @@ struct wmi_wow_ev_arg {
> >  #define WOW_MIN_PATTERN_SIZE	1
> >  #define WOW_MAX_PATTERN_SIZE	148
> >  #define WOW_MAX_PKT_OFFSET	128
> > +#define WOW_HDR_LEN	(sizeof(struct ieee80211_hdr_3addr) + \
> > +	sizeof(struct rfc1042_hdr))
> > +#define WOW_MAX_REDUCE	(WOW_HDR_LEN - sizeof(struct
> ethhdr) - \
> > +	offsetof(struct ieee80211_hdr_3addr, addr1))
> >
> >  enum wmi_tdls_state {
> >  	WMI_TDLS_DISABLE,
> > diff --git a/drivers/net/wireless/ath/ath10k/wow.c
> > b/drivers/net/wireless/ath/ath10k/wow.c
> > index c4cbccb..9b56a41 100644
> > --- a/drivers/net/wireless/ath/ath10k/wow.c
> > +++ b/drivers/net/wireless/ath/ath10k/wow.c
> > @@ -1,5 +1,6 @@
> >  /*
> >   * Copyright (c) 2015-2017 Qualcomm Atheros, Inc.
> > + * Copyright (c) 2018, The Linux Foundation. All rights reserved.
> >   *
> >   * Permission to use, copy, modify, and/or distribute this software fo=
r any
> >   * purpose with or without fee is hereby granted, provided that the
> > above @@ -76,6 +77,98 @@ static int ath10k_wow_cleanup(struct ath10k
> *ar)
> >  	return 0;
> >  }
> >
> > +static void ath10k_wow_convert_8023_to_80211
> > +					(struct cfg80211_pkt_pattern *new,
> > +					const struct cfg80211_pkt_pattern
> *old) {
> > +	u8 hdr_8023_pattern[ETH_HLEN] =3D {};
> > +	u8 hdr_8023_bit_mask[ETH_HLEN] =3D {};
> > +	u8 hdr_80211_pattern[WOW_HDR_LEN] =3D {};
> > +	u8 hdr_80211_bit_mask[WOW_HDR_LEN] =3D {};
> > +
> > +	int total_len =3D old->pkt_offset + old->pattern_len;
> > +	int hdr_80211_end_offset;
> > +
> > +	struct ieee80211_hdr_3addr *new_hdr_pattern =3D
> > +		(struct ieee80211_hdr_3addr *)hdr_80211_pattern;
> > +	struct ieee80211_hdr_3addr *new_hdr_mask =3D
> > +		(struct ieee80211_hdr_3addr *)hdr_80211_bit_mask;
> > +	struct ethhdr *old_hdr_pattern =3D (struct ethhdr *)hdr_8023_pattern;
> > +	struct ethhdr *old_hdr_mask =3D (struct ethhdr *)hdr_8023_bit_mask;
> > +	int hdr_len =3D sizeof(*new_hdr_pattern);
> > +
> > +	struct rfc1042_hdr *new_rfc_pattern =3D
> > +		(struct rfc1042_hdr *)(hdr_80211_pattern + hdr_len);
> > +	struct rfc1042_hdr *new_rfc_mask =3D
> > +		(struct rfc1042_hdr *)(hdr_80211_bit_mask + hdr_len);
> > +	int rfc_len =3D sizeof(*new_rfc_pattern);
> > +
> > +	memcpy(hdr_8023_pattern + old->pkt_offset,
> > +	       old->pattern, ETH_HLEN - old->pkt_offset);
> > +	memcpy(hdr_8023_bit_mask + old->pkt_offset,
> > +	       old->mask, ETH_HLEN - old->pkt_offset);
> > +
> > +	/* Copy destination address */
> > +	memcpy(new_hdr_pattern->addr1, old_hdr_pattern->h_dest,
> ETH_ALEN);
> > +	memcpy(new_hdr_mask->addr1, old_hdr_mask->h_dest, ETH_ALEN);
> > +
> > +	/* Copy source address */
> > +	memcpy(new_hdr_pattern->addr3, old_hdr_pattern->h_source,
> ETH_ALEN);
> > +	memcpy(new_hdr_mask->addr3, old_hdr_mask->h_source,
> ETH_ALEN);
> > +
> > +	/* Copy logic link type */
> > +	memcpy(&new_rfc_pattern->snap_type,
> > +	       &old_hdr_pattern->h_proto,
> > +	       sizeof(old_hdr_pattern->h_proto));
> > +	memcpy(&new_rfc_mask->snap_type,
> > +	       &old_hdr_mask->h_proto,
> > +	       sizeof(old_hdr_mask->h_proto));
> > +
> > +	/* Caculate new pkt_offset */
> > +	if (old->pkt_offset < ETH_ALEN)
> > +		new->pkt_offset =3D old->pkt_offset +
> > +			offsetof(struct ieee80211_hdr_3addr, addr1);
> > +	else if (old->pkt_offset < offsetof(struct ethhdr, h_proto))
> > +		new->pkt_offset =3D old->pkt_offset +
> > +			offsetof(struct ieee80211_hdr_3addr, addr3) -
> > +			offsetof(struct ethhdr, h_source);
> > +	else
> > +		new->pkt_offset =3D old->pkt_offset + hdr_len + rfc_len -
> ETH_HLEN;
> > +
> > +	/* Caculate new hdr end offset */
> > +	if (total_len > ETH_HLEN)
> > +		hdr_80211_end_offset =3D hdr_len + rfc_len;
> > +	else if (total_len > offsetof(struct ethhdr, h_proto))
> > +		hdr_80211_end_offset =3D hdr_len + rfc_len + total_len -
> ETH_HLEN;
> > +	else if (total_len > ETH_ALEN)
> > +		hdr_80211_end_offset =3D total_len - ETH_ALEN +
> > +			offsetof(struct ieee80211_hdr_3addr, addr3);
> > +	else
> > +		hdr_80211_end_offset =3D total_len +
> > +			offsetof(struct ieee80211_hdr_3addr, addr1);
> > +
> > +	new->pattern_len =3D hdr_80211_end_offset - new->pkt_offset;
> > +
> > +	memcpy((u8 *)new->pattern,
> > +	       hdr_80211_pattern + new->pkt_offset,
> > +	       new->pattern_len);
> > +	memcpy((u8 *)new->mask,
> > +	       hdr_80211_bit_mask + new->pkt_offset,
> > +	       new->pattern_len);
> > +
> > +	if (total_len > ETH_HLEN) {
> > +		/* Copy frame body */
> > +		memcpy((u8 *)new->pattern + new->pattern_len,
> > +		       (void *)old->pattern + ETH_HLEN - old->pkt_offset,
> > +		       total_len - ETH_HLEN);
> > +		memcpy((u8 *)new->mask + new->pattern_len,
> > +		       (void *)old->mask + ETH_HLEN - old->pkt_offset,
> > +		       total_len - ETH_HLEN);
> > +
> > +		new->pattern_len +=3D total_len - ETH_HLEN;
> > +	}
> > +}
> > +
> >  static int ath10k_vif_wow_set_wakeups(struct ath10k_vif *arvif,
> >  				      struct cfg80211_wowlan *wowlan)  { @@
> -116,22 +209,39 @@
> > static int ath10k_vif_wow_set_wakeups(struct ath10k_vif *arvif,
> >
> >  	for (i =3D 0; i < wowlan->n_patterns; i++) {
> >  		u8 bitmask[WOW_MAX_PATTERN_SIZE] =3D {};
> > +		u8 ath_pattern[WOW_MAX_PATTERN_SIZE] =3D {};
> > +		u8 ath_bitmask[WOW_MAX_PATTERN_SIZE] =3D {};
>=20
> So now we've got 3 * 148 =3D 444 bytes on the stack just for this? Seems =
like it's
> getting a little large for kernel code, but maybe not too bad.
> I guess we can go with this until somebody runs into a real problem...
>=20
> Otherwise, seems to work for me:
>=20
> Tested-by: Brian Norris <briannorris@chromium.org>
> Reviewed-by: Brian Norris <briannorris@chromium.org>
>=20
> > +		struct cfg80211_pkt_pattern new_pattern =3D {};
> > +		struct cfg80211_pkt_pattern old_pattern =3D patterns[i];
> >  		int j;
> > -
> > +		new_pattern.pattern =3D ath_pattern;
> > +		new_pattern.mask =3D ath_bitmask;
> >  		if (patterns[i].pattern_len > WOW_MAX_PATTERN_SIZE)
> >  			continue;
> > -
> >  		/* convert bytemask to bitmask */
> >  		for (j =3D 0; j < patterns[i].pattern_len; j++)
> >  			if (patterns[i].mask[j / 8] & BIT(j % 8))
> >  				bitmask[j] =3D 0xff;
> > +		old_pattern.mask =3D bitmask;
> > +		new_pattern =3D old_pattern;
> > +
> > +		if (ar->wmi.rx_decap_mode =3D=3D
> ATH10K_HW_TXRX_NATIVE_WIFI) {
> > +			if (patterns[i].pkt_offset < ETH_HLEN)
> > +
> 	ath10k_wow_convert_8023_to_80211(&new_pattern,
> > +
> &old_pattern);
> > +			else
> > +				new_pattern.pkt_offset +=3D WOW_HDR_LEN -
> ETH_HLEN;
> > +		}
> > +
> > +		if (WARN_ON(new_pattern.pattern_len >
> WOW_MAX_PATTERN_SIZE))
> > +			return -EINVAL;
> >
> >  		ret =3D ath10k_wmi_wow_add_pattern(ar, arvif->vdev_id,
> >  						 pattern_id,
> > -						 patterns[i].pattern,
> > -						 bitmask,
> > -						 patterns[i].pattern_len,
> > -						 patterns[i].pkt_offset);
> > +						 new_pattern.pattern,
> > +						 new_pattern.mask,
> > +						 new_pattern.pattern_len,
> > +						 new_pattern.pkt_offset);
> >  		if (ret) {
> >  			ath10k_warn(ar, "failed to add pattern %i to
> vdev %i: %d\n",
> >  				    pattern_id,
> > @@ -345,6 +455,12 @@ int ath10k_wow_init(struct ath10k *ar)
> >  		return -EINVAL;
> >
> >  	ar->wow.wowlan_support =3D ath10k_wowlan_support;
> > +
> > +	if (ar->wmi.rx_decap_mode =3D=3D ATH10K_HW_TXRX_NATIVE_WIFI) {
> > +		ar->wow.wowlan_support.pattern_max_len -=3D
> WOW_MAX_REDUCE;
> > +		ar->wow.wowlan_support.max_pkt_offset -=3D
> WOW_MAX_REDUCE;
> > +	}
> > +
> >  	ar->wow.wowlan_support.n_patterns =3D ar-
> >wow.max_num_patterns;
> >  	ar->hw->wiphy->wowlan =3D &ar->wow.wowlan_support;
> >
> > --
> > 2.7.4
> >
>=20
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
