Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:64473 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbaHSJjV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 05:39:21 -0400
Received: by mail-we0-f180.google.com with SMTP id w61so6163954wes.25
        for <linux-wireless@vger.kernel.org>; Tue, 19 Aug 2014 02:39:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140819082325.16842.18721.stgit@potku.adurom.net>
References: <20140819082038.16842.46876.stgit@potku.adurom.net>
	<20140819082325.16842.18721.stgit@potku.adurom.net>
Date: Tue, 19 Aug 2014 11:39:20 +0200
Message-ID: <CA+BoTQ=H6Pnm39xxzT+u_kRBDkGujaR3r6gMyTU3V+8cZi0qLw@mail.gmail.com> (sfid-20140819_113924_795478_7CC282BA)
Subject: Re: [PATCH v7 6/8] ath10k: save firmware RAM and ROM BSS sections on crash
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
> This can be used to get a useful back trace out of a firmware
> crash that involves an interrupt handler.  For instance, a
> null-pointer-exception would be this kind of trace.  A user-space
> tool can read the debugfs file and decode things as wished.
>
> This requires a packaged firmware with a new IE to describe the
> BSS section starts and length.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---
[...]
> +static void ath10k_pci_dump_bss_ram(struct ath10k *ar,
> +                                   struct ath10k_fw_crash_data *crash_data) {
> +       int ret;
> +
> +       lockdep_assert_held(&ar->data_lock);
> +
> +       if (!ar->fw.ram_bss_addr)
> +               return;
> +
> +       if (!ar->fw.ram_bss_len)
> +               return;
> +
> +       ret = ath10k_pci_diag_read_mem(ar, ar->fw.ram_bss_addr,
> +                                      crash_data->ram_bss_buf,
> +                                      ar->fw.ram_bss_len);
> +       if (ret)
> +               ath10k_warn("failed to read firmware RAM BSS memory from %d (%d B): %d\n",
> +                           ar->fw.ram_bss_addr, ar->fw.ram_bss_len, ret);
> +}
> +
> +static void ath10k_pci_dump_bss_rom(struct ath10k *ar,
> +                                   struct ath10k_fw_crash_data *crash_data)
> +{
> +       int ret;
> +
> +       lockdep_assert_held(&ar->data_lock);
> +
> +       if (!ar->fw.rom_bss_addr)
> +               return;
> +
> +       if (!ar->fw.rom_bss_len)
> +               return;
> +
> +       ret = ath10k_pci_diag_read_mem(ar, ar->fw.rom_bss_addr,
> +                                      crash_data->rom_bss_buf,
> +                                      ar->fw.rom_bss_len);
> +       if (ret)
> +               ath10k_warn("failed to read firmware ROM BSS memory from %d (%d B): %d\n",
> +                           ar->fw.rom_bss_addr, ar->fw.rom_bss_len, ret);
> +}

Ditto as with other patches - endianess mess.


Michał
