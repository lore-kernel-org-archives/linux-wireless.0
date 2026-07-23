Received: from va-2-16.ptr.blmpb.com (va-2-16.ptr.blmpb.com [209.127.231.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164FC33A9CF
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 02:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784772814; cv=none; b=ADLKPaAQkg6hRCEb0mebWWN+7IUAF8/oRT5EoZ1p5cWKkbt3bcFNN/SODsQZDhvzTbHvLi3y/4ROTaikZFCuI55Cbrwn7wGw9i1BoToZwrvHlTX0nVOJh7X1LtnF1iuv1Uhs8kWQ+eGqVXwVJ7RnQmTzAYbTqPivMRihqJZmfKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784772814; c=relaxed/simple;
	bh=VBcRxKSmJHdESd20B4RE703lNKdxPrlchoIxbNnWtC4=;
	h=Mime-Version:Content-Type:From:Subject:Message-Id:Date:To:Cc; b=gxV9i/vwuSqS1D4HpAu3GcR4EnTvE0vEVyTPmLzv7Qt1CyUnU4RPTMu6yrmApBrGA150poo8eOEMm1SlCQkpqmLA4wZgr12xb64DW+9e+ttibpNA7UASwKJtbZhpbVVAB8HAkCCKJfM5Aulu98KytVRkBa8Zhqr61q2rZvcbDCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bedmex.com; spf=none smtp.mailfrom=bedmex.com; dkim=pass (2048-bit key) header.d=bedmex-com.20200927.dkim.feishu.cn header.i=@bedmex-com.20200927.dkim.feishu.cn header.b=dugtaAYC; arc=none smtp.client-ip=209.127.231.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bedmex.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bedmex.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bedmex-com.20200927.dkim.feishu.cn header.i=@bedmex-com.20200927.dkim.feishu.cn header.b="dugtaAYC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=bedmex-com.20200927.dkim.feishu.cn; t=1784772796;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=bcacDBzv7UQ/XQfm/8eyBa+w759WmmcMLYKHom/8gFc=;
 b=dugtaAYCKo6twaYGcz5tpIQ4p9Lb2xTkzT5RvnLQWDKNeJypT7BU84FNOOKcEuPq2w56+P
 yMPSBiC8Md9gLrn1KG5HtUC13WbcmCEX7agGiqtyl6TTVV2Vkuh3lFotfL/nlyTK61WEr6
 Hu4OXpzb6NXa+bcZ0CX/7u3fz5c5fsYjZhb7Ael8Su3p3pt2CNeyoA1jHp/+43v9XB4Vjh
 DSUx8jPyvpnVcmBnJ/bYv03wIvw6LVbiB70C/W7jw7gGbFhtlMPlr/0WloKl1L0lPk4TAa
 7uKpgp4Agt7c+UVlCbk7JmQQklfnvrWf1FeEXza5rFMYlRJGAw4sOlaaajAU9Q==
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1
X-Original-From: Yanli Yang <yanli.yang@bedmex.com>
Content-Type: text/plain; charset=UTF-8
From: "Yanli Yang" <yanli.yang@bedmex.com>
Subject: [RFC PATCH wireless-next v2 0/4] wifi: aic: add AIC8800 SDIO FullMAC driver
Message-Id: <cover.1784724170.git.yanli.yang@bedmex.com>
Date: Thu, 23 Jul 2026 10:13:08 +0800
X-Lms-Return-Path: <lba+26a6178ba+e913d1+vger.kernel.org+yanli.yang@bedmex.com>
Received: from bmxpxe-virtual-desktop.. ([36.141.79.164]) by smtp.feishu.cn with ESMTPS; Thu, 23 Jul 2026 10:13:14 +0800
Content-Transfer-Encoding: 7bit
To: <linux-wireless@vger.kernel.org>
Cc: "Johannes Berg" <johannes@sipsolutions.net>, 
	"Zhirun Liu" <zhirunliu@aicsemi.com>, "Dijia Xu" <dijiaxu@aicsemi.com>, 
	"Chunqiu Liu" <chunqiuliu@aicsemi.com>, 
	"Liheng Wei" <liheng.wei@bedmex.com>

This RFC adds an SDIO FullMAC driver for AIC8801, AIC8800DC and
AIC8800D80 devices. It contains an SDIO/BSP layer, the firmware protocol,
the cfg80211 FullMAC implementation, and diagnostic and compatibility
interfaces.

The series is organized as follows:

  1. build configuration, SDIO BSP, firmware loading and BSP chip support;
  2. FullMAC firmware protocol, platform bring-up and control path;
  3. cfg80211 core, data path, SDIO/chip support, wireless features,
     diagnostics and compatibility interfaces;
  4. parent wireless build integration and MAINTAINERS.

The parent build integration is added last so that no incomplete driver
state can be selected by Kconfig.

Changes since v1:

  - update the driver for current wireless-next cfg80211 APIs, including
    per-interface-type HE capability registration;
  - fix cfg80211 BSS IE lifetime and reference handling;
  - address 32-bit GCC, Clang, W=1 and sparse diagnostics, including
    declarations, const correctness, format strings and unused objects;
  - limit file-local data and helpers to static scope;
  - complete kernel-doc annotations needed by W=1 builds;
  - normalize maintainer names in MAINTAINERS.

v1: https://lore.kernel.org/r/cover.1784544076.git.yanli.yang@bedmex.com

Validation performed for v2:

  - ARCH=i386 allmodconfig W=1 build with GCC 13.3.0;
  - x86-64 allmodconfig W=1 build with Clang/LLD 18.1.3;
  - W=1 C=1 sparse checks for all 51 AIC translation units with no AIC
    warning or error;
  - sequential git am application on wireless-next commit ac798f757d6475.

The complete W=1 C=1 allmodconfig build was interrupted after the AIC
checks by a reproducible sparse v0.6.5-rc1 crash while checking the
unrelated drivers/gpu/drm/msm/msm_gem.c file.

Runtime testing on production hardware has not yet been performed.

Known limitations of this RFC are:

  - firmware redistribution permission and the corresponding linux-firmware
    submission are not yet available;
  - DT power and wake bindings are not included;
  - private generic-netlink and vendor interfaces, the regulatory database,
    and rwnx_settings.ini require follow-up work.

Zhirun Liu (4):
  wifi: aic: add SDIO BSP and build configuration
  wifi: aic: add FullMAC firmware and platform interface
  wifi: aic: add FullMAC WLAN driver
  wifi: aic: integrate AIC8800 driver

 MAINTAINERS                                   |   10 +
 drivers/net/wireless/Kconfig                  |    1 +
 drivers/net/wireless/Makefile                 |    1 +
 drivers/net/wireless/aic/Kconfig              |  135 +
 drivers/net/wireless/aic/Makefile             |   17 +
 drivers/net/wireless/aic/aic8800_bsp/Kconfig  |   97 +
 drivers/net/wireless/aic/aic8800_bsp/Makefile |   42 +
 .../aic/aic8800_bsp/aic8800d80_compat.c       |  290 +
 .../aic/aic8800_bsp/aic8800d80_compat.h       |   11 +
 .../aic/aic8800_bsp/aic8800dc_compat.c        | 1342 ++++
 .../aic/aic8800_bsp/aic8800dc_compat.h        |   40 +
 .../wireless/aic/aic8800_bsp/aic_bsp_driver.c | 1679 +++++
 .../wireless/aic/aic8800_bsp/aic_bsp_driver.h |  624 ++
 .../wireless/aic/aic8800_bsp/aic_bsp_export.h |   70 +
 .../wireless/aic/aic8800_bsp/aic_bsp_main.c   |  556 ++
 .../aic/aic8800_bsp/aic_chip_8800d80.c        |  116 +
 .../aic/aic8800_bsp/aic_chip_8800dc.c         |  133 +
 .../wireless/aic/aic8800_bsp/aic_chip_8801.c  |  117 +
 .../wireless/aic/aic8800_bsp/aic_chip_ops.c   |   77 +
 .../wireless/aic/aic8800_bsp/aic_chip_ops.h   |   71 +
 .../net/wireless/aic/aic8800_bsp/aicsdio.c    | 2020 ++++++
 .../net/wireless/aic/aic8800_bsp/aicsdio.h    |  176 +
 .../wireless/aic/aic8800_bsp/aicsdio_txrxif.c |  465 ++
 .../wireless/aic/aic8800_bsp/aicsdio_txrxif.h |  180 +
 .../aic/aic8800_bsp/aicwf_txq_prealloc.c      |   72 +
 .../aic/aic8800_bsp/aicwf_txq_prealloc.h      |    8 +
 drivers/net/wireless/aic/aic8800_bsp/md5.c    |  165 +
 drivers/net/wireless/aic/aic8800_bsp/md5.h    |   77 +
 .../aic/aic8800_bsp/rwnx_version_gen.h        |    5 +
 drivers/net/wireless/aic/aic8800_fdrv/Kconfig |  539 ++
 .../net/wireless/aic/aic8800_fdrv/Makefile    |  117 +
 .../wireless/aic/aic8800_fdrv/aic_br_ext.c    | 1598 +++++
 .../wireless/aic/aic8800_fdrv/aic_br_ext.h    |   72 +
 .../aic/aic8800_fdrv/aic_bsp_export.h         |   62 +
 .../wireless/aic/aic8800_fdrv/aic_btsdio.c    | 1169 ++++
 .../wireless/aic/aic8800_fdrv/aic_btsdio.h    |  472 ++
 .../net/wireless/aic/aic8800_fdrv/aic_bus.h   |  191 +
 .../wireless/aic/aic8800_fdrv/aic_priv_cmd.c  | 1978 ++++++
 .../wireless/aic/aic8800_fdrv/aic_priv_cmd.h  |  127 +
 .../wireless/aic/aic8800_fdrv/aic_vendor.c    |  950 +++
 .../wireless/aic/aic8800_fdrv/aic_vendor.h    |  370 ++
 .../aic/aic8800_fdrv/aicwf_chip_8800d80.c     |  291 +
 .../aic/aic8800_fdrv/aicwf_chip_8800dc.c      |  300 +
 .../aic/aic8800_fdrv/aicwf_chip_8801.c        |  279 +
 .../aic/aic8800_fdrv/aicwf_chip_ops.c         |  267 +
 .../aic/aic8800_fdrv/aicwf_chip_ops.h         |  186 +
 .../aic/aic8800_fdrv/aicwf_compat_8800d80.c   |   96 +
 .../aic/aic8800_fdrv/aicwf_compat_8800d80.h   |   16 +
 .../aic/aic8800_fdrv/aicwf_compat_8800dc.c    |  505 ++
 .../aic/aic8800_fdrv/aicwf_compat_8800dc.h    |   22 +
 .../wireless/aic/aic8800_fdrv/aicwf_debug.h   |   37 +
 .../wireless/aic/aic8800_fdrv/aicwf_genl.c    |  941 +++
 .../wireless/aic/aic8800_fdrv/aicwf_genl.h    |  112 +
 .../aic/aic8800_fdrv/aicwf_rx_prealloc.c      |  102 +
 .../aic/aic8800_fdrv/aicwf_rx_prealloc.h      |   34 +
 .../wireless/aic/aic8800_fdrv/aicwf_sdio.c    | 2816 +++++++++
 .../wireless/aic/aic8800_fdrv/aicwf_sdio.h    |  264 +
 .../wireless/aic/aic8800_fdrv/aicwf_tcp_ack.c |  565 ++
 .../wireless/aic/aic8800_fdrv/aicwf_tcp_ack.h |  104 +
 .../wireless/aic/aic8800_fdrv/aicwf_txrxif.c  |  753 +++
 .../wireless/aic/aic8800_fdrv/aicwf_txrxif.h  |  217 +
 .../aic/aic8800_fdrv/aicwf_wext_linux.c       | 1137 ++++
 .../aic/aic8800_fdrv/aicwf_wext_linux.h       |   15 +
 .../net/wireless/aic/aic8800_fdrv/hal_desc.h  |  359 ++
 .../wireless/aic/aic8800_fdrv/ipc_compat.h    |   25 +
 .../net/wireless/aic/aic8800_fdrv/ipc_host.c  |   42 +
 .../net/wireless/aic/aic8800_fdrv/ipc_host.h  |  169 +
 .../wireless/aic/aic8800_fdrv/ipc_shared.h    |  781 +++
 .../net/wireless/aic/aic8800_fdrv/lmac_mac.h  |  470 ++
 .../net/wireless/aic/aic8800_fdrv/lmac_msg.h  | 3124 ++++++++++
 .../wireless/aic/aic8800_fdrv/lmac_types.h    |   37 +
 drivers/net/wireless/aic/aic8800_fdrv/md5.c   |  175 +
 drivers/net/wireless/aic/aic8800_fdrv/md5.h   |   82 +
 .../wireless/aic/aic8800_fdrv/reg_access.h    |  146 +
 drivers/net/wireless/aic/aic8800_fdrv/regdb.c | 2772 +++++++++
 .../wireless/aic/aic8800_fdrv/rwnx_bfmer.c    |   93 +
 .../wireless/aic/aic8800_fdrv/rwnx_bfmer.h    |  100 +
 .../wireless/aic/aic8800_fdrv/rwnx_cfgfile.c  |  265 +
 .../wireless/aic/aic8800_fdrv/rwnx_cfgfile.h  |   33 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_cmds.c |  471 ++
 .../net/wireless/aic/aic8800_fdrv/rwnx_cmds.h |   99 +
 .../wireless/aic/aic8800_fdrv/rwnx_compat.h   |   93 +
 .../wireless/aic/aic8800_fdrv/rwnx_debugfs.c  | 2585 ++++++++
 .../wireless/aic/aic8800_fdrv/rwnx_debugfs.h  |  134 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_defs.h |  743 +++
 .../wireless/aic/aic8800_fdrv/rwnx_events.h   |  938 +++
 .../wireless/aic/aic8800_fdrv/rwnx_fw_trace.c |   50 +
 .../wireless/aic/aic8800_fdrv/rwnx_fw_trace.h |   28 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_gki.c  |  406 ++
 .../net/wireless/aic/aic8800_fdrv/rwnx_gki.h  |   46 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_irqs.c |   49 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_irqs.h |   12 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_main.c | 5413 +++++++++++++++++
 .../net/wireless/aic/aic8800_fdrv/rwnx_main.h |   35 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_mesh.c |   33 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_mesh.h |   35 +
 .../aic/aic8800_fdrv/rwnx_mod_params.c        | 1312 ++++
 .../aic/aic8800_fdrv/rwnx_mod_params.h        |   74 +
 .../wireless/aic/aic8800_fdrv/rwnx_msg_rx.c   | 1742 ++++++
 .../wireless/aic/aic8800_fdrv/rwnx_msg_rx.h   |    8 +
 .../wireless/aic/aic8800_fdrv/rwnx_msg_tx.c   | 3809 ++++++++++++
 .../wireless/aic/aic8800_fdrv/rwnx_msg_tx.h   |  285 +
 .../wireless/aic/aic8800_fdrv/rwnx_mu_group.c |  653 ++
 .../wireless/aic/aic8800_fdrv/rwnx_mu_group.h |  159 +
 .../wireless/aic/aic8800_fdrv/rwnx_platform.c | 2954 +++++++++
 .../wireless/aic/aic8800_fdrv/rwnx_platform.h |  187 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_prof.h |  142 +
 .../wireless/aic/aic8800_fdrv/rwnx_radar.c    | 1975 ++++++
 .../wireless/aic/aic8800_fdrv/rwnx_radar.h    |  285 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_rx.c   | 2445 ++++++++
 .../net/wireless/aic/aic8800_fdrv/rwnx_rx.h   |  358 ++
 .../net/wireless/aic/aic8800_fdrv/rwnx_strs.c |  269 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_strs.h |   31 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_tdls.c |  777 +++
 .../net/wireless/aic/aic8800_fdrv/rwnx_tdls.h |   57 +
 .../wireless/aic/aic8800_fdrv/rwnx_testmode.c |  217 +
 .../wireless/aic/aic8800_fdrv/rwnx_testmode.h |   68 +
 .../wireless/aic/aic8800_fdrv/rwnx_trace.c    |    5 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_tx.c   | 1811 ++++++
 .../net/wireless/aic/aic8800_fdrv/rwnx_tx.h   |  185 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_txq.c  | 1362 +++++
 .../net/wireless/aic/aic8800_fdrv/rwnx_txq.h  |  358 ++
 .../wireless/aic/aic8800_fdrv/rwnx_utils.c    |   36 +
 .../wireless/aic/aic8800_fdrv/rwnx_utils.h    |  131 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_v7.c   |  181 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_v7.h   |   21 +
 .../wireless/aic/aic8800_fdrv/rwnx_version.h  |   14 +
 .../aic/aic8800_fdrv/rwnx_version_gen.h       |    5 +
 .../wireless/aic/aic8800_fdrv/rwnx_wakelock.c |  109 +
 .../wireless/aic/aic8800_fdrv/rwnx_wakelock.h |   24 +
 .../net/wireless/aic/aic8800_fdrv/sdio_host.c |  132 +
 .../net/wireless/aic/aic8800_fdrv/sdio_host.h |   39 +
 132 files changed, 67364 insertions(+)
 create mode 100644 drivers/net/wireless/aic/Kconfig
 create mode 100644 drivers/net/wireless/aic/Makefile
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/Kconfig
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/Makefile
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aic8800d80_compat.c
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aic8800d80_compat.h
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aic8800dc_compat.c
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aic8800dc_compat.h
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aic_bsp_driver.c
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aic_bsp_driver.h
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aic_bsp_export.h
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aic_bsp_main.c
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aic_chip_8800d80.c
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aic_chip_8800dc.c
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aic_chip_8801.c
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aic_chip_ops.c
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aic_chip_ops.h
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aicsdio.c
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aicsdio.h
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aicsdio_txrxif.c
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aicsdio_txrxif.h
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aicwf_txq_prealloc.c
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/aicwf_txq_prealloc.h
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/md5.c
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/md5.h
 create mode 100644 drivers/net/wireless/aic/aic8800_bsp/rwnx_version_gen.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/Kconfig
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/Makefile
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aic_br_ext.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aic_br_ext.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aic_bsp_export.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aic_btsdio.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aic_btsdio.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aic_bus.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aic_priv_cmd.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aic_priv_cmd.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aic_vendor.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aic_vendor.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aicwf_chip_8800d80.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aicwf_chip_8800dc.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aicwf_chip_8801.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aicwf_chip_ops.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aicwf_chip_ops.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aicwf_compat_8800d80.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aicwf_compat_8800d80.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aicwf_compat_8800dc.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aicwf_compat_8800dc.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aicwf_debug.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aicwf_genl.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aicwf_genl.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aicwf_rx_prealloc.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aicwf_rx_prealloc.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aicwf_sdio.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aicwf_sdio.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aicwf_tcp_ack.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aicwf_tcp_ack.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aicwf_txrxif.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aicwf_txrxif.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aicwf_wext_linux.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aicwf_wext_linux.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/hal_desc.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/ipc_compat.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/ipc_host.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/ipc_host.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/ipc_shared.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/lmac_mac.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/lmac_msg.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/lmac_types.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/md5.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/md5.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/reg_access.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/regdb.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_bfmer.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_bfmer.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_cfgfile.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_cfgfile.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_cmds.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_cmds.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_compat.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_debugfs.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_debugfs.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_defs.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_events.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_fw_trace.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_fw_trace.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_gki.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_gki.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_irqs.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_irqs.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_main.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_main.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_mesh.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_mesh.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_mod_params.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_mod_params.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_msg_rx.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_msg_rx.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_msg_tx.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_msg_tx.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_mu_group.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_mu_group.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_platform.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_platform.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_prof.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_radar.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_radar.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_rx.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_rx.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_strs.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_strs.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_tdls.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_tdls.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_testmode.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_testmode.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_trace.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_tx.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_tx.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_txq.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_txq.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_utils.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_utils.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_v7.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_v7.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_version.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_version_gen.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_wakelock.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_wakelock.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/sdio_host.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/sdio_host.h


base-commit: ac798f757d6475dc6fee2ec899980d6740714596
