Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6059CC4338F
	for <linux-wireless@archiver.kernel.org>; Mon,  9 Aug 2021 09:52:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3823160F11
	for <linux-wireless@archiver.kernel.org>; Mon,  9 Aug 2021 09:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbhHIJwc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 9 Aug 2021 05:52:32 -0400
Received: from ixit.cz ([94.230.151.217]:45390 "EHLO ixit.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232944AbhHIJwb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Aug 2021 05:52:31 -0400
Received: from [192.168.1.138] (ixit.cz [94.230.151.217])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ixit.cz (Postfix) with ESMTPSA id 010922029F;
        Mon,  9 Aug 2021 11:52:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ixit.cz; s=dkim;
        t=1628502729; h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type; bh=zMMvPYXCWwg1ECXuJ65Ce2QQL+GNmPxWmXQL8VjJT+A=;
        b=howMU3VFC/t653oHDrbc9ZILio1UPU+Z1yl3/1JY3PGCRGCy9IbsCRLWrayvM02TYCZaZM
        m7P3PfTT+5FcjDnGL9l1VIEA/SMw8lsE8sxphkAGMYJ2Q7FMkI3fvaXupq10Q8nvpaby0K
        NBqjWP5KzA6wlVl8zJEMZXDz85wA4bg=
Date:   Mon, 09 Aug 2021 11:51:03 +0200
From:   David Heidelberg <david@ixit.cz>
Reply-To: 1608618887-8857-1-git-send-email-miaoqing@codeaurora.org
Subject: Re: [PATCH v2] ath10k: fix wmi mgmt tx queue full due to race
 condition
To:     miaoqing@codeaurora.org, briannorris@chromium.org,
        kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <3PGKXQ.OUNHZGPTI7091@ixit.cz>
X-Mailer: geary/40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello all,

since I noticed this issue is very common (at least for me and some 
others) on 4.14 kernels [1] [2] would you think that backporting this 
patch into stable would make sense? I assume that at some point it 
could help some OpenWRT/LEDE and other devices (since for Turris it'll 
be most likely backported anyway).

Thank you for the working on this!
David

[1] 
https://forum.turris.cz/t/5-2-4-patch-wifi-fails-after-while-wmi-mgmt-tx-queue-is-full/15510
[2] https://forum.turris.cz/t/unstable-wifi-on-mox-b/11065/



