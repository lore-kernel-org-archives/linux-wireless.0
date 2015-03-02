Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:43041 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbbCBMHa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 07:07:30 -0500
Received: by wesu56 with SMTP id u56so32839665wes.10
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2015 04:07:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1425295680-2269-2-git-send-email-vthiagar@qti.qualcomm.com>
References: <1425295680-2269-1-git-send-email-vthiagar@qti.qualcomm.com>
	<1425295680-2269-2-git-send-email-vthiagar@qti.qualcomm.com>
Date: Mon, 2 Mar 2015 13:07:29 +0100
Message-ID: <CA+BoTQkJbshivUL304juyS6JdwGu0n_NPeMNa=qDtsdRjVvd6Q@mail.gmail.com> (sfid-20150302_130734_194612_805B8713)
Subject: Re: [PATCH V4 2/2] ath10k: Fix interrupt storm
From: Michal Kazior <michal.kazior@tieto.com>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 March 2015 at 12:28, Vasanthakumar Thiagarajan
<vthiagar@qti.qualcomm.com> wrote:
[...]
> +static bool ath10k_mac_should_disable_promisc(struct ath10k *ar)
> +{
> +       struct ath10k_vif *arvif;
> +
> +       if (!(ar->filter_flags & FIF_PROMISC_IN_BSS))
> +               return true;
> +
> +       if (!ar->num_started_vdevs)
> +               return false;
> +
> +       list_for_each_entry(arvif, &ar->arvifs, list)
> +               if (arvif->vdev_type != WMI_VDEV_TYPE_AP)
> +                       return false;
> +
> +       ath10k_dbg(ar, ATH10K_DBG_MAC,
> +                  "mac disabling promiscuous mode because vdev is started\n");
> +       ar->filter_flags &= ~FIF_PROMISC_IN_BSS;

ar->filter_flags shouldn't be changed. Especially in a function which
shouldn't have side-effects.


Michał
