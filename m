Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:34513 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751317AbdGQUgk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 16:36:40 -0400
Received: by mail-wm0-f48.google.com with SMTP id 70so24781688wmo.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jul 2017 13:36:40 -0700 (PDT)
Subject: Re: BUG: brcmfmac: add firmware feature detection for gscan feature
 breaks 43430a1
To: Ian Molton <ian@mnementh.co.uk>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
References: <25c47ffe-af3e-fb85-ed5b-ff1987cfd93f@mnementh.co.uk>
 <e6635794-7c35-1a46-2d5b-68824c7b0657@mnementh.co.uk>
 <ff344ee3-3feb-6886-8007-d8ed00386424@broadcom.com>
 <c322c7c6-823b-0d36-8968-101d143b3220@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <6c512250-5299-0cad-675b-e7780e999b58@broadcom.com> (sfid-20170717_223644_609961_40F18137)
Date: Mon, 17 Jul 2017 22:36:37 +0200
MIME-Version: 1.0
In-Reply-To: <c322c7c6-823b-0d36-8968-101d143b3220@mnementh.co.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 17-07-17 22:13, Ian Molton wrote:
> On 17/07/17 20:53, Arend van Spriel wrote:
>>> 2) The firmware is failing when asked to handle the new requiests, and
>>>    is going to la-la land.
>> taken a wrong turn straight into la-la land.
> 
> Doh!
> 
>>> I have version wl0: Aug 29 2016 20:48:16 version 7.45.41.26 (r640327)
>>> FWID 01-4527cfab
>> Not so much newer firmware, but I used a different chip when
>> implementing the multi-scheduled scan patches. I tried some other
>> devices, but not the bcm4343{0,8}. Now as far as I can see over here the
>> brcmfmac43430-sdio.bin is not built with gscan support so it should just
>> return firmware errorcode, ie. -23. So it would be interesting to see
>> what firmware has to say. Can you load the driver with
>> ignore_probe_fail=1 and dump the forensics file in debugfs.
> 
> I don't appear to get anything useful in debugfs. Where should I be looking?

In <debugfs_mountpoint>/brcmfmac/*/forensics, but you have to load the
driver with modules parameter 'ignore_probe_fail=1' to avoid the driver
remove tearing down all debugfs stuff.
