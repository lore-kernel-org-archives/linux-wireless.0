Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:39313 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751819AbeAZPGo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 10:06:44 -0500
Subject: Re: [PATCH] ath9k: Fix get channel default noise floor
To: Kalle Valo <kvalo@codeaurora.org>,
        Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
References: <1516976454-8883-1-git-send-email-Wojciech.Dubowik@neratec.com>
 <87k1w4u1qr.fsf@kamboji.qca.qualcomm.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <73df95f3-be45-b1ba-74a6-425fe201b739@dd-wrt.com> (sfid-20180126_160658_174481_169AA431)
Date: Fri, 26 Jan 2018 16:06:42 +0100
MIME-Version: 1.0
In-Reply-To: <87k1w4u1qr.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

the regression has been solved with that patch. so noise floor looks 
normal for me on the 9280 chipset again

Am 26.01.2018 um 15:35 schrieb Kalle Valo:
> Wojciech Dubowik <Wojciech.Dubowik@neratec.com> writes:
>
>> Commit 8da58553cc63 ("ath9k: Use calibrated noise floor value
>> when available") introduced regression in ath9k_hw_getchan_noise
>> where per chain nominal noise floor has been taken instead default
>> for channel.
>> Revert to original default channel noise floor.
>>
>> Reported-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
>> Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
> Fixes: 8da58553cc63 ("ath9k: Use calibrated noise floor value when available")
>
> I can add that if this passes Sebastian's tests.
>
> And I'm planning to queue this for 4.16.
>

-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
