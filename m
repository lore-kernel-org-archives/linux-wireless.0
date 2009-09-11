Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:49910 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbZIKBqe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 21:46:34 -0400
Received: by iwn8 with SMTP id 8so297400iwn.4
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2009 18:46:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b6c5339f0909101842t74479b34heaf0628d1a3b7edb@mail.gmail.com>
References: <1252632895-11914-1-git-send-email-lrodriguez@atheros.com>
	<1252632895-11914-4-git-send-email-lrodriguez@atheros.com>
	<b6c5339f0909101842t74479b34heaf0628d1a3b7edb@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 10 Sep 2009 18:46:17 -0700
Message-ID: <43e72e890909101846p3c696b69y41675d0dd3ae221d@mail.gmail.com>
Subject: Re: [PATCH 3/4] ath5k: define ath_common ops
To: Bob Copeland <bcopeland@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, devel@linuxdriverproject.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 10, 2009 at 6:42 PM, Bob Copeland <bcopeland@gmail.com> wrote:
> On Thu, Sep 10, 2009 at 9:34 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>>  static inline u32 ath5k_hw_reg_read(struct ath5k_hw *ah, u16 reg)
>>  {
>> -       return ioread32(ah->ah_iobase + reg);
>> +       return ath5k_hw_common(ah)->ops->read(ah, reg);
>>  }
>
> Is there any way we can do this without two pointer dereferences for every
> read and write?  I have a feeling this is going to make certain operations
> (e.g. loading initvals during reset) really suck.

It seems to work fine on my box, perhaps a single CPU (real single
CPU) user can test to see if there are any differences noted. I don't
think there should be really.

In any case if its deemed too nested for ath5k purposes you can just
leave an ioread/iowrite on the  ath5k_hw_reg_read() and later just
move all read/write ops to use the common ops calls. If someone can
think of better alternatives I'm all ears.

  Luis
