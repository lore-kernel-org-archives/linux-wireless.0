Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48686 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751645AbdFNJEd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Jun 2017 05:04:33 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org, Alexey.Brodkin@synopsys.com,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: Re: [PATCH 6/6] rsi: add tx frame for common device configuration
References: <1496412785-8720-1-git-send-email-amit.karwar@redpinesignals.com>
        <1496412785-8720-7-git-send-email-amit.karwar@redpinesignals.com>
Date: Wed, 14 Jun 2017 12:04:28 +0300
In-Reply-To: <1496412785-8720-7-git-send-email-amit.karwar@redpinesignals.com>
        (Amitkumar Karwar's message of "Fri, 2 Jun 2017 19:43:05 +0530")
Message-ID: <87d1a7os83.fsf@purkki.adurom.net> (sfid-20170614_112224_085207_127A1778)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>
> After successful loading of firmware, a CARD READY indication is
> received by host. Common device configuration parameters are sent
> to the device after this. It includes information like device
> operating mode (Wi-Fi alone or BT coex), power save related
> parameters, GPIO information etc. As device supports BT coex,
> this frame is send in COEX queue initially. Based on the operating
> mode, CARD READY indication is received from each protocol module
> in firmware i.e. WLAN, BT.
>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

[...]

> +struct rsi_ulp_gpio_vals {
> +#ifdef __LITTLE_ENDIAN
> +	u8 motion_sensor_gpio_ulp_wakeup:1;
> +	u8 sleep_ind_from_device:1;
> +	u8 ulp_gpio_2:1;
> +	u8 push_button_ulp_wakeup:1;
> +	u8 reserved:4;
> +#else
> +	u8 reserved:4;
> +	u8 push_button_ulp_wakeup:1;
> +	u8 ulp_gpio_2:1;
> +	u8 sleep_ind_from_device:1;
> +	u8 motion_sensor_gpio_ulp_wakeup:1;
> +#endif
> +} __packed;

This is something I'm not exactly thrilled to see (bitfields are not
really liked in upstream community) but I'm not going to reject that
either as we have other offenders, rtl8xxxx being one. But it's much
better that to __le_to_cpu(), FIELD_GET() & co. That you don't need to
duplicate the fields and is less error prone.

> +struct rsi_config_vals {
> +#ifdef __LITTLE_ENDIAN
> +	u16 len:12;
> +	u16 q_no:4;
> +#else
> +	u16 q_no:4;
> +	u16 len:12;
> +#endif
> +	u8 pkt_type;
> +	u8 misc_flags;
> +	__le16 reserved1[6];
> +	u8 lp_ps_handshake;
> +	u8 ulp_ps_handshake;
> +	u8 sleep_config_params; /* 0 for no handshake,
> +				 * 1 for GPIO based handshake,
> +				 * 2 packet handshake
> +				 */
> +	u8 unused_ulp_gpio;
> +	u32 unused_soc_gpio_bitmap;
> +	u8 ext_pa_or_bt_coex_en;
> +	u8 opermode;
> +	u8 wlan_rf_pwr_mode;
> +	u8 bt_rf_pwr_mode;
> +	u8 zigbee_rf_pwr_mode;
> +	u8 driver_mode;
> +	u8 region_code;
> +	u8 antenna_sel_val;
> +	u8 reserved2[16];
> +} __packed;

But here you are even mixing use of __LITTLE_ENDIAN and __le16, that's
just weird. And shouldn't unused_soc_gpio_bitmap be __le32?

-- 
Kalle Valo
