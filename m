Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:33518 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbaLHGv3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2014 01:51:29 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so5433922wgh.34
        for <linux-wireless@vger.kernel.org>; Sun, 07 Dec 2014 22:51:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141203081054.31187.10953.stgit@potku.adurom.net>
References: <20141203080803.31187.85059.stgit@potku.adurom.net>
	<20141203081054.31187.10953.stgit@potku.adurom.net>
Date: Mon, 8 Dec 2014 07:51:28 +0100
Message-ID: <CA+BoTQ=MbCkF11QwqCGbtPm4veFKrUmN=3dQ_zK+APeWifCRPQ@mail.gmail.com> (sfid-20141208_075137_223228_8BDC21CD)
Subject: Re: [PATCH v4 6/8] ath10k: introduce wmi ops
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 December 2014 at 09:10, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
[...]
>  int ath10k_wmi_attach(struct ath10k *ar)
>  {
> -       if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
> -               if (test_bit(ATH10K_FW_FEATURE_WMI_10_2, ar->fw_features))
> -                       ar->wmi.cmd = &wmi_10_2_cmd_map;
> -               else
> -                       ar->wmi.cmd = &wmi_10x_cmd_map;
> -
> +       switch (ar->wmi.op_version) {
> +       case ATH10K_FW_WMI_OP_VERSION_10_2:
> +               ar->wmi.cmd = &wmi_10_2_cmd_map;
> +               ar->wmi.ops = &wmi_10_2_ops;
>                 ar->wmi.vdev_param = &wmi_10x_vdev_param_map;
>                 ar->wmi.pdev_param = &wmi_10x_pdev_param_map;
> -       } else {
> +               break;
> +       case ATH10K_FW_WMI_OP_VERSION_10_1:
> +               ar->wmi.cmd = &wmi_10x_cmd_map;
> +               ar->wmi.ops = &wmi_10_1_ops;
> +               ar->wmi.vdev_param = &wmi_10x_vdev_param_map;
> +               ar->wmi.pdev_param = &wmi_10x_pdev_param_map;
> +               break;
> +       case ATH10K_FW_WMI_OP_VERSION_MAIN:
>                 ar->wmi.cmd = &wmi_cmd_map;
> +               ar->wmi.ops = &wmi_ops;
>                 ar->wmi.vdev_param = &wmi_vdev_param_map;
>                 ar->wmi.pdev_param = &wmi_pdev_param_map;
> +               break;
> +       default:

I think we don't need the `default` here now, do we? Instead _UNSET
and _MAX should be handled.


Michał
