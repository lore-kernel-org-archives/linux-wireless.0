Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:34847 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751856AbdGRTt1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Jul 2017 15:49:27 -0400
Received: by mail-wr0-f175.google.com with SMTP id w4so42943281wrb.2
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jul 2017 12:49:26 -0700 (PDT)
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
 <6c512250-5299-0cad-675b-e7780e999b58@broadcom.com>
 <246dc2f3-5cfd-7e89-6244-50fa2f546306@mnementh.co.uk>
 <0271ee86-ba99-fc50-46cd-b796f614fa19@broadcom.com>
 <f3b1c2a3-c2f0-2f1c-c3f6-dbcc78246dc7@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <90ba4777-dedc-1a4f-c9c5-fca58106b754@broadcom.com> (sfid-20170718_214931_111706_C1363951)
Date: Tue, 18 Jul 2017 21:49:24 +0200
MIME-Version: 1.0
In-Reply-To: <f3b1c2a3-c2f0-2f1c-c3f6-dbcc78246dc7@mnementh.co.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18-07-17 00:10, Ian Molton wrote:
> Hi Arend,
> 
> This is all there is in the forensics file, hope its of some use.
> 
> # cat /sys/kernel/debug/brcmfmac/mmc1\:0001\:1/forensics
> Enter
> hndarm_armr addr: 0x18003000, cr4_idx: 0
> 000000.000
> RTE (SDIO-CDC) 7.45.41.26 (r640327) on BCM43430 r1 @ 37.4/81.0/81.0MHz
> 000000.001 sdpcmdcdc0: Broadcom SDPCMD CDC driver
> 000000.005 reclaim section 0: Returned 47716 bytes to the heap
> 000000.007 wlc_bmac_info_init: host_enab 1
> 000000.025 wl0: Broadcom BCM43430 802.11 Wireless Controller 7.45.41.26
> (r640327)
> 000000.026 TCAM: 256 used: 179 exceed:0
> 000000.027 reclaim section 1: Returned 81268 bytes to the heap

You probably guessed it, but this does not show anything useful. The
behavior suggested a firmware crash, but that does not seem to be
happening. Maybe it is the SDIO core driver on the firmware side which
is in la-la land.

Regards,
Arend
