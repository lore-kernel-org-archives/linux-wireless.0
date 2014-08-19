Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:33298 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbaHSJhM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 05:37:12 -0400
Received: by mail-wg0-f45.google.com with SMTP id x12so6250729wgg.16
        for <linux-wireless@vger.kernel.org>; Tue, 19 Aug 2014 02:37:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140819082307.16842.21519.stgit@potku.adurom.net>
References: <20140819082038.16842.46876.stgit@potku.adurom.net>
	<20140819082307.16842.21519.stgit@potku.adurom.net>
Date: Tue, 19 Aug 2014 11:37:10 +0200
Message-ID: <CA+BoTQmgu_bGP6MKV8rV83jWCNONZS+eiE7PDVNy++MvHQX9RA@mail.gmail.com> (sfid-20140819_113718_232408_F7438EFC)
Subject: Re: [PATCH v7 4/8] ath10k: save firmware stack upon firmware crash
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
> Should help debug firmware crashes, and give users a way
> to provide some useful debug reports to firmware developers.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---
[...]
> +/* Save the main firmware stack */
> +static void ath10k_pci_dump_stack(struct ath10k *ar,
> +                                 struct ath10k_fw_crash_data *crash_data)
> +{
> +       lockdep_assert_held(&ar->data_lock);
> +
> +       BUILD_BUG_ON(ATH10K_FW_STACK_SIZE % 4);
> +
> +       ath10k_pci_diag_read_hi(ar, crash_data->stack_buf,
> +                               hi_stack, ATH10K_FW_STACK_SIZE);

Current master tree performs an implicit byte swap so the stack read
from target will be in host endianess. IOW on big-endian host you'll
messed up data and there's no indication of endianess anymore.


Michał
