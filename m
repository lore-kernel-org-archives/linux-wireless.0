Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37388 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751288AbcIQNqx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 09:46:53 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: <igor.mitsyanko.os@quantenna.com>
Cc: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
        Avinash Patil <avinashp@quantenna.com>,
        Dmitrii Lebed <dlebed@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Bindu Therthala <btherthala@quantenna.com>,
        Huizhao Wang <hwang@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>
Subject: Re: [PATCH v2 RESEND] qtnfmac: announcement of new FullMAC driver for Quantenna chipsets
References: <1466460688-28160-1-git-send-email-igor.mitsyanko.os@quantenna.com>
Date: Sat, 17 Sep 2016 16:46:45 +0300
In-Reply-To: <1466460688-28160-1-git-send-email-igor.mitsyanko.os@quantenna.com>
        (igor mitsyanko os's message of "Tue, 21 Jun 2016 01:11:28 +0300")
Message-ID: <87eg4i8wqi.fsf@kamboji.qca.qualcomm.com> (sfid-20160917_154656_959521_2008C6C5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<igor.mitsyanko.os@quantenna.com> writes:

> From: Avinash Patil <avinashp@quantenna.com>
>
> This patch adds support for new FullMAC WiFi driver for Quantenna
> QSR10G chipsets.
>
> QSR10G is Quantenna's 8x8, 160M, 11ac offering.
> QSR10G supports 2 simultaneous WMACs- one 5G and one 2G. 5G WMAC
> supports 160M, 8x8 configuration.
> FW supports 8 concurrent virtual interfaces on each WMAC.
>
> Patch introduces 2 new drivers- qtnfmac.ko for interfacing with
> kernel/cfg80211 and qtnfmac_pcie.ko for PCIe bus interface.
>
> Signed-off-by: Dmitrii Lebed <dlebed@quantenna.com>
> Signed-off-by: Sergei Maksimenko <smaksimenko@quantenna.com>
> Signed-off-by: Sergey Matyukevich <smatyukevich@quantenna.com>
> Signed-off-by: Bindu Therthala <btherthala@quantenna.com>
> Signed-off-by: Huizhao Wang <hwang@quantenna.com>
> Signed-off-by: Kamlesh Rath <krath@quantenna.com>
> Signed-off-by: Avinash Patil <avinashp@quantenna.com>
> Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

I read this through and looking good. Below are some comments.

I also saw few warnings but I suspect they are because of cfg80211 API
changes (didn't bother to check that now):

drivers/net/wireless/quantenna/qtnfmac/event.c: In function `qtnf_event_handle_scan_complete':
drivers/net/wireless/quantenna/qtnfmac/event.c:342:2: warning: passing argument 2 of `cfg80211_scan_done' makes pointer from integer without a cast [enabled by default]
./include/net/cfg80211.h:4104:6: note: expected `struct cfg80211_scan_info *' but argument is of type `u32'
drivers/net/wireless/quantenna/qtnfmac/cfg80211.c: In function `qtnf_virtual_intf_cleanup':
drivers/net/wireless/quantenna/qtnfmac/cfg80211.c:1093:4: warning: passing argument 2 of `cfg80211_scan_done' makes pointer from integer without a cast [enabled by default]
./include/net/cfg80211.h:4104:6: note: expected `struct cfg80211_scan_info *' but argument is of type `int'

> Resend to correct email kvalo@codeaurora.org.

BTW, no need to send me directly. I take patches directly from patchwork
so sending them to linux-wireless is enough. Doesn't do any harm to send
them to, I just immediately delete them from my INBOX :)

> Changelist V1->V2:
> 1. Get rid of confidentiality footer.
> 2. Rewrite qlink.h header to make it easier to use, add
> documentation to most of qlink.h definitions.
>
>  MAINTAINERS                                        |    8 +
>  drivers/net/wireless/Kconfig                       |    1 +
>  drivers/net/wireless/Makefile                      |    1 +
>  drivers/net/wireless/quantenna/Kconfig             |   16 +
>  drivers/net/wireless/quantenna/Makefile            |    6 +
>  drivers/net/wireless/quantenna/include/bus.h       |  195 ++
>  .../wireless/quantenna/include/pcie_regs_pearl.h   |  353 ++++
>  drivers/net/wireless/quantenna/include/qlink.h     |  939 ++++++++++
>  .../net/wireless/quantenna/include/qtn_hw_ids.h    |   34 +
>  .../net/wireless/quantenna/include/shm_ipc_defs.h  |   46 +

Is there a particular reason why you have a separate include directory?
There's just one quantenna driver for now so the extra include directory
feels unnecessary. I would prefer to have that only once there are two
quantenna drivers and we know exactly what is shared between the two.

> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9151,6 +9151,14 @@ L:	qemu-devel@nongnu.org
>  S:	Maintained
>  F:	drivers/firmware/qemu_fw_cfg.c
>  
> +QUANTENNA QTNFMAC WIRELESS DRIVER
> +M:	Igor Mitsyanko <imitsyanko@quantenna.com>
> +M:	Avinash Patil <avinashp@quantenna.com>
> +M:	Sergey Matyukevich <smatyukevich@quantenna.com>
> +L:	linux-wireless@vger.kernel.org
> +S:	Maintained
> +F:	drivers/net/wireless/quantenna/qtnfmac

The include directory is not listed.

> +ccflags-y += -D__CHECK_ENDIAN

Very good.

> +/* Supported rates to be advertised to the cfg80211 */
> +static struct ieee80211_rate qtnf_rates[] = {
> +	{.bitrate = 10, .hw_value = 2, },
> +	{.bitrate = 20, .hw_value = 4, },
> +	{.bitrate = 55, .hw_value = 11, },
> +	{.bitrate = 110, .hw_value = 22, },
> +	{.bitrate = 60, .hw_value = 12, },
> +	{.bitrate = 90, .hw_value = 18, },
> +	{.bitrate = 120, .hw_value = 24, },
> +	{.bitrate = 180, .hw_value = 36, },
> +	{.bitrate = 240, .hw_value = 48, },
> +	{.bitrate = 360, .hw_value = 72, },
> +	{.bitrate = 480, .hw_value = 96, },
> +	{.bitrate = 540, .hw_value = 108, },
> +};
> +
> +/* Channel definitions to be advertised to cfg80211 */
> +static struct ieee80211_channel qtnf_channels_2ghz[] = {
> +	{.center_freq = 2412, .hw_value = 1, },
> +	{.center_freq = 2417, .hw_value = 2, },
> +	{.center_freq = 2422, .hw_value = 3, },
> +	{.center_freq = 2427, .hw_value = 4, },
> +	{.center_freq = 2432, .hw_value = 5, },
> +	{.center_freq = 2437, .hw_value = 6, },
> +	{.center_freq = 2442, .hw_value = 7, },
> +	{.center_freq = 2447, .hw_value = 8, },
> +	{.center_freq = 2452, .hw_value = 9, },
> +	{.center_freq = 2457, .hw_value = 10, },
> +	{.center_freq = 2462, .hw_value = 11, },
> +	{.center_freq = 2467, .hw_value = 12, },
> +	{.center_freq = 2472, .hw_value = 13, },
> +	{.center_freq = 2484, .hw_value = 14, },
> +};

I guess some of these static variables could be also const, but didn't
check.

> +MODULE_AUTHOR("Quantenna Communications");
> +MODULE_DESCRIPTION("Quantenna 802.11 wireless LAN FullMAC driver.");
> +MODULE_LICENSE("Dual BSD/GPL");

[...]

> +++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
> @@ -0,0 +1,170 @@
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
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + **/

MODULE_LICENSE() doesn't match license in headers, is that correct?

> +static int
> +qtnf_event_handle_sta_assoc(struct qtnf_wmac *mac, struct qtnf_vif *vif,
> +			    const struct qlink_event_sta_assoc *sta_assoc,
> +			    u16 len)
> +{
> +	const u8 *sta_addr;
> +	u16 frame_control;
> +	struct station_info sinfo = { 0 };
> +	size_t payload_len;
> +	u16 tlv_type;
> +	u16 tlv_value_len;
> +	size_t tlv_full_len;
> +	const struct qlink_tlv_hdr *tlv;
> +
> +	if (unlikely(len < sizeof(*sta_assoc))) {
> +		pr_err("%s: payload is too short (%u < %zu)\n", __func__,
> +		       len, sizeof(*sta_assoc));
> +		return -EINVAL;
> +	}

I see unlikely() used a lot, I counted 145 times. Not a big issue but I
don't see the point. In hot path I understand using it, but not
everywhere.

> +/* sysfs knobs: stats and other diagnistics */

Johannes also commented about this. Please use debugfs or some generic
interface.

-- 
Kalle Valo
