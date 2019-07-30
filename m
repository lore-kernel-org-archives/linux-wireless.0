Return-Path: <SRS0=VbuY=V3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7703DC0650F
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Jul 2019 15:02:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D34A206B8
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Jul 2019 15:02:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dDOWa3Jg";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="J9IKLMSV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732081AbfG3PCR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Jul 2019 11:02:17 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33168 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfG3PCR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Jul 2019 11:02:17 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D15ED60735; Tue, 30 Jul 2019 15:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1564498936;
        bh=9y/8la5mIDvXXyg82RZC1NJc79+uacylZpte2rTqNt0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=dDOWa3JgzIulliA0voY5YSHTbQfoI8ZcAehI+vb3dBIWZ3JRzmN1kg4X2kJog6dUh
         gVAZqqD4J4ZBQXkjalxdmEQf8cfPtSBv5WVMQpwYQaEwsyHnN/AjApmmPyu0WYzHc0
         n/oBxERpaLCBjuotAA1M8od+8nOGtqQpX5G1heUU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 37A12606FC;
        Tue, 30 Jul 2019 15:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1564498932;
        bh=9y/8la5mIDvXXyg82RZC1NJc79+uacylZpte2rTqNt0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=J9IKLMSV+SjiI+77CSw6uXrmbORJWMZ6axkxnC0mtkkUmayB1GXAm9+uApWMrZdTw
         l+ChaoClpmFR5YWruj0RlMgTuVe9qWBLoBHVWaxukaHy9TXB+YSqPx+0ViBOPmOgBc
         ECyub6bP4gEnhJHudlBd/EaV+ipgjXU4mcJ8EyPk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 37A12606FC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 5.3] mwifiex: fix 802.11n/WPA detection
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190724194634.205718-1-briannorris@chromium.org>
References: <20190724194634.205718-1-briannorris@chromium.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Brian Norris <briannorris@chromium.org>, stable@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190730150215.D15ED60735@smtp.codeaurora.org>
Date:   Tue, 30 Jul 2019 15:02:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> wrote:

> Commit 63d7ef36103d ("mwifiex: Don't abort on small, spec-compliant
> vendor IEs") adjusted the ieee_types_vendor_header struct, which
> inadvertently messed up the offsets used in
> mwifiex_is_wpa_oui_present(). Add that offset back in, mirroring
> mwifiex_is_rsn_oui_present().
> 
> As it stands, commit 63d7ef36103d breaks compatibility with WPA (not
> WPA2) 802.11n networks, since we hit the "info: Disable 11n if AES is
> not supported by AP" case in mwifiex_is_network_compatible().
> 
> Fixes: 63d7ef36103d ("mwifiex: Don't abort on small, spec-compliant vendor IEs")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Patch applied to wireless-drivers.git, thanks.

df612421fe25 mwifiex: fix 802.11n/WPA detection

-- 
https://patchwork.kernel.org/patch/11057585/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

