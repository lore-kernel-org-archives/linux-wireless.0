Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2EFC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 13:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12BA1214C6
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 13:29:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UZLj0cNZ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lgal3F/0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbfAJN3v (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 08:29:51 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:56100 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728888AbfAJN3u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 08:29:50 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1AAB96038E; Thu, 10 Jan 2019 13:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547126990;
        bh=iuk39SxciM8KqGRl45x4b28ujBRhmHv4iwfNBoUqMlY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=UZLj0cNZtOLJhEtscY9Epwes3yKPu+hVDE6DHJnFsYFRLnmWgTe+QFsy0Vj9fMjz1
         uiO6xZ7YUPYmwmXrGI3NRgfPa7QABztc7JzLgQV9zhEtawIEb2k3LUV3raP4heaslG
         Rr7s20YMRgYaqk69jnme1U8kixD54dXrWjcNSYkc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 408D860300;
        Thu, 10 Jan 2019 13:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547126989;
        bh=iuk39SxciM8KqGRl45x4b28ujBRhmHv4iwfNBoUqMlY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=lgal3F/0DaXjRA/sVPBcC4gip2ovnbiTl2urvGGcFM6R8phQvXojyt5WWpr6LlHYw
         OnVtfiMN44HnAe633OZIwDQfilGcURS0n/WvRUKOSYn2/dKZQWenlugjSielMyRah6
         rHsy0eUqNdlQTmDUD+4YCtoU4vWCY3zCnM0mxBng=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 408D860300
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wireless: ath: return error code upstream
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181226064328.75897-1-kjlu@umn.edu>
References: <20181226064328.75897-1-kjlu@umn.edu>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     kjlu@umn.edu, pakki001@umn.edu,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190110132950.1AAB96038E@smtp.codeaurora.org>
Date:   Thu, 10 Jan 2019 13:29:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kangjie Lu <kjlu@umn.edu> wrote:

> ath6kl_wmi_cmd_send could fail, so let's return its error code upstream.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

fc6a6521556c ath6kl: return error code in ath6kl_wmi_set_roam_lrssi_cmd()

-- 
https://patchwork.kernel.org/patch/10742845/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

