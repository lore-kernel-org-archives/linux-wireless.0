Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:56590 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbZINIut convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 04:50:49 -0400
Received: by iwn8 with SMTP id 8so1230317iwn.4
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 01:50:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AAE0297.20401@gmail.com>
References: <1252917123-11559-1-git-send-email-lrodriguez@atheros.com>
	<1252917123-11559-3-git-send-email-lrodriguez@atheros.com>
	<4AAE0297.20401@gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 14 Sep 2009 01:50:32 -0700
Message-ID: <43e72e890909140150i1e060503nae9987aba9275764@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] ath5k: allocate ath5k_hw prior to initializing hw
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linville@tuxdriver.com, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 14, 2009 at 1:45 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 09/14/2009 10:32 AM, Luis R. Rodriguez wrote:
>> --- a/drivers/net/wireless/ath/ath.h
>> +++ b/drivers/net/wireless/ath/ath.h
>> @@ -51,7 +51,7 @@ struct ath_common {
>>       u8 curbssid[ETH_ALEN];
>>       u8 bssidmask[ETH_ALEN];
>>       struct ath_regulatory regulatory;
>> -     struct ath_ops *ops;
>> +     const struct ath_ops *ops;
>
> If I'm looking correctly, this will emit a warning for ath9k.

Hm, I'm using C=1 when compiling and see no warnings even from sparse.

  Luis
