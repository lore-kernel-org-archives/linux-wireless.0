Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30E47C43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 15:28:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD79F2086E
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 15:28:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dh2HkZ/6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD79F2086E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbeIZVlg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 17:41:36 -0400
Received: from mail-ot1-f48.google.com ([209.85.210.48]:39018 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbeIZVlf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 17:41:35 -0400
Received: by mail-ot1-f48.google.com with SMTP id c12-v6so28582886otl.6
        for <linux-wireless@vger.kernel.org>; Wed, 26 Sep 2018 08:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:references:from:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WaFcSWOuVNYEiMeGKRgP4iPjZ1DLS0L1WJDpef42VAQ=;
        b=Dh2HkZ/6Mibu6XIIy9nSrg7nL+gf0hHPUGr/uR334KPuoLhGvMnvklUoS103dnJgkT
         H4jMSqCwrkSC2nk4yE0aCtD/56bfvrdnaayz0PNxwaaNkI53y7RSBllXKvd7fGOKDcEq
         ogjM4LNcGwe49W89pFrJPDIWTQNRyi1sLEWHXu5HqNnd2BzZ3kuesleFi5xLajL/Dx+x
         Xz0bSD5cFLqdcUTGfTb1hk3ifh5/Jfmk4JRmrZEzSMBSCVdKQJ+B5iLoa1JzBcaodTMA
         IPHxayLTIcasxtbJbY7sOuf9PPEoONcLcsGMQuP9ZsEVfZm3l0tIYEV2EHJHQhKywqI0
         YuFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:references:from:cc:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WaFcSWOuVNYEiMeGKRgP4iPjZ1DLS0L1WJDpef42VAQ=;
        b=k5z9upI4bAOZv/Y5HR0NyBn1lXdR/Ke1MXQyVvyRkv7gJ3I0H/aqZaAVLRW97Ptonc
         CqSTsuvqscF4zR33etawHmta3KSnoR8/ova/QM9hNu+SvDE42ImUiUTkR9l4SRndF6ac
         dJ5jaegadsyzx5UzF+pt+LesWsisJ7kfEEX6+hfCTwmdk5yrdKSn2jZLYHW8KxKbUm17
         9vjxzXDE73HUxNTos7C0OilyZ2BM5DwQJVNu/C5tI4Ryn8w6MO8yi9VKU7SKiOg0hlNB
         0bTYNhttCnVYTohGDcEbRCAMS7p0bwmdAGpAuRUKj2rIwK+sH14Z1RXKomNfOKOWgPiH
         jqug==
X-Gm-Message-State: ABuFfojk2tHfbVgP+SjRgdcSyh8+6SGzCA+SVyTBami0Tk7YBcd2HGa+
        fRCHDDXYPtN7VRFXWprgS+wLascs
X-Google-Smtp-Source: ACcGV61TnRnCLNqN4fx/zMhfppoCrfLBN+UWluhEvPaKljAspPOU5cYiGy1bCHlI3XrVPFU2BdXyVQ==
X-Received: by 2002:a9d:37a1:: with SMTP id x30-v6mr4688728otb.55.1537975687000;
        Wed, 26 Sep 2018 08:28:07 -0700 (PDT)
Received: from [192.168.1.107] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id x61-v6sm2072681ota.39.2018.09.26.08.28.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Sep 2018 08:28:05 -0700 (PDT)
Subject: Re: Problems and suggestions to the kernel module r8723bs
To:     Simon Beginn <simonmicro@simonmicro.de>,
        Bastien Nocera <hadess@hadess.net>,
        Hans de Goede <hdegoede@redhat.com>
References: <83c86a2a-0d2a-8119-2831-e9cfab7a43d7@simonmicro.de>
 <f0b67da4-747a-08e3-9744-fce2c74aaddc@lwfinger.net>
 <6e27de67-739f-ee17-eb5f-efb079d1f37f@simonmicro.de>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <7a47d05c-2f3b-e4d5-ccf1-5c2106d3c93d@lwfinger.net>
Date:   Wed, 26 Sep 2018 10:28:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <6e27de67-739f-ee17-eb5f-efb079d1f37f@simonmicro.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 9/26/18 3:54 AM, Simon Beginn wrote:
>>
>> The convention has long been to use rnnnnxx for the Realtek drivers in 
>> staging, and rtlnnnnxx when they are moved to the regular wireless tree. If 
>> you want it renamed, then you need to do the work to get the driver into the 
>> condition necessary for it to be in the regular tree.
> I'll see what I can do...
> 
>> Module parameter ant_sel for rtl8723be and rtl8723de was created because some 
>> vendors saved a few pennies by only supplying one antenna. The problem is that 
>> they encoded the WRONG value into the EFUSE, thus code that uses that setting 
>> (Linux) essentially has no antenna attached. The simple measure of opening the 
>> case and moving the antenna to the other connector was not viable for warranty 
>> conditions. In addition, it broke the Windows driver. Do you have a case where 
>> there is a single antenna for the rtl8723bs, and the PROM shows the wrong 
>> value? If not, then any antenna number option is not needed. 
> Hmm. I cant answer this for sure. The symptoms on my tablet are that the wifi 
> chip works OK using Windows (10) and is slow as **** under Linux. Under Linux 
> the system also didn't connect directly to my router (or any other of its 
> guest-networks) and prefers a far away adapter - which are all spread over my 
> house. And I think the chip does select the wrong antenna, because my router 
> (which the tablet doesn't like) discard all connection attempts if they are too 
> weak. The, as mentioned before, other adapters doesn't have such a feature AND 
> the wifi works only well if I stand directly beside the "i-take-everything" 
> adapters. To make this analysis stand on something: How can I read the PROM 
> values? The tablets BIOS is not the key - it only provides the EFI selection.

This driver is not reading any PROM data. It sets the antenna to 1 unless it is 
overridden by the rtw_ant_num option. We need to use signal strengths to decide 
if using ant_num 2 would be better. Use the following command to get the 
baseline values:

sudo iw dev wlan0 scan | egrep "SSID|signal"

Change the wlan0 to the actual device name on your system.

Next, do the command sequence

sudo modprobe -rv r8723bs
sudo modprobe -v r8723bs rtw_ant_num=2

Then repeat the iw command.

If the second set of signals is something like 30 dBm greater, then prepare an 
options file to force antenna #2. Post all the scan data for the AP you want to use.

Larry

