Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:53203 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756350AbdLVPrr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 10:47:47 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC v3 09/11] ath10k: add QCA9377 sdio hw_param item
Date: Fri, 22 Dec 2017 15:47:01 +0000
Message-ID: <877eteahoq.fsf@kamboji.qca.qualcomm.com> (sfid-20171222_164753_273152_FD59E106)
References: <20170917194013.8658-1-erik.stromdahl@gmail.com>
        <20170917194013.8658-10-erik.stromdahl@gmail.com>
In-Reply-To: <20170917194013.8658-10-erik.stromdahl@gmail.com> (Erik
        Stromdahl's message of "Sun, 17 Sep 2017 21:40:11 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> Hardware parameters for QCA9377 sdio devices.
>
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.c | 25 +++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath10k/hw.h   |  1 +
>  2 files changed, 26 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireles=
s/ath/ath10k/core.c
> index b6893254ef53..146a9f61b5f0 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -351,6 +351,31 @@ static const struct ath10k_hw_params ath10k_hw_param=
s_list[] =3D {
>  		.bus =3D ATH10K_BUS_USB,
>  		.start_once =3D true,
>  	},
> +	{
> +		.id =3D QCA9377_HW_1_1_DEV_VERSION,
> +		.dev_id =3D QCA9377_1_0_DEVICE_ID,
> +		.name =3D "qca9377 hw1.1 sdio",
> +		.patch_load_addr =3D QCA9377_HW_1_0_PATCH_LOAD_ADDR,
> +		.uart_pin =3D 19,
> +		.otp_exe_param =3D 0,
> +		.channel_counters_freq_hz =3D 88000,
> +		.max_probe_resp_desc_thres =3D 0,
> +		.cal_data_len =3D 8124,
> +		.fw =3D {
> +			.dir =3D QCA9377_HW_1_0_FW_DIR,
> +			.board =3D QCA9377_HW_1_0_BOARD_DATA_FILE_SDIO,
> +			.board_size =3D QCA9377_BOARD_DATA_SZ,
> +			.board_ext_size =3D QCA9377_BOARD_EXT_DATA_SZ,
> +		},
> +		.hw_ops =3D &qca6174_ops,
> +		.hw_clk =3D qca6174_clk,
> +		.target_cpu_freq =3D 176000000,
> +		.decap_align_bytes =3D 4,
> +		.max_num_peers =3D TARGET_QCA9377_HL_NUM_PEERS,
> +		.is_high_latency =3D true,
> +		.bus =3D ATH10K_BUS_SDIO,
> +		.start_once =3D true,
> +	},
>  	{
>  		.id =3D QCA4019_HW_1_0_DEV_VERSION,
>  		.dev_id =3D 0,
> diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/=
ath/ath10k/hw.h
> index 420851e26a09..77011a6cafa1 100644
> --- a/drivers/net/wireless/ath/ath10k/hw.h
> +++ b/drivers/net/wireless/ath/ath10k/hw.h
> @@ -128,6 +128,7 @@ enum qca9377_chip_id_rev {
>  #define QCA9377_HW_1_0_FW_DIR          ATH10K_FW_DIR "/QCA9377/hw1.0"
>  #define QCA9377_HW_1_0_BOARD_DATA_FILE "board.bin"
>  #define QCA9377_HW_1_0_BOARD_DATA_FILE_USB "board-usb.bin"
> +#define QCA9377_HW_1_0_BOARD_DATA_FILE_SDIO "board-sdio.bin"

Similar comment about not sure about having separate board.bin for sdio.

--=20
Kalle Valo=
