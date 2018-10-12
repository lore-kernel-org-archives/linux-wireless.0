Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D43C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 12:11:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 585072086A
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 12:11:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 585072086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=theobroma-systems.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbeJLTni convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 15:43:38 -0400
Received: from vegas.theobroma-systems.com ([144.76.126.164]:37435 "EHLO
        mail.theobroma-systems.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728145AbeJLTni (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 15:43:38 -0400
Received: from [86.59.122.178] (port=62820 helo=[10.2.146.249])
        by mail.theobroma-systems.com with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <christoph.muellner@theobroma-systems.com>)
        id 1gAwHs-0008PQ-5m; Fri, 12 Oct 2018 14:11:24 +0200
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Subject: Re: brcmfmac with BCM4359 on arm64 (RK3399) and SDIO
From:   =?utf-8?Q?Christoph_M=C3=BCllner?= 
        <christoph.muellner@theobroma-systems.com>
In-Reply-To: <32f4abff-80e2-235f-8004-1c10a8375c34@broadcom.com>
Date:   Fri, 12 Oct 2018 14:11:23 +0200
Cc:     Franky Lin <franky.lin@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <BBCBFBD6-4653-48EE-9AD1-03FE4B66D317@theobroma-systems.com>
References: <5C44048D-0676-48E6-9AA3-F327839F13E5@theobroma-systems.com>
 <CA+8PC_dkJAPR2C0DsOWRb__RrijbZZ43MM1gtKGjsMxdTGwsZQ@mail.gmail.com>
 <fabdecc1-f032-789e-058f-2c62442b12c0@theobroma-systems.com>
 <C9DFBEBB-4481-4CBA-AE10-92A20C815D4F@theobroma-systems.com>
 <f7645f53-3e63-c888-c4a7-ece11655849d@broadcom.com>
 <b97f6b6c-aad9-8008-aab3-bf1ab1c1f2a0@theobroma-systems.com>
 <32f4abff-80e2-235f-8004-1c10a8375c34@broadcom.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
X-Mailer: Apple Mail (2.3445.6.18)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> On 12.10.2018, at 13:22, Arend van Spriel <arend.vanspriel@broadcom.com> wrote:
> 
> On 10/12/2018 10:59 AM, Christoph Müllner wrote:
>> 
>> 
>> On 10/12/18 10:00 AM, Arend van Spriel wrote:
>>> On 10/11/2018 6:04 PM, Christoph Müllner wrote:
>>>> Hi Franky and Arend,
>>>> 
>>>> today I could get a SDIO Wifi module, which includes a BCM43455.
>>>> I was able to get this up and running without any issues with the
>>>> brcmfmac
>>>> driver and a 4.19 kernel. For me that's enough evidence to say that
>>>> the SDIO
>>>> driver works.
>>>> 
>>>> However, the BCM4359 still does not work.
>>>> It times out in brcmf_sdio_firmware_callback(), while enabling func2.
>>>> 
>>>> I've inserted tons of debug log outputs in both, the DHD driver and the
>>>> brcmfmac driver, and compared them. Differences which I've found so far
>>>> are: a) brcmfmac strips out whitespaces from nvram contents and
>>>> b) DHD downloads firmware first and brcmfmac downloads nvram first.
>>>> I've adapted the DHD driver to behave like brcmfmac in both cases
>>>> and it still works.
>>>> 
>>>> I've increased the timeout for enabling func2 from 3 seconds to 10
>>>> seconds,
>>>> but that did not help.
>>>> 
>>>> Any ideas left?
>>> 
>>> When enabling func2 fails it generally means the firmware crashed. I am
>>> not sure if the patch below works to get console information. It might
>>> show up empty or simply fail if firmware did not fill shared memory
>>> info, but it may be worth a try.
>> 
>> I added the patch and additionally added debug output for all error
>> cases in the two called functions. Here's the output:
>> 
>> [   14.746092] brcmfmac: brcmf_sdio_firmware_callback: enable F2: err=-62
>> [   14.767523] brcmfmac: brcmf_sdio_checkdied: firmware not built with
>> -assert
>> [   14.778777] brcmfmac: brcmf_sdio_checkdied: firmware trap in dongle
>> [   14.789220] brcmfmac: brcmf_sdio_readconsole: brcmf_sdio_readconsole:
>> bus->console_addr == 0!
>> 
>> Do you have an educated guess, what causes the firmware crash, when
>> being loaded via the brcmfmac driver?
> 
> Maybe we can find out with the patch below.


That gives me (three out of three times):

> [   12.934594] brcmfmac: brcmf_sdio_firmware_callback: enable F2: err=-62
> [   12.943851] brcmfmac: brcmf_sdio_checkdied: firmware not built with -assert
> [   12.951734] brcmfmac: brcmf_sdio_checkdied: firmware trap in dongle
> [   12.959320] dongle trap info: type 0x4 @ epc 0x001e0f8c
> [   12.959320]   cpsr 0x80000193 spsr 0x800000b3 sp 0x001b35b0
> [   12.959320]   lr   0x0006608b pc   0x001e0f8c offset 0x1b3558
> [   12.959320]   r0   0x001fbf14 r1   0x00000001 r2 0x18101000 r3 0x18001000
> [   12.959320]   r4   0x001fbf14 r5   0x00000000 r6 0x00000002 r7 0x000043ef
> [   12.993068] brcmfmac: brcmf_sdio_readconsole: brcmf_sdio_readconsole: bus->console_addr == 0!





