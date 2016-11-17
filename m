Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43534 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941355AbcKQLCc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 06:02:32 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com,
        hofrat@osadl.org, xypron.glpk@gmx.de,
        prameela.garnepudi@redpinesignals.com
Subject: Re: [PATCH 3/5] rsi: Added support for configuring tx power
References: <1479125836-2722-1-git-send-email-prameela.j04cs@gmail.com>
Date: Thu, 17 Nov 2016 13:02:22 +0200
In-Reply-To: <1479125836-2722-1-git-send-email-prameela.j04cs@gmail.com>
        (Prameela Rani Garnepudi's message of "Mon, 14 Nov 2016 17:47:16
        +0530")
Message-ID: <87eg2apdxd.fsf@purkki.adurom.net> (sfid-20161117_120254_960912_CAE1643D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prameela Rani Garnepudi <prameela.j04cs@gmail.com> writes:

> TX power can be configured from iwconfig, iw or from mac80211 when
> regulatory changes are done. Hence support for configuring tx power
> to device is added. This can be done by sending RADIO_PARAMS_UPDATE
> command frame to device with upated tx power value.
>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

[...]

>  /* Send Frames Types */
>  enum cmd_frame_type {
> -	TX_DOT11_MGMT,
> -	RESET_MAC_REQ,
> -	RADIO_CAPABILITIES,
> -	BB_PROG_VALUES_REQUEST,
> -	RF_PROG_VALUES_REQUEST,
> -	WAKEUP_SLEEP_REQUEST,
> -	SCAN_REQUEST,
> -	TSF_UPDATE,
> -	PEER_NOTIFY,
> -	BLOCK_HW_QUEUE,
> -	SET_KEY_REQ,
> -	AUTO_RATE_IND,
> -	BOOTUP_PARAMS_REQUEST,
> -	VAP_CAPABILITIES,
> -	EEPROM_READ_TYPE ,
> -	EEPROM_WRITE,
> -	GPIO_PIN_CONFIG ,
> -	SET_RX_FILTER,
> -	AMPDU_IND,
> -	STATS_REQUEST_FRAME,
> -	BB_BUF_PROG_VALUES_REQ,
> -	BBP_PROG_IN_TA,
> -	BG_SCAN_PARAMS,
> -	BG_SCAN_PROBE_REQ,
> -	CW_MODE_REQ,
> -	PER_CMD_PKT
> +	TX_DOT11_MGMT = 0,
> +	RESET_MAC_REQ, /* 0x1 */
> +	RADIO_CAPABILITIES, /* 0x2 */
> +	BB_PROG_VALUES_REQUEST, /* 0x3 */
> +	RF_PROG_VALUES_REQUEST, /* 0x4 */
> +	WAKEUP_SLEEP_REQUEST, /* 0x5 */
> +	SCAN_REQUEST, /* 0x6 */
> +	TSF_UPDATE, /* 0x7 */
> +	PEER_NOTIFY, /* 0x8 */
> +	BLOCK_HW_QUEUE, /* 0x9 */
> +	SET_KEY_REQ, /* 0xA */
> +	AUTO_RATE_IND, /* 0xB */
> +	BOOTUP_PARAMS_REQUEST, /* 0xC */
> +	VAP_CAPABILITIES, /* 0xD */
> +	EEPROM_READ_TYPE, /* 0xE */
> +	EEPROM_WRITE, /* 0xF */
> +	GPIO_PIN_CONFIG, /* 0x10 */
> +	SET_RX_FILTER, /* 0x11 */
> +	AMPDU_IND, /* 0x12 */
> +	STATS_REQUEST, /* 0x13 */
> +	BB_BUF_PROG_VALUES_REQ, /* 0x14 */
> +	BBP_PROG_IN_TA, /* 0x15 */
> +	BG_SCAN_PARAMS, /* 0x16 */
> +	BG_SCAN_PROBE_REQ, /* 0x17 */
> +	CW_MODE_REQ, /* 0x18 */
> +	PER_CMD_PKT, /* 0x19 */
> +	DEV_SLEEP_REQUEST, /* 0x1A */
> +	DEV_WAKEUP_CNF,  /* 0x1B */
> +	RF_LOOPBACK_REQ, /* 0x1C */
> +	RF_LPBK_M3,  /* 0x1D */
> +	RF_RESET_FRAME,  /* 0x1E */
> +	LMAC_REG_OPS,  /* 0x1F */
> +	ANT_SEL_FRAME, /* 0x20 */
> +	CONFIRM, /* 0x21 */
> +	WLAN_DE_REGISTER, /* 0x22 */
> +	DEBUG_FRAME,  /* 0x23 */
> +	HW_BMISS_HANDLE, /* 0x24 */
> +	MULTICAST_ENABLE, /* 0x25 */
> +	TX_MISC_IND, /* 0x26 */
> +	VAP_DYNAMIC_UPDATE, /* 0x27 */
> +	COMMON_DEV_CONFIG, /* 0x28 */
> +	RADIO_PARAMS_UPDATE, /* 0x29 */
> +	RADAR_REQUEST, /* 0x2A */
> +	WOWLAN_CONFIG_PARAMS, /* 2B */
> +	IAP_CONFIG, /* 0x2C */
>  };

Adding the values for enums is a separate logical change and makes it
hard to see the real changes, so please do this in a separate patch.

But in overall your patches look now _much_ better, easy to review and
basically what I expect to see. Keep up the good work.

-- 
Kalle Valo
