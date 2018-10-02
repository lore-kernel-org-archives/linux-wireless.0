Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57965C43143
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 15:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E04320666
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 15:23:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LkYpwwOH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E04320666
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbeJBWHm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 18:07:42 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:44554 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbeJBWHm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 18:07:42 -0400
Received: by mail-oi1-f195.google.com with SMTP id u74-v6so1811366oia.11
        for <linux-wireless@vger.kernel.org>; Tue, 02 Oct 2018 08:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=678p+uUzSCCfpbl2ibUqRip9WTNHMM93aIG8g4eTTkQ=;
        b=LkYpwwOHujw9Rh8vWGHk68B9DZmGK0jVevOYVJMjcCEAvXiWaGguLXLGU940tKTFPF
         1Z17v3uIOw8zDj21yVSUIPFKx6sabZ5ge2p/KKu5yWHEwFWGjc+xxtjciVJ0w3Ufmei7
         sXUfZ//ou7KQ28C3XbqrPoYW7bdcS+s5p+EZg6woTsHaOVDWaVQKqcIpDmS9uVrQ/bDC
         ooH/UJOT8X5EZjdvvjd1zHf6c/CsgboiL8VobLIWkLkxNUWs+ZbEM5gCiwloiZhfGM+r
         +xvGt7CjcojeGSCxsL5flch6M5o3o7hWocd2ZS+Dkas9B+BXJ1ShnfrpurVyn/3tDPi9
         Y2mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=678p+uUzSCCfpbl2ibUqRip9WTNHMM93aIG8g4eTTkQ=;
        b=QKxhyXcPlyfjznurSpQII4yoBadt4DVXR3WD9X18p5x9JvfdVnzEDhyWynVvwcfm5w
         7hWCi6f7jQ41pdSg1Cteo1lFiXXaF60xasO+3QsLengymR46MY5a9iMW88aK4zwKRepZ
         AJvvHTIer5lsviBG2dzocNc5C/nIuNZypksPFCd2JfGB40O31WxFHK3wJpCqUCqWTepV
         Z7qivYymIZdt6bAveNLCWgHb00w0MdubZMVirUE9eHMECwg0w5292rFhiQqBUtYvUfgm
         bMxM37xkBJAxuNxQpF+GWDgwyyjLtM1l6z25qV7eN6i9ujO1NWGu/l1hv3M0Xpcm4FRf
         H+fA==
X-Gm-Message-State: ABuFfoi9yXIQ8hPCEiS8a7dgp861n4WYNBVRDlmpCKMHOp9WU+GM35Wq
        GR1haDItijzCF2Hdl1b/fvA=
X-Google-Smtp-Source: ACcGV60C1b7hkcaNk02J5qUtLQAnOKBJqJFZr3YLtAFwvlQdP0scZRdETZweMyeCpGPgXLOOJSkTlw==
X-Received: by 2002:aca:b745:: with SMTP id h66-v6mr7287139oif.75.1538493826478;
        Tue, 02 Oct 2018 08:23:46 -0700 (PDT)
Received: from [192.168.1.107] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id e205-v6sm5836471oia.9.2018.10.02.08.23.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Oct 2018 08:23:45 -0700 (PDT)
Subject: Re: [PATCH 01/12] rtwlan: main files
To:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Tony Chuang <yhchuang@realtek.com>
Cc:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>
References: <1537509847-21087-1-git-send-email-yhchuang@realtek.com>
 <1537509847-21087-2-git-send-email-yhchuang@realtek.com>
 <20180927135040.GA4712@redhat.com>
 <F7CD281DE3E379468C6D07993EA72F84D08D9F56@RTITMBSVM01.realtek.com.tw>
 <20180928092918.GC8323@redhat.com>
 <F7CD281DE3E379468C6D07993EA72F84D08DB7E3@RTITMBSVM01.realtek.com.tw>
 <20181002102957.GB25116@redhat.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <a54dec4e-1164-f9c5-c791-3396a239eeba@lwfinger.net>
Date:   Tue, 2 Oct 2018 10:23:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <20181002102957.GB25116@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/2/18 5:29 AM, Stanislaw Gruszka wrote:
> On Fri, Sep 28, 2018 at 11:32:41AM +0000, Tony Chuang wrote:
>>> 	if (rtw_hci_tx(rtwdev, &pkt_info, skb))
>>> 		dev_kfree_skb_any(skb)
>>>
>>> just to remove 'return;' and out label.
>>
>>
>> OK, but why not use ieee80211_free_txskb, should it be better for mac80211?
> 
> Yes, it is better as it also do some extra thing for dropped frame.
> 
>>>> OK, but I think this is needed, our tables have different forms ....
>>>
>>> Not sure if that is better solution, but could the tables be pre-prarsed
>>> by user-space program and then embed in the driver in ready to send
>>> to the hardware from ?
>>>
>>> Also there are lot of redundancy in those tables, for example:
>>>
>>> +	0x81C, 0xFF000003,
>>> +	0x81C, 0xF5000003,
>>> +	0x81C, 0xF4020003,
>>> +	0x81C, 0xF3040003,
>>> +	0x81C, 0xF2060003,
>>> +	0x81C, 0xF1080003,
>>> +	0x81C, 0xF00A0003,
>>> +	0x81C, 0xEF0C0003,
>>> +	0x81C, 0xEE0E0003,
>>> +	0x81C, 0xED100003,
>>> +	0x81C, 0xEC120003,
>>> +	0x81C, 0xEB140003,
>>> +	0x81C, 0xEA160003,
>>> +	0x81C, 0xE9180003,
>>> +	0x81C, 0xE81A0003,
>>> +	0x81C, 0xE71C0003,
>>> +	0x81C, 0xE61E0003,
>>> +	0x81C, 0xE5200003,
>>>
>>> 0x81C and 0003 repeats in many lines.
>>>
>>> This seems to be parse data, not that we have to write 0x81C
>>> register many times. Would be possible to remove the redundancy?
>>
>>
>> No, they cannot be removed, the sequence matters.
>> And it is really writing to 0x81C ...
>> It is really magic, I cannot believe to this, too.
> 
> This is contradiction for what I asked you before, i.e. doing parsing
> in user space, but since we have this parsing mechanism in the driver
> perhaps the tables can be coded in some more compact way, for example:
> 
> { prefix, suffix, len, {data} }
> 
> { 0x81C, 0x0003, N ,
>    { 0xFF02 , 0xF500 , .... , 0xE520 } }
> 
> The rtw8822b_table.c file is quite big.

You might also consider having these tables as a configuration file read from 
the firmware directory.

Larry

