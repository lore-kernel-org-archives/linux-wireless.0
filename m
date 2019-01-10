Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDC8BC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 08:50:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C62A20879
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 08:50:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727651AbfAJIuS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 03:50:18 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33847 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727582AbfAJIuS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 03:50:18 -0500
Received: by mail-wr1-f67.google.com with SMTP id j2so10417420wrw.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2019 00:50:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y5Bx9+ZXvD37+st+1diejdevGl7hKaknbqFKL/O2d3o=;
        b=QkRdM9+kriOEQWPmIWsBwXdK9a42x1hOPARfd7bBBwmQ87SFQxrhxlaeT1U3ipkmpc
         XBaqNCcAjAdZOaXVgukEJs4i887SqHJQjD6S/+P2tdbuNZHbqcnwGoWatAp6WVaC7uRH
         q7Pc4yTfFWASSUt7/YYK2kVbKavYtdjrY2AB4Nq3DeocpmDnLeHyXywhKbsIUOAvB53d
         Xdu0JeRCZgfF7i9QihOyA4U4zYTzHyl/CwUAcfiKeUHyhzH2Bce1HBnH6jv4RPQ0r9wf
         pc5+TCiIj4Kdo1gwUBZhMJKim6/AVVqvia0spA9l7cvm4U7o9/Ryd1VT0fhCgwBg1k1m
         sfxQ==
X-Gm-Message-State: AJcUukc8OHxxmy2Q7JoI8BHwKcNrrAg0v1LH6K2f1xiyY0P0XM3gNgh0
        snW5YRqKsuADaBjfTYev94EC2g==
X-Google-Smtp-Source: ALg8bN7G+xIc14T8xRZrGSqpLfVdWteyKwfXD+YUePKXi4R0mVBuCma3levsWkCmA8DUzzCCAIe2cg==
X-Received: by 2002:a5d:65ce:: with SMTP id e14mr7906475wrw.150.1547110216296;
        Thu, 10 Jan 2019 00:50:16 -0800 (PST)
Received: from shalem.localdomain (546A5441.cm-12-3b.dynamic.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id o15sm51711321wrp.12.2019.01.10.00.50.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Jan 2019 00:50:15 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: Use request_firmware_direct for the clm_blob
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Wright Feng <Wright.Feng@cypress.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        John Van Boxtel <John.VanBoxtel@cypress.com>
References: <20190107113401.6824-1-hdegoede@redhat.com>
 <d6dafb19-4e88-c2c7-9547-2ebd5b4bec2e@broadcom.com>
 <5b365baf-99b3-2033-1f8e-6ca38d6daf42@redhat.com>
 <55db0ecb-5386-7a10-f26a-fa1e50af9b57@cypress.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <d0bdf1d9-afa1-2eb7-b308-a6ea5278d0f6@redhat.com>
Date:   Thu, 10 Jan 2019 09:50:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <55db0ecb-5386-7a10-f26a-fa1e50af9b57@cypress.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On 10-01-19 09:16, Chi-Hsien Lin wrote:
>> A "Firmware crash fix" to me sounds like a potential security issue, yet
> 
> It is a functional bug that causes wifi to stop working correctly. Not a
> security hole. We did upstream firmware for security issues.

Even if this is just a functional bug it would be still nice to also
have bugfixes like this available to the millions of users who get
their firmware through linux-firmware.

Also if this bug us remotely triggerable it allows a denial-of-service
attack and thus still is a security issue.

>> Another example is the firmware for the wifi on the Raspberry Pi 3B+ which
>> is *years* older in linux-firmware.
> 
> Could you please specify the source (link) of the firmware you're
> referring to?

linux-firmware has:

[hans@shalem ~]$ strings /lib/firmware/brcm/brcmfmac43455-sdio.bin | tail -n1
43455c0-roml/sdio-ag-p2p-pno-aoe-pktfilter-keepalive-mchan-pktctx-proptxstatus-ampduhostreorder-lpc-pwropt-txbf-wnm-okc-ccx-ltecx-wfds-wl11u-mfp-tdls-ve
Version: 7.45.18.0 CRC: d7226371 Date: Sun 2015-03-01 07:31:57 PST Ucode Ver: 1026.2 FWID: 01-6a2c8ad4

Where as: https://community.cypress.com/docs/DOC-15932 has:

[hans@shalem Download]$ strings firmware/brcmfmac43455-sdio.bin | tail -n2
43455c0-roml/43455_sdio-pno-aoe-pktfilter-pktctx-wfds-mfp-dfsradar-wowlpf-idsup-idauth-noclminc-clm_min-obss-obssdump-swdiv-gtkoe-roamprof-txbf-ve-sae-sr Version:
7.45.173 (r707987 CY) CRC: 7beaf14c Date: Fri 2018-09-21 04:12:04 PDT Ucode Ver: 1043.2116 FWID 01-d2799ea2

So the linux firmware version is *three and a half* years out of date!

>> I must say these whole shenanigans with the firmware causing
>> linux-firmware to
>> have way too old firmware versions makes me very unhappy. I'm at the point
>> where I'm telling friends to not buy any hardware with Cypress wifi in
>> there
>> because of this and because of the *complete* lack of bluetooth firmware.
> 
> We did work with HTC to upstream their bluetooth firmware to
> linux-firmware, although I admit that most of the bluetooth firmware are
> only available through hardware vendors.
> 
> Bluetooth firmware files are specific to vendor board designs. When
> there is an update, the hardware (device/board) vendor qualifies the
> firmware and release through their preferred channel (in HTC's case they
> chose to upstream it).

I'm aware that the bluetooth patchram files may have board specific
elements too them (most are generic but some contain board specific
workarounds), this is also why for USB bluetooth adapters the kernel
includes the vendorid-productid in the filename, as can be seen with
for example the HTC vive bluetooth firmware.

A community member has made bluetooth patchram files from the Windows
drivers with the filenames expected by Linux available for Linux users here:
https://github.com/winterheart/broadcom-bt-firmware/tree/master/

These files come with/under the following license:
https://github.com/winterheart/broadcom-bt-firmware/blob/master/LICENSE.broadcom_bcm20702

Which indicates that even though these files are distributed through vendor
channels for Windows, Broadcom and now Cypress holds the rights on these files.

So it is within Cypress power to give permission to distribute these files under the
https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/LICENCE.cypress
license. That is all we are asking for.

We are not asking you to do special Linux builds, Linux can use the per
board Windows files just fine, all we need is permission to distribute this
and then Linux users will run their boards with the same qualified firmware
files as are being used under Windows.

Actually by not allowing us to provide these files you run the risk of users
grabbing a random file from somewhere and renaming it, potentially having it
not match the board the user is using.

Regards,

Hans

