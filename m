Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:48872 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752918AbeAZOpE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 09:45:04 -0500
Subject: Re: [PATCH 0/4] ath9k: AR9003 noise floor calibration support
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        Wojciech Dubowik <wojciech.dubowik@neratec.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com
References: <1516692925-6695-1-git-send-email-Wojciech.Dubowik@neratec.com>
 <87o9ll57ps.fsf@kamboji.qca.qualcomm.com>
 <b9553f06-b190-c6ec-bb85-587984abfee0@dd-wrt.com>
 <ed47cefe-efa4-a7c9-d017-b50a99316f43@neratec.com>
 <d9e84a77-636e-cd13-7713-9119a4ac971d@dd-wrt.com>
 <b0be6634-de6a-9f24-b48b-88e67ca9eee4@neratec.com>
 <20f8b133-98a9-0491-6c16-ea3a414e5bb0@dd-wrt.com>
 <d311b71d-e5fa-6ed2-2c27-d036471e3459@neratec.com>
 <88585623-bad1-83e0-2b43-005e0240919a@dd-wrt.com>
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Message-ID: <d987abc9-1233-352f-6e85-197400d1dad8@neratec.com> (sfid-20180126_154508_488255_01E7B898)
Date: Fri, 26 Jan 2018 15:38:34 +0100
MIME-Version: 1.0
In-Reply-To: <88585623-bad1-83e0-2b43-005e0240919a@dd-wrt.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2018 03:20 PM, Sebastian Gottschall wrote:
> Am 26.01.2018 um 15:16 schrieb Wojciech Dubowik:
>>
>>
>> On 26/01/18 12:42, Sebastian Gottschall wrote:
>>> i have a idea what one cause could ne
>>>
>>> +                nfval =
>>> +                    ath9k_hw_get_nf_limits(ah, chan)->cal[i];
>>> +                if (nfval > -60 || nfval < -127)
>>> +                    nfval = default_nf;
>>>
>> This is just a check to make sure we have sane calibrated values. Anything above
>> -60 or under -127 will not work so
>> we take nominal value.
> yes. but that means all < -127 and all > -60 catches it. this is the full value
> range. the check is wrong
> everything is above -60 and bellow -127 at the same time. OR must ne AND
> 

The minus sign generates some confusion here (had to evaluate the condition
several times myself to get it right).

what it does is defining the valid range for the nfval as follows
        -128: nok (Atheros code for invalid RSSI)
[-127...-60]: ok
 [-59...127]: nok


Cheers,
Zefir
