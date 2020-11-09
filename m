Return-Path: <SRS0=1s3v=EP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2100C2D0A3
	for <linux-wireless@archiver.kernel.org>; Mon,  9 Nov 2020 11:14:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A51B2084C
	for <linux-wireless@archiver.kernel.org>; Mon,  9 Nov 2020 11:14:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="LNcPuCgA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgKILOS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 9 Nov 2020 06:14:18 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:10818 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727077AbgKILOS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Nov 2020 06:14:18 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604920457; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=VH21nwiQ8tnv5u2HGvF1xrVM+BB35X6LD6gK/LAbbA8=; b=LNcPuCgAqv0zjWLd3U0U5jLTaJofPmI10g7jM0vgEPhxG4MxuEX1LzfxYGTxG/nHaKpxGN06
 ZKJCKp7maUJJcwNZD/7Vmzsy5fxYyIR4hSCO07n0mbGP9GFpDnrY/GhYEXSuDWYiUANstZ6d
 P64NwgaUgaOELsCTcmjd0zk6bd4=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5fa924550fe4be3f4371a746 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 09 Nov 2020 11:13:25
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 39266C433C8; Mon,  9 Nov 2020 11:13:25 +0000 (UTC)
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1D22EC433CB;
        Mon,  9 Nov 2020 11:13:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1D22EC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/8] wireless: remove WDS mode
References: <20201109095747.113720-1-johannes@sipsolutions.net>
Date:   Mon, 09 Nov 2020 13:13:22 +0200
In-Reply-To: <20201109095747.113720-1-johannes@sipsolutions.net> (Johannes
        Berg's message of "Mon, 9 Nov 2020 10:57:39 +0100")
Message-ID: <87h7py6awd.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> We use 4-addr AP/client instead. Remove WDS code that was
> basically not possible to enable anyway.

If you take the driver patches to your tree:

Acked-by: Kalle Valo <kvalo@codeaurora.org>

But just let me know if I should take the driver patches instead.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
