Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1639C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 11:22:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E0A62086A
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 11:22:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="LuYRM3ZO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E0A62086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbeJLSyO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 14:54:14 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34531 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbeJLSyO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 14:54:14 -0400
Received: by mail-wm1-f66.google.com with SMTP id z25-v6so17833416wmf.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 04:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=dZwiZ43ukxjX48xCG2RLM42WU1upTYUXOj8DCsTRwFw=;
        b=LuYRM3ZOSWvxYw1E/YDWOh42i5qAznBfzC99Rttr7zj0YtHQfydr6h37PXQ02mz3rx
         GTrMt2Dh4RvKoRr6I6JWkoMm9eIIx/yyu7AD5P/v6FwQY5f1AHsLQCzZaw+/L8FyjcaT
         c9dyJdLiqqoyxVOB73GoFz4tjvdv7FwGg5TZQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=dZwiZ43ukxjX48xCG2RLM42WU1upTYUXOj8DCsTRwFw=;
        b=N3F9+nhaTwoOtvpp2TrDjWdjxiHWh41AR2nSmz9kwJJ+akd7ScnToK5MxiQsvc2dVS
         2ZYGjh1PPIjQZRXIc4MDrRzL67U2ioh8wrNpn0vk5JJYxINBESLgE/As98arg9YehIJe
         HYqGzU5OqUN0hfFEJJGsUJJTqHGWOYFuepledUFOJ1zk4DIJHNYm01JN3p+PWqw/rspE
         7HEcEKtXFsnXsgS3zhHBc895Am9CiAjkLXzIT2/JfiC8ZN8NQF8aABSFhVeIiSe6SKzK
         l1+lqnIXtZhoLVhpk+MrfKKI1a/tY4JHjU2qr8KhunthUqwDwLA5Mf+OEex/ifxpV38v
         jRNg==
X-Gm-Message-State: ABuFfoghGHysKK2WOpAaJG+VKpQGFpkY64pOwzodM1c1g7raAfs2U6iz
        QwB0twFqHhxlaTTGZvpBXw9eng1ogGzETQ==
X-Google-Smtp-Source: ACcGV61IIiEuL4i8a/NkDjIo7qWeZBxRP6WQRTJgZM4bTHa8qHXojIq+oKe5kZPYfYnlhJr3duzNuQ==
X-Received: by 2002:a1c:7614:: with SMTP id r20-v6mr5080030wmc.52.1539343333817;
        Fri, 12 Oct 2018 04:22:13 -0700 (PDT)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id g15-v6sm730229wrr.36.2018.10.12.04.22.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Oct 2018 04:22:12 -0700 (PDT)
Subject: Re: brcmfmac with BCM4359 on arm64 (RK3399) and SDIO
To:     =?UTF-8?Q?Christoph_M=c3=bcllner?= 
        <christoph.muellner@theobroma-systems.com>,
        Franky Lin <franky.lin@broadcom.com>
References: <5C44048D-0676-48E6-9AA3-F327839F13E5@theobroma-systems.com>
 <CA+8PC_dkJAPR2C0DsOWRb__RrijbZZ43MM1gtKGjsMxdTGwsZQ@mail.gmail.com>
 <fabdecc1-f032-789e-058f-2c62442b12c0@theobroma-systems.com>
 <C9DFBEBB-4481-4CBA-AE10-92A20C815D4F@theobroma-systems.com>
 <f7645f53-3e63-c888-c4a7-ece11655849d@broadcom.com>
 <b97f6b6c-aad9-8008-aab3-bf1ab1c1f2a0@theobroma-systems.com>
Cc:     "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <32f4abff-80e2-235f-8004-1c10a8375c34@broadcom.com>
Date:   Fri, 12 Oct 2018 13:22:11 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <b97f6b6c-aad9-8008-aab3-bf1ab1c1f2a0@theobroma-systems.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/12/2018 10:59 AM, Christoph Müllner wrote:
>
>
> On 10/12/18 10:00 AM, Arend van Spriel wrote:
>> On 10/11/2018 6:04 PM, Christoph Müllner wrote:
>>> Hi Franky and Arend,
>>>
>>> today I could get a SDIO Wifi module, which includes a BCM43455.
>>> I was able to get this up and running without any issues with the
>>> brcmfmac
>>> driver and a 4.19 kernel. For me that's enough evidence to say that
>>> the SDIO
>>> driver works.
>>>
>>> However, the BCM4359 still does not work.
>>> It times out in brcmf_sdio_firmware_callback(), while enabling func2.
>>>
>>> I've inserted tons of debug log outputs in both, the DHD driver and the
>>> brcmfmac driver, and compared them. Differences which I've found so far
>>> are: a) brcmfmac strips out whitespaces from nvram contents and
>>> b) DHD downloads firmware first and brcmfmac downloads nvram first.
>>> I've adapted the DHD driver to behave like brcmfmac in both cases
>>> and it still works.
>>>
>>> I've increased the timeout for enabling func2 from 3 seconds to 10
>>> seconds,
>>> but that did not help.
>>>
>>> Any ideas left?
>>
>> When enabling func2 fails it generally means the firmware crashed. I am
>> not sure if the patch below works to get console information. It might
>> show up empty or simply fail if firmware did not fill shared memory
>> info, but it may be worth a try.
>
> I added the patch and additionally added debug output for all error
> cases in the two called functions. Here's the output:
>
> [   14.746092] brcmfmac: brcmf_sdio_firmware_callback: enable F2: err=-62
> [   14.767523] brcmfmac: brcmf_sdio_checkdied: firmware not built with
> -assert
> [   14.778777] brcmfmac: brcmf_sdio_checkdied: firmware trap in dongle
> [   14.789220] brcmfmac: brcmf_sdio_readconsole: brcmf_sdio_readconsole:
> bus->console_addr == 0!
>
> Do you have an educated guess, what causes the firmware crash, when
> being loaded via the brcmfmac driver?

Maybe we can find out with the patch below.

Regards,
Arend

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c 
b/drivers/ne
index b2e1ab5..b1a4631 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -2969,21 +2969,35 @@ static int brcmf_sdio_trap_info(struct seq_file 
*seq, str
         if (error < 0)
                 return error;

-       seq_printf(seq,
-                  "dongle trap info: type 0x%x @ epc 0x%08x\n"
-                  "  cpsr 0x%08x spsr 0x%08x sp 0x%08x\n"
-                  "  lr   0x%08x pc   0x%08x offset 0x%x\n"
-                  "  r0   0x%08x r1   0x%08x r2 0x%08x r3 0x%08x\n"
-                  "  r4   0x%08x r5   0x%08x r6 0x%08x r7 0x%08x\n",
-                  le32_to_cpu(tr.type), le32_to_cpu(tr.epc),
-                  le32_to_cpu(tr.cpsr), le32_to_cpu(tr.spsr),
-                  le32_to_cpu(tr.r13), le32_to_cpu(tr.r14),
-                  le32_to_cpu(tr.pc), sh->trap_addr,
-                  le32_to_cpu(tr.r0), le32_to_cpu(tr.r1),
-                  le32_to_cpu(tr.r2), le32_to_cpu(tr.r3),
-                  le32_to_cpu(tr.r4), le32_to_cpu(tr.r5),
-                  le32_to_cpu(tr.r6), le32_to_cpu(tr.r7));
-
+       if (seq)
+               seq_printf(seq,
+                          "dongle trap info: type 0x%x @ epc 0x%08x\n"
+                          "  cpsr 0x%08x spsr 0x%08x sp 0x%08x\n"
+                          "  lr   0x%08x pc   0x%08x offset 0x%x\n"
+                          "  r0   0x%08x r1   0x%08x r2 0x%08x r3 0x%08x\n"
+                          "  r4   0x%08x r5   0x%08x r6 0x%08x r7 
0x%08x\n",
+                          le32_to_cpu(tr.type), le32_to_cpu(tr.epc),
+                          le32_to_cpu(tr.cpsr), le32_to_cpu(tr.spsr),
+                          le32_to_cpu(tr.r13), le32_to_cpu(tr.r14),
+                          le32_to_cpu(tr.pc), sh->trap_addr,
+                          le32_to_cpu(tr.r0), le32_to_cpu(tr.r1),
+                          le32_to_cpu(tr.r2), le32_to_cpu(tr.r3),
+                          le32_to_cpu(tr.r4), le32_to_cpu(tr.r5),
+                          le32_to_cpu(tr.r6), le32_to_cpu(tr.r7));
+       else
+               pr_debug("dongle trap info: type 0x%x @ epc 0x%08x\n"
+                        "  cpsr 0x%08x spsr 0x%08x sp 0x%08x\n"
+                        "  lr   0x%08x pc   0x%08x offset 0x%x\n"
+                        "  r0   0x%08x r1   0x%08x r2 0x%08x r3 0x%08x\n"
+                        "  r4   0x%08x r5   0x%08x r6 0x%08x r7 0x%08x\n",
+                        le32_to_cpu(tr.type), le32_to_cpu(tr.epc),
+                        le32_to_cpu(tr.cpsr), le32_to_cpu(tr.spsr),
+                        le32_to_cpu(tr.r13), le32_to_cpu(tr.r14),
+                        le32_to_cpu(tr.pc), sh->trap_addr,
+                        le32_to_cpu(tr.r0), le32_to_cpu(tr.r1),
+                        le32_to_cpu(tr.r2), le32_to_cpu(tr.r3),
+                        le32_to_cpu(tr.r4), le32_to_cpu(tr.r5),
+                        le32_to_cpu(tr.r6), le32_to_cpu(tr.r7));
         return 0;
  }

@@ -3037,8 +3051,10 @@ static int brcmf_sdio_checkdied(struct brcmf_sdio 
*bus)
         else if (sh.flags & SDPCM_SHARED_ASSERT)
                 brcmf_err("assertion in dongle\n");

-       if (sh.flags & SDPCM_SHARED_TRAP)
+       if (sh.flags & SDPCM_SHARED_TRAP) {
                 brcmf_err("firmware trap in dongle\n");
+               brcmf_sdio_trap_info(NULL, bus, &sh);
+       }

         return 0;
  }

