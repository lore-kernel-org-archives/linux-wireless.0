Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BA9FC433E9
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Mar 2021 08:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A62464EB1
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Mar 2021 08:24:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhCOIXz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Mar 2021 04:23:55 -0400
Received: from z11.mailgun.us ([104.130.96.11]:61193 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229924AbhCOIXv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Mar 2021 04:23:51 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1615796631; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=egW71XUo1KXjfG19RKKEjftCPONENS0wYUPLTYAUT6o=;
 b=M+Dug7OSpeVPwnhkdrQvWcCD9GHH6KU+2bqhMm6Ji3wabEqyM0FTSseGa2EPiX23pWDl4VKn
 x3IdrMPRQrpF6B+jZiPNvNj8hHZKbWuGJDx1eTQgD/afTdOAF0ByOJClU764dSrb70znuDSM
 8DWoChIvS+NWSnZzE7qyRdqiiQA=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 604f198d5d70193f885a1637 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 15 Mar 2021 08:23:41
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AF50BC433ED; Mon, 15 Mar 2021 08:23:41 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3250BC433C6;
        Mon, 15 Mar 2021 08:23:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3250BC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtw88: remove unnecessary variable
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210223075438.13676-1-samirweng1979@163.com>
References: <20210223075438.13676-1-samirweng1979@163.com>
To:     samirweng1979 <samirweng1979@163.com>
Cc:     tony0620emma@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        inux-kernel@vger.kernel.org, wengjianfeng <wengjianfeng@yulong.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210315082341.AF50BC433ED@smtp.codeaurora.org>
Date:   Mon, 15 Mar 2021 08:23:41 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

samirweng1979 <samirweng1979@163.com> wrote:

> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> The variable ret is defined at the beginning and initialized
> to 0 until the function returns ret, and the variable ret is
> not reassigned.Therefore, we do not need to define the variable
> ret, just return 0 directly at the end of the function.
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>

Patch applied to wireless-drivers-next.git, thanks.

4a7ea94377c9 rtw88: remove unnecessary variable

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210223075438.13676-1-samirweng1979@163.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

