Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34405C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F00A92081D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:14:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BQpYDF9I";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BQpYDF9I"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F00A92081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389139AbeKGBkk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 20:40:40 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51378 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387685AbeKGBkk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 20:40:40 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C6AAF60A98; Tue,  6 Nov 2018 16:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541520884;
        bh=Qw/TDs0QczVbQL/2edKOc786LuvqCkxcSFTpMawVjaQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BQpYDF9IduEA3le4hatHFx6ZAh5S4ZINDqTRsViTJRT7TKW+ynhEmPRZUjDQmmEbI
         1AnLejmzCCkiYgE1WvemgjhtVdgXZgMgdGaqDBGkPtSL+N1wDWJnPJ9UkVyDWau/U7
         SSLKItV3/0+PxENSBqOjGBePaGy7kJweTnBtOhvw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C095C60741;
        Tue,  6 Nov 2018 16:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541520884;
        bh=Qw/TDs0QczVbQL/2edKOc786LuvqCkxcSFTpMawVjaQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BQpYDF9IduEA3le4hatHFx6ZAh5S4ZINDqTRsViTJRT7TKW+ynhEmPRZUjDQmmEbI
         1AnLejmzCCkiYgE1WvemgjhtVdgXZgMgdGaqDBGkPtSL+N1wDWJnPJ9UkVyDWau/U7
         SSLKItV3/0+PxENSBqOjGBePaGy7kJweTnBtOhvw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C095C60741
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Doug Anderson <dianders@chromium.org>
Cc:     Brian Norris <briannorris@chromium.org>,
        Govind Singh <govinds@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, ath10k@lists.infradead.org
Subject: Re: [PATCH 4/4] ath10k: snoc: fix unbalanced clock error handling
References: <20181013005504.46399-1-briannorris@chromium.org>
        <20181013005504.46399-4-briannorris@chromium.org>
        <CAD=FV=XFUeyYZ-LQwYHeQH=b0kBf_wM5ZywpQDS74+_zqeDhEw@mail.gmail.com>
Date:   Tue, 06 Nov 2018 18:14:40 +0200
In-Reply-To: <CAD=FV=XFUeyYZ-LQwYHeQH=b0kBf_wM5ZywpQDS74+_zqeDhEw@mail.gmail.com>
        (Doug Anderson's message of "Tue, 16 Oct 2018 16:53:52 -0700")
Message-ID: <87wopqb2tr.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Doug Anderson <dianders@chromium.org> writes:

> Hi,
> On Fri, Oct 12, 2018 at 5:55 PM Brian Norris <briannorris@chromium.org> wrote:
>>
>> Similar to regulator error handling, we should only start tearing down
>> the 'i - 1' clock when clock 'i' fails to enable. Otherwise, we might
>> end up with an unbalanced clock, where we never successfully enabled the
>> clock, but we try to disable it anyway.
>>
>> Signed-off-by: Brian Norris <briannorris@chromium.org>
>
> Presumably you could have a Fixes tag just to help folks, like:
>
> Fixes: a6a793f98786 ("ath10k: vote for hardware resources for WCN3990")

Thanks, I added that in the pending branch.

-- 
Kalle Valo
