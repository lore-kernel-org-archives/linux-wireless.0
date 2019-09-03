Return-Path: <SRS0=FCSK=W6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39F90C3A5A2
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 12:53:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E4D522DBF
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 12:53:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SwVQwCIw";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="faYBO9Mq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbfICMxZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Sep 2019 08:53:25 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53404 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729102AbfICMxZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Sep 2019 08:53:25 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4CDC76085C; Tue,  3 Sep 2019 12:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567515204;
        bh=Uc8EO9MaUKR2jlzWfo/S9YafzG8RbBj7EFhoroGAOSw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=SwVQwCIwUkKWCPzAWaXySMV1SyEx9Lo646QdnqzFQQjKzHx5Fgd6UwpW/+xdR8PgY
         E5CJea3q4aQqPxaq1epX9hCMLpoHek0Mv85afZ5BOHeBf9NfwYnmWWmPHWmf+JbzIh
         CN+0tfmniiXk85IMKpPmLiKAKUwgIt2xzkj6cuLA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B979460592;
        Tue,  3 Sep 2019 12:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567515203;
        bh=Uc8EO9MaUKR2jlzWfo/S9YafzG8RbBj7EFhoroGAOSw=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=faYBO9MqL9PmrrWX85GbDG0A63UigOhJeQRqunm4WYSSSzMuJBeBDpoqGFB+S2IyE
         PJMHUr+5HnciWm3X08BaV9hj4DFXqb9R0nzL0ehOdR7JhtEdZxOpQmQ6sf/fK6p4W7
         6rYtBsBcXkDWJYrnnpZ07NCCPSqI/s4hbOKntCr4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B979460592
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 4/8] rtw88: 8822c: add FW IQK support
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1565174405-2689-5-git-send-email-yhchuang@realtek.com>
References: <1565174405-2689-5-git-send-email-yhchuang@realtek.com>
To:     <yhchuang@realtek.com>
Cc:     <linux-wireless@vger.kernel.org>, <briannorris@chromium.org>,
        <sgruszka@redhat.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190903125324.4CDC76085C@smtp.codeaurora.org>
Date:   Tue,  3 Sep 2019 12:53:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<yhchuang@realtek.com> wrote:

> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> Add support for doing IQK in firmware
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>

The commit log does not answer "Why?". What is IQK and how does it help?

No need to resend, I can update the commit log but just let me know what to
add.

-- 
https://patchwork.kernel.org/patch/11081851/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

