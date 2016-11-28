Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35006 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751307AbcK1S57 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 13:57:59 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com,
        hofrat@osadl.org, xypron.glpk@gmx.de,
        prameela.garnepudi@redpinesignals.com
Subject: Re: [PATCH 1/2] rsi: New firware loading method for RSI 91X devices
References: <1477044595-10348-1-git-send-email-prameela.j04cs@gmail.com>
Date: Mon, 28 Nov 2016 20:57:54 +0200
In-Reply-To: <1477044595-10348-1-git-send-email-prameela.j04cs@gmail.com>
        (Prameela Rani Garnepudi's message of "Fri, 21 Oct 2016 15:39:55
        +0530")
Message-ID: <87vav7mnyl.fsf@purkki.adurom.net> (sfid-20161128_195802_415435_E7B8D40B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prameela Rani Garnepudi <prameela.j04cs@gmail.com> writes:

> RSI deprecated the old firmware loading method and introduced
> new method using soft boot loader for 9113 chipsets.
> Current driver only supports 9113 device model hence firmware
> loading method has been changed.
>
> In the new method, complete RAM image and flash image are present
> in the flash. Two firmwares present in the device, Boot loader firmware
> and functional firmware. Boot loader firmware is fixed but functional
> firmware can be changed. Before loading the functional firmware, host
> issues commands to check whether existing firmware in the chip and the
> firmware file content to load are same or not. If not, host issues
> commands to load the RAM image and then boot loaded switches to the
> functioanl firmware.
>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

A general rule is that existing firmware support should not be broken.
Instead there should be a transition period for some time end then
support for old firmware method is removed. But as I don't know if that
upstream driver is not that widely used I guess it might be ok to break
it as it won't cause that much problems to people.

Typo in the title: "firware"

>  drivers/net/wireless/rsi/Makefile           |    2 +-
>  drivers/net/wireless/rsi/rsi_91x_hal.c      | 1049 +++++++++++++++++++++++++++
>  drivers/net/wireless/rsi/rsi_91x_mgmt.c     |   49 ++
>  drivers/net/wireless/rsi/rsi_91x_pkt.c      |  215 ------
>  drivers/net/wireless/rsi/rsi_91x_sdio.c     |  231 +++++-
>  drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |  192 +----
>  drivers/net/wireless/rsi/rsi_91x_usb.c      |  176 ++++-
>  drivers/net/wireless/rsi/rsi_91x_usb_ops.c  |  130 +---
>  drivers/net/wireless/rsi/rsi_common.h       |    4 +
>  drivers/net/wireless/rsi/rsi_hal.h          |  150 ++++
>  drivers/net/wireless/rsi/rsi_main.h         |   68 +-
>  drivers/net/wireless/rsi/rsi_mgmt.h         |    2 +
>  drivers/net/wireless/rsi/rsi_sdio.h         |   18 +-
>  drivers/net/wireless/rsi/rsi_usb.h          |   14 +-
>  14 files changed, 1720 insertions(+), 580 deletions(-)
>  create mode 100644 drivers/net/wireless/rsi/rsi_91x_hal.c
>  delete mode 100644 drivers/net/wireless/rsi/rsi_91x_pkt.c
>  create mode 100644 drivers/net/wireless/rsi/rsi_hal.h

The patch is quite big which makes review hard. If you had split this
into, for example, three patches it would be a lot faster to review. You
seem to be doing multiple logical changes in one path.

But remember that neither the build nor runtime functionality should
break between the patches.

> +/* FLASH Firmware */
> +struct ta_metadata metadata_flash_content[] = {
> +	{"flash_content", 0x00010000},
> +	{"RS9113_WLAN_QSPI.rps", 0x00010000},
> +	{"RS9113_WLAN_BT_DUAL_MODE.rps", 0x00010000},
> +	{"RS9113_WLAN_ZIGBEE.rps", 0x00010000},
> +	{"RS9113_AP_BT_DUAL_MODE.rps", 0x00010000},
> +	{"RS9113_WLAN_QSPI.rps", 0x00010000}
> +};

Are the strings here the names of the firmware images on host
filesystem? The preference is that they are lower case.

Also will you be posting the firmware images to linux-firmware.git?

> +
> +/**
> + * rsi_send_data_pkt() - This function sends the received data packet from
> + *			 driver to device.
> + * @common: Pointer to the driver private structure.
> + * @skb: Pointer to the socket buffer structure.
> + *
> + * Return: status: 0 on success, -1 on failure.
> + */
> +int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
> +{
> +	struct rsi_hw *adapter = common->priv;
> +	struct ieee80211_hdr *wh = NULL;
> +	struct ieee80211_tx_info *info;
> +	struct skb_info *tx_params;
> +	struct ieee80211_bss_conf *bss = NULL;
> +	int status = -EINVAL;

Documentation and code don't match again.

> +	u8 ieee80211_hdr_size = MIN_802_11_HDR_LEN;
> +	u8 dword_align_bytes = 0;
> +	u8 header_size = 0;
> +	__le16 *frame_desc;
> +	struct xtended_desc *xtend_desc;
> +	u16 seq_num = 0;
> +
> +	info = IEEE80211_SKB_CB(skb);
> +	bss = &info->control.vif->bss_conf;
> +	tx_params = (struct skb_info *)info->driver_data;
> +
> +	if (!bss->assoc)
> +		goto err;
> +
> +	dword_align_bytes = ((uintptr_t)skb->data & 0x3f);

ALIGN()?

> +	header_size = dword_align_bytes + FRAME_DESC_SZ +
> +					sizeof(struct xtended_desc);
> +	if (header_size > skb_headroom(skb)) {
> +		rsi_dbg(ERR_ZONE, "%s: Not enough headroom\n", __func__);
> +		status = -ENOSPC;
> +		goto err;
> +	}
> +
> +	skb_push(skb, header_size);
> +	frame_desc = (__le16 *)&skb->data[0];
> +	xtend_desc = (struct xtended_desc *)&skb->data[FRAME_DESC_SZ];
> +	memset((u8 *)frame_desc, 0, header_size);
> +
> +	wh = (struct ieee80211_hdr *)&skb->data[header_size];
> +	seq_num = (le16_to_cpu(wh->seq_ctrl) >> 4);

I would hope include/linux/ieee80211.h already provides a macro for this.

> +	frame_desc[2] = cpu_to_le16(header_size - FRAME_DESC_SZ);
> +	if (ieee80211_is_data_qos(wh->frame_control)) {
> +		ieee80211_hdr_size += 2;
> +		frame_desc[6] |= cpu_to_le16(BIT(12));
> +	}

No magic numbers, please. What's frame_desc[6] and BIT(12)? English
constants are much more understandable.

> +
> +	if ((!(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)) &&
> +	    (common->secinfo.security_enable)) {
> +		if (rsi_is_cipher_wep(common))
> +			ieee80211_hdr_size += 4;
> +		else
> +			ieee80211_hdr_size += 8;
> +		frame_desc[6] |= cpu_to_le16(BIT(15));
> +	}
> +
> +	frame_desc[0] = cpu_to_le16((skb->len - FRAME_DESC_SZ) |
> +				    (RSI_WIFI_DATA_Q << 12));
> +	frame_desc[2] |= cpu_to_le16(ieee80211_hdr_size << 8);

Ditto. Why don't you have a struct for frame_desc?

> +	if (common->min_rate != 0xffff) {
> +		/* Send fixed rate */
> +		frame_desc[3] = cpu_to_le16(RATE_INFO_ENABLE);
> +		frame_desc[4] = cpu_to_le16(common->min_rate);
> +
> +		if (conf_is_ht40(&common->priv->hw->conf))
> +			frame_desc[5] = cpu_to_le16(FULL40M_ENABLE);
> +
> +		if ((common->vif_info[0].sgi) && (common->min_rate & 0x100)) {
> +			/* Only MCS rates */
> +			frame_desc[4] |= cpu_to_le16(ENABLE_SHORTGI_RATE);
> +		}
> +	}
> +
> +	if ((skb->data[header_size + 12] == 0x88) &&
> +	    (skb->data[header_size + 12] == 0x8e)) {
> +		rsi_dbg(INFO_ZONE, "*** Tx EAPOL ***\n");

I would think there's a cleaner way to check for EAPOL.

> +		frame_desc[6] |= cpu_to_le16(BIT(13));
> +		frame_desc[1] |= cpu_to_le16(BIT(12));
> +#define EAPOL_RETRY_CNT 15
> +		xtend_desc->retry_cnt = EAPOL_RETRY_CNT;
> +	}
> +
> +	frame_desc[6] |= cpu_to_le16(seq_num & 0xfff);
> +	frame_desc[7] = cpu_to_le16(((tx_params->tid & 0xf) << 4) |
> +				    (skb->priority & 0xf) |
> +				    (tx_params->sta_id << 8));

Lots of magic numbers.

> +	status = adapter->host_intf_ops->write_pkt(common->priv,
> +						   skb->data, skb->len);

[...]

> +	rsi_dbg(INFO_ZONE, "Invalidating regout\n");
> +	if ((hif_ops->master_reg_write(adapter,
> +				       SWBL_REGOUT,
> +				       (cmd | REGOUT_INVALID << 8),
> +				       2)) < 0) {
> +		rsi_dbg(ERR_ZONE,
> +			"%s: Command %0x REGOUT writing failed..\n",
> +			__func__, cmd);
> +		goto fail;
> +	}
> +	mdelay(1);
> +
> +	if (output == exp_resp) {
> +		rsi_dbg(INFO_ZONE,
> +			"%s: Recvd Expected resp %x for cmd %0x\n",
> +			__func__, output, cmd);
> +	} else {
> +		rsi_dbg(ERR_ZONE,
> +			"%s: Recvd resp %x for cmd %0x\n",
> +			__func__, output, cmd);
> +		goto fail;
> +	}
> +	return 0;
> +
> +fail:
> +	return -1;
> +}

The recommendation is that you use negative error values (-EINVAL etc)
everywhere and then just return that to upper layers. Not a hard
requirement, other drivers use this -1 style also, but not really liked.

> +#define align_address(a) ((unsigned long)(a) & ~0x7)

We have ALIGN() & co all for alignment, please don't reinvent the wheel.

> +	if (size == 2) {
> +		if ((addr & 0x3) == 0)
> +			*read_buf = *data;
> +		else
> +			*read_buf  = ((*data >> 16));
> +		*read_buf = (*read_buf & 0xFFFF);
> +	} else if (size == 1) {
> +		if ((addr & 0x3) == 0)
> +			*read_buf = *data;
> +		else if ((addr & 0x3) == 1)
> +			*read_buf = (*data >> 8);
> +		else if ((addr & 0x3) == 2)
> +			*read_buf = (*data >> 16);
> +		else
> +			*read_buf = (*data >> 24);
> +		*read_buf = (*read_buf & 0xFF);
> +	} else { /*size is 4 */
> +		*read_buf = *data;
> +	}

Can't you use swap32() and others?

I stopped the review here.

-- 
Kalle Valo
