Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF605C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 17:01:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B70282081D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 17:01:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XDbGgEJ9";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NkMSpeMe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B70282081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389561AbeKGC1Y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 21:27:24 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58478 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389285AbeKGC1Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 21:27:24 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EDDF4602F4; Tue,  6 Nov 2018 17:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523675;
        bh=9r5whNvsAbqsSZ9VC6D6JAO+9n/RAJcAlD8Awj7ZO5Q=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=XDbGgEJ9Pwpldx7XPLG/fbk7nWId00DBfBImKBbubGnqXNnHNxvFEBfk5Za698b2V
         seXpviH/tlrRJaU0dKgH9/j79Xqojuf5x0o8kSvAsc+92JW1ngx7TkEXp4k/ChiYVI
         pxFRwGV8rf7SowPOCRt3AoCeDM0Ea9LZ6fKGHu40=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 35ABF601D7;
        Tue,  6 Nov 2018 17:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523675;
        bh=9r5whNvsAbqsSZ9VC6D6JAO+9n/RAJcAlD8Awj7ZO5Q=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=NkMSpeMe5nYGtDUp3jo6pWGCTYekUorNMqNJsCzTZf4blH9m0yQir+hNaerX4nI/5
         Y8cxllMEyxxr9ukTRtSX+Qqra03GvIoKQlOYWWUXrj/xvNLdwG8DbdLrfPB0aq+bPp
         zlloEWFg9KpKcsQGwzr2oRjdpIj52yMeYkzLpHo0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 35ABF601D7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmsmac: never log "tid x is not agg'able" by default
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181023161235.18143-1-alimjalnasrawy@gmail.com>
References: <20181023161235.18143-1-alimjalnasrawy@gmail.com>
To:     Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181106170115.EDDF4602F4@smtp.codeaurora.org>
Date:   Tue,  6 Nov 2018 17:01:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com> wrote:

> This message greatly spams the log under heavy Tx of frames with BK access
> class which is especially true when operating as AP. It is also not informative
> as the "agg'ablity" of TIDs are set once and never change.
> Fix this by logging only in debug mode.
> 
> Signed-off-by: Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

96fca788e578 brcmsmac: never log "tid x is not agg'able" by default

-- 
https://patchwork.kernel.org/patch/10653373/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

