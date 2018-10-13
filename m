Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EC3FC28CF8
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 17:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5588320659
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 17:03:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UZPgHWY6";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EbGs9Bpb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5588320659
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbeJNAks (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 20:40:48 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38320 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbeJNAks (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 20:40:48 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D315460C62; Sat, 13 Oct 2018 17:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539450173;
        bh=wcemWQgqR2JXWaN23sJAclpbIloQsL+0RxhVlzgSBms=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=UZPgHWY6XCHU6InKnlPU5i4gDIZ4o5re63nUVfRJRdC2Ux2+u8HW3KpKojQAuEQPE
         e2Um0YIy8nxamg3HijzVnrlaEGB52JXN6dp8+LkmgNZy25A75jVGSgc038fFTxd0UR
         wb94G4kcbtezNs6n7Fi33t0m+PRJiy/VD1btT8SY=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E60FF60B72;
        Sat, 13 Oct 2018 17:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539450173;
        bh=wcemWQgqR2JXWaN23sJAclpbIloQsL+0RxhVlzgSBms=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=EbGs9BpbsRZVqVBZ/uPlzqzcCIC1xIMnAYwdrYFTW6L8ArEmx6JfjrLUkcvGMW4h3
         YPSuUczMRCsro41PgOVa7cX9K9wUZNpeIE1s7BqKxO0JhzuPY9001BTslDAlqazhFy
         w820amNA6RoEevaICuvHsgQM97UhHOPGvRon8Cng=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E60FF60B72
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iwlegacy: Add a lock assertion in il4965_send_rxon_assoc()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181005135546.21011-1-baijiaju1990@gmail.com>
References: <20181005135546.21011-1-baijiaju1990@gmail.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     sgruszka@redhat.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181013170253.D315460C62@smtp.codeaurora.org>
Date:   Sat, 13 Oct 2018 17:02:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Jia-Ju Bai <baijiaju1990@gmail.com> wrote:

> The variables il->staging.filter_flags, rxon1->filter_flags and 
> rxon2->filter_flags need to be protected by the mutex lock il->mutex.
> This patch adds a lock assertion of il->mutex to check whether 
> this lock is held.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

52a312673aff iwlegacy: Add a lock assertion in il4965_send_rxon_assoc()

-- 
https://patchwork.kernel.org/patch/10628205/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

