Return-Path: <SRS0=TB3F=Z6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E268C43603
	for <linux-wireless@archiver.kernel.org>; Sun,  8 Dec 2019 13:21:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E46B206E0
	for <linux-wireless@archiver.kernel.org>; Sun,  8 Dec 2019 13:21:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gmHdDtM7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfLHNVT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 8 Dec 2019 08:21:19 -0500
Received: from mail-oi1-f180.google.com ([209.85.167.180]:45556 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbfLHNVS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 8 Dec 2019 08:21:18 -0500
Received: by mail-oi1-f180.google.com with SMTP id v10so3970896oiv.12
        for <linux-wireless@vger.kernel.org>; Sun, 08 Dec 2019 05:21:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=utwC4XohCcXnrBFHUC70byzbJgs7U0Wsom2HTKUY9fI=;
        b=gmHdDtM77hVTrx2L2drz1TnC8VpUqk2PYFXYy3rhewb4CQsVSZn/FeVh5D+2h9P2Qs
         euTP4giKsGYzG4Q5WYVrqXTRb/ahJaozcw8woAcrRgqgr7lJjFEzbsPsAKPTXMcZmj+h
         fJCMSdSeMZSU3UZ9a7UdVd3WKZX11EOIlMheso1Of3An1W/2MCBJVRtuIdJI1WkZ5rBB
         Nyt0ljaTFg1U64kKYF/ahSUy8SyMb/s2Op7ZxngL1BEXwQIGmddJaE2wnlOWtnOMHGMT
         3+sTWkj4d2NHVP/CeB/4PDCgfp61WTHME1H1KhTmrpJmneceT8SEH5niYxd8iipuPuJZ
         wTbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=utwC4XohCcXnrBFHUC70byzbJgs7U0Wsom2HTKUY9fI=;
        b=A3L6cq0jL3v5b7mfY0+uNEyyhDjz5ylUcRWURD1DpCALPWFCLj6BksfyDnKSlJezjS
         0fO7BN4wAoAR/rM5bwWnqwZXTSgiVekzKNOA3JMaZzMVFqn1uJi7HHvV9craXmeAgCMc
         nYv2XYOmnUA/oiApryxeDbGB3UKZoFtEGFnH21sM6NzX9MdpiJ7Ys3FQBi4bMOhokn6k
         t02hRXLTv5df+aAgLXS3gFYgY8fAfjVjKPjs0vUTHNglukGhgugAEOJlhls/KLZcwRLK
         S6giv7YI9YTn0CqKbCDRdW7/GAUhRAgvAK7VmnDkZitGnIDUudZBWtBYuu3Y7o9osgWQ
         qCJA==
X-Gm-Message-State: APjAAAXT/cpKc2D07eXWDhpirLz/O4db7lIQWzrp5pwZ44uRG80tdX8H
        ORVOMHqKAjpBysOHP7IvF7I=
X-Google-Smtp-Source: APXvYqx7Rj2Kdzcl3dR3jRRpf3ZpZHnJjsmk+4x9/T/MwsLDMsgjs0wDxBu2oFQpI72WW9z9HEvUkw==
X-Received: by 2002:a05:6808:a9c:: with SMTP id q28mr20774011oij.176.1575811278031;
        Sun, 08 Dec 2019 05:21:18 -0800 (PST)
Received: from hari-Latitude-E6430.utdallas.edu (cpe-76-184-237-208.tx.res.rr.com. [76.184.237.208])
        by smtp.gmail.com with ESMTPSA id u11sm7361510oie.53.2019.12.08.05.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Dec 2019 05:21:17 -0800 (PST)
From:   Hari Nagalla <hnagalla@gmail.com>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, maitalm@ti.com, hnagalla@gmail.com
Subject: [[PATCH wireless-drivers] 0/1] *** Support for RX Broadcast key ***
Date:   Sun,  8 Dec 2019 07:20:58 -0600
Message-Id: <20191208132058.5588-2-hnagalla@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191208132058.5588-1-hnagalla@gmail.com>
References: <20191208132058.5588-1-hnagalla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

*** BLURB HERE ***

Maital Hahn (1):
  wlcore: mesh: Add support for RX Boradcast Key

 drivers/net/wireless/ti/wlcore/cmd.c      |  6 ++++--
 drivers/net/wireless/ti/wlcore/cmd.h      |  2 +-
 drivers/net/wireless/ti/wlcore/main.c     | 23 +++++++++++++++--------
 drivers/net/wireless/ti/wlcore/wlcore_i.h |  1 +
 4 files changed, 21 insertions(+), 11 deletions(-)

-- 
2.17.1

