Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DE28C65C31
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 12:16:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F330C2147D
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 12:16:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="os4RQi/q";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Nz3K2MJ0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F330C2147D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbeJFTTx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 15:19:53 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48646 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727202AbeJFTTx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 15:19:53 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8B4F560BF4; Sat,  6 Oct 2018 12:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538828210;
        bh=p9IOzPQNAolHZ6879f65g2rk6A4ZPMmr/9jHCqSc+ZM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=os4RQi/qP6A1Yd6+jWgimf//G+tkBBFxN8HEQga8szTXBRol9VXdjB76Abr6dUrf3
         h160gmeHTWq/JCeg09INAqMXkNhNdknMH1BlCQu81ygIFTJpPS95bb5qQ9KZXpMndd
         zZ7q/zPR9xbY3A26SGB2UPdukPtcDzUhxfIITK/U=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E1662605FF;
        Sat,  6 Oct 2018 12:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538828209;
        bh=p9IOzPQNAolHZ6879f65g2rk6A4ZPMmr/9jHCqSc+ZM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Nz3K2MJ0/wyWdVL9m0af6fDLk3dyMDZHaIQIsfDa54kLtsy5KkhjVm8DUlonkmFgn
         IbZHIkfDYpXJ55fFaxQcVhwTAaAgWEICzVYJQ4HokxnqPmSNl+1YYTO1S2z59nw585
         cVI6y770DIfVYBGZjGqw8xbgvQN7vHjHdiMi8Y0Q=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E1662605FF
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
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
Date:   Sat, 06 Oct 2018 15:16:45 +0300
In-Reply-To: <20181004134252.GA20484@redhat.com> (Stanislaw Gruszka's message
        of "Thu, 4 Oct 2018 15:42:53 +0200")
Message-ID: <87lg7bfexe.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> On Thu, Oct 04, 2018 at 03:39:55PM +0300, Kalle Valo wrote:
>> >> Can we put the configuration file in the firmware directory?
>> >> Should we package them into binary files? Or just put the raw data.
>> >>
>> >> We can test the performance for it. After we got the result, we
>> >> will make a decision
>> >> about it. And if we decide to put them in the firmware directory,
>> >> will send a patch.
>> >> For now, I think we can just leave them in the .c.
>> >
>> > Yes, you could put the configuration files in the firmware directory.
>> > I would put them in binary form, not as text files. That way the size
>> > would be smaller, and it would not be possible to alter them,
>> > particularly if the binary file is checksummed.
>> >
>> > It would likely be OK if only the agc table was stored in this way.
>> > That would take away about half of the lines in the 8822b table file.
>> 
>> So what's the worry here? The lines of source code, binary size or what?
>> 
>>  .../net/wireless/realtek/rtw88/rtw8822b_table.c    | 20783 +++++++++++++++++++
>> 
>> Looking at the diffstat rtw8822b_table.c seems to be 20 kLOC, IMHO it's
>> not that bad as it's just data. But of course I might be missing
>> something as I haven't checked patches yet.
>
> My concern was it's plenty of redundant data, for example:
>
>         0x81C, 0xFF000003,
>         0x81C, 0xFE000003,
>         0x81C, 0xFD020003,
>         0x81C, 0xFC040003,
>         0x81C, 0xFB060003,
>         0x81C, 0xFA080003,
>         0x81C, 0xF90A0003,
>         0x81C, 0xF80C0003,
>         0x81C, 0xF70E0003,
>         0x81C, 0xF6100003,
>
> Approx 10000 lines like this, braked by lines like this
>
>         0x90000012,     0x00000000,     0x40000000,     0x00000000,
>
> in more or less regular way.
>
> Not big deal, but perhaps this could be coded in much more compact way.

Sure, making it more compact makes sense to me.

But I don't see that as a strict requirement, that could be done also
after the driver is accepted. Do note that I haven't reviewed the driver
yet so I reserve the right to change my opinion :)

-- 
Kalle Valo
