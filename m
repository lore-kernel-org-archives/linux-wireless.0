Return-Path: <SRS0=Yehs=D2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A88C43457
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Oct 2020 04:55:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A28F62224D
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Oct 2020 04:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgJSEzk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Oct 2020 00:55:40 -0400
Received: from smtprelay0054.hostedemail.com ([216.40.44.54]:51006 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726829AbgJSEzk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Oct 2020 00:55:40 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id DC97B1822494D;
        Mon, 19 Oct 2020 04:55:36 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: self88_3d141c327234
X-Filterd-Recvd-Size: 5055
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf17.hostedemail.com (Postfix) with ESMTPA;
        Mon, 19 Oct 2020 04:55:34 +0000 (UTC)
Message-ID: <e59c0c575f9d9e1af8c6fdf2911cd9d028de257f.camel@perches.com>
Subject: Re: [PATCH] [v5] wireless: Initial driver submission for pureLiFi
 STA devices
From:   Joe Perches <joe@perches.com>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Date:   Sun, 18 Oct 2020 21:55:33 -0700
In-Reply-To: <20201019031744.17916-1-srini.raju@purelifi.com>
References: <20201016063444.29822-1-srini.raju@purelifi.com>
         <20201019031744.17916-1-srini.raju@purelifi.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2020-10-19 at 08:47 +0530, Srinivasan Raju wrote:
> This introduces the pureLiFi LiFi driver for LiFi-X, LiFi-XC
> and LiFi-XL USB devices.

Mostly trivial comments:

> diff --git a/drivers/net/wireless/purelifi/chip.c b/drivers/net/wireless/purelifi/chip.c
[]
> +int purelifi_chip_set_rate(struct purelifi_chip *chip, u8 rate)
> +{
> +	int r;
> +	static struct purelifi_chip *chip_p;

Isn't chip_p pointless?

> +
> +	if (chip)
> +		chip_p = chip;
> +	if (!chip_p)
> +		return -EINVAL;
> +

chip_p is otherwise unused.

> diff --git a/drivers/net/wireless/purelifi/mac.c b/drivers/net/wireless/purelifi/mac.c
[]
> +int purelifi_mac_init_hw(struct ieee80211_hw *hw)
> +{
> +	int r;
> +	struct purelifi_mac *mac = purelifi_hw_mac(hw);
> +	struct purelifi_chip *chip = &mac->chip;
> +
> +	r = purelifi_chip_init_hw(chip);
> +	if (r) {
> +		dev_warn(purelifi_mac_dev(mac), "init hw failed (%d)\n", r);
> +		goto out;
> +	}
> +
> +	dev_dbg(purelifi_mac_dev(mac), "irq_disabled %d\n", irqs_disabled());
> +
> +	r = regulatory_hint(hw->wiphy, "CA");
> +out:
> +	return r;
> +}

Simpler without the out: label and a direct return

	if (r) {
		dev_warn(...)
		return r;
	}

	...

	return regulator_hint(hw->wiphy, "CA");
}

> +static int download_fpga(struct usb_interface *intf)
> +{
[]
> +	if ((le16_to_cpu(udev->descriptor.idVendor) ==
> +				PURELIFI_X_VENDOR_ID_0) &&
> +	    (le16_to_cpu(udev->descriptor.idProduct) ==
> +				PURELIFI_X_PRODUCT_ID_0)) {
> +		fw_name = "purelifi/li_fi_x/fpga.bit";
> +		dev_info(&intf->dev, "bit file for X selected.\n");
> +
> +	} else if ((le16_to_cpu(udev->descriptor.idVendor)) ==
> +					PURELIFI_XC_VENDOR_ID_0 &&
> +		   (le16_to_cpu(udev->descriptor.idProduct) ==
> +					PURELIFI_XC_PRODUCT_ID_0)) {
> +		fw_name = "purelifi/li_fi_x/fpga_xc.bit";
> +		dev_info(&intf->dev, "bit filefor XC selected.\n");

Inconsistent dev_info spacing: "file for" vs "filefor"

> +	for (fw_data_i = 0; fw_data_i < fw->size;) {
> +		int tbuf_idx;
> +
> +		if ((fw->size - fw_data_i) < blk_tran_len)
> +			blk_tran_len = fw->size - fw_data_i;
> +
> +		fw_data = kmalloc(blk_tran_len, GFP_KERNEL);
> +
> +		memcpy(fw_data, &fw->data[fw_data_i], blk_tran_len);
> +
> +		for (tbuf_idx = 0; tbuf_idx < blk_tran_len; tbuf_idx++) {
> +			fw_data[tbuf_idx] =
> +				((fw_data[tbuf_idx] & 128) >> 7) |
> +				((fw_data[tbuf_idx] &  64) >> 5) |
> +				((fw_data[tbuf_idx] &  32) >> 3) |
> +				((fw_data[tbuf_idx] &  16) >> 1) |
> +				((fw_data[tbuf_idx] &   8) << 1) |
> +				((fw_data[tbuf_idx] &   4) << 3) |
> +				((fw_data[tbuf_idx] &   2) << 5) |
> +				((fw_data[tbuf_idx] &   1) << 7);
> +		}

pity there isn't an u8_bit_reverse function/mechanism

> +static void pretty_print_mac(struct usb_interface *intf, char *serial_number,
> +			     unsigned char *hw_address
> +			    )
> +{
> +	unsigned char i;
> +
> +	for (i = 0; i < ETH_ALEN; i++)
> +		dev_info(&intf->dev, "hw_address[%d]=%x\n", i, hw_address[i]);

I don't think this prettier than %pM

> +}
> +
> +static int upload_mac_and_serial_number(struct usb_interface *intf,
> +					unsigned char *hw_address,
> +					unsigned char *serial_number)
> +{
[]
> +	do {
> +		unsigned char buf[8];
> +
> +		msleep(200);
> +
> +		send_vendor_request(udev, 0x40, buf, sizeof(buf));
> +		flash.enabled = buf[0] & 0xFF;
> +
> +		if (flash.enabled) {
> +			flash.sectors = ((buf[6] & 255) << 24) |

buf is unsigned char[], rather pointless using & 255

> diff --git a/drivers/net/wireless/purelifi/usb.h b/drivers/net/wireless/purelifi/usb.h
[]
> +struct station_t {
> +   //  7...3    |    2     |     1     |     0     |
> +   // Reserved  | Hearbeat | FIFO full | Connected |

heartbeat


