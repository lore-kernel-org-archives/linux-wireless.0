Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:33076 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754011AbcLLJ0g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Dec 2016 04:26:36 -0500
Received: by mail-pg0-f43.google.com with SMTP id 3so33640858pgd.0
        for <linux-wireless@vger.kernel.org>; Mon, 12 Dec 2016 01:26:36 -0800 (PST)
Subject: Re: Could we have request_firmware_nowait with FW_OPT_NO_WARN?
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>
References: <CACna6rxOGo0e9U7eXpUgnnBuxL+x1B0JBf9ZBq2WPbaBE=YZ-g@mail.gmail.com>
 <1481530339.4067.1.camel@sipsolutions.net>
 <CACna6rzZnO1YtS2=6S1PGCTJkzTeuz9oJ+1yHBgWNhvUPz4acg@mail.gmail.com>
Cc: Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        brcm80211 development <brcm80211-dev-list@broadcom.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <815a15b6-f22d-8c45-f76c-2c756f159366@broadcom.com> (sfid-20161212_102651_716588_FEF6C687)
Date: Mon, 12 Dec 2016 10:26:31 +0100
MIME-Version: 1.0
In-Reply-To: <CACna6rzZnO1YtS2=6S1PGCTJkzTeuz9oJ+1yHBgWNhvUPz4acg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12-12-2016 9:32, Rafał Miłecki wrote:
> On 12 December 2016 at 09:12, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Sat, 2016-12-10 at 16:54 +0100, Rafał Miłecki wrote:
>>> In brcmfmac we use request_firmware_nowait and if fetching firmware
>>> with NVRAM variables fails then we try to fallback to the platform
>>> one (see brcmf_fw_request_code_done & brcmf_fw_request_nvram_done).
>>>
>>> Some problem for us is that on devices with platform NVRAM we get
>>> this error:
>>> Direct firmware load for brcm/brcmfmac43602-pcie.txt failed with error -2
>>
>> This also happens with iwlwifi, because it requests multiple firmware
>> versions starting at the most recent supported one (which is often not
>> released at the same time).
> 
> Good to know it may help others as well!
> 
> 
>> So yeah, this would be really useful - why don't you just make a patch
>> with some kind of flags, whether it's FW_OPT_* or new flags?
> 
> OK! If noone will come with any special comments/ideas soon, I'll
> propose a patch for using some flags.
> 
> FWIW, meanwhile I submitted
> [PATCH V2] firmware: simplify defining and handling FW_OPT_FALLBACK
> https://patchwork.kernel.org/patch/9469875/

Similar thread couple of months ago [1]

Regards,
Arend

[1] http://lists.infradead.org/pipermail/ath10k/2016-July/thread.html#8026
