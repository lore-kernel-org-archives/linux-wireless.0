Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:52372 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230AbZINJB4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 05:01:56 -0400
Received: by iwn8 with SMTP id 8so1232098iwn.4
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 02:02:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AAE02E9.2050905@gmail.com>
References: <1252917123-11559-1-git-send-email-lrodriguez@atheros.com>
	<1252917123-11559-4-git-send-email-lrodriguez@atheros.com>
	<4AAE02E9.2050905@gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 14 Sep 2009 02:01:40 -0700
Message-ID: <43e72e890909140201k71c0592ej76df4902f2e51ebb@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] ath5k: define ath_common ops
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linville@tuxdriver.com, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 14, 2009 at 1:46 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 09/14/2009 10:32 AM, Luis R. Rodriguez wrote:
>> --- a/drivers/net/wireless/ath/ath5k/base.c
>> +++ b/drivers/net/wireless/ath/ath5k/base.c
>> @@ -437,6 +437,22 @@ ath5k_chip_name(enum ath5k_srev_type type, u_int16_t val)
>>
>>       return name;
>>  }
>> +static unsigned int ath5k_ioread32(void *hw_priv, u32 reg_offset)
>> +{
>> +     struct ath5k_hw *ah = (struct ath5k_hw *) hw_priv;
>> +     return ioread32(ah->ah_iobase + reg_offset);
>
> Why not just
> return ath5k_hw_reg_read(hw_priv, reg_offset)
> as I suggested?
>
>> +static void ath5k_iowrite32(void *hw_priv, u32 val, u32 reg_offset)
>> +{
>> +     struct ath5k_hw *ah = (struct ath5k_hw *) hw_priv;
>> +     iowrite32(val, ah->ah_iobase + reg_offset);
>
> and ath5k_hw_reg_write(hw_priv, val, reg_offset)
>
> If we ever decide to not use ioread32/iowrite32, it will need a change
> on a single place.

Alright, will respin, sorry meant to have done that.

>> +}
>> +
>> +const static struct ath_ops ath5k_common_ops = {
>
> C99, 6.11.5 Storage-class specifiers:
> 1 The placement of a storage-class specifier other than at the
> beginning of the declaration specifiers in a declaration is
> an obsolescent feature.
>
> I.e. use static const, please.

Sure thanks for the review.

  Luis
