Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:36284 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751520AbdLSLgl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 06:36:41 -0500
Received: by mail-qk0-f176.google.com with SMTP id 8so22062250qkj.3
        for <linux-wireless@vger.kernel.org>; Tue, 19 Dec 2017 03:36:41 -0800 (PST)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: BCM4356 does not initalize after firmware update
To: Stanislaw Gruszka <sgruszka@redhat.com>
References: <20171213161257.GB2811@redhat.com> <5A3240B9.90007@broadcom.com>
 <20171214142243.GB2737@redhat.com> <5A339CB2.1040202@broadcom.com>
 <20171215103215.GA2742@redhat.com> <5A33ADAA.9060008@broadcom.com>
 <20171215122045.GB2742@redhat.com>
Cc: linux-wireless@vger.kernel.org
Message-ID: <5A38F9C4.3050202@broadcom.com> (sfid-20171219_123646_547224_1B14358E)
Date: Tue, 19 Dec 2017 12:36:36 +0100
MIME-Version: 1.0
In-Reply-To: <20171215122045.GB2742@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/15/2017 1:20 PM, Stanislaw Gruszka wrote:
> On Fri, Dec 15, 2017 at 12:10:34PM +0100, Arend van Spriel wrote:
>> # cat /sys/kernel/debug/brcmfmac/0000:03:00.0/revinfo
>
> vendorid: 0x14e4
> deviceid: 0x43ec
> radiorev: 0.41.32.105
> chipnum: 17238 (4356)
> chiprev: 2
> chippkg: 2
> corerev: 48
> boardid: 0x0777
> boardvendor: 0x14e4
> boardrev: P103
> driverrev: 7.35.180.119
> ucoderev: 0
> bus: 0
> phytype: 11
> phyrev: 17
> anarev: 0
> nvramrev: 00000000

Thanks for the info. I was looking for the board info. It seems we do 
not have an nvram file for that specific board.

For SDIO devices I would suggest to use the module parameter 
'ignore_probe_fail' so we could do post-mortem stuff with the driver 
bound to the device, but for PCIe there are not much debug options. Let 
me work on that. May take a bit longer though.

Regards,
Arend
