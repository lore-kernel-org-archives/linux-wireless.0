Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:30336 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756620AbdLVPtk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 10:49:40 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC v3 08/11] ath10k: add QCA9377 usb hw_param item
Date: Fri, 22 Dec 2017 15:49:33 +0000
Message-ID: <87y3lu9302.fsf@kamboji.qca.qualcomm.com> (sfid-20171222_164947_514817_3F25B4F1)
References: <20170917194013.8658-1-erik.stromdahl@gmail.com>
        <20170917194013.8658-9-erik.stromdahl@gmail.com>
In-Reply-To: <20170917194013.8658-9-erik.stromdahl@gmail.com> (Erik
        Stromdahl's message of "Sun, 17 Sep 2017 21:40:10 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> Hardware parameters for QCA9377 usb devices.
>
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>

[...]

> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -328,6 +328,29 @@ static const struct ath10k_hw_params ath10k_hw_param=
s_list[] =3D {
>  		.vht160_mcs_rx_highest =3D 0,
>  		.vht160_mcs_tx_highest =3D 0,
>  	},
> +	{
> +		.id =3D QCA9377_HW_1_1_DEV_VERSION,
> +		.dev_id =3D QCA9377_1_0_DEVICE_ID,
> +		.name =3D "qca9377 hw1.1 usb",
> +		.patch_load_addr =3D QCA9377_HW_1_0_PATCH_LOAD_ADDR,
> +		.uart_pin =3D 6,
> +		.otp_exe_param =3D 0,
> +		.channel_counters_freq_hz =3D 88000,
> +		.max_probe_resp_desc_thres =3D 0,
> +		.cal_data_len =3D 8124,
> +		.fw =3D {
> +			.dir =3D QCA9377_HW_1_0_FW_DIR,
> +			.board =3D QCA9377_HW_1_0_BOARD_DATA_FILE_USB,
> +			.board_size =3D QCA9377_BOARD_DATA_SZ,
> +			.board_ext_size =3D QCA9377_BOARD_EXT_DATA_SZ,
> +		},
> +		.hw_ops =3D &qca988x_ops,
> +		.decap_align_bytes =3D 4,
> +		.max_num_peers =3D TARGET_QCA9377_HL_NUM_PEERS,
> +		.is_high_latency =3D true,
> +		.bus =3D ATH10K_BUS_USB,
> +		.start_once =3D true,
> +	},

Oh, forgot to mention that adding hw_params entry should be last in the
patchset and only added once all fixes etc are already in place (eg
patch 10 and 11 should be before this).

--=20
Kalle Valo=
