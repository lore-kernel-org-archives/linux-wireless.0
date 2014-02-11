Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:52153 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaBKIK6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Feb 2014 03:10:58 -0500
Received: by mail-la0-f51.google.com with SMTP id c6so5566771lan.38
        for <linux-wireless@vger.kernel.org>; Tue, 11 Feb 2014 00:10:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8761omdqe5.fsf@kamboji.qca.qualcomm.com>
References: <1392034375-13532-1-git-send-email-bartosz.markowski@tieto.com>
	<8761omdqe5.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 11 Feb 2014 09:10:56 +0100
Message-ID: <CACKGw+Es7YsNHtg+MJE_82Ffm5m9hHu+qo6nZbo-hoOfqCDmOQ@mail.gmail.com> (sfid-20140211_091101_432541_2C4A1A95)
Subject: Re: [PATCH] ath10k: AP: handle HT station which does not have HT RX MCS
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 February 2014 09:06, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Bartosz Markowski <bartosz.markowski@tieto.com> writes:
>
>> This is a workaround for HT-enabled STAs which break the spec
>> and have no HT capabilities RX mask (no HT RX MCS map).
>>
>> As per spec, in section 20.3.5 Modulation and coding scheme (MCS),
>> MCS 0 through 7 are mandatory in 20MHz with 800 ns GI at all STAs.
>>
>> Firmware asserts if such situation occurs.
>>
>> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
>
> This conflicted with Marek K's patch "ath10k: Set proper nss value for
> the peer". Please check that my resolution in ath-next-test is correct:
>
> https://github.com/kvalo/ath/commit/d56aa0e779c17f8048a70a9dbd5228b54d9a712e

Looks good.

-- 
Bartosz
