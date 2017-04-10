Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16575 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754515AbdDJPkN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 11:40:13 -0400
From: "Mohammed Shafi Shajakhan (Mohammed Shafi)"
        <mohammed@qti.qualcomm.com>
To: Adrian Chadd <adrian@freebsd.org>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "Mohammed Shafi Shajakhan" <mohammed@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Fix spectral scan for QCA99X0 family of chipsets
Date: Mon, 10 Apr 2017 15:40:05 +0000
Message-ID: <1491838804882.81793@qti.qualcomm.com> (sfid-20170410_174028_286369_9E26D81C)
References: <1491834374-25239-1-git-send-email-mohammed@qca.qualcomm.com>,<CAJ-Vmo=-=vwhGLQHLjN=Spx9d4+tXC_k8LtNOvsMnV2XiagWaQ@mail.gmail.com>
In-Reply-To: <CAJ-Vmo=-=vwhGLQHLjN=Spx9d4+tXC_k8LtNOvsMnV2XiagWaQ@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Adrian,=0A=
=0A=
For reference, would you mind pulling out what hte format of the edge=0A=
detection dword is?=0A=
=0A=
[shafi] Sorry I did not dig into the DWORD carrying some radar related info=
,=0A=
as this gets discarded anyway for spectral processing. If you think the dis=
carded=0A=
data is going to be useful in some way ??, let me get the dump for you. But=
 feel=0A=
free to experiment with this patch !=0A=
=0A=
This is anyway needed for fixing spectral scan ...=0A=
=0A=
If you look into this patch more closely it just extends what Raja had fixe=
d=0A=
long time back for QCA99X0 alone=0A=
https://patchwork.kernel.org/patch/7040681/=0A=
=0A=
regards,=0A=
shafi=0A=
=0A=
=0A=
On 10 April 2017 at 07:26, Mohammed Shafi Shajakhan=0A=
<mohammed@qti.qualcomm.com> wrote:=0A=
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>=0A=
>=0A=
> spectral_bin length (number of bins per fft sample) is usually=0A=
> a value where (2^n =3D value), n is an integer.  All of the QCA99X0=0A=
> family of chipsets seems to report a spectral_bin length of=0A=
> 2^n + 'm' bytes, where m =3D 4, 12 based on the chipset. This 'm'=0A=
> bytes seems to carry some radar related info which is currenly=0A=
> discarded only for 'bin_len =3D 68' bytes. Extend this discarding of=0A=
> irrelevant 'bin_len' for QCA9984, QCA9888, IPQ4019 as well by=0A=
> introducing a hardware parameter 'spectral_bin_discard'. Also=0A=
> for QCA988X based family of chipsets which doesn't seem to have this=0A=
> issue and also for some of the hardware which I have not tested=0A=
> like QCA6174/QCA9377 the existing behaviour is retained as it is.=0A=
>=0A=
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>=0A=
> ---=0A=
>=0A=
>  drivers/net/wireless/ath/ath10k/core.c     | 12 ++++++++++++=0A=
>  drivers/net/wireless/ath/ath10k/hw.h       |  3 +++=0A=
>  drivers/net/wireless/ath/ath10k/spectral.c | 25 +++++++++++++++++-------=
-=0A=
>  3 files changed, 32 insertions(+), 8 deletions(-)=0A=
>=0A=
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireles=
s/ath/ath10k/core.c=0A=
> index 5736f79..b543c84 100644=0A=
> --- a/drivers/net/wireless/ath/ath10k/core.c=0A=
> +++ b/drivers/net/wireless/ath/ath10k/core.c=0A=
> @@ -71,6 +71,7 @@=0A=
>                 },=0A=
>                 .hw_ops =3D &qca988x_ops,=0A=
>                 .decap_align_bytes =3D 4,=0A=
> +               .spectral_bin_discard =3D 0,=0A=
>         },=0A=
>         {=0A=
>                 .id =3D QCA9887_HW_1_0_VERSION,=0A=
> @@ -91,6 +92,7 @@=0A=
>                 },=0A=
>                 .hw_ops =3D &qca988x_ops,=0A=
>                 .decap_align_bytes =3D 4,=0A=
> +               .spectral_bin_discard =3D 0,=0A=
>         },=0A=
>         {=0A=
>                 .id =3D QCA6174_HW_2_1_VERSION,=0A=
> @@ -110,6 +112,7 @@=0A=
>                 },=0A=
>                 .hw_ops =3D &qca988x_ops,=0A=
>                 .decap_align_bytes =3D 4,=0A=
> +               .spectral_bin_discard =3D 0,=0A=
>         },=0A=
>         {=0A=
>                 .id =3D QCA6174_HW_2_1_VERSION,=0A=
> @@ -129,6 +132,7 @@=0A=
>                 },=0A=
>                 .hw_ops =3D &qca988x_ops,=0A=
>                 .decap_align_bytes =3D 4,=0A=
> +               .spectral_bin_discard =3D 0,=0A=
>         },=0A=
>         {=0A=
>                 .id =3D QCA6174_HW_3_0_VERSION,=0A=
> @@ -148,6 +152,7 @@=0A=
>                 },=0A=
>                 .hw_ops =3D &qca988x_ops,=0A=
>                 .decap_align_bytes =3D 4,=0A=
> +               .spectral_bin_discard =3D 0,=0A=
>         },=0A=
>         {=0A=
>                 .id =3D QCA6174_HW_3_2_VERSION,=0A=
> @@ -168,6 +173,7 @@=0A=
>                 },=0A=
>                 .hw_ops =3D &qca988x_ops,=0A=
>                 .decap_align_bytes =3D 4,=0A=
> +               .spectral_bin_discard =3D 0,=0A=
>         },=0A=
>         {=0A=
>                 .id =3D QCA99X0_HW_2_0_DEV_VERSION,=0A=
> @@ -193,6 +199,7 @@=0A=
>                 .sw_decrypt_mcast_mgmt =3D true,=0A=
>                 .hw_ops =3D &qca99x0_ops,=0A=
>                 .decap_align_bytes =3D 1,=0A=
> +               .spectral_bin_discard =3D 4,=0A=
>         },=0A=
>         {=0A=
>                 .id =3D QCA9984_HW_1_0_DEV_VERSION,=0A=
> @@ -219,6 +226,7 @@=0A=
>                 .sw_decrypt_mcast_mgmt =3D true,=0A=
>                 .hw_ops =3D &qca99x0_ops,=0A=
>                 .decap_align_bytes =3D 1,=0A=
> +               .spectral_bin_discard =3D 12,=0A=
>         },=0A=
>         {=0A=
>                 .id =3D QCA9888_HW_2_0_DEV_VERSION,=0A=
> @@ -244,6 +252,7 @@=0A=
>                 .sw_decrypt_mcast_mgmt =3D true,=0A=
>                 .hw_ops =3D &qca99x0_ops,=0A=
>                 .decap_align_bytes =3D 1,=0A=
> +               .spectral_bin_discard =3D 12,=0A=
>         },=0A=
>         {=0A=
>                 .id =3D QCA9377_HW_1_0_DEV_VERSION,=0A=
> @@ -263,6 +272,7 @@=0A=
>                 },=0A=
>                 .hw_ops =3D &qca988x_ops,=0A=
>                 .decap_align_bytes =3D 4,=0A=
> +               .spectral_bin_discard =3D 0,=0A=
>         },=0A=
>         {=0A=
>                 .id =3D QCA9377_HW_1_1_DEV_VERSION,=0A=
> @@ -282,6 +292,7 @@=0A=
>                 },=0A=
>                 .hw_ops =3D &qca988x_ops,=0A=
>                 .decap_align_bytes =3D 4,=0A=
> +               .spectral_bin_discard =3D 0,=0A=
>         },=0A=
>         {=0A=
>                 .id =3D QCA4019_HW_1_0_DEV_VERSION,=0A=
> @@ -308,6 +319,7 @@=0A=
>                 .sw_decrypt_mcast_mgmt =3D true,=0A=
>                 .hw_ops =3D &qca99x0_ops,=0A=
>                 .decap_align_bytes =3D 1,=0A=
> +               .spectral_bin_discard =3D 4,=0A=
>         },=0A=
>  };=0A=
>=0A=
> diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/=
ath/ath10k/hw.h=0A=
> index f0fda0f..8a0f9db 100644=0A=
> --- a/drivers/net/wireless/ath/ath10k/hw.h=0A=
> +++ b/drivers/net/wireless/ath/ath10k/hw.h=0A=
> @@ -416,6 +416,9 @@ struct ath10k_hw_params {=0A=
>=0A=
>         /* Number of bytes used for alignment in rx_hdr_status of rx desc=
. */=0A=
>         int decap_align_bytes;=0A=
> +=0A=
> +       /* Number of bytes to be discarded for each FFT sample */=0A=
> +       int spectral_bin_discard;=0A=
>  };=0A=
>=0A=
>  struct htt_rx_desc;=0A=
> diff --git a/drivers/net/wireless/ath/ath10k/spectral.c b/drivers/net/wir=
eless/ath/ath10k/spectral.c=0A=
> index c061d69..3fd5d7d 100644=0A=
> --- a/drivers/net/wireless/ath/ath10k/spectral.c=0A=
> +++ b/drivers/net/wireless/ath/ath10k/spectral.c=0A=
> @@ -56,6 +56,21 @@ static uint8_t get_max_exp(s8 max_index, u16 max_magni=
tude, size_t bin_len,=0A=
>         return max_exp;=0A=
>  }=0A=
>=0A=
> +static inline size_t ath10k_spectral_fix_bin_size(struct ath10k *ar,=0A=
> +                                                 size_t bin_len)=0A=
> +{=0A=
> +       /* some chipsets reports bin size as 2^n bytes + 'm' bytes in=0A=
> +        * report mode 2. First 2^n bytes carries inband tones and last=
=0A=
> +        * 'm' bytes carries band edge detection data mainly used in=0A=
> +        * radar detection purpose. Strip last 'm' bytes to make bin size=
=0A=
> +        * as a valid one. 'm' can take possible values of 4, 12.=0A=
> +        */=0A=
> +       if (!is_power_of_2(bin_len))=0A=
> +               bin_len -=3D ar->hw_params.spectral_bin_discard;=0A=
> +=0A=
> +       return bin_len;=0A=
> +}=0A=
> +=0A=
>  int ath10k_spectral_process_fft(struct ath10k *ar,=0A=
>                                 struct wmi_phyerr_ev_arg *phyerr,=0A=
>                                 const struct phyerr_fft_report *fftr,=0A=
> @@ -70,17 +85,11 @@ int ath10k_spectral_process_fft(struct ath10k *ar,=0A=
>=0A=
>         fft_sample =3D (struct fft_sample_ath10k *)&buf;=0A=
>=0A=
> +       bin_len =3D ath10k_spectral_fix_bin_size(ar, bin_len);=0A=
> +=0A=
>         if (bin_len < 64 || bin_len > SPECTRAL_ATH10K_MAX_NUM_BINS)=0A=
>                 return -EINVAL;=0A=
>=0A=
> -       /* qca99x0 reports bin size as 68 bytes (64 bytes + 4 bytes) in=
=0A=
> -        * report mode 2. First 64 bytes carries inband tones (-32 to +31=
)=0A=
> -        * and last 4 byte carries band edge detection data (+32) mainly=
=0A=
> -        * used in radar detection purpose. Strip last 4 byte to make bin=
=0A=
> -        * size is valid one.=0A=
> -        */=0A=
> -       if (bin_len =3D=3D 68)=0A=
> -               bin_len -=3D 4;=0A=
>=0A=
>         reg0 =3D __le32_to_cpu(fftr->reg0);=0A=
>         reg1 =3D __le32_to_cpu(fftr->reg1);=0A=
> --=0A=
> 1.9.1=0A=
>=0A=
