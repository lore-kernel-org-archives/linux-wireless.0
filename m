Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D49C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 10:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EDEC2172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 10:10:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1EDEC2172C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=simonmicro.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729343AbeI1QdC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 12:33:02 -0400
Received: from forward102o.mail.yandex.net ([37.140.190.182]:33627 "EHLO
        forward102o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729093AbeI1QdC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 12:33:02 -0400
X-Greylist: delayed 432 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2018 12:32:59 EDT
Received: from mxback5j.mail.yandex.net (mxback5j.mail.yandex.net [IPv6:2a02:6b8:0:1619::10e])
        by forward102o.mail.yandex.net (Yandex) with ESMTP id 0C9AB5A05B55;
        Fri, 28 Sep 2018 13:02:46 +0300 (MSK)
Received: from smtp4p.mail.yandex.net (smtp4p.mail.yandex.net [2a02:6b8:0:1402::15:6])
        by mxback5j.mail.yandex.net (nwsmtp/Yandex) with ESMTP id tSmXXJ89hD-2joShoRD;
        Fri, 28 Sep 2018 13:02:46 +0300
Received: by smtp4p.mail.yandex.net (nwsmtp/Yandex) with ESMTPSA id pSnQl2IZdM-2hVaq1b8;
        Fri, 28 Sep 2018 13:02:43 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Subject: Re: Problems and suggestions to the kernel module r8723bs
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Bastien Nocera <hadess@hadess.net>,
        Hans de Goede <hdegoede@redhat.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
References: <83c86a2a-0d2a-8119-2831-e9cfab7a43d7@simonmicro.de>
 <f0b67da4-747a-08e3-9744-fce2c74aaddc@lwfinger.net>
 <6e27de67-739f-ee17-eb5f-efb079d1f37f@simonmicro.de>
 <7a47d05c-2f3b-e4d5-ccf1-5c2106d3c93d@lwfinger.net>
 <3a0468ee-e391-3b03-bfc5-36df484bce9d@simonmicro.de>
 <9a7105c0-fd23-c7ff-3e28-62533c24cdb9@lwfinger.net>
From:   Simon Beginn <simonmicro@simonmicro.de>
Message-ID: <374c0f3a-aa89-18c5-cd53-0c395ff02a6d@simonmicro.de>
Date:   Fri, 28 Sep 2018 12:02:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <9a7105c0-fd23-c7ff-3e28-62533c24cdb9@lwfinger.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> That value means that the signal strength is way too low. One other 
> possibility is that the chip has retained the setting and is not 
> obeying the antenna number command. To check that, create a file (as 
> root) named /etc/modprobe.d/50-r8723bs.conf, and add a single line 
> containing "options r8723bs rtw_ant_num=2" (without the quotation 
> marks). After that file is ready, then do a cold boot so that the chip 
> has been power cycled. Finally, redo the signal test. Note: If your 
> patch is applied, the above will not work! 
I've applied my patch and got the following results (btw good idea with 
the cold boot!):

***FILE CREATED***
options rtl8723bs rtw_ant_num=1

***POWEROFF + 2 MINUTES WAITING***

***REBOOT + COMMAND***
sudo iw dev wlan0 scan | egrep "SSID|signal"
-> Desk
     signal: -93.00 dBm
     SSID: Gonzales
     signal: -63.00 dBm
     SSID: Gonzales
     signal: -63.00 dBm
     SSID: Gonzales
     signal: -50.00 dBm
     SSID: TPC_Install
-> Place A
     signal: -93.00 dBm
     SSID: Gonzales
     signal: -45.00 dBm
     SSID: Gonzales
     signal: -62.00 dBm
     SSID: Gonzales
     signal: -64.00 dBm
     SSID: TPC_Install

***FILE MODIFIED***
options rtl8723bs rtw_ant_num=2

***POWEROFF + 2 MINUTES WAITING***

***REBOOT + COMMAND***
sudo iw dev wlan0 scan | egrep "SSID|signal"
-> Desk
     signal: -85.00 dBm
     SSID: Gonzales
     signal: -64.00 dBm
     SSID: Gonzales
     signal: -65.00 dBm
     SSID: Gonzales
     signal: -48.00 dBm
     SSID: Gonzales
     signal: -48.00 dBm
     SSID: TPC_Install
-> Place A
     signal: -79.00 dBm
     SSID: Gonzales
     signal: -45.00 dBm
     SSID: Gonzales
     signal: -63.00 dBm
     SSID: Gonzales
     signal: -63.00 dBm
     SSID: TPC_Install

> ccepted. Even if it had been correctly done, I would have NACKed it.
Sry, would you reformulate this, please? I just can't 
understand/determine what the word "NACKed" means in this situation 
(Neither google or the raw translation helps me).


Thank you,

Simon


On 09/27/2018 05:21 PM, Larry Finger wrote:
> On 9/27/18 3:33 AM, Simon Beginn wrote:
>>> Use the following command to get the baseline values: 
>> Done - aand nothing changes (The access point has a strength of -60dB 
>> on my desk). Well maybe the manufacturer has two antennas builtin. 
>> Yay - sorry for that.
>
> That value means that the signal strength is way too low. One other 
> possibility is that the chip has retained the setting and is not 
> obeying the antenna number command. To check that, create a file (as 
> root) named /etc/modprobe.d/50-r8723bs.conf, and add a single line 
> containing "options r8723bs rtw_ant_num=2" (without the quotation 
> marks). After that file is ready, then do a cold boot so that the chip 
> has been power cycled. Finally, redo the signal test. Note: If your 
> patch is applied, the above will not work!
>
>>
>>> In dmesg
>> Yep, too late. I've already installed the necessary firmware-files. 
>> But I didn't wrote it, because the WiFi test wasn't performed until yet.
>>
>>
>>> o the work to get the driver into the condition necessary for it to 
>>> be in the regular tree. 
>> Did my patch made it?
>
> Your patch was not in the correct format to be accepted. Even if it 
> had been correctly done, I would have NACKed it. Given the location of 
> the driver, the name is what it should be. Once you, or someone else, 
> has done the many hours to put that Realtek crap into proper kernel 
> form, then it could be placed in the normal wireless tree and given 
> the name rtl8723bs.
>
> Larry
