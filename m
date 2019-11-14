Return-Path: <SRS0=YOlZ=ZG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC16C43215
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Nov 2019 15:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05118206DC
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Nov 2019 15:10:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="U+nFSuPi";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LL2wZvUe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfKNPKh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Nov 2019 10:10:37 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:52984 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbfKNPKh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Nov 2019 10:10:37 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A2CF760D98; Thu, 14 Nov 2019 15:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573744236;
        bh=YVUbrLMtVvtrGTOTLrUczWAJTot2SFhAPI3K9N9nIsA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=U+nFSuPiWqmtUuMy4oVrxvGXqOiWJcJae6rAqqfyAhIMXP7ZuhJv/LIB7Md/0uD7d
         FO0i+KFhNyzKAjSnRvA6QN+GbcXQA71y92wfOCVFhKgUrh8cjzha+Io2QPde6FDErm
         lghsIkTs1yzAY5dgQDS3xHaCE2DHDp3s7JsnQwJI=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B5B3660D95;
        Thu, 14 Nov 2019 15:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573744236;
        bh=YVUbrLMtVvtrGTOTLrUczWAJTot2SFhAPI3K9N9nIsA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=LL2wZvUeWu6Ut5lQnecJLsTXylQOiINfPF3uf1JHTqinwC4tYcr7w1csUpivXwDdc
         f6orWQKvKQu/3M/kwjJWtoEuGO49Q0GObWfrvUUaSRRoZVx1LeXBY5NyOdn2JVAKrJ
         50TX028i3jGTuvZczy5BmqHh+3gYIlyluVc1CWEE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B5B3660D95
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/3] rtlwifi: rtl8192de: Fix missing code to retrieve RX
 buffer address
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191111194046.26908-2-Larry.Finger@lwfinger.net>
References: <20191111194046.26908-2-Larry.Finger@lwfinger.net>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191114151036.A2CF760D98@smtp.codeaurora.org>
Date:   Thu, 14 Nov 2019 15:10:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> In commit 38506ecefab9 ("rtlwifi: rtl_pci: Start modification for
> new drivers"), a callback to get the RX buffer address was added to
> the PCI driver. Unfortunately, driver rtl8192de was not modified
> appropriately and the code runs into a WARN_ONCE() call. The use
> of an incorrect array is also fixed.
> 
> Fixes: 38506ecefab9 ("rtlwifi: rtl_pci: Start modification for new drivers")
> Cc: Stable <stable@vger.kernel.org> # 3.18+
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

3 patches applied to wireless-drivers-next.git, thanks.

0e531cc575c4 rtlwifi: rtl8192de: Fix missing code to retrieve RX buffer address
3155db7613ed rtlwifi: rtl8192de: Fix missing callback that tests for hw release of buffer
330bb7117101 rtlwifi: rtl8192de: Fix missing enable interrupt flag

-- 
https://patchwork.kernel.org/patch/11237573/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

