Return-Path: <SRS0=0mSa=WC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ACC2C433FF
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Aug 2019 12:35:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F29EC2070D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Aug 2019 12:35:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PYsiIF5t";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XIRSpFrt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730964AbfHFMfv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Aug 2019 08:35:51 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59340 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726711AbfHFMfv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Aug 2019 08:35:51 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EA78E6090E; Tue,  6 Aug 2019 12:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565094950;
        bh=NZDwtrQI4U0ABkUADvCTivKQDmwAGr82qO/iVNbsfxM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=PYsiIF5t9J5zaxrAV+TgXRtor9lk2/uVbTugLiXURIR3iAigZkSRPNOQ0Xhxrj1yF
         QK+BurzZ84xHDconNI4B3+NF898m/7IC/6/SXem27fgg2Bqbtx0BdB8mVpJ37EZwyQ
         TAm/qCFkaqTLGh6YnZUMqzOdhkriTFlNmR2ljxxY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DB2B56090E;
        Tue,  6 Aug 2019 12:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565094948;
        bh=NZDwtrQI4U0ABkUADvCTivKQDmwAGr82qO/iVNbsfxM=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=XIRSpFrtyrkt1YScYWkoXYydse7nqZ+gBnOvX7Id2f9juOLnmFeFr/tzH1PURrJyQ
         p3Clla8U6EAAeFOq8YK1N/HjS6iejAMQJM2Nz1wFOufmZ+YJMHJHZWSPKXRcCwx5iD
         PUU5EDFETNy8UexZBeActnB04Gkl3dH1BbfnbWT0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DB2B56090E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mt7601u: null check the allocation
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190724141736.29994-1-navid.emamdoost@gmail.com>
References: <20190724141736.29994-1-navid.emamdoost@gmail.com>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        secalert@redhat.com, Navid Emamdoost <navid.emamdoost@gmail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190806123549.EA78E6090E@smtp.codeaurora.org>
Date:   Tue,  6 Aug 2019 12:35:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Navid Emamdoost <navid.emamdoost@gmail.com> wrote:

> devm_kzalloc may fail and return NULL. So the null check is needed.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> Acked-by: Jakub Kicinski <kubakici@wp.pl>

Patch applied to wireless-drivers-next.git, thanks.

b95c732234fa mt7601u: null check the allocation

-- 
https://patchwork.kernel.org/patch/11057013/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

