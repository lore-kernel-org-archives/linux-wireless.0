Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34474 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754235AbdCFVTW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2017 16:19:22 -0500
Received: by mail-lf0-f67.google.com with SMTP id y193so12560105lfd.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Mar 2017 13:19:21 -0800 (PST)
Subject: Re: [PATCH v4] qtnfmac: announcement of new FullMAC driver for
 Quantenna chipsets
To: igor.mitsyanko.os@quantenna.com, linux-wireless@vger.kernel.org
References: <1483952830-3967-1-git-send-email-igor.mitsyanko.os@quantenna.com>
Cc: johannes@sipsolutions.net, btherthala@quantenna.com,
        hwang@quantenna.com, smaksimenko@quantenna.com,
        dlebed@quantenna.com,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <af3dbd89-d9e8-7f6a-d48a-ebe430671963@gmail.com> (sfid-20170306_221926_823469_E5C22010)
Date: Mon, 6 Mar 2017 22:19:18 +0100
MIME-Version: 1.0
In-Reply-To: <1483952830-3967-1-git-send-email-igor.mitsyanko.os@quantenna.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2017 10:07 AM, igor.mitsyanko.os@quantenna.com wrote:
> From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
>
> This patch adds support for new FullMAC WiFi driver for Quantenna
> QSR10G chipsets.
>
> QSR10G (aka Pearl) is Quantenna's 8x8, 160M, 11ac offering.
> QSR10G supports 2 simultaneous WMACs - one 5G and one 2G.
> 5G WMAC supports 160M, 8x8 configuration. FW supports
> up to 8 concurrent virtual interfaces on each WMAC.
>
> Patch introduces 2 new drivers:
> - qtnfmac.ko for interfacing with kernel wireless core
> - qtnfmac_pearl_pcie.ko for interfacing with hardware over PCIe interface

Hi, what's the state of this patch? Kalle I see it in your pending branch,
could you give me/us a hint what does it mean, please?

I've also one not-strictly-related question. What about other chipsets support?
I'm mostly interested in QT3840BC which can be found in few home routers that
OpenWrt/LEDE could support.
Can they be supported with submitted core code and just an additional bus
driver?

Please also find few minor comments below.


> +static int __init qtnf_module_init(void)
> +{
> +	return 0;
> +}
> +
> +static void __exit qtnf_module_exit(void)
> +{
> +}
> +
> +module_init(qtnf_module_init);
> +module_exit(qtnf_module_exit);

Is this needed? AFAIU this module just exports symbols, I think init and exit
aren't required for that.


> +static int qtnf_mac_init_single_band(struct wiphy *wiphy,
> +				     struct qtnf_wmac *mac,
> +				     enum nl80211_band band)
> +{
> +	int ret;
> +
> +	wiphy->bands[band] = kzalloc(sizeof(*wiphy->bands[band]), GFP_KERNEL);
> +	if (!wiphy->bands[band])
> +		return -ENOMEM;
> +
> +	wiphy->bands[band]->band = band;
> +
> +	ret = qtnf_cmd_get_mac_chan_info(mac, wiphy->bands[band]);
> +	if (ret) {
> +		pr_err("failed to get chans info for band %u\n",
> +		       band);
> +		return ret;

I think you leak memory here. I'm aware that in case qtnf_core_attach fails you
call qtnf_core_detach, but I think it won't free this memory due to:
if (!mac || !mac->mac_started)
evaluating to false. A simple kfree here would be easier to follow.


> +	}
> +
> (...)
> +
> +int qtnf_core_attach(struct qtnf_bus *bus)
> +{
> +	int i;
> +
> +	qtnf_trans_init(bus);
> +
> +	bus->fw_state = QTNF_FW_STATE_BOOT_DONE;
> +	qtnf_bus_data_rx_start(bus);
> +
> +	bus->workqueue = alloc_ordered_workqueue("QTNF_BUS", 0);
> +	if (!bus->workqueue) {
> +		pr_err("failed to alloc main workqueue\n");
> +		return -1;
> +	}
> +
> +	INIT_WORK(&bus->event_work, qtnf_event_work_handler);
> +
> +	if (qtnf_cmd_send_init_fw(bus)) {
> +		pr_err("failed to send FW init commands\n");
> +		return -1;
> +	}
> +
> +	bus->fw_state = QTNF_FW_STATE_ACTIVE;
> +
> +	if (qtnf_cmd_get_hw_info(bus)) {
> +		pr_err("failed to get HW info\n");
> +		return -1;
> +	}
> +
> +	if (bus->hw_info.ql_proto_ver != QLINK_PROTO_VER) {
> +		pr_err("qlink protocol version mismatch\n");
> +		return -1;
> +	}
> +
> +	if (bus->hw_info.num_mac > QTNF_MAX_MAC) {
> +		pr_err("FW reported invalid mac count: %d\n",
> +		       bus->hw_info.num_mac);
> +		return -1;
> +	}
> +
> +	for (i = 0; i < bus->hw_info.num_mac; i++) {
> +		if (qtnf_core_mac_init(bus, i)) {
> +			pr_err("mac(%d) init failed\n", i);
> +			return -1;
> +		}
> +	}
> +
> +	return 0;

This would be nice to see an error path here instead of depending on a caller to
use qtnf_core_detach.


> +}
> +EXPORT_SYMBOL_GPL(qtnf_core_attach);
