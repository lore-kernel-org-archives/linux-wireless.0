Return-Path: <SRS0=KFxB=X2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23402C352AA
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Oct 2019 09:19:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECBBF2133F
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Oct 2019 09:19:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IQM5yFLV";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="U5cz+xpq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387418AbfJAJTJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 1 Oct 2019 05:19:09 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39574 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728748AbfJAJTI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Oct 2019 05:19:08 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6D01C6076C; Tue,  1 Oct 2019 09:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569921547;
        bh=aAWvCZYegerllMvZ/ZPMWpSmc22b+zyrwrm+VBt9azk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=IQM5yFLVVg6bnVhG3YLAMpKk3d+vgPg7Wj8vWj/ep7AtPo9FV7CLztUozmM8UHpxj
         7Ef/p+tNBOyK04AkxZg5rtpOYAH82cJq1vc39V3belywebN393RynRVsVG9jrtSThE
         BJbs2e1IigaO9mol6UlmtkoKaAyfuPwjK4AtptDI=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4157B6076C;
        Tue,  1 Oct 2019 09:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569921546;
        bh=aAWvCZYegerllMvZ/ZPMWpSmc22b+zyrwrm+VBt9azk=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=U5cz+xpqROcI8f5DTuGJByz3aIj61Uka+9PZdzKkLPBmkze5DajJYTCYJvG9RIuho
         ml6Dh7HaFo+io5nwNbu0VgKqHO8R3jy8uYRSh44brVJS6s5F5QfUOpdDNm25nO2ODx
         5Ubtx6hxAio3qz9uaVMJ/Y1U4TDBcKCl93jG9idI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4157B6076C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rsi: release skb if rsi_prepare_beacon fails
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190914000812.10188-1-navid.emamdoost@gmail.com>
References: <20190914000812.10188-1-navid.emamdoost@gmail.com>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     unlisted-recipients:; (no To-header on input) emamd001@umn.edu,
        smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)emamd001@umn.edu
                                                                     ^-missing end of address
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191001091907.6D01C6076C@smtp.codeaurora.org>
Date:   Tue,  1 Oct 2019 09:19:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Navid Emamdoost <navid.emamdoost@gmail.com> wrote:

> In rsi_send_beacon, if rsi_prepare_beacon fails the allocated skb should
> be released.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

d563131ef23c rsi: release skb if rsi_prepare_beacon fails

-- 
https://patchwork.kernel.org/patch/11145515/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

