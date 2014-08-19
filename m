Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:37255 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaHSJiM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 05:38:12 -0400
Received: by mail-we0-f171.google.com with SMTP id p10so6155237wes.30
        for <linux-wireless@vger.kernel.org>; Tue, 19 Aug 2014 02:38:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140819082316.16842.85085.stgit@potku.adurom.net>
References: <20140819082038.16842.46876.stgit@potku.adurom.net>
	<20140819082316.16842.85085.stgit@potku.adurom.net>
Date: Tue, 19 Aug 2014 11:38:10 +0200
Message-ID: <CA+BoTQk5pm9GoS41YGtE7VPdsNiuX294KgiR5aXH0WWBPVq4SA@mail.gmail.com> (sfid-20140819_113815_317224_729D109C)
Subject: Re: [PATCH v7 5/8] ath10k: dump exception stack contents on firmware crash
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 August 2014 10:23, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> Firmware developers can decode this and maybe figure out
> why the firmware crashed.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---
[...]
> +/* Save the firmware exception stack */
> +static void ath10k_pci_dump_exc_stack(struct ath10k *ar,
> +                                     struct ath10k_fw_crash_data *crash_data)
> +{
> +       lockdep_assert_held(&ar->data_lock);
> +
> +       BUILD_BUG_ON(ATH10K_FW_STACK_SIZE % 4);
> +
> +       ath10k_pci_diag_read_hi(ar, crash_data->exc_stack_buf,
> +                               hi_err_stack, ATH10K_FW_STACK_SIZE);

Current master tree performs an implicit byte swap so the stack read
from target will be in host endianess. IOW on big-endian host you'll
messed up data and there's no indication of endianess anymore.


Michał
