Return-Path: <SRS0=PzJh=Y6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F38C1C5DF64
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Nov 2019 06:35:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABB682075C
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Nov 2019 06:35:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Vw0xgO1+";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Xr1QG7sz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730821AbfKFGfX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Nov 2019 01:35:23 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60576 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729824AbfKFGfW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Nov 2019 01:35:22 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1B44961216; Wed,  6 Nov 2019 06:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573022122;
        bh=aCOY2P2csr5ulBYDHGdLOQsvtbKjaVc9VAMK3H2MPy0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Vw0xgO1+L43d9BklJRYCIGTl0jZHI9Gb0TfVLDFsmUmG3F32+IBQ7WYxgmVq7KisM
         SRqreaXwC5cra2YXbCbicVncKJ/u//i1LLEqvDzJoS7Y9xh8A+RlV6cyAPYYJ3IYle
         P1JRCNaz2ffvJI6eQOHJ6DJHAJgvfEo4Jaudv3yo=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9D51460CA5;
        Wed,  6 Nov 2019 06:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573022121;
        bh=aCOY2P2csr5ulBYDHGdLOQsvtbKjaVc9VAMK3H2MPy0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Xr1QG7szcj3iHRDk1ZvDHJZKmyww0vrWbuqDTrGoZdH8XkAUaHfUAy4k2Vz+hEO8n
         V+5aj5InfACNhI3OiGPYRpcn9ci64PIMo7VXB4O7rO7HDPAXz1WhB5/p086Rw4j2Ul
         VeFbeoXyLtLSdf8w2IZVSRJpDrWnEjdatTIgICOo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9D51460CA5
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next-2019-11-05
References: <20191105145823.3FF88616AE@smtp.codeaurora.org>
        <20191105.184053.2112877734260713502.davem@davemloft.net>
Date:   Wed, 06 Nov 2019 08:35:17 +0200
In-Reply-To: <20191105.184053.2112877734260713502.davem@davemloft.net> (David
        Miller's message of "Tue, 05 Nov 2019 18:40:53 -0800 (PST)")
Message-ID: <87wocd5x7e.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Kalle Valo <kvalo@codeaurora.org>
> Date: Tue,  5 Nov 2019 14:58:23 +0000 (UTC)
>
>> here's a pull request to net-next tree, more info below. Please let me know if
>> there are any problems.
>
> Pulled.
>
> There was a minor merge conflict, please double check my work.

Looks good, thanks!

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
