Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLACK
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 368E4C64EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 12:35:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFF43205C9
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 12:35:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NwnSH+zD";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SZFw+z04"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EFF43205C9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbeJDT26 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 15:28:58 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42576 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727407AbeJDT26 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 15:28:58 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 06FA560D0C; Thu,  4 Oct 2018 12:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538656551;
        bh=J8ei9hNhp5ttGxqhKWlEgJA7N5pRcXKtEpQYpJFhdYY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=NwnSH+zD7PdR/Z/LgpMbSJU6gby7IBrDFNgafp9OYLJ75P1GJZzDPbVhwmNbzHMn5
         L8bODwahF2fBAu3p4RFoy3pnZqpqDo5NrFVdzrRl0vYDV31oVYbOg8YRA85ZwQrmfu
         YEZANkWqKtYfQ2LoQmZsMi7OXuOor74V+B0BSCpo=
Received: from x230.qca.qualcomm.com (85-76-114-39-nat.elisa-mobile.fi [85.76.114.39])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6413C60D3B;
        Thu,  4 Oct 2018 12:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538656549;
        bh=J8ei9hNhp5ttGxqhKWlEgJA7N5pRcXKtEpQYpJFhdYY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=SZFw+z04jFs5XrHqcaFsHttxpX2aQgqdUMuOIksmGLIjN7U6ySz1iS+DTgrHzrg/m
         EgKWJQcKd3kEZp5TA03oF/bt9VNQUjgn6hEPMiSMbso+2aLRk2loiwbWH+hireaUeK
         qkfPNg+5I4stO+ZptKb2kkSzqQIswq2xqrlnBjrM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6413C60D3B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Tony Chuang <yhchuang@realtek.com>,
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
Date:   Thu, 04 Oct 2018 15:35:44 +0300
In-Reply-To: <a54dec4e-1164-f9c5-c791-3396a239eeba@lwfinger.net> (Larry
        Finger's message of "Tue, 2 Oct 2018 10:23:44 -0500")
Message-ID: <87o9c928kf.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 10/2/18 5:29 AM, Stanislaw Gruszka wrote:
>> On Fri, Sep 28, 2018 at 11:32:41AM +0000, Tony Chuang wrote:
>>>> 	if (rtw_hci_tx(rtwdev, &pkt_info, skb))
>>>> 		dev_kfree_skb_any(skb)
>>>>
>>>> just to remove 'return;' and out label.
>>>
>>>
>>> OK, but why not use ieee80211_free_txskb, should it be better for mac80211?
>>
>> Yes, it is better as it also do some extra thing for dropped frame.
>>
>>>>> OK, but I think this is needed, our tables have different forms ....
>>>>
>>>> Not sure if that is better solution, but could the tables be pre-prarsed
>>>> by user-space program and then embed in the driver in ready to send
>>>> to the hardware from ?
>>>>
>>>> Also there are lot of redundancy in those tables, for example:
>>>>
>>>> +	0x81C, 0xFF000003,
>>>> +	0x81C, 0xF5000003,
>>>> +	0x81C, 0xF4020003,
>>>> +	0x81C, 0xF3040003,
>>>> +	0x81C, 0xF2060003,
>>>> +	0x81C, 0xF1080003,
>>>> +	0x81C, 0xF00A0003,
>>>> +	0x81C, 0xEF0C0003,
>>>> +	0x81C, 0xEE0E0003,
>>>> +	0x81C, 0xED100003,
>>>> +	0x81C, 0xEC120003,
>>>> +	0x81C, 0xEB140003,
>>>> +	0x81C, 0xEA160003,
>>>> +	0x81C, 0xE9180003,
>>>> +	0x81C, 0xE81A0003,
>>>> +	0x81C, 0xE71C0003,
>>>> +	0x81C, 0xE61E0003,
>>>> +	0x81C, 0xE5200003,
>>>>
>>>> 0x81C and 0003 repeats in many lines.
>>>>
>>>> This seems to be parse data, not that we have to write 0x81C
>>>> register many times. Would be possible to remove the redundancy?
>>>
>>>
>>> No, they cannot be removed, the sequence matters.
>>> And it is really writing to 0x81C ...
>>> It is really magic, I cannot believe to this, too.
>>
>> This is contradiction for what I asked you before, i.e. doing parsing
>> in user space, but since we have this parsing mechanism in the driver
>> perhaps the tables can be coded in some more compact way, for example:
>>
>> { prefix, suffix, len, {data} }
>>
>> { 0x81C, 0x0003, N ,
>>    { 0xFF02 , 0xF500 , .... , 0xE520 } }
>>
>> The rtw8822b_table.c file is quite big.
>
> You might also consider having these tables as a configuration file
> read from the firmware directory.

Configuration files for upstream drivers is something I would like to
avoid until we have a generic solution. That seems to come up now and
then but there does not seem to be any consensus how it should be
implemented.

-- 
Kalle Valo
