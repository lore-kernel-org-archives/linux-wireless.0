Return-Path: <SRS0=VTAB=T3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DE65C07542
	for <linux-wireless@archiver.kernel.org>; Mon, 27 May 2019 04:16:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3BA9206E0
	for <linux-wireless@archiver.kernel.org>; Mon, 27 May 2019 04:16:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZlO5Pevn";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZlO5Pevn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbfE0EQy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 27 May 2019 00:16:54 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45136 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfE0EQy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 May 2019 00:16:54 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B0CD960850; Mon, 27 May 2019 04:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558930613;
        bh=2U+FWdNTCUE+5AySKg68tPWk8Kf3LLCb0bMzaMCXmOI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ZlO5Pevn3ev4kYs5I2z+m23G5tQXhFRzytki1lBhUudnUomk33BNsWi7hpVvLZDqz
         mSCd0WoYOSVQDWeKAQWtCOX4Zb4MlVu/Q5lvCrfV/vr2Ak0vanqaIppwgsD1Hf5As+
         Yvl3yBAvdOJOxLayVjWTaXXU+RmlUvSP5BFMx1fc=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6C5E56087B;
        Mon, 27 May 2019 04:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558930613;
        bh=2U+FWdNTCUE+5AySKg68tPWk8Kf3LLCb0bMzaMCXmOI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ZlO5Pevn3ev4kYs5I2z+m23G5tQXhFRzytki1lBhUudnUomk33BNsWi7hpVvLZDqz
         mSCd0WoYOSVQDWeKAQWtCOX4Zb4MlVu/Q5lvCrfV/vr2Ak0vanqaIppwgsD1Hf5As+
         Yvl3yBAvdOJOxLayVjWTaXXU+RmlUvSP5BFMx1fc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6C5E56087B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Andy Strohman <andrew@andrewstrohman.com>
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        Andy Strohman <andy@uplevelsystems.com>
Subject: Re: [PATCH] netlink: fix station_info pertid memory leak
References: <20190525062729.8504-1-andy@uplevelsystems.com>
Date:   Mon, 27 May 2019 07:16:50 +0300
In-Reply-To: <20190525062729.8504-1-andy@uplevelsystems.com> (Andy Strohman's
        message of "Fri, 24 May 2019 23:27:29 -0700")
Message-ID: <877eacv8el.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Andy Strohman <andrew@andrewstrohman.com> writes:

> When dumping stations, memory allocated for station_info's
> pertid member will leak if the nl80211 header cannot be added to
> the sk_buff due to insufficient tail room.
>
> I noticed this leak in the kmalloc-2048 cache.
>
> Fixes: 8689c051a201 ("cfg80211: dynamically allocate per-tid stats for station info")
> Signed-off-by: Andy Strohman <andy@uplevelsystems.com>
> ---
>  net/wireless/nl80211.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

The correct prefix should be "nl80211:".

-- 
Kalle Valo
