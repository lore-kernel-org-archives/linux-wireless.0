Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:35336 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbZIKGqF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 02:46:05 -0400
Received: by fxm17 with SMTP id 17so592969fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2009 23:46:07 -0700 (PDT)
Message-ID: <4AA9F22C.3090007@gmail.com>
Date: Fri, 11 Sep 2009 08:46:04 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	devel@linuxdriverproject.org, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/4] ath5k: define ath_common ops
References: <1252632895-11914-1-git-send-email-lrodriguez@atheros.com>	<1252632895-11914-4-git-send-email-lrodriguez@atheros.com> <40f31dec0909102316q7902098jbee7fd8d17c3f622@mail.gmail.com>
In-Reply-To: <40f31dec0909102316q7902098jbee7fd8d17c3f622@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/11/2009 08:16 AM, Nick Kossifidis wrote:
>>  static inline u32 ath5k_hw_reg_read(struct ath5k_hw *ah, u16 reg)
>>  {
>> -       return ioread32(ah->ah_iobase + reg);
>> +       return ath5k_hw_common(ah)->ops->read(ah, reg);
>>  }
>>
>> -/*
>> - * Write to a register
>> - */
>>  static inline void ath5k_hw_reg_write(struct ath5k_hw *ah, u32 val, u16 reg)
>>  {
>> -       iowrite32(val, ah->ah_iobase + reg);
>> +       ath5k_hw_common(ah)->ops->write(ah, reg, val);
...
> Since each driver will use it's own reg read/write functions (ath5k hw
> code still uses ath5k_hw_reg_read/write), why do we need to have
> common reg read/write functions like that used in the driver code ?
> This makes the code more complex that it needs to be and i don't see a
> reason why we need it. I understand why we need a way to handle
> read/write functions from common ath code but i don't see a reason to
> use these functions on ath5k, we can just fill ath_ops struct so that
> common code can use them and leave ath5k_hw_read/write untouched.

I definitely agree with Nick here. Althought whole ath_ops will be hot
cache after the first operation, there is no need to prolong hot paths
by computing the op address and a call. Ok, read/write on PCI is pretty
slow, but still...
