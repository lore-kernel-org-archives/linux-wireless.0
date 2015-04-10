Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:37938 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951AbbDJM1H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2015 08:27:07 -0400
Received: by wiun10 with SMTP id n10so24229115wiu.1
        for <linux-wireless@vger.kernel.org>; Fri, 10 Apr 2015 05:27:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1425641270-4059-1-git-send-email-sjegadee@qti.qualcomm.com>
References: <1425641270-4059-1-git-send-email-sjegadee@qti.qualcomm.com>
Date: Fri, 10 Apr 2015 14:26:39 +0200
Message-ID: <CA+BoTQmn6WTQY2OqS+jPeKHsJvy7Yxro0fuZ19xGzddfkJgJ3A@mail.gmail.com> (sfid-20150410_142717_005769_A9E76585)
Subject: Re: [PATCH V3 1/2] ath10k: Add abstraction layer for peer flags
From: Michal Kazior <michal.kazior@tieto.com>
To: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 March 2015 at 12:27, SenthilKumar Jegadeesan
<sjegadee@qti.qualcomm.com> wrote:
> Abstraction layer for peer flags is added to fix
> ABI breakage.
>
> Signed-off-by: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
[...]

Hi,

This patch seems to have many formatting issues:


> diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
> index f34baa0..a99793e 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
> @@ -2788,6 +2788,25 @@ static const struct wmi_ops wmi_tlv_ops = {
>         .gen_sta_keepalive = ath10k_wmi_tlv_op_gen_sta_keepalive,
>  };
>
> +static struct wmi_peer_flags_map wmi_tlv_peer_flags_map = {
> +        .auth = WMI_TLV_PEER_AUTH,
> +        .qos = WMI_TLV_PEER_QOS,
> +        .need_ptk_4_way = WMI_TLV_PEER_NEED_PTK_4_WAY,
> +        .need_gtk_2_way = WMI_TLV_PEER_NEED_GTK_2_WAY,
> +        .apsd = WMI_TLV_PEER_APSD,
> +        .ht = WMI_TLV_PEER_HT,
> +        .bw40 = WMI_TLV_PEER_40MHZ,
> +        .stbc = WMI_TLV_PEER_STBC,
> +        .ldbc = WMI_TLV_PEER_LDPC,
> +        .dyn_mimops = WMI_TLV_PEER_DYN_MIMOPS,
> +        .static_mimops = WMI_TLV_PEER_STATIC_MIMOPS,
> +        .spatial_mux = WMI_TLV_PEER_SPATIAL_MUX,
> +        .vht = WMI_TLV_PEER_VHT,
> +        .bw80 = WMI_TLV_PEER_80MHZ,
> +        .pmf = WMI_TLV_PEER_PMF,

Should be indented with tabs, not spaces.


> diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
> index d7a31e1..7159b69 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
> +++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
> @@ -527,6 +527,25 @@ enum wmi_tlv_vdev_param {
>         WMI_TLV_VDEV_PARAM_IBSS_PS_1RX_CHAIN_IN_ATIM_WINDOW_ENABLE,
>  };
>
> +enum wmi_tlv_peer_flags {
> +

Unnecessary empty line.


> +        WMI_TLV_PEER_AUTH = 0x00000001,
> +        WMI_TLV_PEER_QOS = 0x00000002,
> +        WMI_TLV_PEER_NEED_PTK_4_WAY = 0x00000004,
> +        WMI_TLV_PEER_NEED_GTK_2_WAY = 0x00000010,
> +        WMI_TLV_PEER_APSD = 0x00000800,
> +        WMI_TLV_PEER_HT = 0x00001000,
> +        WMI_TLV_PEER_40MHZ = 0x00002000,
> +        WMI_TLV_PEER_STBC = 0x00008000,
> +        WMI_TLV_PEER_LDPC = 0x00010000,
> +        WMI_TLV_PEER_DYN_MIMOPS = 0x00020000,
> +        WMI_TLV_PEER_STATIC_MIMOPS = 0x00040000,
> +        WMI_TLV_PEER_SPATIAL_MUX = 0x00200000,
> +        WMI_TLV_PEER_VHT = 0x02000000,
> +        WMI_TLV_PEER_80MHZ = 0x04000000,
> +        WMI_TLV_PEER_PMF = 0x08000000,

Should be indented with tabs, not spaces.


> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index c7ea77e..6be3726 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
[...]
> +static struct wmi_peer_flags_map wmi_10x_peer_flags_map = {
> +        .auth = WMI_10X_PEER_AUTH,
> +        .qos = WMI_10X_PEER_QOS,
> +        .need_ptk_4_way = WMI_10X_PEER_NEED_PTK_4_WAY,
> +        .need_gtk_2_way = WMI_10X_PEER_NEED_GTK_2_WAY,
> +        .apsd = WMI_10X_PEER_APSD,
> +        .ht = WMI_10X_PEER_HT,
> +        .bw40 = WMI_10X_PEER_40MHZ,
> +        .stbc = WMI_10X_PEER_STBC,
> +        .ldbc = WMI_10X_PEER_LDPC,
> +        .dyn_mimops = WMI_10X_PEER_DYN_MIMOPS,
> +        .static_mimops = WMI_10X_PEER_STATIC_MIMOPS,
> +        .spatial_mux = WMI_10X_PEER_SPATIAL_MUX,
> +        .vht = WMI_10X_PEER_VHT,
> +        .bw80 = WMI_10X_PEER_80MHZ,

Should be indented with tabs, not spaces.


> +};
> +
> +static struct wmi_peer_flags_map wmi_10_2_peer_flags_map = {
> +        .auth = WMI_10_2_PEER_AUTH,
> +        .qos = WMI_10_2_PEER_QOS,
> +        .need_ptk_4_way = WMI_10_2_PEER_NEED_PTK_4_WAY,
> +        .need_gtk_2_way = WMI_10_2_PEER_NEED_GTK_2_WAY,
> +        .apsd = WMI_10_2_PEER_APSD,
> +        .ht = WMI_10_2_PEER_HT,
> +        .bw40 = WMI_10_2_PEER_40MHZ,
> +        .stbc = WMI_10_2_PEER_STBC,
> +        .ldbc = WMI_10_2_PEER_LDPC,
> +        .dyn_mimops = WMI_10_2_PEER_DYN_MIMOPS,
> +        .static_mimops = WMI_10_2_PEER_STATIC_MIMOPS,
> +        .spatial_mux = WMI_10_2_PEER_SPATIAL_MUX,
> +        .vht = WMI_10_2_PEER_VHT,
> +        .bw80 = WMI_10_2_PEER_80MHZ,
> +        .vht_2g = WMI_10_2_PEER_VHT_2G,
> +        .pmf = WMI_10_2_PEER_PMF,

Should be indented with tabs, not spaces.


> diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
> index 28c1822..40d5244 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.h
> +++ b/drivers/net/wireless/ath/ath10k/wmi.h
[...]
> +struct wmi_peer_flags_map {
> +       u32 auth;
> +       u32 qos;
> +       u32 need_ptk_4_way;
> +       u32 need_gtk_2_way;
> +       u32 apsd;
> +       u32 ht;
> +       u32 bw40;
> +       u32 stbc;
> +       u32 ldbc;
> +       u32 dyn_mimops;
> +       u32 static_mimops;
> +       u32 spatial_mux;
> +       u32 vht;
> +       u32 bw80;
> +       u32 vht_2g;
> +       u32 pmf;
> +};
> +
> +enum wmi_peer_flags {
> +

Unnecessary empty line.


> +       WMI_PEER_AUTH = 0x00000001,
> +       WMI_PEER_QOS = 0x00000002,
> +       WMI_PEER_NEED_PTK_4_WAY = 0x00000004,
> +       WMI_PEER_NEED_GTK_2_WAY = 0x00000010,
> +       WMI_PEER_APSD = 0x00000800,
> +       WMI_PEER_HT = 0x00001000,
> +       WMI_PEER_40MHZ = 0x00002000,
> +       WMI_PEER_STBC = 0x00008000,
> +       WMI_PEER_LDPC = 0x00010000,
> +       WMI_PEER_DYN_MIMOPS = 0x00020000,
> +       WMI_PEER_STATIC_MIMOPS = 0x00040000,
> +       WMI_PEER_SPATIAL_MUX = 0x00200000,
> +       WMI_PEER_VHT = 0x02000000,
> +       WMI_PEER_80MHZ = 0x04000000,
> +       WMI_PEER_VHT_2G = 0x08000000,
> +       WMI_PEER_PMF = 0x10000000,
> +};
> +
> +enum wmi_10x_peer_flags {
> +

Unnecessary empty lines.


> +       WMI_10X_PEER_AUTH = 0x00000001,

This one's good, but..


> +        WMI_10X_PEER_QOS = 0x00000002,
> +        WMI_10X_PEER_NEED_PTK_4_WAY = 0x00000004,
> +        WMI_10X_PEER_NEED_GTK_2_WAY = 0x00000010,
> +        WMI_10X_PEER_APSD = 0x00000800,
> +        WMI_10X_PEER_HT = 0x00001000,
> +        WMI_10X_PEER_40MHZ = 0x00002000,
> +        WMI_10X_PEER_STBC = 0x00008000,
> +        WMI_10X_PEER_LDPC = 0x00010000,
> +        WMI_10X_PEER_DYN_MIMOPS = 0x00020000,
> +        WMI_10X_PEER_STATIC_MIMOPS = 0x00040000,
> +        WMI_10X_PEER_SPATIAL_MUX = 0x00200000,
> +        WMI_10X_PEER_VHT = 0x02000000,
> +        WMI_10X_PEER_80MHZ = 0x04000000,

These should be indented with tabs as well, not spaces.


> +};
> +
> +enum wmi_10_2_peer_flags {
> +

Unnecessary empty line.


> +        WMI_10_2_PEER_AUTH = 0x00000001,
> +        WMI_10_2_PEER_QOS = 0x00000002,
> +        WMI_10_2_PEER_NEED_PTK_4_WAY = 0x00000004,
> +        WMI_10_2_PEER_NEED_GTK_2_WAY = 0x00000010,
> +        WMI_10_2_PEER_APSD = 0x00000800,
> +        WMI_10_2_PEER_HT = 0x00001000,
> +        WMI_10_2_PEER_40MHZ = 0x00002000,
> +        WMI_10_2_PEER_STBC = 0x00008000,
> +        WMI_10_2_PEER_LDPC = 0x00010000,
> +        WMI_10_2_PEER_DYN_MIMOPS = 0x00020000,
> +        WMI_10_2_PEER_STATIC_MIMOPS = 0x00040000,
> +        WMI_10_2_PEER_SPATIAL_MUX = 0x00200000,
> +        WMI_10_2_PEER_VHT = 0x02000000,
> +        WMI_10_2_PEER_80MHZ = 0x04000000,
> +        WMI_10_2_PEER_VHT_2G = 0x08000000,
> +        WMI_10_2_PEER_PMF = 0x10000000,

Should be indented with tabs, not spaces.


Michał
