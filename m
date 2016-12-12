Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34176 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbcLLLtE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Dec 2016 06:49:04 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        brcm80211 development <brcm80211-dev-list@broadcom.com>
Subject: Re: Could we have request_firmware_nowait with FW_OPT_NO_WARN?
References: <CACna6rxOGo0e9U7eXpUgnnBuxL+x1B0JBf9ZBq2WPbaBE=YZ-g@mail.gmail.com>
        <1481530339.4067.1.camel@sipsolutions.net>
        <CACna6rzZnO1YtS2=6S1PGCTJkzTeuz9oJ+1yHBgWNhvUPz4acg@mail.gmail.com>
Date: Mon, 12 Dec 2016 13:48:58 +0200
In-Reply-To: <CACna6rzZnO1YtS2=6S1PGCTJkzTeuz9oJ+1yHBgWNhvUPz4acg@mail.gmail.com>
        (=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Mon, 12 Dec 2016
 09:32:26 +0100")
Message-ID: <87y3zll651.fsf@purkki.adurom.net> (sfid-20161212_124926_345271_6CEF742F)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:

> On 12 December 2016 at 09:12, Johannes Berg <johannes@sipsolutions.net> w=
rote:
>> On Sat, 2016-12-10 at 16:54 +0100, Rafa=C5=82 Mi=C5=82ecki wrote:
>>> In brcmfmac we use request_firmware_nowait and if fetching firmware
>>> with NVRAM variables fails then we try to fallback to the platform
>>> one (see brcmf_fw_request_code_done & brcmf_fw_request_nvram_done).
>>>
>>> Some problem for us is that on devices with platform NVRAM we get
>>> this error:
>>> Direct firmware load for brcm/brcmfmac43602-pcie.txt failed with error =
-2
>>
>> This also happens with iwlwifi, because it requests multiple firmware
>> versions starting at the most recent supported one (which is often not
>> released at the same time).
>
> Good to know it may help others as well!

We have the same problem also on ath10k :) And it's confusing users a
lot, especially as we also load calibration file and other files. So
yes, something like this is very much needed.

But in ath10k we use request_firmware() instead
request_firmware_nowait(). So I would appreciate if you could add the
support to both variants.

--=20
Kalle Valo
