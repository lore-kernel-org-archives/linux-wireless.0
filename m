Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34915 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab2BYETe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 23:19:34 -0500
Received: by daed14 with SMTP id d14so3190091dae.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2012 20:19:34 -0800 (PST)
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: hauke@hauke-m.de, nbd@nbd.name, linville@tuxdriver.com,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH 0/4] compat: fix compiling against all kernels
Date: Fri, 24 Feb 2012 20:19:25 -0800
Message-Id: <1330143569-30296-1-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120225_051938_548369_38972D51)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@frijolero.org>

I was tired of seeing ckmake fail against different kernels, this
series of patches fixes compilation against all supported kernels.
The modpost one was tricky.

Luis R. Rodriguez (4):
  compat: fix compilation warning for compat_firmware_class on 2.6.26
  compat: clean ckmake log of color output
  compat: avoid NOSTDINC_FLAGS during modpost
  compat: fix compat_firmware class for all kernels

 Makefile                       |   27 ++++++++++++++++-----------
 bin/ckmake                     |    3 +++
 compat/compat_firmware_class.c |    6 +++---
 scripts/skip-colors            |    2 ++
 4 files changed, 24 insertions(+), 14 deletions(-)
 create mode 100755 scripts/skip-colors

-- 
1.7.4.15.g7811d

