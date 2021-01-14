Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E810C433E0
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Jan 2021 17:34:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 522D523B3E
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Jan 2021 17:34:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbhANReo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Jan 2021 12:34:44 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:49290 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727199AbhANReo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jan 2021 12:34:44 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610645660; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=GtUs3vD5WtQrcB4HH5ci1wwROvfSxKF9pU453lfoDUU=;
 b=TycuG3TbfUhMzlg75JfCSo0yQbDrV3MCZIpQDuxUPHgM0jMdQsf9qoej7YuMtqh9OrN3gsc9
 iJyA/8XKQqVKbeZj0m4r3SYHvaUwc3w9xWVb/c/If2jREPeOwvjS4mnk6CEy1qKVN7X1mvY9
 mdBN7o3Szw7cvkqkCwiTsdzI3Rg=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 60008094d84bad3547b92d1d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 14 Jan 2021 17:34:12
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 571DBC433ED; Thu, 14 Jan 2021 17:34:12 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 79A40C433CA;
        Thu, 14 Jan 2021 17:34:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 79A40C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wlcore: Downgrade exceeded max RX BA sessions to debug
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210101065955.63386-1-tony@atomide.com>
References: <20210101065955.63386-1-tony@atomide.com>
To:     Tony Lindgren <tony@atomide.com>
Cc:     Eyal Reizer <eyalr@ti.com>, Guy Mishol <guym@ti.com>,
        Raz Bouganim <r-bouganim@ti.com>,
        linux-wireless@vger.kernel.org, linux-omap@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210114173412.571DBC433ED@smtp.codeaurora.org>
Date:   Thu, 14 Jan 2021 17:34:12 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tony Lindgren <tony@atomide.com> wrote:

> We can get the following in the logs every few minutes or so:
> 
> wlcore: ERROR exceeded max RX BA sessions
> 
> Let's downgrade the message to a debug message as suggested by the TI
> support folks at:
> 
> https://e2e.ti.com/support/wireless-connectivity/wifi/f/968/p/352435/1244754
> 
> "The WL127x firmware supports max of 3 BA sessions. It cannot be increased.
>  I think the problem here is the peer trying to initiate a 4th BA session
>  (ADDBA request)."
> 
> Signed-off-by: Tony Lindgren <tony@atomide.com>

Patch applied to wireless-drivers-next.git, thanks.

07ceefa3012f wlcore: Downgrade exceeded max RX BA sessions to debug

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210101065955.63386-1-tony@atomide.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

