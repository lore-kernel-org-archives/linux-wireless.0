Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0EB4C169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 08:59:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6418321473
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 08:59:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kaOL3xJA";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZO8fLUIz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfA2I72 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 03:59:28 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60824 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbfA2I72 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 03:59:28 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4D18260881; Tue, 29 Jan 2019 08:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548752367;
        bh=wlwB7aPEtGVotepRpf2RrtMcOmdzqdBC+QrXA+vu8Mk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kaOL3xJAi2AFNsO1t2n0UgDbRj1IO6ihoH0/yVGkf+TloJSEFZfYMcORg52U06Qb7
         5bdlwrJLDzeCcerarNDbmZDofKwowmVfrcOD3OZBjRkcoYy3wJdWiCthk27FR+SmwP
         OXTYhacX9Qbp1laYDrm8THQ+qsnoX3vdC861pB2k=
Received: from x230.qca.qualcomm.com (87-93-85-88.bb.dnainternet.fi [87.93.85.88])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 81A076047C;
        Tue, 29 Jan 2019 08:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548752366;
        bh=wlwB7aPEtGVotepRpf2RrtMcOmdzqdBC+QrXA+vu8Mk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ZO8fLUIz9BIkYODudILCy5CQtiwSnKKjyZDwciy+y/B6uDBvWOv+zCh4STsyKpG7q
         f5QBcWJVbZl0Kr4dBu3vjVbEaH5qIHkBDA/GNS9CkDjEu7RxquhNy9Niu0vi3fQfC3
         954WaQR7BtNFVoettNOpIoJd8ADcrfwbZYR4SSmI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 81A076047C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Tony Chuang <yhchuang@realtek.com>,
        "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>
Subject: Re: [PATCH v2 13/13] rtw88: add support for Realtek 802.11ac wireless chips
References: <1542367879-28880-1-git-send-email-yhchuang@realtek.com>
        <1542367879-28880-14-git-send-email-yhchuang@realtek.com>
        <20190122213423.GA52826@google.com>
        <F7CD281DE3E379468C6D07993EA72F84D1793553@RTITMBSVM04.realtek.com.tw>
        <CA+ASDXOWfFqZRyWbsb=WqORDvsVD+HjNmbGON9R1kOL88=aKew@mail.gmail.com>
Date:   Tue, 29 Jan 2019 10:59:22 +0200
In-Reply-To: <CA+ASDXOWfFqZRyWbsb=WqORDvsVD+HjNmbGON9R1kOL88=aKew@mail.gmail.com>
        (Brian Norris's message of "Mon, 28 Jan 2019 13:01:29 -0800")
Message-ID: <875zu7zvo5.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> writes:

> Hi,
>
> On Sun, Jan 27, 2019 at 7:36 PM Tony Chuang <yhchuang@realtek.com> wrote:
>> > -----Original Message-----
>> > From: Brian Norris [mailto:briannorris@chromium.org]
>> >
>> > On Fri, Nov 16, 2018 at 07:31:19PM +0800, yhchuang@realtek.com wrote:
>> > > diff --git a/MAINTAINERS b/MAINTAINERS
>> > > index 9ad052a..138515b 100644
>> > > --- a/MAINTAINERS
>> > > +++ b/MAINTAINERS
>> > > @@ -12546,6 +12546,14 @@ T: git
>> > git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.g
>> > >  S: Maintained
>> > >  F: drivers/net/wireless/realtek/rtlwifi/
>> > >
>> > > +REALTEK WIRELESS DRIVER (rtw88)
>> > > +M: Yan-Hsuan Chuang <yhchuang@realtek.com>
>> > > +L: linux-wireless@vger.kernel.org
>> > > +W: http://wireless.kernel.org/
>> > > +T: git
>> > git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
>> >
>> > That tree hasn't been updated in years. I expect that's not relevant, so
>> > perhaps you should remove it? I think these days, unless you have a
>> > large amount of patches that deserves its own tree / pull-request,
>> > you're probably just going to be covered by the wireless-drivers /
>> > wireless-drivers-next trees:
>> >
>> > NETWORKING DRIVERS (WIRELESS)
>> > M:      Kalle Valo <kvalo@codeaurora.org>
>> > L:      linux-wireless@vger.kernel.org
>> > Q:      http://patchwork.kernel.org/project/linux-wireless/list/
>> > T:      git
>> > git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git
>> > T:      git
>> > git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git
>>
>> OK, I can change to wireless-drivers tree and send PATCHv3.
>
> I wouldn't list wireless-drivers directly -- you don't need to list
> any tree at all, and the "NETWORKING DRIVERS (WIRELESS)" entry will
> cover you anyway.

I agree, no need to duplicate the git tree entry for every driver. The
top level "NETWORKING DRIVERS (WIRELESS)" entry should be enough.

-- 
Kalle Valo
