Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:33124 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759005AbcAUI4n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 03:56:43 -0500
Subject: Re: [PATCH] rtlwifi: rtl8821ae: Fix 5G failure when EEPROM is
 incorrectly encoded
To: Kalle Valo <kvalo@codeaurora.org>
References: <1453348719-5546-1-git-send-email-Larry.Finger@lwfinger.net>
 <87oacf1fho.fsf@kamboji.qca.qualcomm.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	littlesmartguy@gmail.com, gabe@codehaus.org,
	Stable <stable@vger.kernel.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <56A09D47.6010600@lwfinger.net> (sfid-20160121_095649_773133_93E37B14)
Date: Thu, 21 Jan 2016 02:56:39 -0600
MIME-Version: 1.0
In-Reply-To: <87oacf1fho.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/21/2016 02:52 AM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>
>> Recently, it has been reported that D-Link DWA-582 cards, which use an
>> RTL8812AE chip are not able to scan for 5G networks. The problems started
>> with kernel 4.2, which is the first version that had commit d10101a60372
>> ("rtlwifi: rtl8821ae: Fix problem with regulatory information"). With this
>> patch, the driver went from setting a default channel plan to using
>> the value derived from EEPROM.
>>
>> Bug reports at https://bugzilla.kernel.org/show_bug.cgi?id=111031 and
>> https://bugzilla.redhat.com/show_bug.cgi?id=1279653 are examples of this
>> problem.
>>
>> The problem was solved once I learned that the internal country code was
>> resulting in a regulatory set with only 2.4 GHz channels. With the RTL8821AE
>> chips available to me, the country code was such that both 2.4 and 5 GHz
>> channels are allowed. The fix is to allow both bands even when the EEPROM
>> is incorrectly encoded.
>>
>> Fixes: d10101a60372 ("rtlwifi: rtl8821ae: Fix problem with regulatory information")
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: littlesmartguy@gmail.com
>> Cc: gabe@codehaus.org
>> Cc: Stable <stable@vger.kernel.org> [v4.2+]
>
> I'll queue this to 4.5.

Thanks.

Larry


