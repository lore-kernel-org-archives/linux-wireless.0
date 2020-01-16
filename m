Return-Path: <SRS0=LENq=3F=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 398C1C33CB3
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jan 2020 14:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08FB12081E
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jan 2020 14:34:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LUxJ3q3k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgAPOeK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 16 Jan 2020 09:34:10 -0500
Received: from mail-oi1-f180.google.com ([209.85.167.180]:37051 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbgAPOeJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Jan 2020 09:34:09 -0500
Received: by mail-oi1-f180.google.com with SMTP id z64so19051062oia.4
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jan 2020 06:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=utwC4XohCcXnrBFHUC70byzbJgs7U0Wsom2HTKUY9fI=;
        b=LUxJ3q3kzGi1bciRinAkc/VkkZgLT3s/RkM3Ob8hnUscsmB7m/+iBwTftchaySzro9
         NXSPbvwUXxD/S/umFnb0fXsqwtbgaitejjzhz5jlWVyqGNLq99SvSkfVX3Ku59nQb24X
         vDjQfgVuhnP1D1lh8boHXD+yiPICFHuxyxsqZ8+wk50A6LwTedAVrEkoR+vA3B95Yx7d
         i0rPfsVa9v3xOH+A4nckCrBG+JpOKwQv7Clx4jVj9oZeAiLhG8uTxuo8VWKNmiokKELA
         n7JEb39oyAvGhJovupuWBzjd1ffspuZJ5/H53shUbHfzqCgTPg6jsU8pTtKYXXTQh549
         oQ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=utwC4XohCcXnrBFHUC70byzbJgs7U0Wsom2HTKUY9fI=;
        b=bRYyxJYq64JbiGVAKLR3Q8D/q5gjB++Tn5SuR6L9retKq0BAjO+/BQo3Z1qZxw1c0R
         qVRb1xF0mfTuyhcsYFrrov2xQs3vbFfYpM9wJGKy2haq9qgdZbsOccmLU4IvOEt0vPGD
         UGvbbRw+N1ff3riugQfGU+aaNrBRKl/Pp0l+kp721ryvivEbHG3w/qjcf1DxyU1zpveO
         6B0FvF2fcSh+HbdTQEbCQ1J5GVpxsoThHb9h1UtG8ynrgFma6Cr0P0eexmecXktlHSMf
         DJ7YfrsZ/ebdhDbUxTyjw6bO3c1ZctWj4nCfJmEhyenjYXwyy9oLRJ5n2pIXqJWvPUt5
         MAWw==
X-Gm-Message-State: APjAAAXPbut++PdGN0duJBut5e1mIO1YTWgyNZh8CofYV4QecKdUJGXn
        UnMvkPcTR7vpATfltVSHP83l7JePknY=
X-Google-Smtp-Source: APXvYqwcFiYDpAlmqxNv3KoCi7HgExPkS0LFaWuxYI2CRtddbTHWdjMM+TAmNBRHcaPYmvQnVjwxIg==
X-Received: by 2002:aca:889:: with SMTP id 131mr4093579oii.3.1579185248894;
        Thu, 16 Jan 2020 06:34:08 -0800 (PST)
Received: from hari-Latitude-E6430.utdallas.edu (cpe-76-184-240-102.tx.res.rr.com. [76.184.240.102])
        by smtp.gmail.com with ESMTPSA id w6sm6705298oih.19.2020.01.16.06.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 06:34:08 -0800 (PST)
From:   Hari Nagalla <hnagalla@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     mailtalm@ti.com, kvalo@codeaurora.org, hnagalla@gmail.com
Subject: [[PATCH wireless-drivers-next] 0/1] *** Support for RX Broadcast key ***
Date:   Thu, 16 Jan 2020 08:33:52 -0600
Message-Id: <20200116143353.7541-1-hnagalla@gmail.com>
X-Mailer: git-send-email 2.17.1
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

