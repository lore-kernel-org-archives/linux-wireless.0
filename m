Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0051.outbound.protection.outlook.com ([104.47.37.51]:32469
	"EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750794AbcGKWaJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 18:30:09 -0400
Subject: Re: [PATCH v2 RESEND] qtnfmac: announcement of new FullMAC driver for
 Quantenna chipsets
To: Johannes Berg <johannes@sipsolutions.net>, <kvalo@codeaurora.org>
References: <1466460688-28160-1-git-send-email-igor.mitsyanko.os@quantenna.com>
 <1466511726.3170.33.camel@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Avinash Patil <avinashp@quantenna.com>,
	Dmitrii Lebed <dlebed@quantenna.com>,
	Sergei Maksimenko <smaksimenko@quantenna.com>,
	Sergey Matyukevich <smatyukevich@quantenna.com>,
	Bindu Therthala <btherthala@quantenna.com>,
	Huizhao Wang <hwang@quantenna.com>,
	Kamlesh Rath <krath@quantenna.com>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <fd6ee9cd-71fd-352a-e1cd-61d36b296057@quantenna.com> (sfid-20160712_003016_700430_C9A9C887)
Date: Mon, 11 Jul 2016 21:57:15 +0300
MIME-Version: 1.0
In-Reply-To: <1466511726.3170.33.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,
thank for review and sorry for long delays in replies. A parallel thread 
with Dave a discussion was initiated regarding HW platform samples 
availability. Current driver implementation supports a newer QSR10G 
platform, which availability is limited due to the platform still being 
in development stage. We're working on supporting Quantenna's current 
QSR1000 platform too, what would be the best approach to this:
- have QSR1000 platform support ready, amend it to current patch and 
post it as a new patch revision (there should be a certain amount of new 
code);
- have current patch accepted by community first, and then post a new 
patch (adding new platform support) one on top of it.

More answers bellow.

On 06/21/2016 03:22 PM, Johannes Berg wrote:
> Very brief review:
>
>> +/* */
> That seems slightly odd.

Will remove.

>
>> +	/* bus private data */
>> +	char bus_priv[0];
> You might want to - for future proofing - add some aligned() attribute.
> Otherwise, if struct mutex doesn't have a size that's a multiple of the
> pointer size, fields in here will not be aligned right.

Right, thanks for pointing this out. Probably even better approach here 
would be to take an object-oriented approach and make "bus" a base 
structure with pcie_bus an inheriting structure.

>
>> +static inline void *get_bus_priv(struct qtnf_bus *bus)
>> +{
>> +	if (WARN_ON(!bus)) {
>> +		pr_err("qtnfmac: invalid bus pointer!\n");
>> +		return NULL;
> Better to just use "WARN(!bus, "qtnfmac: invalid bus pointer!\n");"
>
> Also, for pr_* the "qtnfmac: " prefix should be done with pr_fmt, not
> manually.

Ok

>
>> +#define QLINK_HT_MCS_MASK_LEN	10
>> +#define QLINK_ETH_ALEN		6
>> +#define QLINK_MAX_SSID_LEN	32
> These seem a bit strange? Why bother? They are standard values.
> (not entirely sure what the MCS_MASK_LEN is used for though)

The idea was to make protocol definition an independent entity, which 
does not depend on actual values which happened to be used in current 
kernel. And so that we can be sure that both sides of protocol 
communication entities use the same length values.

We actually had discussions regarding this locally too: it was not clear 
whether we should use existing Linux definitions for standard things 
like MAC length, 802.11 header fields, IEs definitions etc. It does make 
a lot of sense to think that they will never change and can not be 
different on opposite sides of protocol, but we went with approach to 
define everything manually.

>
>> +/*
>> + * struct qlink_ht_mcs_info - MCS information
>> + *
>> + * See &struct ieee80211_mcs_info.
>> + */
>> +struct qlink_ht_mcs_info {
>> +	u8 rx_mask[QLINK_HT_MCS_MASK_LEN];
>> +	__le16 rx_highest;
>> +	u8 tx_params;
>> +	u8 reserved[3];
>> +} __packed;
>> +
>> +/*
>> + * struct qlink_ht_cap - HT capabilities
>> + *
>> + * "HT capabilities element", see &struct ieee80211_ht_cap.
>> + */
>> +struct qlink_ht_cap {
>> +	struct qlink_ht_mcs_info mcs;
>> +	__le32 tx_BF_cap_info;
>> +	__le16 cap_info;
>> +	__le16 extended_ht_cap_info;
>> +	u8 ampdu_params_info;
>> +	u8 antenna_selection_info;
>> +} __packed;
>> +
>> +/*
>> + * struct qlink_vht_mcs_info - VHT MCS information
>> + *
>> + * See &struct ieee80211_vht_mcs_info.
>> + */
>> +struct qlink_vht_mcs_info {
>> +	__le16 rx_mcs_map;
>> +	__le16 rx_highest;
>> +	__le16 tx_mcs_map;
>> +	__le16 tx_highest;
>> +} __packed;
>> +
>> +/*
>> + * struct qlink_vht_cap - VHT capabilities
>> + *
>> + * "VHT capabilities element", see &struct ieee80211_vht_cap.
>> + */
>> +struct qlink_vht_cap {
>> +	__le32 vht_cap_info;
>> +	struct qlink_vht_mcs_info supp_mcs;
>> +} __packed;
>
> I think you shouldn't duplicate these, there's no sane way they can
> ever be changed in ieee80211.h

Ok, that makes sense of course. Will discuss this locally.

>
>
>> +enum qlink_iface_type {
>> +	QLINK_IFTYPE_AP		= BIT(0),
>> +	QLINK_IFTYPE_STATION	= BIT(1),
>> +	QLINK_IFTYPE_ADHOC	= BIT(2),
>> +	QLINK_IFTYPE_MONITOR	= BIT(3),
>> +	QLINK_IFTYPE_WDS	= BIT(4),
>> +};
> Not sure how you use these, but BIT() doesn't make a lot of sense for
> something that's mutually exclusive?

You're right, will change to simple enumeration.

>
>> +/**
>> + * Copyright (c) 2015-2016 Quantenna Communications, Inc.
>> + * All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * as published by the Free Software Foundation; either version 2
>> + * of the License, or (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + **/
> You should probably not have those double asterisks since they're
> reserved for kernel-doc.

Ok

>
>> +	if (qtnf_cmd_send_start_ap(vif)) {
>> +		pr_err("failed to issue start AP command\n");
>> +		return -EFAULT;
>> +	}
>> +
>> +	if (!(vif->bss_status & QTNF_STATE_AP_START)) {
>> +		pr_err("failed to start AP operations in FW\n");
>> +		return -EFAULT;
>> +	}
> This is strange - I'd expect send_start_ap() to not actually just send
> it, but also wait for a response, and then it can return an error if
> the flag didn't get set. If it doesn't, then it's racy, no?

COMMAND_SEND/REPLY_PROCESS procedure is "atomic" in the driver, meaning 
once one command is sent, next one will not be sent until previous 
command response is received and processed completely (we rely on RTNL 
mutex taken by cfg80211 layer here). Currently every command requires a 
response.
In this particular case QTNF_STATE_AP_START will be set only after a 
response for send_start_ap is received and response indicated successful 
command execution by another side.

>
>> +static int
>> +qtnf_connect(struct wiphy *wiphy, struct net_device *dev,
>> +	     struct cfg80211_connect_params *sme)
>> +{
>> +	struct qtnf_vif *vif;
>> +	struct qtnf_bss_config *bss_cfg;
>> +
>> +	vif = qtnf_netdev_get_priv(dev);
>> +	if (!vif) {
>> +		pr_err("core_attach: could not get valid vif
>> pointer\n");
>> +		return -EFAULT;
>> +	}
> It seems that you're overdoing the error checks a bit - I don't see how
> this could possibly fail?

Agree

>
>> +	memcpy(&bss_cfg->crypto, &sme->crypto, sizeof(bss_cfg-
>>> crypto));
> This makes no sense at all - you have to convert the format of this
> somehow to make it work - at least endianness has to be fixed, even if
> you copied all of the cfg80211 struct.

In this particular place we're making a local copy of cfg80211 struct to 
local data structure (per each virtual interface). Conversion before 
sending to another side is done in qtnf_cmd_send_connect(), it is 
converted into struct qlink_auth_encr.

>
> [snip - lots of stuff I didn't really look at]
>
>> +/* sysfs knobs: stats and other diagnistics */
> I think you should not have these - maybe add those with separate
> patches later that really can't be done otherwise, and then give very
> good rationale for it. Having driver-specific sysfs is not a good idea
> in general.

Ok, got it.

>
>> +static inline u64 qtnf_get_unaligned_le64(const __le64 *ptr)
>> +{
>> +	return le64_to_cpu(get_unaligned(ptr));
>> +}
>> +
>> +static inline u32 qtnf_get_unaligned_le32(const __le32 *ptr)
>> +{
>> +	return le32_to_cpu(get_unaligned(ptr));
>> +}
>> +
>> +static inline u16 qtnf_get_unaligned_le16(const __le16 *ptr)
>> +{
>> +	return le16_to_cpu(get_unaligned(ptr));
>> +}
> Huh, what? These exist, or should exist, already.

Will change to existing ones.

>
> [snip more]
>
> johannes

