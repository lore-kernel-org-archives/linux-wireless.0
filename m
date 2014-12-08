Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:11733 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbaLHHDr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2014 02:03:47 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4 6/8] ath10k: introduce wmi ops
References: <20141203080803.31187.85059.stgit@potku.adurom.net>
	<20141203081054.31187.10953.stgit@potku.adurom.net>
	<CA+BoTQ=MbCkF11QwqCGbtPm4veFKrUmN=3dQ_zK+APeWifCRPQ@mail.gmail.com>
Date: Mon, 8 Dec 2014 09:03:30 +0200
In-Reply-To: <CA+BoTQ=MbCkF11QwqCGbtPm4veFKrUmN=3dQ_zK+APeWifCRPQ@mail.gmail.com>
	(Michal Kazior's message of "Mon, 8 Dec 2014 07:51:28 +0100")
Message-ID: <87fvcq4o8t.fsf@kamboji.qca.qualcomm.com> (sfid-20141208_080357_466470_410658AF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 3 December 2014 at 09:10, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> [...]
>>  int ath10k_wmi_attach(struct ath10k *ar)
>>  {
>> -       if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
>> -               if (test_bit(ATH10K_FW_FEATURE_WMI_10_2, ar->fw_features))
>> -                       ar->wmi.cmd = &wmi_10_2_cmd_map;
>> -               else
>> -                       ar->wmi.cmd = &wmi_10x_cmd_map;
>> -
>> +       switch (ar->wmi.op_version) {
>> +       case ATH10K_FW_WMI_OP_VERSION_10_2:
>> +               ar->wmi.cmd = &wmi_10_2_cmd_map;
>> +               ar->wmi.ops = &wmi_10_2_ops;
>>                 ar->wmi.vdev_param = &wmi_10x_vdev_param_map;
>>                 ar->wmi.pdev_param = &wmi_10x_pdev_param_map;
>> -       } else {
>> +               break;
>> +       case ATH10K_FW_WMI_OP_VERSION_10_1:
>> +               ar->wmi.cmd = &wmi_10x_cmd_map;
>> +               ar->wmi.ops = &wmi_10_1_ops;
>> +               ar->wmi.vdev_param = &wmi_10x_vdev_param_map;
>> +               ar->wmi.pdev_param = &wmi_10x_pdev_param_map;
>> +               break;
>> +       case ATH10K_FW_WMI_OP_VERSION_MAIN:
>>                 ar->wmi.cmd = &wmi_cmd_map;
>> +               ar->wmi.ops = &wmi_ops;
>>                 ar->wmi.vdev_param = &wmi_vdev_param_map;
>>                 ar->wmi.pdev_param = &wmi_pdev_param_map;
>> +               break;
>> +       default:
>
> I think we don't need the `default` here now, do we? Instead _UNSET
> and _MAX should be handled.

Correct. I folded this change:

--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4786,7 +4786,8 @@ int ath10k_wmi_attach(struct ath10k *ar)
                ar->wmi.vdev_param = &wmi_vdev_param_map;
                ar->wmi.pdev_param = &wmi_pdev_param_map;
                break;
-       default:
+       case ATH10K_FW_WMI_OP_VERSION_UNSET:
+       case ATH10K_FW_WMI_OP_VERSION_MAX:
                ath10k_err(ar, "unsupported WMI op version: %d\n",
                           ar->wmi.op_version);
                return -EINVAL;

-- 
Kalle Valo
