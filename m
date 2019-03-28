Return-Path: <SRS0=yxJm=R7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F50CC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Mar 2019 13:15:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 169B921773
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Mar 2019 13:15:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jr9WtKYO";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OmvGMf3n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfC1NPM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Mar 2019 09:15:12 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37594 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbfC1NPM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Mar 2019 09:15:12 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 60EB16053B; Thu, 28 Mar 2019 13:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553778911;
        bh=5yYHoa5diDPq+jk4/Rj4SArx5h6lrKs3dOyamli4b9U=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=jr9WtKYOuD1tHM856TRna2DjCWXfAPAz1nByLwq07kE19Gn2HEHy6dPjd7LGhx3vI
         O5GbulQnFQGLQum/EhrFWn0M3UVIQWRn2Se8bdIlJj1EKNqILoaI9kpE1n7x1OzUaa
         HPF3NG1mjiz/5hhnRhM6DHuAVIaDNk8XR74NyELY=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1FB696081E;
        Thu, 28 Mar 2019 13:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553778909;
        bh=5yYHoa5diDPq+jk4/Rj4SArx5h6lrKs3dOyamli4b9U=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=OmvGMf3nFH8hcEF1cW+/9w+qKYI3dfSjcADfR2mvlEY1alPAviCfn1+MhlPZx2kOt
         exIIZKagyqPdf0XnRId0n2aLodoItzxPMVWYgSlt438AFJeVMjKa7tO+t6/9VXm4TB
         kZG6mXeNscHwdzMd1ePlFSmOdsuqW7+3VBGEkHWg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1FB696081E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Ganapathi Bhat <gbhat@marvell.com>
Cc:     "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Brian Norris <briannorris@chromium.org>
Subject: Re: mwifiex: update set_mac_address logic
References: <CY4PR18MB123726E26A33B0E4F48E785FA0580@CY4PR18MB1237.namprd18.prod.outlook.com>
Date:   Thu, 28 Mar 2019 15:15:05 +0200
In-Reply-To: <CY4PR18MB123726E26A33B0E4F48E785FA0580@CY4PR18MB1237.namprd18.prod.outlook.com>
        (Ganapathi Bhat's message of "Wed, 27 Mar 2019 07:29:01 +0000")
Message-ID: <87pnqbxhra.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ganapathi Bhat <gbhat@marvell.com> writes:

> From: Sharvari Harisangam <sharvari@marvell.com>
> Date: Wed, 27 Mar 2019 11:47:03 +0530
> Subject: mwifiex: update set_mac_address logic
>
> In set_mac_address, driver check for interfaces with same bss_type
> For first STA entry, this would return 3 interfaces since all priv's have
> bss_type as 0 due to kzalloc. Thus mac address gets changed for STA
> unexpected. This patch adds check for first STA and avoids mac address
> change. This patch also adds mac_address change for p2p based on bss_num
> type.
>
> Signed-off-by: Sharvari Harisangam <sharvari@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

The formatting looks broken to me, please use git send-email to send
patches.

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#format_issues

-- 
Kalle Valo
