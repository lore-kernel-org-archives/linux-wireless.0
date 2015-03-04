Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:46300 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbbCDCMR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 21:12:17 -0500
Received: by lbiz11 with SMTP id z11so15299756lbi.13
        for <linux-wireless@vger.kernel.org>; Tue, 03 Mar 2015 18:12:16 -0800 (PST)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by mx.google.com with ESMTPSA id w9sm481491lae.35.2015.03.03.18.12.13
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Mar 2015 18:12:15 -0800 (PST)
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] ath5k: reset path fixes
Date: Wed,  4 Mar 2015 05:12:09 +0300
Message-Id: <1425435131-12701-1-git-send-email-ryazanov.s.a@gmail.com> (sfid-20150304_031220_769137_06957449)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Couple of patches for the reset code path to address the
"invalid hw_rix" warning and to make reset more robust.

Patch 1 helps to avoid warning by fixing the order of rx disable and
channel update actions.

Patch 2 fixes the root cause, which is interrupt disable/enable race
between tasklet and reset function.

The second patch contains a more generic fix, which is enough to
prevent the warning. But I think that the first patch should be applied
too, just in case. If no one has any objections.

Sergey Ryazanov (2):
  ath5k: channel change fix
  ath5k: fix reset race

 drivers/net/wireless/ath/ath5k/ath5k.h |  1 +
 drivers/net/wireless/ath/ath5k/base.c  | 31 ++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath5k/reset.c | 24 ------------------------
 3 files changed, 29 insertions(+), 27 deletions(-)

-- 
2.0.4

