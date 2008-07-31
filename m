Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.242]:22092 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbYGaBXU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 21:23:20 -0400
Received: by an-out-0708.google.com with SMTP id d40so51162and.103
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jul 2008 18:23:20 -0700 (PDT)
Message-ID: <43e72e890807301823w3b800ebcwa12317e0a45d0dcb@mail.gmail.com> (sfid-20080731_032324_658955_7EF57B93)
Date: Wed, 30 Jul 2008 18:23:19 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: [PATCH 11/16] ath9k: Remove "OS_" prefixes in macros.
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, Jouni.Malinen@atheros.com,
	"Sujith Manoharan" <smanoharan@atheros.com>
In-Reply-To: <1217467009.3616.9.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
	 <f716bd4495bedc5987c6fd1283a09843e3c9331e.1217309552.git.lrodriguez@atheros.com>
	 <1217467009.3616.9.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 30, 2008 at 6:16 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Mon, 2008-07-28 at 22:47 -0700, lrodriguez@atheros.com wrote:
>> From: Sujith Manoharan <smanoharan@atheros.com>
>>
>> diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
>> index 6fa1eb6..c3294c0 100644
>> --- a/drivers/net/wireless/ath9k/ath9k.h
>> +++ b/drivers/net/wireless/ath9k/ath9k.h
>> @@ -622,17 +622,15 @@ struct hal_country_entry {
>>
>>  #define SM(_v, _f)  (((_v) << _f##_S) & _f)
>>  #define MS(_v, _f)  (((_v) & _f) >> _f##_S)
>> -#define OS_REG_RMW(_a, _r, _set, _clr)    \
>> +#define REG_RMW(_a, _r, _set, _clr)    \
>>       REG_WRITE(_a, _r, (REG_READ(_a, _r) & ~(_clr)) | (_set))
>
> I think these are pretty good candidates for inline functions.  I'm not
> sure removing "OS_" is a useful intermediate step.  It's better to keep
> such massive changes to the minimum to avoid potential conflicts with
> other patches.

This was done in response to Johannes comments. This can be moved to
inline though.

  Luis
