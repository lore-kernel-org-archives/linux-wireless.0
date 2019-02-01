Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45823C282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:41:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C40620863
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:41:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JdfNsE1t";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RsIjxKP9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbfBAMli (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 07:41:38 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58590 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727356AbfBAMlh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 07:41:37 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 05E7860721; Fri,  1 Feb 2019 12:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549024897;
        bh=m08NcHMNA4Vlt1HOj4LTXH8eifF9gQnIlFp16ZccBLg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=JdfNsE1tPjc9GtibatMQA23F3OZoEftePmYSXJieO5RIV/IUnp51q6KBN6DVV6J7i
         PuVdnBmSGYDv6erVKW0svwsJrT7i2yJIHg0rGiOIgkMOHJPSnsXs6dNk0LdVt/0p/2
         iH8RxLymFg9BHhbE/Ffbq+V9hKCp/pS5w58JWVGE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AAF256043F;
        Fri,  1 Feb 2019 12:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549024896;
        bh=m08NcHMNA4Vlt1HOj4LTXH8eifF9gQnIlFp16ZccBLg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=RsIjxKP9mFgXyyGI5+EIs52ETbifq1vvqLO/zskUD/WEWarmhhB5pL6aet9Cz7vk2
         /AhPcd2Kij2/sdtDxyaqtyxlUaPlnyPzTvmnCGN37ryC5czt3AlZuI42zMHzCUWAl9
         Zil1puHFTzkypHjgttwtRlF/gQ9pF7Upi3nbVzeA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AAF256043F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mt7601u: do not use WARN_ON in the datapath
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <ea874df744d188833cf8c38261b509ef246f3d5d.1548171270.git.lorenzo.bianconi@redhat.com>
References: <ea874df744d188833cf8c38261b509ef246f3d5d.1548171270.git.lorenzo.bianconi@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     kubakici@wp.pl, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190201124137.05E7860721@smtp.codeaurora.org>
Date:   Fri,  1 Feb 2019 12:41:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Substitute WARN_ON with WARN_ON_ONCE in mt7601u_rx_next_seg_len
> routine
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Acked-by: Jakub Kicinski <kubakici@wp.pl>

Patch applied to wireless-drivers-next.git, thanks.

b6958ad021c1 mt7601u: do not use WARN_ON in the datapath

-- 
https://patchwork.kernel.org/patch/10775829/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

