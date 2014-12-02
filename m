Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:45026 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbaLBLv7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 06:51:59 -0500
Received: by mail-wi0-f176.google.com with SMTP id ex7so27715411wid.15
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 03:51:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141201144507.18248.9856.stgit@potku.adurom.net>
References: <20141201144400.18248.62714.stgit@potku.adurom.net>
	<20141201144507.18248.9856.stgit@potku.adurom.net>
Date: Tue, 2 Dec 2014 12:51:58 +0100
Message-ID: <CA+BoTQm+JqCEXPQ4njxGvm-v_Typ0BDTK5g8627O_-gKiTWHZw@mail.gmail.com> (sfid-20141202_125202_362421_D682FC13)
Subject: Re: [PATCH v3 2/7] ath10k: add ATH10K_FW_IE_WMI_OP_VERSION
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 December 2014 at 15:45, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
[...]
> @@ -562,6 +562,17 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
>                         ar->otp_len = ie_len;
>
>                         break;
> +               case ATH10K_FW_IE_WMI_OP_VERSION:
> +                       if (ie_len != sizeof(u32))
> +                               break;
> +
> +                       version = (__le32 *)data;
> +
> +                       ar->wmi.op_version = le32_to_cpup(version);
> +
> +                       ath10k_dbg(ar, ATH10K_DBG_BOOT, "found fw ie wmi op version %d\n",
> +                                  ar->wmi.op_version);

Hmm.. wouldn't it make sense to have a ATH10K_FW_WMI_OP_VERSION_MAX
(or _LAST) and verify if the IE value doesn't exceed the last known
value? This way switch()es won't need default handler by design and
thus we'll get the benefit of compiler telling us about unhandled
cases when we add new enums.


Michał
