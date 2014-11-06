Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tpesmarthost.raritan.com ([220.128.57.202]:55533 "EHLO
	tpesmarthost.raritan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbaKFK5G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 05:57:06 -0500
Message-ID: <545B51B3.9000901@raritan.com> (sfid-20141106_115711_044560_B6796199)
Date: Thu, 6 Nov 2014 11:47:15 +0100
From: Ronald Wahl <ronald.wahl@raritan.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] mac80211: Fix regression that triggers a kernel BUG with
 CCMP
References: <1415267752-4704-1-git-send-email-ronald.wahl@raritan.com> <1415268135.1884.1.camel@sipsolutions.net>
In-Reply-To: <1415268135.1884.1.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06.11.2014 11:02, Johannes Berg wrote:
> On Thu, 2014-11-06 at 10:55 +0100, Ronald Wahl wrote:
>> Commit 7ec7c4a9a686c608315739ab6a2b0527a240883c (mac80211: port CCMP to
>> cryptoapi's CCM driver) introduced a regression when decrypting empty
>> packets (data_len == 0). This will lead to backtraces like:
>
> Not good.
>
>> This patch adds an additional length check.
>>
>> Signed-off-by: Ronald Wahl <ronald.wahl@raritan.com>
>
> Please add
>
> Cc: stable@vger.kernel.org
> Fixes: 7ec7c4a9a686 ("mac80211: port CCMP to cryptoapi's CCM driver")
>
>> +	if (data_len == 0)
>> +		return EINVAL;
>
> error codes should be negative.

Argh. New patch on the way...

thx,
ron

-- 
Ronald Wahl - ronald.wahl@raritan.com - Phone +49 375271349-0 Fax -99
Raritan Deutschland GmbH, Kornmarkt 7, 08056 Zwickau, Germany
USt-IdNr. DE813094160, Steuer-Nr. 227/117/01749
Amtsgericht Chemnitz HRB 23605
Geschäftsführung: Stuart Hopper, Ralf Ploenes
