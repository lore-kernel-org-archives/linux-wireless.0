Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A478FC65BA7
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 05:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45E1C2098A
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 05:40:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HZ5loBqd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 45E1C2098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727396AbeJCM07 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 08:26:59 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:35950 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbeJCM06 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 08:26:58 -0400
Received: by mail-ot1-f67.google.com with SMTP id c18-v6so4368300otm.3
        for <linux-wireless@vger.kernel.org>; Tue, 02 Oct 2018 22:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XR5rb06C7TC8LC2mQCFK8I5PvQaQc0l24BmeOZrSPac=;
        b=HZ5loBqdpVEmPoFV8EFCdM0dMzestnSPIICFC9CXG1PQJNX+x6sNY9Vymp9KBcDp4n
         YyFRF0xZXNEXVh9cD0z+juVSqJ2SWDk+uTvPAsce+dj7b2uCysNiU9rSnOaSorZScfsl
         tH2NalHJmvTimihsytOaYqKD6kLdGkBbk//jZgb4IBSq/b56SlI1Bfu6xcJDteV17DO9
         eqy/e4teD3GKglWvf+GG+bn1K1NQsBidS5eqbRZqW1yqs7U+FLMLT8o0GOnwZbqM6OMb
         oGEolHlDlYcT7+XSv2CH3gMhZ35IDNtc0+np7DuvObiHuvzVItzwwNWWbZaetPxYnOhJ
         Xc/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XR5rb06C7TC8LC2mQCFK8I5PvQaQc0l24BmeOZrSPac=;
        b=nY10TeBUqWCGsTDAB6qKKas7Scl/K1NbPMxvB4KsmRpBOHsaXOI+P7RZ4R9LYDZmZS
         NZTDbJnZoDZ+IKUtfJZHEkEjDX6DuA/DwtstlXBOveoDFXvz/yax99pbHmw30BdocMGA
         scNUGNGtfzEVjMUUwaqzZk+IlBIxCmqdfiwbKqJvl8Lf5hoNSUT7lwkKDm3eO/Wzc7e5
         +UG6/6x3cpCm7PqK5/qqW5O1wylRD+Kxr/l9UCJvtsTM5SL1+vssLx/LE74Kav9+Vp35
         rZRgVJ+j8G+nLlziIXBJP0eni7dPJR1M+oBhGxpp81zb+0Qj+jkUlb6kHF7MG3Ckk7UM
         cAFw==
X-Gm-Message-State: ABuFfojv63FkJjn4znhD2AEjP5HdQMF9L3DGaBkIvTkRvcQiIMUp4T1s
        JPY28hi1exYni654KnugxyA=
X-Google-Smtp-Source: ACcGV62Hg4hamKi8T1h1pGEcjc8sQ56YOZ70kc9WUZrta7ZZKaagiKZELHDhm4IB9atrpVqpmXV5fQ==
X-Received: by 2002:a9d:29f2:: with SMTP id g47mr1018193otd.21.1538545208590;
        Tue, 02 Oct 2018 22:40:08 -0700 (PDT)
Received: from [192.168.1.107] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id u17-v6sm79003oia.43.2018.10.02.22.40.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Oct 2018 22:40:07 -0700 (PDT)
Subject: Re: [PATCH 01/12] rtwlan: main files
To:     Tony Chuang <yhchuang@realtek.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
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
 <a54dec4e-1164-f9c5-c791-3396a239eeba@lwfinger.net>
 <F7CD281DE3E379468C6D07993EA72F84D1728978@RTITMBSVM01.realtek.com.tw>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <4b50e06f-2fd0-9378-d283-1ca6d02f9586@lwfinger.net>
Date:   Wed, 3 Oct 2018 00:40:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D1728978@RTITMBSVM01.realtek.com.tw>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/2/18 9:57 PM, Tony Chuang wrote:
> 
> 
>> -----Original Message-----
>> From: Larry Finger [mailto:larry.finger@gmail.com] On Behalf Of Larry Finger
>> Sent: Tuesday, October 02, 2018 11:24 PM
>> To: Stanislaw Gruszka; Tony Chuang
>> Cc: kvalo@codeaurora.org; linux-wireless@vger.kernel.org; Pkshih; Andy
>> Huang
>> Subject: Re: [PATCH 01/12] rtwlan: main files
>>
>> On 10/2/18 5:29 AM, Stanislaw Gruszka wrote:
>>> On Fri, Sep 28, 2018 at 11:32:41AM +0000, Tony Chuang wrote:
>>>>> 	if (rtw_hci_tx(rtwdev, &pkt_info, skb))
>>>>> 		dev_kfree_skb_any(skb)
>>>>>
>>>>> just to remove 'return;' and out label.
>>>>
>>>>
>>>> OK, but why not use ieee80211_free_txskb, should it be better for
>> mac80211?
>>>
>>> Yes, it is better as it also do some extra thing for dropped frame.
>>>
>>>>>> OK, but I think this is needed, our tables have different forms ....
>>>>>
>>>>> Not sure if that is better solution, but could the tables be pre-prarsed
>>>>> by user-space program and then embed in the driver in ready to send
>>>>> to the hardware from ?
>>>>>
>>>>> Also there are lot of redundancy in those tables, for example:
>>>>>
>>>>> +	0x81C, 0xFF000003,
>>>>> +	0x81C, 0xF5000003,
>>>>> +	0x81C, 0xF4020003,
>>>>> +	0x81C, 0xF3040003,
>>>>> +	0x81C, 0xF2060003,
>>>>> +	0x81C, 0xF1080003,
>>>>> +	0x81C, 0xF00A0003,
>>>>> +	0x81C, 0xEF0C0003,
>>>>> +	0x81C, 0xEE0E0003,
>>>>> +	0x81C, 0xED100003,
>>>>> +	0x81C, 0xEC120003,
>>>>> +	0x81C, 0xEB140003,
>>>>> +	0x81C, 0xEA160003,
>>>>> +	0x81C, 0xE9180003,
>>>>> +	0x81C, 0xE81A0003,
>>>>> +	0x81C, 0xE71C0003,
>>>>> +	0x81C, 0xE61E0003,
>>>>> +	0x81C, 0xE5200003,
>>>>>
>>>>> 0x81C and 0003 repeats in many lines.
>>>>>
>>>>> This seems to be parse data, not that we have to write 0x81C
>>>>> register many times. Would be possible to remove the redundancy?
>>>>
>>>>
>>>> No, they cannot be removed, the sequence matters.
>>>> And it is really writing to 0x81C ...
>>>> It is really magic, I cannot believe to this, too.
>>>
>>> This is contradiction for what I asked you before, i.e. doing parsing
>>> in user space, but since we have this parsing mechanism in the driver
>>> perhaps the tables can be coded in some more compact way, for example:
>>>
>>> { prefix, suffix, len, {data} }
>>>
>>> { 0x81C, 0x0003, N ,
>>>     { 0xFF02 , 0xF500 , .... , 0xE520 } }
>>>
>>> The rtw8822b_table.c file is quite big.
>>
>> You might also consider having these tables as a configuration file read from
>> the firmware directory.
>>
> 
> Hi Larry,
> 
> Can we put the configuration file in the firmware directory?
> Should we package them into binary files? Or just put the raw data.
> 
> We can test the performance for it. After we got the result, we will make a decision
> about it. And if we decide to put them in the firmware directory, will send a patch.
> For now, I think we can just leave them in the .c.

Yes, you could put the configuration files in the firmware directory. I would 
put them in binary form, not as text files. That way the size would be smaller, 
and it would not be possible to alter them, particularly if the binary file is 
checksummed.

It would likely be OK if only the agc table was stored in this way. That would 
take away about half of the lines in the 8822b table file.

Larry
