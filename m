Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F27C65C31
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 12:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33B4B21473
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 12:20:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OBFf7EZV";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QbwKcLTW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33B4B21473
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbeJFTXc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 15:23:32 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49332 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727658AbeJFTXc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 15:23:32 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1C38A60791; Sat,  6 Oct 2018 12:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538828428;
        bh=6niyHyId9hqwrPEjmnbPXYiLQ0irTaeTrEeu8YZCgUs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=OBFf7EZVyO/n7oFQbqwYKlKduu9qbtg64B0basikQ6IV5XDzB+vKb3qQBu6GSoiks
         fXV1oiCxsDZ8cwhjY3EJAG07G17P/35HqZIWzjqB1FrMQQEA1ZBSB47wwGwfEXb9Zq
         PFEvIgNcwgZfuKmlm7nHsnsl4YDaU/uONQDQkkuI=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0BF546053C;
        Sat,  6 Oct 2018 12:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538828427;
        bh=6niyHyId9hqwrPEjmnbPXYiLQ0irTaeTrEeu8YZCgUs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=QbwKcLTWik9dYoP4h3ljTc+3gxJ/Xhrr6j46n+JWfGAe5qWchcunX3z9IeSBpiYvw
         f53ioYXFYD8M+LSw92N0mZa+ZLDLpY1B/NqnWZymwtddG7OtJIzXaRMyq8T6JE9Wzr
         r+l5953QMGhJr+chCux6YjAwlHmmAvx640jicPiE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0BF546053C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Tony Chuang <yhchuang@realtek.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>
Subject: Re: [PATCH 01/12] rtwlan: main files
References: <1537509847-21087-2-git-send-email-yhchuang@realtek.com>
        <20180927135040.GA4712@redhat.com>
        <F7CD281DE3E379468C6D07993EA72F84D08D9F56@RTITMBSVM01.realtek.com.tw>
        <20180928092918.GC8323@redhat.com>
        <F7CD281DE3E379468C6D07993EA72F84D08DB7E3@RTITMBSVM01.realtek.com.tw>
        <20181002102957.GB25116@redhat.com>
        <a54dec4e-1164-f9c5-c791-3396a239eeba@lwfinger.net>
        <F7CD281DE3E379468C6D07993EA72F84D1728978@RTITMBSVM01.realtek.com.tw>
        <4b50e06f-2fd0-9378-d283-1ca6d02f9586@lwfinger.net>
        <87k1mx28dg.fsf@codeaurora.org> <20181004134252.GA20484@redhat.com>
        <2fa15cec-bcef-35af-43af-5365d52d82c8@lwfinger.net>
Date:   Sat, 06 Oct 2018 15:20:18 +0300
In-Reply-To: <2fa15cec-bcef-35af-43af-5365d52d82c8@lwfinger.net> (Larry
        Finger's message of "Thu, 4 Oct 2018 11:19:59 -0500")
Message-ID: <87h8hzferh.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 10/4/18 8:42 AM, Stanislaw Gruszka wrote:
>> On Thu, Oct 04, 2018 at 03:39:55PM +0300, Kalle Valo wrote:
>>>>> Can we put the configuration file in the firmware directory?
>>>>> Should we package them into binary files? Or just put the raw data.
>>>>>
>>>>> We can test the performance for it. After we got the result, we
>>>>> will make a decision
>>>>> about it. And if we decide to put them in the firmware directory,
>>>>> will send a patch.
>>>>> For now, I think we can just leave them in the .c.
>>>>
>>>> Yes, you could put the configuration files in the firmware directory.
>>>> I would put them in binary form, not as text files. That way the size
>>>> would be smaller, and it would not be possible to alter them,
>>>> particularly if the binary file is checksummed.
>>>>
>>>> It would likely be OK if only the agc table was stored in this way.
>>>> That would take away about half of the lines in the 8822b table file.
>>>
>>> So what's the worry here? The lines of source code, binary size or what?
>>>
>>>   .../net/wireless/realtek/rtw88/rtw8822b_table.c    | 20783 +++++++++++++++++++
>>>
>>> Looking at the diffstat rtw8822b_table.c seems to be 20 kLOC, IMHO it's
>>> not that bad as it's just data. But of course I might be missing
>>> something as I haven't checked patches yet.
>>
>> My concern was it's plenty of redundant data, for example:
>>
>>          0x81C, 0xFF000003,
>>          0x81C, 0xFE000003,
>>          0x81C, 0xFD020003,
>>          0x81C, 0xFC040003,
>>          0x81C, 0xFB060003,
>>          0x81C, 0xFA080003,
>>          0x81C, 0xF90A0003,
>>          0x81C, 0xF80C0003,
>>          0x81C, 0xF70E0003,
>>          0x81C, 0xF6100003,
>>
>> Approx 10000 lines like this, braked by lines like this
>>
>>          0x90000012,     0x00000000,     0x40000000,     0x00000000,
>>
>> in more or less regular way.
>>
>> Not big deal, but perhaps this could be coded in much more compact way.
>
> What should be the tradeoff between large tables of redundant data and
> complicated generation and interpretation? I think this table should
> be converted to binary in its present form and added to the
> "firmware", the way that is done for b43. That way the source is
> smaller, and the loading will be only a bit more time consuming.

But separating the data from the driver creates another set of problems.
For example, what if the data is dependent on the driver changes? Then
we need to think about backwards compatibility etc, which creates more
work us. I prefer simple solutions, less work and less problems :)

-- 
Kalle Valo
