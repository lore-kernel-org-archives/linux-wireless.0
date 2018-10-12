Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 292C0C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 08:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E01AE2075B
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 08:59:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E01AE2075B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=theobroma-systems.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbeJLQbL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 12:31:11 -0400
Received: from vegas.theobroma-systems.com ([144.76.126.164]:34921 "EHLO
        mail.theobroma-systems.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727210AbeJLQbL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 12:31:11 -0400
Received: from [86.59.122.178] (port=39324 helo=[10.11.0.42])
        by mail.theobroma-systems.com with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA1:128)
        (Exim 4.80)
        (envelope-from <christoph.muellner@theobroma-systems.com>)
        id 1gAtIL-0002qd-EC; Fri, 12 Oct 2018 10:59:41 +0200
Subject: Re: brcmfmac with BCM4359 on arm64 (RK3399) and SDIO
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>
Cc:     "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>
References: <5C44048D-0676-48E6-9AA3-F327839F13E5@theobroma-systems.com>
 <CA+8PC_dkJAPR2C0DsOWRb__RrijbZZ43MM1gtKGjsMxdTGwsZQ@mail.gmail.com>
 <fabdecc1-f032-789e-058f-2c62442b12c0@theobroma-systems.com>
 <C9DFBEBB-4481-4CBA-AE10-92A20C815D4F@theobroma-systems.com>
 <f7645f53-3e63-c888-c4a7-ece11655849d@broadcom.com>
From:   =?UTF-8?Q?Christoph_M=c3=bcllner?= 
        <christoph.muellner@theobroma-systems.com>
Message-ID: <b97f6b6c-aad9-8008-aab3-bf1ab1c1f2a0@theobroma-systems.com>
Date:   Fri, 12 Oct 2018 10:59:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <f7645f53-3e63-c888-c4a7-ece11655849d@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 10/12/18 10:00 AM, Arend van Spriel wrote:
> On 10/11/2018 6:04 PM, Christoph Müllner wrote:
>> Hi Franky and Arend,
>>
>> today I could get a SDIO Wifi module, which includes a BCM43455.
>> I was able to get this up and running without any issues with the
>> brcmfmac
>> driver and a 4.19 kernel. For me that's enough evidence to say that
>> the SDIO
>> driver works.
>>
>> However, the BCM4359 still does not work.
>> It times out in brcmf_sdio_firmware_callback(), while enabling func2.
>>
>> I've inserted tons of debug log outputs in both, the DHD driver and the
>> brcmfmac driver, and compared them. Differences which I've found so far
>> are: a) brcmfmac strips out whitespaces from nvram contents and
>> b) DHD downloads firmware first and brcmfmac downloads nvram first.
>> I've adapted the DHD driver to behave like brcmfmac in both cases
>> and it still works.
>>
>> I've increased the timeout for enabling func2 from 3 seconds to 10
>> seconds,
>> but that did not help.
>>
>> Any ideas left?
> 
> When enabling func2 fails it generally means the firmware crashed. I am
> not sure if the patch below works to get console information. It might
> show up empty or simply fail if firmware did not fill shared memory
> info, but it may be worth a try.

I added the patch and additionally added debug output for all error
cases in the two called functions. Here's the output:

[   14.746092] brcmfmac: brcmf_sdio_firmware_callback: enable F2: err=-62
[   14.767523] brcmfmac: brcmf_sdio_checkdied: firmware not built with
-assert
[   14.778777] brcmfmac: brcmf_sdio_checkdied: firmware trap in dongle
[   14.789220] brcmfmac: brcmf_sdio_readconsole: brcmf_sdio_readconsole:
bus->console_addr == 0!

Do you have an educated guess, what causes the firmware crash, when
being loaded via the brcmfmac driver?

Thanks,
Christoph


