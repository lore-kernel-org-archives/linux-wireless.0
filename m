Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:60315 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751032AbeA2G7l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Jan 2018 01:59:41 -0500
Subject: Re: [PATCH 0/4] ath9k: AR9003 noise floor calibration support
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc: Wojciech Dubowik <wojciech.dubowik@neratec.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
References: <1516692925-6695-1-git-send-email-Wojciech.Dubowik@neratec.com>
 <87o9ll57ps.fsf@kamboji.qca.qualcomm.com>
 <b9553f06-b190-c6ec-bb85-587984abfee0@dd-wrt.com>
 <ed47cefe-efa4-a7c9-d017-b50a99316f43@neratec.com>
 <d9e84a77-636e-cd13-7713-9119a4ac971d@dd-wrt.com>
 <b0be6634-de6a-9f24-b48b-88e67ca9eee4@neratec.com>
 <20f8b133-98a9-0491-6c16-ea3a414e5bb0@dd-wrt.com>
 <d311b71d-e5fa-6ed2-2c27-d036471e3459@neratec.com>
 <88585623-bad1-83e0-2b43-005e0240919a@dd-wrt.com>
From: Matthias May <matthias.may@neratec.com>
Message-ID: <0b97a42a-7392-6101-63fa-0ecde6e8a57a@neratec.com> (sfid-20180129_075946_844020_30A0A64E)
Date: Mon, 29 Jan 2018 07:53:45 +0100
MIME-Version: 1.0
In-Reply-To: <88585623-bad1-83e0-2b43-005e0240919a@dd-wrt.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26/01/18 15:20, Sebastian Gottschall wrote:
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
>> This is just a check to make sure we have sane calibrated values. Anything above -60 or under -127 will not work so
>> we take nominal value.
> yes. but that means all < -127 and all > -60 catches it. this is the full value range. the check is wrong
> everything is above -60 and bellow -127 at the same time. OR must ne AND

Not really. Note the negative numbers.
-60 is a bigger value than -127.
The expressions states that all values from -127 to -60 are valid.

BR
Matthias
