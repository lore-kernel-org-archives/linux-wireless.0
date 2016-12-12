Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:34640 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750991AbcLLIc1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Dec 2016 03:32:27 -0500
MIME-Version: 1.0
In-Reply-To: <1481530339.4067.1.camel@sipsolutions.net>
References: <CACna6rxOGo0e9U7eXpUgnnBuxL+x1B0JBf9ZBq2WPbaBE=YZ-g@mail.gmail.com>
 <1481530339.4067.1.camel@sipsolutions.net>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Mon, 12 Dec 2016 09:32:26 +0100
Message-ID: <CACna6rzZnO1YtS2=6S1PGCTJkzTeuz9oJ+1yHBgWNhvUPz4acg@mail.gmail.com> (sfid-20161212_093253_895657_F0BA09F0)
Subject: Re: Could we have request_firmware_nowait with FW_OPT_NO_WARN?
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        brcm80211 development <brcm80211-dev-list@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 December 2016 at 09:12, Johannes Berg <johannes@sipsolutions.net> wro=
te:
> On Sat, 2016-12-10 at 16:54 +0100, Rafa=C5=82 Mi=C5=82ecki wrote:
>> In brcmfmac we use request_firmware_nowait and if fetching firmware
>> with NVRAM variables fails then we try to fallback to the platform
>> one (see brcmf_fw_request_code_done & brcmf_fw_request_nvram_done).
>>
>> Some problem for us is that on devices with platform NVRAM we get
>> this error:
>> Direct firmware load for brcm/brcmfmac43602-pcie.txt failed with error -=
2
>
> This also happens with iwlwifi, because it requests multiple firmware
> versions starting at the most recent supported one (which is often not
> released at the same time).

Good to know it may help others as well!


> So yeah, this would be really useful - why don't you just make a patch
> with some kind of flags, whether it's FW_OPT_* or new flags?

OK! If noone will come with any special comments/ideas soon, I'll
propose a patch for using some flags.

FWIW, meanwhile I submitted
[PATCH V2] firmware: simplify defining and handling FW_OPT_FALLBACK
https://patchwork.kernel.org/patch/9469875/

--=20
Rafa=C5=82
