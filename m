Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A34C10F0C
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B72AD205F4
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:13:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="f0NajSm7";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Jq+fGbZa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbfDDKNl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 06:13:41 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37944 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbfDDKNl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 06:13:41 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 09A9461836; Thu,  4 Apr 2019 10:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554372820;
        bh=J+Ymf1zOe05e/G0Pq7gWzdmC0ObjXqE6ys1W0FRBdx0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=f0NajSm77o0m89Ns8gVAVgCDDDHxbh17fLVjzmR2XylNEH5923FihbC/tGweHBQ23
         AdqfhFwGiCrTtCwaDRsTYdrbW57tT5J/tkPJ7/OzgCW4S3wkH7ymLKIEMnt8/yyynq
         PFu5XqdwMlwr0uR9uO9wYSsqrUi/eziN9uu2j4Ew=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5C01161A41;
        Thu,  4 Apr 2019 10:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554372817;
        bh=J+Ymf1zOe05e/G0Pq7gWzdmC0ObjXqE6ys1W0FRBdx0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Jq+fGbZa5xx806/nzl6cC/IZWT7ZzfCo9M3iuOVfMWID8Qvke3455JBGklWMuo0oQ
         s2gw7/4cnKAvw3FhtDoYbfjd80dBDW7pQtTcLrnR9Ay31tSZIxBkJ0BQTVJEU4EMz+
         M+AbUlHpuPDoZ5S72WNNl2onYev0vbuptAGyv/L0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5C01161A41
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3] brcmfmac: fix missing checks for kmemdup
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190315170433.3845-1-kjlu@umn.edu>
References: <20190315170433.3845-1-kjlu@umn.edu>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     kjlu@umn.edu, pakki001@umn.edu,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190404101340.09A9461836@smtp.codeaurora.org>
Date:   Thu,  4 Apr 2019 10:13:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kangjie Lu <kjlu@umn.edu> wrote:

> In case kmemdup fails, the fix sets conn_info->req_ie_len and
> conn_info->resp_ie_len to zero to avoid buffer overflows.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

46953f97224d brcmfmac: fix missing checks for kmemdup

-- 
https://patchwork.kernel.org/patch/10855341/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

