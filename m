Return-Path: <SRS0=+7Bs=YY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B93A3CA9EC3
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Oct 2019 08:23:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AC1D2087F
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Oct 2019 08:23:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kEWR1UmC";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kEv0UHRD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfJaIXl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Oct 2019 04:23:41 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50970 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbfJaIXl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Oct 2019 04:23:41 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BE32D60931; Thu, 31 Oct 2019 08:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572510220;
        bh=u/tEIgMvNDj9n2naSJiDmKss+gWOoq17J1DfRPDY7iI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=kEWR1UmCA7h3olUGZsr/AfD/VJdgA0gmnQfOf/NToo00mxnLP5hjNlRK+ZXxf/otN
         UfST96QJ0qbsFhDJZ6nkihlt3b0dNelJHx/OFElVGjB3ClIJpWhAFiIyVI1+z9QWoH
         6p3FnqBrPbqoePsiH+Cb/5yV+mM1NCK2zXxzW2bs=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AC6AE60927;
        Thu, 31 Oct 2019 08:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572510219;
        bh=u/tEIgMvNDj9n2naSJiDmKss+gWOoq17J1DfRPDY7iI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=kEv0UHRD4mQJ40q0m6kQqh+KKhIl6OAFDBL0BLHyz/lYXmYWHuLknYzaIrPAFBduw
         HaRWvThQXE3wEidAy68NyGvnkO9mivGAvAKKuJB3n7nxNSGyZhUPYv34X/ZaMXlgt4
         nmhx7VwRJpcxPSzZnU4NUqwHjFdS0aUR8r7CGgAA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AC6AE60927
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wcn36xx: remove unecessary return
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191030084141.24009-1-eduardoabinader@gmail.com>
References: <20191030084141.24009-1-eduardoabinader@gmail.com>
To:     Eduardo Abinader <eduardoabinader@gmail.com>
Cc:     wcn36xx@lists.infradead.org,
        Eduardo Abinader <eduardoabinader@gmail.com>,
        linux-wireless@vger.kernel.org, kvallo@codeaurora.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191031082340.BE32D60931@smtp.codeaurora.org>
Date:   Thu, 31 Oct 2019 08:23:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Eduardo Abinader <eduardoabinader@gmail.com> wrote:

> Signed-off-by: Eduardo Abinader <eduardoabinader@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

6dea30b4fd54 wcn36xx: remove unecessary return

-- 
https://patchwork.kernel.org/patch/11219245/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

