Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A1DC04EBF
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 13:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F7A32082F
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 13:38:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BQs73AUM";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BQs73AUM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F7A32082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbeLCNjL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 08:39:11 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36042 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbeLCNjL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 08:39:11 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A9C7C61340; Mon,  3 Dec 2018 13:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543844287;
        bh=PKS1LP40/p8Tv1/zmqrc1SR1+sYb0RMGOS9eayHP3yA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BQs73AUMMt3O3QNJs0zyd/SFNxiTMww8Qy1fH7P3UA5lC5D4ZyYiaZGzVMHAHkl2R
         rZ6aH+rjyN53op/v7tPLS4kBhb3X+wcY/43bSX+gDkskUQ0zNrvyyDqliTepmRbBPO
         P0htGz+X9+kCIjdViKg2RO/QkGSwZ6dZ74vXED/s=
Received: from x230.qca.qualcomm.com (37-33-92-201.bb.dnainternet.fi [37.33.92.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DA71061343;
        Mon,  3 Dec 2018 13:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543844287;
        bh=PKS1LP40/p8Tv1/zmqrc1SR1+sYb0RMGOS9eayHP3yA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BQs73AUMMt3O3QNJs0zyd/SFNxiTMww8Qy1fH7P3UA5lC5D4ZyYiaZGzVMHAHkl2R
         rZ6aH+rjyN53op/v7tPLS4kBhb3X+wcY/43bSX+gDkskUQ0zNrvyyDqliTepmRbBPO
         P0htGz+X9+kCIjdViKg2RO/QkGSwZ6dZ74vXED/s=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DA71061343
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Yangtao Li <tiny.windzz@gmail.com>
Cc:     pizza@shaftnet.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless/cw1200: convert to DEFINE_SHOW_ATTRIBUTE
References: <20181203133145.12430-1-tiny.windzz@gmail.com>
Date:   Mon, 03 Dec 2018 15:38:03 +0200
In-Reply-To: <20181203133145.12430-1-tiny.windzz@gmail.com> (Yangtao Li's
        message of "Mon, 3 Dec 2018 08:31:45 -0500")
Message-ID: <87zhtmenno.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yangtao Li <tiny.windzz@gmail.com> writes:

> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
>
> Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>

The prefix should be "cw1200:", I can fix that.

-- 
Kalle Valo
