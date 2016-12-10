Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:36731 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751494AbcLJPyn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Dec 2016 10:54:43 -0500
MIME-Version: 1.0
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Sat, 10 Dec 2016 16:54:41 +0100
Message-ID: <CACna6rxOGo0e9U7eXpUgnnBuxL+x1B0JBf9ZBq2WPbaBE=YZ-g@mail.gmail.com> (sfid-20161210_165513_587245_23610C6B)
Subject: Could we have request_firmware_nowait with FW_OPT_NO_WARN?
To: Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        brcm80211 development <brcm80211-dev-list@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

In brcmfmac we use request_firmware_nowait and if fetching firmware
with NVRAM variables fails then we try to fallback to the platform one
(see brcmf_fw_request_code_done & brcmf_fw_request_nvram_done).

Some problem for us is that on devices with platform NVRAM we get this erro=
r:
Direct firmware load for brcm/brcmfmac43602-pcie.txt failed with error -2
(which is harmless if getting platform NVRAM succeeds). This error is
quite confusing for users. They think something went wrong, they
expect problems & they report it back to us. Obviously I don't want
ugly hacks like:
pr_info("Got platform NVRAM, ignore above error\n");

So it would be nice to have version of request_firmware_nowait with
FW_OPT_NO_WARN. If requesting firmware NVRAM fails *and* getting
platform NVRAM fails, then I could to print error on my own.
Does it make sense? Can you see a point of my request?

Do you have any suggestion for this? If and how I could proceed with
implementation?

request_firmware_nowait already has "bool uevent" argument, I don't
want it to have argument per every available option. I was thinking
about moving FW_OPT_* defines to the include/linux/firmware.h but I'm
not sure if it's OK as they depend on:
CONFIG_FW_LOADER_USER_HELPER
and
CONFIG_FW_LOADER_USER_HELPER_FALLBACK
With defines placed in firmware.h I could replace "bool uevent" with
"unsigned int opt_flags".
Does it sound like a good plan? Or do you have any better idea?

--=20
Rafa=C5=82
