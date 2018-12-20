Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EACAC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 06:47:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 220DB2176F
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 06:47:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CITqtLi3";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Z3MxnqCv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725793AbeLTGq4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 01:46:56 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:59400 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbeLTGq4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 01:46:56 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A2AB760854; Thu, 20 Dec 2018 06:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545288415;
        bh=1X/pIgFeX3slGqgZqeS/pjGq9L/OhawEWi4/afSEJ0I=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=CITqtLi3+iIw3LVVzJ53vp4XYpxdBeucFPGQPopKWHTbsmoLAHxrdGHk/SBKnODjV
         OlbOTp5fxmrCypGVEdNtbrapCQ2p8ztFQuIs0fAlcwSpdTodc2zTSMy30jj7KMTNcw
         fR+UBKp1hXgRhjDtNRQE7E7q1S6iEEbFxWobMW8g=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EC78A60132;
        Thu, 20 Dec 2018 06:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545288415;
        bh=1X/pIgFeX3slGqgZqeS/pjGq9L/OhawEWi4/afSEJ0I=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Z3MxnqCvhxXEPIORdKziYcyN7TUMs8H6uM5pF5v1sgMQkCLgCt0PI1hZ2wGPw8ISV
         ZimeWv/Z90XO6a6Gtpqh8Bk6db19GZtp33sLS1mKB+PQdBhLfv5FUNn/CfcjvWus0v
         upu4XFCXwa287Q9a9iZgx9Yjdt38nZdHjbB/Pc88=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EC78A60132
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] cw1200: convert to DEFINE_SHOW_ATTRIBUTE
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181203133145.12430-1-tiny.windzz@gmail.com>
References: <20181203133145.12430-1-tiny.windzz@gmail.com>
To:     Yangtao Li <tiny.windzz@gmail.com>
Cc:     pizza@shaftnet.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181220064655.A2AB760854@smtp.codeaurora.org>
Date:   Thu, 20 Dec 2018 06:46:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yangtao Li <tiny.windzz@gmail.com> wrote:

> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
> 
> Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

cc4dc97ffc69 cw1200: convert to DEFINE_SHOW_ATTRIBUTE

-- 
https://patchwork.kernel.org/patch/10709559/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

