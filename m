Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:63440 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaKYJDR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 04:03:17 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so643075wiv.13
        for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2014 01:03:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87r3wr1xl6.fsf@kamboji.qca.qualcomm.com>
References: <20141124164037.29422.14033.stgit@potku.adurom.net>
	<20141124164208.29422.76134.stgit@potku.adurom.net>
	<87r3wr1xl6.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 25 Nov 2014 10:03:16 +0100
Message-ID: <CA+BoTQ=fc0hRr2Vad_P-wLWdKna-mzHaaFgGrYsO0KavTG7e7g@mail.gmail.com> (sfid-20141125_100325_102318_41563E95)
Subject: Re: [PATCH v2 2/2] ath10k: add memory dump debugfs interface
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 November 2014 at 09:41, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Kalle Valo <kvalo@qca.qualcomm.com> writes:
>
>> +static ssize_t ath10k_mem_value_read(struct file *file,
>> +                                  char __user *user_buf,
>> +                                  size_t count, loff_t *ppos)
>> +{
[...]
>> +static ssize_t ath10k_mem_value_write(struct file *file,
>> +                                   const char __user *user_buf,
>> +                                   size_t count, loff_t *ppos)
[...]
> In these two functions we also need to check ar->state.

It should work but the pci_wake (I've mentioned in the other mail) is
tricky though.


Michał
