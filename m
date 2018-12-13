Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D36A1C65BAE
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 09:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 966F72080F
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 09:40:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nclmCR3s";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TAlAOoTk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 966F72080F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbeLMJkh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 04:40:37 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:56632 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbeLMJkh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 04:40:37 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 63D66612F8; Thu, 13 Dec 2018 09:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544694036;
        bh=meEfZp2b5o3wU8Lv+r0rNgwPyDzWeJB/QElz1WPqK0A=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=nclmCR3sFrK9cHaiVK9dwA6bAZbI0JaRy9F+E6GrqiG2jq5PmObMKDKqRyWKOGThY
         YQwEZtwgR9+cIY3U5VqfvdVGVSE/mZLg9hLiX+0wPEiOq7xorZ0HFOKWYtycq4phZD
         tUOtn8wAu6CW11uD9/d5EyzC4w/NHTEurQIVDakA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EB33F612E3;
        Thu, 13 Dec 2018 09:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544694035;
        bh=meEfZp2b5o3wU8Lv+r0rNgwPyDzWeJB/QElz1WPqK0A=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=TAlAOoTkgQ8iK7Xhf4xr8HgveYmyj+E5hfTiSjliIfLigea+tIzIXjJUdPeFPAZAz
         yjjwEeIGJcBXbVnTqIDeAupRlVrGn4mm9VsuO63/gwrYwlQiFyOj1uZ3Gflt+xIP4E
         wP4+QUOOwyBY4xjb4ezJpYYNyphoz8OA4LtsqAL0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EB33F612E3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Critical fix for rtlwifi
References: <e419ff31-d9fe-feed-9f40-4a7d4b82a44e@lwfinger.net>
Date:   Thu, 13 Dec 2018 11:40:32 +0200
In-Reply-To: <e419ff31-d9fe-feed-9f40-4a7d4b82a44e@lwfinger.net> (Larry
        Finger's message of "Wed, 12 Dec 2018 11:55:36 -0600")
Message-ID: <87k1kdzrvz.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On November 18th, I submitted a patch entitles "[PATCH 4.20] rtlwifi:
> Fix leak of skb when processing C2H_BT_INFO" that fixes an skb memory
> leak.

So this is the patch:

https://patchwork.kernel.org/patch/10687671/

> I just checked, and this one-line patch is still sitting in patchwork
> with a status of "NEW". Why is this the case?

I just have been busy with other stuff and haven't had enough free time
to process patches.

> The reports and testing of the fix took place in a GitHub issue
> thread, but that should not keep a critical fix from being handled
> fairly quickly. Meanwhile users of unpatched kernels are having their
> systems run out of memory! This problem is present in kernels 4.18+!

Sure, I understand that. I'll try to apply the patch soon.

-- 
Kalle Valo
