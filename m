Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 052FBC4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFB4620882
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:25:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UZLqYGkp";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CqIeYaFy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729258AbfDDKZN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 06:25:13 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:44994 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfDDKZM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 06:25:12 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id ADBB861344; Thu,  4 Apr 2019 10:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554373511;
        bh=+kjDBZ69muzvXn1wtYlYw7mbI3XqyjhSb6umEv7mhKE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=UZLqYGkpgq/1TbyUUiFxaSmpenh4gzJwgfzngVS6RxDgqdigEHEkHWi3GdUSRyUPS
         OP36G+p+xPqDVjyRYaYBL40pm0SvFeIazHsLh6ZHI5I0jtqBCoF0QnPH5t8ZmP5Ple
         /kUTmAk+tbJ9XgB4xw+AKQz7g9ihNTM7XoqodHaY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 826916141C;
        Thu,  4 Apr 2019 10:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554373510;
        bh=+kjDBZ69muzvXn1wtYlYw7mbI3XqyjhSb6umEv7mhKE=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=CqIeYaFyTfP3npvBHq7HQJF2Auk1irCyjkS6sBRFbq42B2VmxgIIELTRLnBpzxrhF
         5wfP4CEHEqFi4GkfUeYTUfO7pDyKIzfVSmgAyGgIyyRaO7oQmP1TrlVaeni/vAzC5g
         nE0nG1GUwnnb63AFVR8vLiCJ0xifKh5Tar4GLX8c=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 826916141C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: fix a potential NULL pointer dereference
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190312075633.573-1-kjlu@umn.edu>
References: <20190312075633.573-1-kjlu@umn.edu>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     kjlu@umn.edu, pakki001@umn.edu, Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190404102511.ADBB861344@smtp.codeaurora.org>
Date:   Thu,  4 Apr 2019 10:25:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kangjie Lu <kjlu@umn.edu> wrote:

> In case alloc_workqueue fails, the fix reports the error and
> returns to avoid NULL pointer dereference.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>

Patch applied to wireless-drivers-next.git, thanks.

765976285a8c rtlwifi: fix a potential NULL pointer dereference

-- 
https://patchwork.kernel.org/patch/10848697/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

