Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7077DC43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 16:46:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3446A2087F
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 16:46:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bQBkUWm/";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mZ2iv9r4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbfAHQqT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 11:46:19 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:59780 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728228AbfAHQqT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 11:46:19 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E7FAA60DB0; Tue,  8 Jan 2019 16:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546965978;
        bh=qqddlqz6euhtNtXTU3NIRjytHFmphV/nYiU4l5c4wO8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=bQBkUWm/Z/R5vU5MOSqJCM4Xa26V2XzdIS6IjK9Y7mdvUaH+kcVt/nf+lQId6EGnO
         Z7H1vNcoc9yL5pgs/MVPkvbZCNyFI2wMHtf2sX3ye2Gn57+wWH5WJlAU4ny+S4wh93
         sFKe624zGo9Ga+tkLGVSAUu/b5x6aIzFDhOz0bUA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7A16460DA8;
        Tue,  8 Jan 2019 16:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546965976;
        bh=qqddlqz6euhtNtXTU3NIRjytHFmphV/nYiU4l5c4wO8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=mZ2iv9r4W0iiTdinVFmLMnUbTEM2Dsnf57D1mf4tYZVUwC6o3+SwgHhBZNSWHMIKi
         f0JZIUoJ4HCpygIjKdHn756bLpinVb2TcKQxh+xUpkHcaX+FQPQrwjZFkiMModWllG
         Va3AfurgXe2mt5Twnm3ALEHQLsA50FTBEhZvhnlg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7A16460DA8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, "David S. Miller" <davem@davemloft.net>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: marvell: add checks for the return value of sysfs_create_group
References: <20181226034305.73411-1-kjlu@umn.edu>
Date:   Tue, 08 Jan 2019 18:46:11 +0200
In-Reply-To: <20181226034305.73411-1-kjlu@umn.edu> (Kangjie Lu's message of
        "Tue, 25 Dec 2018 21:43:03 -0600")
Message-ID: <87va2zqer0.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kangjie Lu <kjlu@umn.edu> writes:

> sysfs_create_group() could fail, so let's check its return values and
> issue error messages if it fails.
>
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>  drivers/net/wireless/marvell/libertas/mesh.c | 4 ++++

The correct prefix is "libertas: ".

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_title_is_wrong

> --- a/drivers/net/wireless/marvell/libertas/mesh.c
> +++ b/drivers/net/wireless/marvell/libertas/mesh.c
> @@ -797,7 +797,11 @@ static void lbs_persist_config_init(struct net_device *dev)
>  {
>  	int ret;
>  	ret = sysfs_create_group(&(dev->dev.kobj), &boot_opts_group);
> +	if (ret)
> +		pr_err("failed to create boot_opts_group.\n");

Please add an empty line here for readability and resend the patch as
v2.

>  	ret = sysfs_create_group(&(dev->dev.kobj), &mesh_ie_group);
> +	if (ret)
> +		pr_err("failed to create mesh_ie_group.\n");
>  }
>  
>  static void lbs_persist_config_remove(struct net_device *dev)

-- 
Kalle Valo
