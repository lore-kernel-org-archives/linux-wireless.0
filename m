Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57135 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbcFUMn6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 08:43:58 -0400
Message-ID: <1466511726.3170.33.camel@sipsolutions.net> (sfid-20160621_144421_168198_5752456B)
Subject: Re: [PATCH v2 RESEND] qtnfmac: announcement of new FullMAC driver
 for Quantenna chipsets
From: Johannes Berg <johannes@sipsolutions.net>
To: igor.mitsyanko.os@quantenna.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Avinash Patil <avinashp@quantenna.com>,
	Dmitrii Lebed <dlebed@quantenna.com>,
	Sergei Maksimenko <smaksimenko@quantenna.com>,
	Sergey Matyukevich <smatyukevich@quantenna.com>,
	Bindu Therthala <btherthala@quantenna.com>,
	Huizhao Wang <hwang@quantenna.com>,
	Kamlesh Rath <krath@quantenna.com>
Date: Tue, 21 Jun 2016 14:22:06 +0200
In-Reply-To: <1466460688-28160-1-git-send-email-igor.mitsyanko.os@quantenna.com>
References: <1466460688-28160-1-git-send-email-igor.mitsyanko.os@quantenna.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Very brief review:

> +/* */

That seems slightly odd.

> +	/* bus private data */
> +	char bus_priv[0];

You might want to - for future proofing - add some aligned() attribute.
Otherwise, if struct mutex doesn't have a size that's a multiple of the
pointer size, fields in here will not be aligned right.

> +static inline void *get_bus_priv(struct qtnf_bus *bus)
> +{
> +	if (WARN_ON(!bus)) {
> +		pr_err("qtnfmac: invalid bus pointer!\n");
> +		return NULL;

Better to just use "WARN(!bus, "qtnfmac: invalid bus pointer!\n");"

Also, for pr_* the "qtnfmac: " prefix should be done with pr_fmt, not
manually.

> +#define QLINK_HT_MCS_MASK_LEN	10
> +#define QLINK_ETH_ALEN		6
> +#define QLINK_MAX_SSID_LEN	32

These seem a bit strange? Why bother? They are standard values.
(not entirely sure what the MCS_MASK_LEN is used for though)

> +/*
> + * struct qlink_ht_mcs_info - MCS information
> + *
> + * See &struct ieee80211_mcs_info.
> + */
> +struct qlink_ht_mcs_info {
> +	u8 rx_mask[QLINK_HT_MCS_MASK_LEN];
> +	__le16 rx_highest;
> +	u8 tx_params;
> +	u8 reserved[3];
> +} __packed;
> +
> +/*
> + * struct qlink_ht_cap - HT capabilities
> + *
> + * "HT capabilities element", see &struct ieee80211_ht_cap.
> + */
> +struct qlink_ht_cap {
> +	struct qlink_ht_mcs_info mcs;
> +	__le32 tx_BF_cap_info;
> +	__le16 cap_info;
> +	__le16 extended_ht_cap_info;
> +	u8 ampdu_params_info;
> +	u8 antenna_selection_info;
> +} __packed;
> +
> +/*
> + * struct qlink_vht_mcs_info - VHT MCS information
> + *
> + * See &struct ieee80211_vht_mcs_info.
> + */
> +struct qlink_vht_mcs_info {
> +	__le16 rx_mcs_map;
> +	__le16 rx_highest;
> +	__le16 tx_mcs_map;
> +	__le16 tx_highest;
> +} __packed;
> +
> +/*
> + * struct qlink_vht_cap - VHT capabilities
> + *
> + * "VHT capabilities element", see &struct ieee80211_vht_cap.
> + */
> +struct qlink_vht_cap {
> +	__le32 vht_cap_info;
> +	struct qlink_vht_mcs_info supp_mcs;
> +} __packed;


I think you shouldn't duplicate these, there's no sane way they can
ever be changed in ieee80211.h


> +enum qlink_iface_type {
> +	QLINK_IFTYPE_AP		= BIT(0),
> +	QLINK_IFTYPE_STATION	= BIT(1),
> +	QLINK_IFTYPE_ADHOC	= BIT(2),
> +	QLINK_IFTYPE_MONITOR	= BIT(3),
> +	QLINK_IFTYPE_WDS	= BIT(4),
> +};

Not sure how you use these, but BIT() doesn't make a lot of sense for
something that's mutually exclusive?

> +/**
> + * Copyright (c) 2015-2016 Quantenna Communications, Inc.
> + * All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + **/

You should probably not have those double asterisks since they're
reserved for kernel-doc.

> +	if (qtnf_cmd_send_start_ap(vif)) {
> +		pr_err("failed to issue start AP command\n");
> +		return -EFAULT;
> +	}
> +
> +	if (!(vif->bss_status & QTNF_STATE_AP_START)) {
> +		pr_err("failed to start AP operations in FW\n");
> +		return -EFAULT;
> +	}

This is strange - I'd expect send_start_ap() to not actually just send
it, but also wait for a response, and then it can return an error if
the flag didn't get set. If it doesn't, then it's racy, no?

> +static int
> +qtnf_connect(struct wiphy *wiphy, struct net_device *dev,
> +	     struct cfg80211_connect_params *sme)
> +{
> +	struct qtnf_vif *vif;
> +	struct qtnf_bss_config *bss_cfg;
> +
> +	vif = qtnf_netdev_get_priv(dev);
> +	if (!vif) {
> +		pr_err("core_attach: could not get valid vif
> pointer\n");
> +		return -EFAULT;
> +	}

It seems that you're overdoing the error checks a bit - I don't see how
this could possibly fail?

> +	memcpy(&bss_cfg->crypto, &sme->crypto, sizeof(bss_cfg-
> >crypto));

This makes no sense at all - you have to convert the format of this
somehow to make it work - at least endianness has to be fixed, even if
you copied all of the cfg80211 struct.

[snip - lots of stuff I didn't really look at]

> +/* sysfs knobs: stats and other diagnistics */

I think you should not have these - maybe add those with separate
patches later that really can't be done otherwise, and then give very
good rationale for it. Having driver-specific sysfs is not a good idea
in general.

> +static inline u64 qtnf_get_unaligned_le64(const __le64 *ptr)
> +{
> +	return le64_to_cpu(get_unaligned(ptr));
> +}
> +
> +static inline u32 qtnf_get_unaligned_le32(const __le32 *ptr)
> +{
> +	return le32_to_cpu(get_unaligned(ptr));
> +}
> +
> +static inline u16 qtnf_get_unaligned_le16(const __le16 *ptr)
> +{
> +	return le16_to_cpu(get_unaligned(ptr));
> +}

Huh, what? These exist, or should exist, already.

[snip more]

johannes
