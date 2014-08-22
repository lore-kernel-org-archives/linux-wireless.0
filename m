Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:38725 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850AbaHVGtg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 02:49:36 -0400
Received: by mail-wg0-f51.google.com with SMTP id b13so9981063wgh.34
        for <linux-wireless@vger.kernel.org>; Thu, 21 Aug 2014 23:49:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140821124907.27159.64620.stgit@potku.adurom.net>
References: <20140821124705.27159.67898.stgit@potku.adurom.net>
	<20140821124907.27159.64620.stgit@potku.adurom.net>
Date: Fri, 22 Aug 2014 08:49:35 +0200
Message-ID: <CA+BoTQk6wvXMEWnfFvASJwzj2AC0VB=Zby+zLO-tJ3NN_eA2mg@mail.gmail.com> (sfid-20140822_084942_460826_DE948626)
Subject: Re: [PATCH v8 2/4] ath10k: provide firmware crash info via debugfs
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 August 2014 14:49, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> Store the firmware registers and other relevant data to a firmware crash dump
> file and provide it to user-space via debugfs. Should help with figuring out
> why the firmware crashed.
>
> kvalo: remove dbglog support, rework and refactor the code to avoid ifdefs and
> otherwise simplify it as well
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---
[...]
> +static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
> +{
> +       struct ath10k_fw_crash_data *crash_data = ar->debug.fw_crash_data;
> +       struct ath10k_dump_file_data *dump_data;
> +       struct ath10k_tlv_dump_data *dump_tlv;
> +       int hdr_len = sizeof(*dump_data);
> +       unsigned int len, sofar = 0;
> +       unsigned char *buf;
> +
> +       lockdep_assert_held(&ar->conf_mutex);
[...]
> +static int ath10k_fw_crash_dump_open(struct inode *inode, struct file *file)
> +{
> +       struct ath10k *ar = inode->i_private;
> +       struct ath10k_dump_file_data *dump;
> +       int ret;
> +
> +       mutex_lock(&ar->conf_mutex);

I don't think we need conf_mutex here at all, do we? I'm sorry, I
should've spotted this earlier. Feel free to just ignore me :-)

Other than that this looks fine.


Michał
