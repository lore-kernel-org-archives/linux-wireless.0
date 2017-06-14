Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51294 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751864AbdFNJHk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Jun 2017 05:07:40 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org, Alexey.Brodkin@synopsys.com,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: Re: [PATCH 6/6] rsi: add tx frame for common device configuration
References: <1496412785-8720-1-git-send-email-amit.karwar@redpinesignals.com>
        <1496412785-8720-7-git-send-email-amit.karwar@redpinesignals.com>
Date: Wed, 14 Jun 2017 12:07:36 +0300
In-Reply-To: <1496412785-8720-7-git-send-email-amit.karwar@redpinesignals.com>
        (Amitkumar Karwar's message of "Fri, 2 Jun 2017 19:43:05 +0530")
Message-ID: <878tkvos2v.fsf@purkki.adurom.net> (sfid-20170614_110946_925676_7A12A64F)
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

> +static struct rsi_soc_gpio_vals unused_soc_gpio_bitmap = {
> +	.pspi_csn_0		= USED_GPIO,	//GPIO_0
> +	.pspi_csn_1		= USED_GPIO,	//GPIO_1
> +	.host_wakeup_intr	= USED_GPIO,	//GPIO_2
> +	.pspi_data_0		= USED_GPIO,	//GPIO_3
> +	.pspi_data_1		= USED_GPIO,	//GPIO_4
> +	.pspi_data_2		= USED_GPIO,	//GPIO_5
> +	.pspi_data_3		= USED_GPIO,	//GPIO_6
> +	.i2c_scl		= USED_GPIO,	//GPIO_7
> +	.i2c_sda		= USED_GPIO,	//GPIO_8
> +	.uart1_rx		= UNUSED_GPIO,	//GPIO_9
> +	.uart1_tx		= UNUSED_GPIO,	//GPIO_10
> +	.uart1_rts_i2s_clk	= UNUSED_GPIO,	//GPIO_11
> +	.uart1_cts_i2s_ws	= UNUSED_GPIO,	//GPIO_12
> +	.dbg_uart_rx_i2s_din	= UNUSED_GPIO,	//GPIO_13
> +	.dbg_uart_tx_i2s_dout	= UNUSED_GPIO,	//GPIO_14
> +	.lp_wakeup_boot_bypass	= UNUSED_GPIO,	//GPIO_15
> +	.led_0			= USED_GPIO,	//GPIO_16
> +	.btcoex_wlan_active_ext_pa_ant_sel_A = UNUSED_GPIO, //GPIO_17
> +	.btcoex_bt_priority_ext_pa_ant_sel_B = UNUSED_GPIO, //GPIO_18
> +	.btcoex_bt_active_ext_pa_on_off = UNUSED_GPIO, //GPIO_19
> +	.rf_reset		= USED_GPIO, //GPIO_20
> +	.sleep_ind_from_device	= UNUSED_GPIO,
> +};

No //, please. Use instead /* */.

-- 
Kalle Valo
