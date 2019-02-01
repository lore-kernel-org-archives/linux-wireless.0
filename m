Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFC76C282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:32:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91CC82082C
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:32:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HPYHepVh";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QnGfQzzC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbfBAMcr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 07:32:47 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:46338 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728355AbfBAMcr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 07:32:47 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 069986099A; Fri,  1 Feb 2019 12:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549024366;
        bh=jFVvKbdMYZeEtvsBR0DpC/noBONZJbodBcfMljrdn1Q=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=HPYHepVhFTJ5ydHM7mWe+Ku5kEsFW03tkpI8eugCt1pe1pabgSz6IgxU+JtwUh6yv
         i9zX7NyrdOiIx66OIoqeGRMGVN+7tP6tLXLLvKq6FZxRoryIweQGoRf3aA7IFXMo06
         sn3tnV0lRaUl0FSFsYnmSvn6m8WKs+ag/Ra7df+E=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0F2E860A0A;
        Fri,  1 Feb 2019 12:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549024359;
        bh=jFVvKbdMYZeEtvsBR0DpC/noBONZJbodBcfMljrdn1Q=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=QnGfQzzCF5FcA5FZB4wn7qAw1+DF9JRb3jFfK7Ap4k3A8oZ2czjYt20NN/7MHygsc
         Kn6Los1RHOfAXfZ+gsG7Awk11W6wfUKrSDyRNTLiTMeYaXCAtwPFrjwdbt3s7DL9hb
         k0vVAMyoQuOmFOLcKEzUdynnT8kQTIDzG2RFaZ/M=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0F2E860A0A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wl18xx: no need to check return value of debugfs_create
 functions
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190122152151.16139-28-gregkh@linuxfoundation.org>
References: <20190122152151.16139-28-gregkh@linuxfoundation.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tony Lindgren <tony@atomide.com>,
        linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190201123246.069986099A@smtp.codeaurora.org>
Date:   Fri,  1 Feb 2019 12:32:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: linux-wireless@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: Tony Lindgren <tony@atomide.com>

Patch applied to wireless-drivers-next.git, thanks.

c922a3a02d2b wl18xx: no need to check return value of debugfs_create functions

-- 
https://patchwork.kernel.org/patch/10775787/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

