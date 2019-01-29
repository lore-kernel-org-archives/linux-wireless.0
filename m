Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E49DAC169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 07:54:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1C88207E0
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 07:54:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="a4T7HM8A";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dNp5JN//"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfA2HyE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 02:54:04 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34554 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbfA2HyE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 02:54:04 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9C2D660881; Tue, 29 Jan 2019 07:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548748443;
        bh=QN97siznLjLSUhf4NPqNP5G4LIVHO7+1sYdg1z0n3IY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=a4T7HM8A914FB1JUZiLpXjuzEv2bavfpNlo9nkRsvxN+yI31UvYGm8eHqsRjAzyTN
         wSI1Aqa7TlS8HzJwdronYYni7DSr3NOTI1K9WgLZFQCxMWrNH5mqJBTxdULrFtwTzB
         TZ5M68RxBVlyc6yBscK4hzjhKVUQmgJ3/ifQg51s=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7CA9F60314;
        Tue, 29 Jan 2019 07:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548748442;
        bh=QN97siznLjLSUhf4NPqNP5G4LIVHO7+1sYdg1z0n3IY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=dNp5JN//18qbKQYtMJoDC5VrX6/XdAzqaMxI4hftA9uFMFtERBE/SbfAPIatVzjg1
         H3YaGMkSFgQUH7fC6CeUAMboOLYM3O1f+Ke+eC4koCbT6Ii7Gc9WDn9lMHfbDT6Syj
         eNTga3SA23Y5JPNoouOR5wIQNTqL6TteQlRYy5iY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7CA9F60314
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Tony Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "sgruszka\@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 00/13] rtw88: mac80211 driver for Realtek 802.11ac wireless network chips
References: <1548654407-28469-1-git-send-email-yhchuang@realtek.com>
        <043aedf4-0ed4-e128-3cd2-242aaef128f6@lwfinger.net>
        <F7CD281DE3E379468C6D07993EA72F84D1794AAB@RTITMBSVM04.realtek.com.tw>
        <CA+ASDXM=+_U+SrXhm3pq4Zd7gkvHwkRAZw+OGmzg=6+0+=iZGg@mail.gmail.com>
Date:   Tue, 29 Jan 2019 09:53:58 +0200
In-Reply-To: <CA+ASDXM=+_U+SrXhm3pq4Zd7gkvHwkRAZw+OGmzg=6+0+=iZGg@mail.gmail.com>
        (Brian Norris's message of "Mon, 28 Jan 2019 18:41:06 -0800")
Message-ID: <87pnsfucfd.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> writes:

> On Mon, Jan 28, 2019 at 6:15 PM Tony Chuang <yhchuang@realtek.com> wrote:
>> This NULL pointer was found months ago and has been fixed already.
>> Thanks for your test :).
>> I am holding the patch to fix it for the next patchsets.
>>
>> BTW, since rtw88 has not been accepted, could I send next patch set based on
>> this patch set as long as I explicitly mark that the next patch is based on the previous one?
>
> I'd normally expect that if you find major bugs in your initial driver
> submission that still isn't reviewed/merged, you might as well just
> roll the fix into latest version and describe it in the
> cover-letter/changelog. This particular change is so trivial it
> doesn't really seem to deserve a separate patch.
>
> (It would also help people like me, who may very well run into the
> same bug when they get around to testing/reviewing the driver.)
>
> I also don't know what the contents of the "next patch set" is -- if
> it's a lot of new features, maybe they don't deserve to clutter the
> initial submission, but if they're bugfixes like this, it seems like
> you could just fix the original patch set.

This is what I suggest as well. Don't add new features or any other
large changes while the driver is under review, instead keep them in a
separate branch etc. But bugfixes are ok.

-- 
Kalle Valo
