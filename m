Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50257 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaKYI66 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 03:58:58 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so8367539wiv.5
        for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2014 00:58:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87vbm31xno.fsf@kamboji.qca.qualcomm.com>
References: <20141124164037.29422.14033.stgit@potku.adurom.net>
	<20141124164159.29422.98462.stgit@potku.adurom.net>
	<87vbm31xno.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 25 Nov 2014 09:58:57 +0100
Message-ID: <CA+BoTQmZ=xa=z3237E55cejfOOZM3GYp8OstJobF7NHe=8wTHA@mail.gmail.com> (sfid-20141125_095901_571359_9E8F22EC)
Subject: Re: [PATCH v2 1/2] ath10k: add register access debugfs interface
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 November 2014 at 09:39, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Kalle Valo <kvalo@qca.qualcomm.com> writes:
>
>> +static ssize_t ath10k_reg_value_read(struct file *file,
>> +                                  char __user *user_buf,
>> +                                  size_t count, loff_t *ppos)
>> +{
>> +     struct ath10k *ar = file->private_data;
>> +     u8 buf[48];
>> +     unsigned int len;
>> +     u32 reg_addr, reg_val;
>> +
>> +     spin_lock_bh(&ar->data_lock);
>> +     reg_addr = ar->debug.reg_addr;
>> +     spin_unlock_bh(&ar->data_lock);
>> +
>> +     reg_val = ath10k_hif_read32(ar, reg_addr);
>> +     len = scnprintf(buf, sizeof(buf), "0x%08x:0x%08x\n", reg_addr, reg_val);
>> +
>> +     return simple_read_from_buffer(user_buf, count, ppos, buf, len);
>> +}
>
> I just realised that we need to check ar->state to make sure that
> firmware is running. Because of that I'll need to change the data_lock
> to conf_mutex as well.

Hmm.. It could actually work without firmware running. It just reads MMIO.

The problem I see now is the target may not be awake (Bartosz recently
fixed suspend bug by moving ath10k_pci_wake/sleep back to
hif_power_up) and accessing target registers without it being fully
awake can lead to host memory corruption. I guess ar->state will do
for now because getting this to work otherwise is going to be a little
tricky.


Michał
