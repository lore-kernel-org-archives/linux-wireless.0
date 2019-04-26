Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D851C43218
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 11:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6392A2077B
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 11:48:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Wh8pTGqG";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="X9Mw9qKv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfDZLsZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 07:48:25 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39824 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfDZLsZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 07:48:25 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B271C602F5; Fri, 26 Apr 2019 11:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556279304;
        bh=Ia+qyd1p/dm3siwNvOR5GJAP1AbDYXYSBoLy8ZLjeA8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Wh8pTGqGus87lEh3Ftt5Tyzu7L5cALFv39Ur/RNWvZmIGy53O8o2+sE1YEi2fIbcp
         v7YKPQKUW2K7GdVxgM6BWu0sAZyF3mH3GuvON7TuCA04M7Qe/Uqd4vezVASN+s3L4l
         9q0YC9aLZrOIZZmdPewc3vKiBSjoHSthhbqus4NQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C5FAA6028C;
        Fri, 26 Apr 2019 11:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556279304;
        bh=Ia+qyd1p/dm3siwNvOR5GJAP1AbDYXYSBoLy8ZLjeA8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=X9Mw9qKvzgG7xQ9h3DgSuc1NTf8LezvU1ofeCGRnRTaUiXQkISn3/za3SYOx5nV69
         SUFprjNm1MabV4EENKL/bdjW+LOv/gVgQpOA8nljzAmUg0I38tKBcdi7Z1xtmvLGfe
         9vOrW0EwL/4eUTuGHwcZ9rye2PMDQPoohXSBQD94=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C5FAA6028C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] net: wireless: fix missing checks for ioremap
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190311075440.1513-1-kjlu@umn.edu>
References: <20190311075440.1513-1-kjlu@umn.edu>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     kjlu@umn.edu, pakki001@umn.edu,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190426114824.B271C602F5@smtp.codeaurora.org>
Date:   Fri, 26 Apr 2019 11:48:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kangjie Lu <kjlu@umn.edu> wrote:

> ioremap could fail and returns NULL. The fix actively checks
> its return value and handles potential failures.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>

The prefix should be "ray_cs: ":

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_title_is_wrong

Also I don't see the point of setting the ret variable as it's ignored in the failed label:

failed:
	ray_release(link);
	return -ENODEV;

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/10846851/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

