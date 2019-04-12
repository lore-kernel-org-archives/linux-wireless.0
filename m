Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,SUBJ_ALL_CAPS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97FA7C10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 15:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58C852171F
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 15:01:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KU9cmFgM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfDLPBA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 11:01:00 -0400
Received: from mail-oi1-f179.google.com ([209.85.167.179]:39310 "EHLO
        mail-oi1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbfDLPBA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 11:01:00 -0400
Received: by mail-oi1-f179.google.com with SMTP id n187so8195621oih.6
        for <linux-wireless@vger.kernel.org>; Fri, 12 Apr 2019 08:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r4xEbF9ox5hXOKP6Mdg6wjbAhDSu3tZT5/sOVrpO1Lg=;
        b=KU9cmFgMDOUGAV5R8Ea/GTCB2N88jPYdCvzB7Iij0Gh7dfL0QZ9kmR/UHWslGH/TYd
         nhdOQcyTLWxaQQIhqpWlyJiKES36uhVsosnDEUc/T1MxzuklS/v9opIS+Xov7hnlvN41
         rzZgHf5evWoDyYzDsrypIBbuXIMTMid5ZfIxC5eGkyUm4Kvt4f3aDcbxxmdchTomdKHG
         i+/bF7RDsEWx1EQ5umw5RQyAp8PEXpU9lHVEjHpQpZCcRQorGVQ1sjxh/hqCXDiBd4Oh
         RRoolzhqEfkHuxnZPOBsNXzFBsQ68rgglPV3+Xx3PBmo8F73rvFW65mDS5qsucWJ/pxk
         6cow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r4xEbF9ox5hXOKP6Mdg6wjbAhDSu3tZT5/sOVrpO1Lg=;
        b=iCTinEJSsDcsgYOeQyfWznVGH1zrN0VpmgmjSAB1pCzA30Csc4w80zYXufCtfAk1RL
         DCuRejOpPecTYASkG0MFLZH62YhNrlaVoDOHi0D3M9vki/DCAG4EDSEC5ofiWzcb1C6O
         M4Tu1npoKZWl8vdy6Tz2Bfy8PbIunh92ftZ12JRcvd7yLQ7IDaDJOxusvpUC8wggkHbH
         uPzzYiAHxsIZVFyP3OjEy69NWz7IGSlwGIBSd25WJrY2AYFTg8BRrpWwtgUnRLSLt4tV
         yCN9kfkMwG+fsDD/RfqO3LVN6YKqdnGERbYKB4P7lV7nbusAnONyiHl6mN1aWUqQ9xoE
         yRCg==
X-Gm-Message-State: APjAAAXfUkMLkJXE+2Q1eDReiEfRefT5imynt415vaDx2Y/p5pmygqf7
        uzmgNJQ6hVYp/yU0wxs9xSYy/0GP
X-Google-Smtp-Source: APXvYqzKCSIJHatUtZsNVWbzKW/x7Mu5bxNEgLGxhxoKKKdf8wa4oAZrzLKH5rt6QJu6Wl5fB4qitA==
X-Received: by 2002:aca:f10b:: with SMTP id p11mr10583720oih.86.1555081259457;
        Fri, 12 Apr 2019 08:00:59 -0700 (PDT)
Received: from [192.168.1.249] (cpe-70-114-247-242.austin.res.rr.com. [70.114.247.242])
        by smtp.googlemail.com with ESMTPSA id f3sm17643850oih.38.2019.04.12.08.00.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Apr 2019 08:00:58 -0700 (PDT)
Subject: Re: NL80211_SCAN_FLAG_RANDOM_ADDR ?
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <e09a9bc7-9774-334b-53e8-13e1d781bee3@gmail.com>
 <20190412092623.46ygdnec3wx26zvd@bars>
From:   Denis Kenzior <denkenz@gmail.com>
Message-ID: <241d2caa-6f41-6363-5164-d2ac83463beb@gmail.com>
Date:   Fri, 12 Apr 2019 10:00:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190412092623.46ygdnec3wx26zvd@bars>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Sergey,

On 04/12/2019 04:26 AM, Sergey Matyukevich wrote:
>> I've been poking around at how this flag is used and I noticed this
>> check in net/wireless/nl80211.c:
>>
>> nl80211_check_scan_flags()
>>
>>          if (*flags & NL80211_SCAN_FLAG_RANDOM_ADDR) {
>>                  int err;
>>
>>                  if (!(wiphy->features & randomness_flag) ||
>>                      (wdev && wdev->current_bss))
>>                          return -EOPNOTSUPP;
>>
>>
>> The above disallows the use of RANDOM_ADDR for scans while connected.
>> The nl80211.h uapi header seems to concur:
>>
>>   "@NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR: This device/driver supports
>> using a random MAC address during scan (if the device is unassociated);"
>>
>> However, if I create a P2P Device (in addition to the default STA
>> device), the kernel happily lets me scan on the wdev while the STA
>> interface is connected.
>>
>> sudo iw phy0 interface add p2p type __p2pdev
>> sudo iw wdev 0x2 p2p start
>> sudo iw wdev 0x2 scan randomize
>>
>> So the immediate question I have is, should the RANDOM_ADDR flag indeed
>> be limited to unassociated STA interfaces?  It would seem the hardware
>> is capable randomizing even when connected? Please educate me :)
> 
> Hello Denis,
> 
> IIUC, this feature could be introduced to support Android Compatibility
> Definition Document (CDD). Those documents are available at the
> following page: https://source.android.com/compatibility/cdd

Thanks for the reference.  It looks like a 'At a minimum you should/must 
do this' type of document.  It doesn't look like it precludes the use of 
randomization when connected?

> 
> For instance, in the latest CDD randomized scan requirements are described
> in the section 7.4.2. It looks like current high level nl80211 API follows
> those recommendations. Probably it has been implemented with STA use-case
> in mind, that is why you can use that flag for P2P connection. But, as
> Ben pointed out, actual application of this flag may depend on
> implementation in firwmare and hardware.
> 

Sure, understood.  But this is exactly the point of my question.  Is the 
check at the global level correct?  Or should it be relaxed in case 
there is hardware out there that can randomize probe requests while 
connected?  From my test it would seem this is possible?

Or put another way, besides hardware limitations, are there reasons why 
you would not want to randomize probe request address when connected?

Regards,
-Denis
