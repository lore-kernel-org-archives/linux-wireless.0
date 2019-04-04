Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9812C10F0E
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 14:33:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E0192171F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 14:33:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="F/oEscRt";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="F/oEscRt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbfDDOdf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 10:33:35 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:54584 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbfDDOde (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 10:33:34 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EB80260790; Thu,  4 Apr 2019 14:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554388413;
        bh=EDBu7APradYeb47WtW3wHwz0R9xi7AITNLhdljWeTc8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=F/oEscRt0sThZeqF/c16EZEtcrJQmLMQcytlCNLlpk9SI0SSF5OvC0LYGGuqm+YJw
         KREhraBfI+p8nOp49fq4oAJ8Dfn+HqEBMqsKVar2D3xAYHN5YVfJHW1xLSMe5pmhIJ
         s46NOTQsjzhpcBjUOFt5IB9ZlO2UNonygiq3t6MM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C2FBD6079C;
        Thu,  4 Apr 2019 14:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554388413;
        bh=EDBu7APradYeb47WtW3wHwz0R9xi7AITNLhdljWeTc8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=F/oEscRt0sThZeqF/c16EZEtcrJQmLMQcytlCNLlpk9SI0SSF5OvC0LYGGuqm+YJw
         KREhraBfI+p8nOp49fq4oAJ8Dfn+HqEBMqsKVar2D3xAYHN5YVfJHW1xLSMe5pmhIJ
         s46NOTQsjzhpcBjUOFt5IB9ZlO2UNonygiq3t6MM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C2FBD6079C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath6kl: remove redundant check of status != 0
References: <20190404134723.24667-1-colin.king@canonical.com>
Date:   Thu, 04 Apr 2019 17:33:28 +0300
In-Reply-To: <20190404134723.24667-1-colin.king@canonical.com> (Colin King's
        message of "Thu, 4 Apr 2019 14:47:23 +0100")
Message-ID: <87sguxsuvb.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin King <colin.king@canonical.com> writes:

> From: Colin Ian King <colin.king@canonical.com>
>
> The check on status not being zero is redundant as previous code
> paths that set status to an error value break out of the while
> loop and hence status is never non-zero at the check. Remove
> this redundant code.
>
> Addresses-Coverity: ("Logically dead code")

Is the coverity id missing?

-- 
Kalle Valo
