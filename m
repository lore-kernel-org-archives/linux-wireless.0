Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD77CC43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 15:59:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 836CE206B6
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 15:59:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jmHkR+8V"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 836CE206B6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbeI1WXl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 18:23:41 -0400
Received: from mail-oi1-f173.google.com ([209.85.167.173]:36897 "EHLO
        mail-oi1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbeI1WXl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 18:23:41 -0400
Received: by mail-oi1-f173.google.com with SMTP id e17-v6so4958827oib.4
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2018 08:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=177xObPEmAbsJmBUWc9dUnvuK/WMG0iFTYQNgsJmCKA=;
        b=jmHkR+8VIo5Qg1RDwo/V6POp2bSazf0r4IJvFqBe0KNaKrVizlrOx9gIc00T9L7F3t
         JR7NP21McgYBSO4oXYHtaAgb/pg7cAJFERyKnuE4nkdiHxfz3sVlT/cxeRdwXAVgTwEb
         NcMw32WcAJoGIb0qeA/eQxfImJqX9A7SEKh54ImYbW38W4UQcs4RKQlRAegjau+AUbZl
         zYiH+L0hDa1Ai+68IiHgy7FrRB4w4t2IIbsNR5zr7LXpvZtA5iwHc1GFxzhleFqB9tkQ
         1xidnzL/WX6H0WlLyVed3P6NvkDxtNNu9QKlrfmj7sj/jnw/gSc2B2Veg8i9tzahjqcq
         8Cfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=177xObPEmAbsJmBUWc9dUnvuK/WMG0iFTYQNgsJmCKA=;
        b=L8H5yGkkT3fISYZ9hp3MfgqRjVuVQ/7fqX3bHG/lsdbjTzKqbCq9rpxQgAXzImy5z7
         e1IfYe9kcK4KqB1P3bhXciN+6SSFankfnPEPj1r5vDLgJcBX1bkyMOHyf7rbq2fM56Ct
         5x8F/4VyK3RG+ZMwhFWsbDy6vw0UlxksAeJfy6sR5aU6pAtWp1zF1skwrI/hknWI9BWC
         ogwDopaWZhPjnLPTdUUWZBMul8SILhRRdnsV/OefjCfYPo3KXSsOqBBAqARGLiPliHVF
         8SnxhgMZsymFLtUR5cAGjz7Ckbj0P9yF/L66kvlOyUKw8mjNk/N18ZbjMpteaPe3SenZ
         i80A==
X-Gm-Message-State: ABuFfogmVK3bXbFMAfzjzNbkgoZJsnf01/+AK2KFdjX5nfjrwelo1hD/
        KxaY5BzyWcSfP+GWlnSQLftr7ym3
X-Google-Smtp-Source: ACcGV60MxwfrQuWIF0JrVeCScZLmFpewlxKPxDr5bOeYFuADaoIvIZggOb66d+52dxkzUHEa91pQPA==
X-Received: by 2002:aca:f409:: with SMTP id s9-v6mr6353666oih.102.1538150356871;
        Fri, 28 Sep 2018 08:59:16 -0700 (PDT)
Received: from [192.168.1.107] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id r10-v6sm1904477oif.37.2018.09.28.08.59.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Sep 2018 08:59:15 -0700 (PDT)
Subject: Re: Problems and suggestions to the kernel module r8723bs
To:     Simon Beginn <simonmicro@simonmicro.de>,
        Bastien Nocera <hadess@hadess.net>,
        Hans de Goede <hdegoede@redhat.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
References: <83c86a2a-0d2a-8119-2831-e9cfab7a43d7@simonmicro.de>
 <f0b67da4-747a-08e3-9744-fce2c74aaddc@lwfinger.net>
 <6e27de67-739f-ee17-eb5f-efb079d1f37f@simonmicro.de>
 <7a47d05c-2f3b-e4d5-ccf1-5c2106d3c93d@lwfinger.net>
 <3a0468ee-e391-3b03-bfc5-36df484bce9d@simonmicro.de>
 <9a7105c0-fd23-c7ff-3e28-62533c24cdb9@lwfinger.net>
 <374c0f3a-aa89-18c5-cd53-0c395ff02a6d@simonmicro.de>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <72ffad3d-1cdf-f93b-cefc-4ee06872926d@lwfinger.net>
Date:   Fri, 28 Sep 2018 10:59:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <374c0f3a-aa89-18c5-cd53-0c395ff02a6d@simonmicro.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 9/28/18 5:02 AM, Simon Beginn wrote:
>> That value means that the signal strength is way too low. One other 
>> possibility is that the chip has retained the setting and is not obeying the 
>> antenna number command. To check that, create a file (as root) named 
>> /etc/modprobe.d/50-r8723bs.conf, and add a single line containing "options 
>> r8723bs rtw_ant_num=2" (without the quotation marks). After that file is 
>> ready, then do a cold boot so that the chip has been power cycled. Finally, 
>> redo the signal test. Note: If your patch is applied, the above will not work! 
> I've applied my patch and got the following results (btw good idea with the cold 
> boot!):
> 
> ***FILE CREATED***
> options rtl8723bs rtw_ant_num=1
> 
> ***POWEROFF + 2 MINUTES WAITING***
> 
> ***REBOOT + COMMAND***
> sudo iw dev wlan0 scan | egrep "SSID|signal"
> -> Desk
>      signal: -93.00 dBm
>      SSID: Gonzales
>      signal: -63.00 dBm
>      SSID: Gonzales
>      signal: -63.00 dBm
>      SSID: Gonzales
>      signal: -50.00 dBm
>      SSID: TPC_Install
> -> Place A
>      signal: -93.00 dBm
>      SSID: Gonzales
>      signal: -45.00 dBm
>      SSID: Gonzales
>      signal: -62.00 dBm
>      SSID: Gonzales
>      signal: -64.00 dBm
>      SSID: TPC_Install
> 
> ***FILE MODIFIED***
> options rtl8723bs rtw_ant_num=2
> 
> ***POWEROFF + 2 MINUTES WAITING***
> 
> ***REBOOT + COMMAND***
> sudo iw dev wlan0 scan | egrep "SSID|signal"
> -> Desk
>      signal: -85.00 dBm
>      SSID: Gonzales
>      signal: -64.00 dBm
>      SSID: Gonzales
>      signal: -65.00 dBm
>      SSID: Gonzales
>      signal: -48.00 dBm
>      SSID: Gonzales
>      signal: -48.00 dBm
>      SSID: TPC_Install
> -> Place A
>      signal: -79.00 dBm
>      SSID: Gonzales
>      signal: -45.00 dBm
>      SSID: Gonzales
>      signal: -63.00 dBm
>      SSID: Gonzales
>      signal: -63.00 dBm
>      SSID: TPC_Install
> 
>> ccepted. Even if it had been correctly done, I would have NACKed it.
> Sry, would you reformulate this, please? I just can't understand/determine what 
> the word "NACKed" means in this situation (Neither google or the raw translation 
> helps me).
> 

I do not think that changing rtw_ant_num made any difference. In each location, 
both tests had one AP with a signal greater than -50, which should be strong 
enough. We do not know if the driver is roaming correctly. At each location, is 
that AP with the strongest signal actually the one that is selected? To see 
that, change the scan command to

sudo iw dev wlan0 scan | egrep "associated|SSID|signal"

Check the output to see if the AP with the strongest signal is preceded by a BSS 
line.

Sorry about using jargon that you could not run through a translator. As Bastien 
explained, NACK means to reject a patch. You accept a patch by providing an 
"ACKed-by: name <email address>" line. Thus NACK is the opposite.

Larry


