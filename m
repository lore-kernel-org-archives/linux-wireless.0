Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:33230 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752365AbeC3TR0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Mar 2018 15:17:26 -0400
Message-ID: <1522437431.2902.0.camel@sipsolutions.net> (sfid-20180330_211729_724035_3D9E176B)
Subject: Re: [PATCH 11/17] rtlwifi: halmac: add files to implement halmac ops
From: Johannes Berg <johannes@sipsolutions.net>
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Date: Fri, 30 Mar 2018 21:17:11 +0200
In-Reply-To: <20180330071916.23360-12-pkshih@realtek.com> (sfid-20180330_092005_131151_0A8F8A2A)
References: <20180330071916.23360-1-pkshih@realtek.com>
         <20180330071916.23360-12-pkshih@realtek.com>
         (sfid-20180330_092005_131151_0A8F8A2A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-03-30 at 15:19 +0800, pkshih@realtek.com wrote:
> 
> +static struct rtl_halmac_ops rtl_halmac_operation = {

You should make this const, if at all possible (it looks like it should
be).

> +	.halmac_init_adapter = rtl_halmac_init_adapter,
> +	.halmac_deinit_adapter = rtl_halmac_deinit_adapter,
> +	.halmac_init_hal = rtl_halmac_init_hal,
> +	.halmac_deinit_hal = rtl_halmac_deinit_hal,
> +	.halmac_poweron = rtl_halmac_poweron,
> +	.halmac_poweroff = rtl_halmac_poweroff,
> +
> +	.halmac_phy_power_switch = rtl_halmac_phy_power_switch,
> +	.halmac_set_mac_address = rtl_halmac_set_mac_address,
> +	.halmac_set_bssid = rtl_halmac_set_bssid,
> +
> +	.halmac_get_physical_efuse_size = rtl_halmac_get_physical_efuse_size,
> +	.halmac_read_physical_efuse_map = rtl_halmac_read_physical_efuse_map,
> +	.halmac_get_logical_efuse_size = rtl_halmac_get_logical_efuse_size,
> +	.halmac_read_logical_efuse_map = rtl_halmac_read_logical_efuse_map,
> +
> +	.halmac_set_bandwidth = rtl_halmac_set_bandwidth,
> +
> +	.halmac_c2h_handle = rtl_halmac_c2h_handle,
> +
> +	.halmac_chk_txdesc = rtl_halmac_chk_txdesc,
> +	.halmac_iqk = rtl_halmac_iqk,
> +};
> +
> +struct rtl_halmac_ops *rtl_halmac_get_ops_pointer(void)
> +{
> +	return &rtl_halmac_operation;
> +}
> +EXPORT_SYMBOL(rtl_halmac_get_ops_pointer);

This seems like a rather pointless indirection, you can export the
variable.

johannes
