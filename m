Return-Path: <SRS0=IBNP=X5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0388C47404
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Oct 2019 13:41:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73E662084D
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Oct 2019 13:41:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KwQeN6Ri";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="i2kQ48d4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388621AbfJDNlT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Oct 2019 09:41:19 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48696 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388270AbfJDNlT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Oct 2019 09:41:19 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 234E361A5E; Fri,  4 Oct 2019 13:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570196478;
        bh=IABE1GAiu1pvQqT8gzmXhHn0qZBZMJmM1+C/y7bmKhg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=KwQeN6Ri6A9CwH0QjO29vh8l5q/z2TrMdAemswtkHAVGR4WlHeyh8pVV7PCs/qs6W
         1/cpG9WuQ+Ji/KbRFuLxUYOBrSIebTN34Y5uoSn9t6F0KyFwUueUspXlqI378WZ/o9
         PMk9dNMZRuFD6MpQPVL8PpcK7TGs0xSS4jOrPbvE=
Received: from x230.qca.qualcomm.com (37-33-18-250.bb.dnainternet.fi [37.33.18.250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6A85E61A5F;
        Fri,  4 Oct 2019 13:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570196476;
        bh=IABE1GAiu1pvQqT8gzmXhHn0qZBZMJmM1+C/y7bmKhg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=i2kQ48d4AHlS6/1UbK96BFQwJCAw0JwMyzfxoUOX/PCmVC6RmKiolk9DewS7t1gGI
         vlpmC3FBtd7vYU6ot2Gh8r0Nt++OsCTunpNnN5tNfjCFGD4R50LkTxvmhwWGirGHkb
         AASs8ZM8R2Pf34kFjhISnex74e2cIyCRDbaoIkpc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6A85E61A5F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/8] iwlwifi: mvm: fix race in sync rx queue notification
References: <20191004131414.27372-1-luca@coelho.fi>
        <20191004131414.27372-5-luca@coelho.fi>
Date:   Fri, 04 Oct 2019 16:41:12 +0300
In-Reply-To: <20191004131414.27372-5-luca@coelho.fi> (Luca Coelho's message of
        "Fri, 4 Oct 2019 16:14:10 +0300")
Message-ID: <87imp4sk5j.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> From: Naftali Goldstein <naftali.goldstein@intel.com>
>
> Consider the following flow:
>  1. Driver starts to sync the rx queues due to a delba.
>     mvm->queue_sync_cookie=1.
>     This rx-queues-sync is synchronous, so it doesn't increment the
>     cookie until all rx queues handle the notification from FW.
>  2. During this time, driver starts to sync rx queues due to nssn sync
>     required.
>     The cookie's value is still 1, but it doesn't matter since this
>     rx-queue-sync is non-synchronous so in the notification handler the
>     cookie is ignored.
>     What _does_ matter is that this flow increments the cookie to 2
>     immediately.
>     Remember though that the FW won't start servicing this command until
>     it's done with the previous one.
>  3. FW is still handling the first command, so it sends a notification
>     with internal_notif->sync=1, and internal_notif->cookie=0, which
>     triggers a WARN_ONCE.
>
> The solution for this race is to only use the mvm->queue_sync_cookie in
> case of a synchronous sync-rx-queues. This way in step 2 the cookie's
> value won't change so we avoid the WARN.
>
> The commit in the "fixes" field is the first commit to introduce
> non-synchronous sending of this command to FW.

But I don't see a Fixes field anywhere :)

-- 
Kalle Valo
