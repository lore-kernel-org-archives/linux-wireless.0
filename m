Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLACK
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 574D0C64EBC
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 12:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1434F205C9
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 12:40:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iqxnn8GW";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Pkqp5t+M"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1434F205C9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbeJDTdI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 15:33:08 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:46648 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727370AbeJDTdI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 15:33:08 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 77921607BD; Thu,  4 Oct 2018 12:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538656800;
        bh=L1E8wjTexNSQ4TTWoeqeNanJeyU1VGe/jihaNiBqY/0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=iqxnn8GWommDiZxW2iLa0WLx6dwLUsS854cOkNTsl0K53S0Ds+iifg85OfgkF6Iur
         DjSq1rGJ4uU5epUJRXRRCAXdGQBM6Jvt0E9WO2X+OL0T4XAEFWC0Ary7mVdGQ3PRxt
         X8c/GU0Aujn+lTgcxLbjnKvMbQsb+Vrwgayw8O40=
Received: from x230.qca.qualcomm.com (85-76-114-39-nat.elisa-mobile.fi [85.76.114.39])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 19E6B607BD;
        Thu,  4 Oct 2018 12:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538656799;
        bh=L1E8wjTexNSQ4TTWoeqeNanJeyU1VGe/jihaNiBqY/0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Pkqp5t+MG5PZ6B5VpqxWAshq77GnPc9o0j/j4RgHBruavZvque5bEUL8rTb3jPfpi
         uu3ji5HrGgZNi0psoKnnYBdh9L15Ys3Y3985ASjXT3e8yoGAEcfLCbKaXhbJyrudyP
         AbJ1DOGLZRxZNp8zywk4LfpSkpnQesGuqhx6EFek=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 19E6B607BD
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Tony Chuang <yhchuang@realtek.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>
Subject: Re: [PATCH 01/12] rtwlan: main files
References: <1537509847-21087-1-git-send-email-yhchuang@realtek.com>
        <1537509847-21087-2-git-send-email-yhchuang@realtek.com>
        <20180927135040.GA4712@redhat.com>
        <F7CD281DE3E379468C6D07993EA72F84D08D9F56@RTITMBSVM01.realtek.com.tw>
        <20180928092918.GC8323@redhat.com>
        <F7CD281DE3E379468C6D07993EA72F84D08DB7E3@RTITMBSVM01.realtek.com.tw>
        <20181002102957.GB25116@redhat.com>
        <a54dec4e-1164-f9c5-c791-3396a239eeba@lwfinger.net>
        <F7CD281DE3E379468C6D07993EA72F84D1728978@RTITMBSVM01.realtek.com.tw>
        <4b50e06f-2fd0-9378-d283-1ca6d02f9586@lwfinger.net>
Date:   Thu, 04 Oct 2018 15:39:55 +0300
In-Reply-To: <4b50e06f-2fd0-9378-d283-1ca6d02f9586@lwfinger.net> (Larry
        Finger's message of "Wed, 3 Oct 2018 00:40:06 -0500")
Message-ID: <87k1mx28dg.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 10/2/18 9:57 PM, Tony Chuang wrote:
>>
>>
>>> -----Original Message-----
>>> From: Larry Finger [mailto:larry.finger@gmail.com] On Behalf Of Larry Finger
>>> Sent: Tuesday, October 02, 2018 11:24 PM
>>> To: Stanislaw Gruszka; Tony Chuang
>>> Cc: kvalo@codeaurora.org; linux-wireless@vger.kernel.org; Pkshih; Andy
>>> Huang
>>> Subject: Re: [PATCH 01/12] rtwlan: main files
>>>
>>> On 10/2/18 5:29 AM, Stanislaw Gruszka wrote:
>>>> On Fri, Sep 28, 2018 at 11:32:41AM +0000, Tony Chuang wrote:
>>>>>> 	if (rtw_hci_tx(rtwdev, &pkt_info, skb))
>>>>>> 		dev_kfree_skb_any(skb)
>>>>>>
>>>>>> just to remove 'return;' and out label.
>>>>>
>>>>>
>>>>> OK, but why not use ieee80211_free_txskb, should it be better for
>>> mac80211?
>>>>
>>>> Yes, it is better as it also do some extra thing for dropped frame.
>>>>
>>>>>>> OK, but I think this is needed, our tables have different forms ....
>>>>>>
>>>>>> Not sure if that is better solution, but could the tables be pre-prarsed
>>>>>> by user-space program and then embed in the driver in ready to send
>>>>>> to the hardware from ?
>>>>>>
>>>>>> Also there are lot of redundancy in those tables, for example:
>>>>>>
>>>>>> +	0x81C, 0xFF000003,
>>>>>> +	0x81C, 0xF5000003,
>>>>>> +	0x81C, 0xF4020003,
>>>>>> +	0x81C, 0xF3040003,
>>>>>> +	0x81C, 0xF2060003,
>>>>>> +	0x81C, 0xF1080003,
>>>>>> +	0x81C, 0xF00A0003,
>>>>>> +	0x81C, 0xEF0C0003,
>>>>>> +	0x81C, 0xEE0E0003,
>>>>>> +	0x81C, 0xED100003,
>>>>>> +	0x81C, 0xEC120003,
>>>>>> +	0x81C, 0xEB140003,
>>>>>> +	0x81C, 0xEA160003,
>>>>>> +	0x81C, 0xE9180003,
>>>>>> +	0x81C, 0xE81A0003,
>>>>>> +	0x81C, 0xE71C0003,
>>>>>> +	0x81C, 0xE61E0003,
>>>>>> +	0x81C, 0xE5200003,
>>>>>>
>>>>>> 0x81C and 0003 repeats in many lines.
>>>>>>
>>>>>> This seems to be parse data, not that we have to write 0x81C
>>>>>> register many times. Would be possible to remove the redundancy?
>>>>>
>>>>>
>>>>> No, they cannot be removed, the sequence matters.
>>>>> And it is really writing to 0x81C ...
>>>>> It is really magic, I cannot believe to this, too.
>>>>
>>>> This is contradiction for what I asked you before, i.e. doing parsing
>>>> in user space, but since we have this parsing mechanism in the driver
>>>> perhaps the tables can be coded in some more compact way, for example:
>>>>
>>>> { prefix, suffix, len, {data} }
>>>>
>>>> { 0x81C, 0x0003, N ,
>>>>     { 0xFF02 , 0xF500 , .... , 0xE520 } }
>>>>
>>>> The rtw8822b_table.c file is quite big.
>>>
>>> You might also consider having these tables as a configuration file read from
>>> the firmware directory.
>>>
>>
>> Hi Larry,
>>
>> Can we put the configuration file in the firmware directory?
>> Should we package them into binary files? Or just put the raw data.
>>
>> We can test the performance for it. After we got the result, we will make a decision
>> about it. And if we decide to put them in the firmware directory, will send a patch.
>> For now, I think we can just leave them in the .c.
>
> Yes, you could put the configuration files in the firmware directory.
> I would put them in binary form, not as text files. That way the size
> would be smaller, and it would not be possible to alter them,
> particularly if the binary file is checksummed.
>
> It would likely be OK if only the agc table was stored in this way.
> That would take away about half of the lines in the 8822b table file.

So what's the worry here? The lines of source code, binary size or what?

 .../net/wireless/realtek/rtw88/rtw8822b_table.c    | 20783 +++++++++++++++++++

Looking at the diffstat rtw8822b_table.c seems to be 20 kLOC, IMHO it's
not that bad as it's just data. But of course I might be missing
something as I haven't checked patches yet.

-- 
Kalle Valo
