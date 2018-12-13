Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E804C65BAE
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 09:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C31120811
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 09:15:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="K+uYQkDv";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="afPlkLa4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C31120811
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbeLMJPd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 04:15:33 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36386 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbeLMJPc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 04:15:32 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5EF3460740; Thu, 13 Dec 2018 09:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544692532;
        bh=EUwwDUiSz3J5E3XW7cPOaSupj7MAEuIrU4lYKKeF2do=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=K+uYQkDv+RoJORYsGAYsA7VnA6ZXLD53m3YkAjjOkSM2+wPfNntszhSHjGW9sUlc5
         Dl1Gw15Z5FXi5G0w9uOOHtORgv6JNM1LiEPuUx6dlXj5rjYcpsg4UN3a05tlXdXEEz
         L/tWfrZ/WPQ3qJweGH6maDxlB4UyvZfYVeepJdP4=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3414560159;
        Thu, 13 Dec 2018 09:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544692531;
        bh=EUwwDUiSz3J5E3XW7cPOaSupj7MAEuIrU4lYKKeF2do=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=afPlkLa4PUL0AuVMo32kMoQgBivLYdfxycMtUQzf62ZY+VjPGGtDZtpgSVvZ1ZlKM
         rmjXBT1Zzaz6WNGEmjCqW4fHS4nt5z9x8TdrtwvlcKiQceIcd/BTOdFfduyszUWqHF
         DvfapPLfkpA1hIOXfX0ozd2AyxMXiGCrw7Xh+occ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3414560159
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.14 01/41] mac80211_hwsim: fix module init error paths for netlink
References: <20181213043054.75891-1-sashal@kernel.org>
Date:   Thu, 13 Dec 2018 11:15:27 +0200
In-Reply-To: <20181213043054.75891-1-sashal@kernel.org> (Sasha Levin's message
        of "Wed, 12 Dec 2018 23:30:14 -0500")
Message-ID: <87imzx949c.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sasha Levin <sashal@kernel.org> writes:

> From: Alexey Khoroshilov <khoroshilov@ispras.ru>
>
> [ Upstream commit 05cc09de4c017663a217630682041066f2f9a5cd ]
>
> There is no unregister netlink notifier and family on error paths
> in init_mac80211_hwsim(). Also there is an error path where
> hwsim_class is not destroyed.
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> Fixes: 62759361eb49 ("mac80211-hwsim: Provide multicast event for HWSIM_CMD_NEW_RADIO")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

BTW, thanks for adding "X-Patchwork-Hint: Ignore" to the headers. I
don't see this patch in patchwork and that helps me a lot :)

-- 
Kalle Valo
