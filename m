Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37198 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750933AbcLLIM1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Dec 2016 03:12:27 -0500
Message-ID: <1481530339.4067.1.camel@sipsolutions.net> (sfid-20161212_091247_400510_38CF48FD)
Subject: Re: Could we have request_firmware_nowait with FW_OPT_NO_WARN?
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        brcm80211 development <brcm80211-dev-list@broadcom.com>
Date: Mon, 12 Dec 2016 09:12:19 +0100
In-Reply-To: <CACna6rxOGo0e9U7eXpUgnnBuxL+x1B0JBf9ZBq2WPbaBE=YZ-g@mail.gmail.com> (sfid-20161210_165513_587245_23610C6B)
References: <CACna6rxOGo0e9U7eXpUgnnBuxL+x1B0JBf9ZBq2WPbaBE=YZ-g@mail.gmail.com>
         (sfid-20161210_165513_587245_23610C6B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-12-10 at 16:54 +0100, Rafał Miłecki wrote:
> Hi,
> 
> In brcmfmac we use request_firmware_nowait and if fetching firmware
> with NVRAM variables fails then we try to fallback to the platform
> one (see brcmf_fw_request_code_done & brcmf_fw_request_nvram_done).
> 
> Some problem for us is that on devices with platform NVRAM we get
> this error:
> Direct firmware load for brcm/brcmfmac43602-pcie.txt failed with error -2

This also happens with iwlwifi, because it requests multiple firmware
versions starting at the most recent supported one (which is often not
released at the same time).

So yeah, this would be really useful - why don't you just make a patch
with some kind of flags, whether it's FW_OPT_* or new flags?

johannes
