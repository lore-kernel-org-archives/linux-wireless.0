Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,SUBJ_ALL_CAPS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CE41C10F13
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 01:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DB3A20869
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 01:26:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZTdNV+a+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfDLB0s (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Apr 2019 21:26:48 -0400
Received: from mail-oi1-f176.google.com ([209.85.167.176]:46252 "EHLO
        mail-oi1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbfDLB0s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Apr 2019 21:26:48 -0400
Received: by mail-oi1-f176.google.com with SMTP id x188so6592164oia.13
        for <linux-wireless@vger.kernel.org>; Thu, 11 Apr 2019 18:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ZVC1WS798t8MR2V87GAISj7oXNILMGuJUuMD1xUbfuw=;
        b=ZTdNV+a+Fdrg8AmaD+yJBWOgpGapIhattSBoxD/opB4IQg40TdmakOaBLac+c2JVWT
         njfjR/OSRXtZjoFJdEs0eVmE9iSmv3Hf8WWeaxJgauP6KRV/23hl8XPcQ51luSBEkR7C
         ywPp+BJ0GmJjBCXa2mp69UuwcrKrpU/QsQGuLRoOqtWsoyGMU4E5C4AUuF2L7acgs6dW
         0MBdwlcUWS1HA5iWLBOKiRNldpA09Ezat5gt4aYdKEhiHrv51+OSBV062p9sHu7o9G7E
         gP11Z/xITVmGEyHgsV+ksAhtT/zo0WrxtLSDawiPsw0FSuj9dyd2bm587WCuDR+ehsh7
         DgIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZVC1WS798t8MR2V87GAISj7oXNILMGuJUuMD1xUbfuw=;
        b=GeQiXfRXenNse5rXY7oS6oqLXpkG0+EZyYpC/T7Sm9CY/byToCl+JBwGr2h5ZbApqB
         644nqFLgb6vme08E6uzBQtRJiO2BIhvdyEnxscC2SN2w/ZaJPCh/c4s11gp2gaCZLzA8
         X9+xMUCW2raoTHAeQc6zbedeld/Co+NtEZbT2yZ1rzaBdq8962i4BsC+A7SrCHY5GoqW
         RixeszjGBv/ZRiRcMJydQu+JCatqBXyr+XC7QAt41P7/sVkkAX2FEqsuexX94j+y9ESm
         9RKBqlrLG71ua4jyIYycghvI8Ppt/VqPRigMsu9ctQqmVMYyj+rdkdxx9ubYf9Y6y/mN
         bpMw==
X-Gm-Message-State: APjAAAXCVl9X5pKCd3FamLMr+xUdPYUn/agTSYuU4q2nQDzAFyD1DyxJ
        7st2h/ias0XD6QLATekIb5DM8xb1
X-Google-Smtp-Source: APXvYqzvxQeR+2L7K8E6baGd6XN4ifELFa1vwnMeaSDGBNdIH4MiFZ3HbZBaIgJdpTIZYVBP4i//mQ==
X-Received: by 2002:aca:e8c4:: with SMTP id f187mr8946617oih.158.1555032407236;
        Thu, 11 Apr 2019 18:26:47 -0700 (PDT)
Received: from [192.168.1.249] (cpe-70-114-247-242.austin.res.rr.com. [70.114.247.242])
        by smtp.googlemail.com with ESMTPSA id x66sm8907599oif.12.2019.04.11.18.26.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Apr 2019 18:26:46 -0700 (PDT)
Subject: Re: NL80211_SCAN_FLAG_RANDOM_ADDR ?
To:     Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org
References: <e09a9bc7-9774-334b-53e8-13e1d781bee3@gmail.com>
 <913e7464-ea6e-bb22-141a-ab76019bed3f@candelatech.com>
 <fcd9fcc2-86dd-8cd7-1822-efb7df498cf8@candelatech.com>
From:   Denis Kenzior <denkenz@gmail.com>
Message-ID: <ce4f4f2b-ad34-fbf6-6fcb-0b95cf9b9d24@gmail.com>
Date:   Thu, 11 Apr 2019 20:26:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <fcd9fcc2-86dd-8cd7-1822-efb7df498cf8@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Ben,

On 04/11/2019 06:20 PM, Ben Greear wrote:
> On 4/11/19 4:19 PM, Ben Greear wrote:
>> On 4/11/19 3:30 PM, Denis Kenzior wrote:
>>> Hi,
>>>
>>> I've been poking around at how this flag is used and I noticed this 
>>> check in net/wireless/nl80211.c:
>>>
>>> nl80211_check_scan_flags()
>>>
>>>          if (*flags & NL80211_SCAN_FLAG_RANDOM_ADDR) {
>>>                  int err;
>>>
>>>                  if (!(wiphy->features & randomness_flag) ||
>>>                      (wdev && wdev->current_bss))
>>>                          return -EOPNOTSUPP;
>>>
>>>
>>> The above disallows the use of RANDOM_ADDR for scans while connected. 
>>> The nl80211.h uapi header seems to concur:
>>>
>>>   "@NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR: This device/driver supports 
>>> using a random MAC address during scan (if the device is unassociated);"
>>>
>>> However, if I create a P2P Device (in addition to the default STA 
>>> device), the kernel happily lets me scan on the wdev while the STA 
>>> interface is connected.
>>>
>>> sudo iw phy0 interface add p2p type __p2pdev
>>> sudo iw wdev 0x2 p2p start
>>> sudo iw wdev 0x2 scan randomize
>>>
>>> So the immediate question I have is, should the RANDOM_ADDR flag 
>>> indeed be limited to unassociated STA interfaces?  It would seem the 
>>> hardware is capable randomizing even when connected? Please educate 
>>> me :)
>>
>> You can be sure that each driver/hardware has its own bugs and 
>> limitations related to this.
>>
>> Ath10k wave 1 and wave 2 that I am aware of would ignore and/or not 
>> ACK probe responses
>> sent back to an MAC address that is not that of the station itself.  
>> And changing the mac of a station
>> would require complete re-association AFAIK.  That is likely just one 
>> of the many issues.

Yes, I understand that some hardware would not support this.  But the 
question is does this check belong at the nl80211 layer (e.g. no 
hardware can do this) vs somewhere at the driver layer + additional 
feature bit as needed.

> 
> I should add:  If you really want to scan in this manner, you could just 
> create a new station vdev with
> random addr and have it do the scanning, then delete it when done?  The 
> original station will continue on
> its way unmolested.
> 

So you mean something like:
sudo iw phy0 interface add sta2 type station
sudo iw dev sta2 scan randomize
command failed: Network is down (-100)
sudo ifconfig sta2 up
SIOCSIFFLAGS: Device or resource busy

I guess I'm running into this:

	valid interface combinations:
		 * #{ managed } <= 1, #{ AP, P2P-client, P2P-GO } <= 1, #{ P2P-device 
} <= 1,
		   total <= 3, #channels <= 2

Or did you mean something else?

Regards,
-Denis
