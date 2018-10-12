Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B568C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 08:00:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DF432098A
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 08:00:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="fqrzfiyz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0DF432098A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbeJLPbn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 11:31:43 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37024 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727571AbeJLPbn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 11:31:43 -0400
Received: by mail-ed1-f68.google.com with SMTP id c22-v6so10654163edc.4
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 01:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=lYjymLv/bqpi/c+OoCo1qiQKw8HpwgcbkPA0iWzCItA=;
        b=fqrzfiyzj5wlmCjCkpoMZTj3E66dIPgDyUksrlOX3CsZLQWIXO9QHfLf825A3irJ03
         m1A6PjUy4LTJY9nxb1Ld7BFq+ZZHSIZqZtCxVqRVWBtedwmC8xVjUJZ/4oJUy61RT19N
         u9i+UZU5Rb0RFpcKuK3VeQzgBzej2ssE6/PZE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=lYjymLv/bqpi/c+OoCo1qiQKw8HpwgcbkPA0iWzCItA=;
        b=HtIvHyVna0QxITEpnkZULnBXlI6+phe+F/QQSUTSTETDmHCyGGB4vVmQtDi6RqKGaR
         hMai+0YFFBg1U5XTj5iNI4P+mwR03sS+QCGJ4md85nHuWcOERZMLpA6y+f8vFT8px1/y
         3wL/4hP1d44m1rdOCFfBdSxm0pt7P0Bjn5XmG9fHErF9CotBFWyVKcIWlvJwtWReJP8X
         Y7HiRm0TNaAC76du37MiZo0wure4VcEhduZ4RwFfSRIpxxDLqAgK2c26t8vfUVVzpjZc
         XhidK+0blow50Hlw1BpG5YgRnuOtmoJfyzVF3UCnGA4YDXY2uzX+mJ4XXJJ4ts/iq41a
         /VOQ==
X-Gm-Message-State: ABuFfog0K6PQy0MkpO+fwqz7fxUaMLwvHlwnzGldQdnMRzaDAI7P+/tU
        yU8wTE/8ZowEkiZ1Y5gdCsRHQw==
X-Google-Smtp-Source: ACcGV60utpUwW6bWXnXQ2HpCuE2JQ8bU3yMWYOzCDQaiiEc/JAua+05QGUyCdnsrjaMpSR1/5DRwpw==
X-Received: by 2002:a50:f573:: with SMTP id w48-v6mr7565101edm.230.1539331228734;
        Fri, 12 Oct 2018 01:00:28 -0700 (PDT)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id z33-v6sm335952edb.85.2018.10.12.01.00.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Oct 2018 01:00:27 -0700 (PDT)
Subject: Re: brcmfmac with BCM4359 on arm64 (RK3399) and SDIO
To:     =?UTF-8?Q?Christoph_M=c3=bcllner?= 
        <christoph.muellner@theobroma-systems.com>,
        Franky Lin <franky.lin@broadcom.com>
References: <5C44048D-0676-48E6-9AA3-F327839F13E5@theobroma-systems.com>
 <CA+8PC_dkJAPR2C0DsOWRb__RrijbZZ43MM1gtKGjsMxdTGwsZQ@mail.gmail.com>
 <fabdecc1-f032-789e-058f-2c62442b12c0@theobroma-systems.com>
 <C9DFBEBB-4481-4CBA-AE10-92A20C815D4F@theobroma-systems.com>
Cc:     "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <f7645f53-3e63-c888-c4a7-ece11655849d@broadcom.com>
Date:   Fri, 12 Oct 2018 10:00:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <C9DFBEBB-4481-4CBA-AE10-92A20C815D4F@theobroma-systems.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/11/2018 6:04 PM, Christoph Müllner wrote:
> Hi Franky and Arend,
>
> today I could get a SDIO Wifi module, which includes a BCM43455.
> I was able to get this up and running without any issues with the brcmfmac
> driver and a 4.19 kernel. For me that's enough evidence to say that the SDIO
> driver works.
>
> However, the BCM4359 still does not work.
> It times out in brcmf_sdio_firmware_callback(), while enabling func2.
>
> I've inserted tons of debug log outputs in both, the DHD driver and the
> brcmfmac driver, and compared them. Differences which I've found so far
> are: a) brcmfmac strips out whitespaces from nvram contents and
> b) DHD downloads firmware first and brcmfmac downloads nvram first.
> I've adapted the DHD driver to behave like brcmfmac in both cases
> and it still works.
>
> I've increased the timeout for enabling func2 from 3 seconds to 10 seconds,
> but that did not help.
>
> Any ideas left?

When enabling func2 fails it generally means the firmware crashed. I am 
not sure if the patch below works to get console information. It might 
show up empty or simply fail if firmware did not fill shared memory 
info, but it may be worth a try.

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c 
b/drivers/
index c99a191..739dbaa 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4109,7 +4109,7 @@ static void brcmf_sdio_firmware_callback(struct 
device *d
         } else {
                 /* Disable F2 again */
                 sdio_disable_func(sdiod->func2);
-               goto release;
+               goto checkdied;
         }

         if (brcmf_chip_sr_capable(bus->ci)) {
@@ -4151,6 +4151,9 @@ static void brcmf_sdio_firmware_callback(struct 
device *d
         /* ready */
         return;

+checkdied:
+       brcmf_sdio_checkdied(bus);
+       brcmf_sdio_readconsole(bus);
  release:
         sdio_release_host(sdiod->func1);
  fail:

