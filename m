Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:34401 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbbCBIWl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 03:22:41 -0500
Received: by widex7 with SMTP id ex7so12167671wid.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2015 00:22:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1425118689-32553-1-git-send-email-sjegadee@qti.qualcomm.com>
References: <1425118689-32553-1-git-send-email-sjegadee@qti.qualcomm.com>
Date: Mon, 2 Mar 2015 09:22:40 +0100
Message-ID: <CA+BoTQm_Z_sMqP311mv-ozMr+-JYZYx8M2r4z4pty7idKkDCMg@mail.gmail.com> (sfid-20150302_092245_547462_135D4B29)
Subject: Re: [PATCH] ath10k: Enable encrytion of ADDBA request in PMF configuration
From: Michal Kazior <michal.kazior@tieto.com>
To: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 February 2015 at 11:18, SenthilKumar Jegadeesan
<sjegadee@qti.qualcomm.com> wrote:
> In HT mode, firmware is not encrypting ADDBA request as PMF
> configuration is not set in peer flags during association.
>
> Set peer flags for MFP enabled station in ath10k driver.
>
> Implemented abstraction layer for peer flags.
>
> This change depends on mac80211 patch "[PATCH] mac80211: send
> station PMF configuration to driver".
>
> Signed-off-by: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
[...]
>  static bool ath10k_mac_sta_has_11g_rates(struct ieee80211_sta *sta)
> @@ -1752,6 +1759,11 @@ static int ath10k_peer_assoc_prepare(struct ath10k *ar,
>         ath10k_peer_assoc_h_qos(ar, vif, sta, arg);
>         ath10k_peer_assoc_h_phymode(ar, vif, sta, arg);
>
> +       if (sta->mfp) {
> +               if (ar->wmi.op_version == ATH10K_FW_WMI_OP_VERSION_10_2_4)
> +                       arg->peer_flags |= ar->wmi.peer_flags->wmi_peer_pmf;
> +       }

Why do you check for op_version here? Isn't the peer flag mapping
supposed to deal with the problem already?

This should be just:

 if (sta->mfp)
    arg->peer_flags |= ar->wmi.peer_flags->wmi_peer_pmf;

Backends which don't support PMF would have the wmi_peer_mpf = 0 so
`|= ` would change nothing.

I also think this should be in a separate patch (i.e. patch1=introduce
peer flag map, patch2=mfp fix).


[...]
> +struct wmi_peer_flags_map {
> +       u32 wmi_peer_auth;
> +       u32 wmi_peer_qos;
> +       u32 wmi_peer_need_ptk_4_way;
> +       u32 wmi_peer_need_gtk_2_way;
> +       u32 wmi_peer_apsd;
> +       u32 wmi_peer_ht;
> +       u32 wmi_peer_40MHZ;
> +       u32 wmi_peer_stbc;
> +       u32 wmi_peer_ldbc;
> +       u32 wmi_peer_dyn_mimops;
> +       u32 wmi_peer_static_mimops;
> +       u32 wmi_peer_spatial_mux;
> +       u32 wmi_peer_vht;
> +       u32 wmi_peer_80MHZ;
> +       u32 wmi_peer_vht_2g;
> +       u32 wmi_peer_pmf;
> +};

Does it make sense to have the wmi_peer_ prefix for each entry?
Without it it'd be less wrapping to fit into 80 column limit.

The `MHZ` should probably lower case. It doesn't make much sense to
promote them to uppercase. These will also be a problem if you strip
wmi_peer_ (can't start a symbol with a number) so perhaps bw40/bw80 or
bw_40mhz/bw_80mhz would be fine?


Other than that this looks good. Thanks!


Michał
