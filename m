Return-Path: <SRS0=1RAM=ZH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B7EC432C3
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Nov 2019 12:23:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CFF72077B
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Nov 2019 12:23:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MWzTZSL/";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hHZ7m/i1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbfKOMXu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Nov 2019 07:23:50 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:50198 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727196AbfKOMXu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Nov 2019 07:23:50 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 439066030B; Fri, 15 Nov 2019 12:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573820629;
        bh=zlrsOC4YMkhoyHD3AJ1C/pqGVEdLkHAYuaZ6lyMe+k0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=MWzTZSL/2sofRrOmxQB2lZGH9vkPEb/0jjIk9gxZubS/dbtrZDm3n4TvlgIsVgGf8
         fk0WfnfIz86Jz0XOyh1Y5UAEciZLqONOOSPZG0VIo7Yr9KryhBX4sysMehwcHSYJmD
         D19jZOuDzrqxFlwdS08bNqpj+jMEa7Ka3s+0xxUw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B57196106C;
        Fri, 15 Nov 2019 12:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573820628;
        bh=zlrsOC4YMkhoyHD3AJ1C/pqGVEdLkHAYuaZ6lyMe+k0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=hHZ7m/i155o0iUArXvz7Z3MdYs/p3y9I+e9S7SWXmw1YyFGCAK8cH63ggtnCmlQUZ
         DU12V3vAYdBxGnR6aRoMG1ehTHRZYb35yLSth1hCH+T3WJTWzGGL+YBofDnk+OgkKl
         oVuxHmQyAbS7K3DmejKbYglL22BPM6gKeMjZPN0I=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B57196106C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmsmac: remove unnecessary return
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191107160746.1535-1-eduardoabinader@gmail.com>
References: <20191107160746.1535-1-eduardoabinader@gmail.com>
To:     Eduardo Abinader <eduardoabinader@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        Eduardo Abinader <eduardoabinader@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191115122349.439066030B@smtp.codeaurora.org>
Date:   Fri, 15 Nov 2019 12:23:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Eduardo Abinader <eduardoabinader@gmail.com> wrote:

> Signed-off-by: Eduardo Abinader <eduardoabinader@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

92fe0f81b64b brcmsmac: remove unnecessary return

-- 
https://patchwork.kernel.org/patch/11233281/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

