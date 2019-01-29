Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22812C169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 07:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF7BA214DA
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 07:59:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ox0mPvnp";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="msjNzhyF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725779AbfA2H7R (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 02:59:17 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36458 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbfA2H7Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 02:59:16 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 27A3460712; Tue, 29 Jan 2019 07:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548748755;
        bh=UDhTWCV1M56W0dFoXoQhGaCYdD+35icVnMHPhR1i6Vw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ox0mPvnp6NCE2Xw0/iWvpEIE1Evyl//CxX7G8LQIyssF0NqLiWPC0768vsvxF4uGP
         oTGZlZsnid1fG9KBwmEGCkmbhnAMbja/k0JbhB5bEgAFHDDRXXA2fpJ5Ha7vbKcEnL
         VTviehYQcIWC4WdbwlQr8bg8Sz3xXuJEpCJFl640=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2824160712;
        Tue, 29 Jan 2019 07:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548748754;
        bh=UDhTWCV1M56W0dFoXoQhGaCYdD+35icVnMHPhR1i6Vw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=msjNzhyFMfq0aj0sIpE0zrAYgli4J6XlJKY6m1X7g+hlpmGmPgxg7h3exsZPeX6XA
         1tS5Z3WrTtmPciIZ8cyZGWHcfgGyr0H8G05jgfPEMtNje18qclGRPPads0Nk0gE7wr
         VcjU8IMMySYXLqcGUsXAjRMoClJLplUTXrHogHbw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2824160712
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "briannorris\@chromium.org" <briannorris@chromium.org>,
        "sgruszka\@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 00/13] rtw88: mac80211 driver for Realtek 802.11ac wireless network chips
References: <1548654407-28469-1-git-send-email-yhchuang@realtek.com>
        <043aedf4-0ed4-e128-3cd2-242aaef128f6@lwfinger.net>
        <F7CD281DE3E379468C6D07993EA72F84D1794AAB@RTITMBSVM04.realtek.com.tw>
        <8d92c20f-a72f-6ea8-d4c8-61c3c8c9adc9@lwfinger.net>
        <F7CD281DE3E379468C6D07993EA72F84D17981EA@RTITMBSVM04.realtek.com.tw>
Date:   Tue, 29 Jan 2019 09:59:11 +0200
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D17981EA@RTITMBSVM04.realtek.com.tw>
        (Tony Chuang's message of "Tue, 29 Jan 2019 04:03:03 +0000")
Message-ID: <87lg33uc6o.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tony Chuang <yhchuang@realtek.com> writes:

>> -----Original Message-----
>> From: linux-wireless-owner@vger.kernel.org
>> [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Larry Finger
>> Sent: Tuesday, January 29, 2019 11:24 AM
>> To: Tony Chuang
>> Cc: Pkshih; Andy Huang; briannorris@chromium.org; sgruszka@redhat.com;
>> linux-wireless@vger.kernel.org
>> Subject: Re: [PATCH v3 00/13] rtw88: mac80211 driver for Realtek 802.11ac
>> wireless network chips
>> 
>> On 1/28/19 8:15 PM, Tony Chuang wrote:
>> >> Tony,
>> >>
>> >> I had not tested rtw88 for some time, so I built a kernel with the V3 patches
>> and
>> >> found that rtw88 crashed with a NULL pointer dereference. I did some
>> >> debugging and found that the problem was in routine
>> rtw_chip_efuse_enable()
>> >> where fw->firmware was NULL.
>> >>
>> >
>> > Hi Larry,
>> >
>> > This NULL pointer was found months ago and has been fixed already.
>> > Thanks for your test :).
>> > I am holding the patch to fix it for the next patchsets.
>> >
>> > BTW, since rtw88 has not been accepted, could I send next patch set based on
>> > this patch set as long as I explicitly mark that the next patch is based on the
>> previous one?
>> > Thanks!
>> 
>> You need to have that patch in whatever version is merged into the wireless
>> tree. It would not look very good for the initial version to crash every users
>> computer.
>> 
>> Yes, I would merge EVERY patch that you have pending into the source and
>> submit V4.
>
> Hi Larry,
>
> But here I am holding almost 40 patches, some of them are common major fixes.
> The rest of them are to enhance and stabilize 8822C.
>
> From the initial submit to now, 8822C has many fixes. Because we tested
> a lot for developing 8822C and we have many parameter changes for it.
> I am not sure should I merge every patch into the original patch set. We will
> have huge difference to the original patch set, means extra effort for
> review.

Yeah, it's very good that you try to keep the changes to minimum while
the driver is under review.

> But I can filter out the less important patches (will be like around 20, still many).
> How do you think?

I suggest to look at criticality of the bug and size of the patch. For
example, if the bug is a minor and the patch is large you should
definitely drop that. And smaller fixes to severe bugs you should
definitely again include them.

Just remember to list in the changelog every change you made since
previous version.

-- 
Kalle Valo
