Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37689 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbaKXODL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:03:11 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so5877297wiv.7
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:03:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <871tos7lo0.fsf@kamboji.qca.qualcomm.com>
References: <1416656922-6645-1-git-send-email-yanbol@qti.qualcomm.com>
	<871tos7lo0.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 24 Nov 2014 15:03:10 +0100
Message-ID: <CA+BoTQmdK1fYaWmPAd4GswKR7dKErD5MA2DtrNRZLEc-dFTYLA@mail.gmail.com> (sfid-20141124_150319_299757_68C7134C)
Subject: Re: [PATCH] ath10k: Add the target register access and memory dump
 debugfs interface
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Yanbo Li <yanbol@qti.qualcomm.com>,
	Yanbo Li <dreamfly281@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 November 2014 at 14:50, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Yanbo Li <yanbol@qti.qualcomm.com> writes:
[...]
>> +     spin_lock_bh(&ar->data_lock);
>> +     reg_addr = ar->debug.reg_addr;
>> +     spin_unlock_bh(&ar->data_lock);
>
> [...]
>
>> +     spin_lock_bh(&ar->data_lock);
>> +     ar->debug.reg_addr = reg_addr;
>> +     spin_unlock_bh(&ar->data_lock);
>
> [...]
>
>> +     spin_lock_bh(&ar->data_lock);
>> +     reg_addr = ar->debug.reg_addr;
>> +     spin_unlock_bh(&ar->data_lock);
>
> [...]
>
>> +     spin_lock_bh(&ar->data_lock);
>> +     reg_addr = ar->debug.reg_addr;
>> +     spin_unlock_bh(&ar->data_lock);
>
> I admit that I'm far from a locking expert, but does that make any
> difference in the functionality?

I imagine reg_addr could end up needing 2 instructions to be set on
some weird architecture+compiler combination in which case locking is
desired. With multiple access to write reg_addr you could end up
reading an address that either isn't the old nor the new one. Should
be harmless though and you could argue that you shouldn't access the
reg_addr debugfs file simultaneously in the first place. Maybe I'm
just over-exaggerating? :-)


Michał
