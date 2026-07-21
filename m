Received: from va-2-45.ptr.blmpb.com (va-2-45.ptr.blmpb.com [209.127.231.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5626444E04C
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 10:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784629324; cv=none; b=IOWD9525LQanmxhIGsyJ9FY1JHco4c6oV7DheNO4xZdYwNOhVJwz+EkKU3arGgJnXROm44SA0h1urYZ8Gw7S+BKAEK+milBKZldCjQY9RggHqsdshyis4rFY5iKKfYo7oRi29ik+md5zvlCQl7x+SkuiFRmpqaqt+l/COVhciLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784629324; c=relaxed/simple;
	bh=LJCIEwX5GUsO/gMNBO00C73+08jrgbLW0UODWYDCx2w=;
	h=To:From:Date:Message-Id:Content-Type:Cc:Subject:Mime-Version; b=AaPeEKF3Oy3mSHgUaw6lfuuowaJfauqryGSWW8qMm/2Q89bCSSc4W0KFzxelL1253XI9ZP0px0yybzhKu8qFf8szkYRKM74kY0Mh2Fyg+jvLABP7whtoNkY3mhaWfaYEtiGs81E6kgEj/7iO2pu53RdpfPy+eX/yTAcHTEh50XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bedmex.com; spf=none smtp.mailfrom=bedmex.com; dkim=pass (2048-bit key) header.d=bedmex-com.20200927.dkim.feishu.cn header.i=@bedmex-com.20200927.dkim.feishu.cn header.b=00b1zbj7; arc=none smtp.client-ip=209.127.231.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bedmex.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bedmex.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bedmex-com.20200927.dkim.feishu.cn header.i=@bedmex-com.20200927.dkim.feishu.cn header.b="00b1zbj7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=bedmex-com.20200927.dkim.feishu.cn; t=1784629310;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=TnLdBDBcQwtrTDnbCs0P0TAAkG7T/JNv13CPlrVF8uU=;
 b=00b1zbj7nJ8PQhU1OT4c4/7WlMXKrIE7rMk2Tr7HIuqKqhZBVOYWyH37KRcOqAgqGU8HK8
 jmrDiS0LBRJ16wqj8lRDMFNlm72Xufk5uyoFhy/rAxXOQp1dJj2KPbIyT+JY9MdY5djrAB
 uW3bdHBWivkoSRdYT30FN+eyFD4wcBYrHEiFuFgnfDYw8jl6S4DaRUilV7EzNGgKZZ1FoI
 PPWkzymWz36P8fVH4Wt3jOqgnkvNXNcPZhqbKtxQtc9W8IVqYHOKJOQMCwFT4vsL3w5uwz
 w5zbfw5lZMdFgT3MhdOc3bky0+XY4Nx+rdKY3c8CPnonE7fAu7H3Z8gVPNoxdA==
X-Original-From: Yanli Yang <yanli.yang@bedmex.com>
To: <linux-wireless@vger.kernel.org>
From: "Yanli Yang" <yanli.yang@bedmex.com>
Date: Tue, 21 Jul 2026 18:20:59 +0800
Message-Id: <cover.1784544076.git.yanli.yang@bedmex.com>
Content-Type: text/plain; charset=UTF-8
X-Mailer: git-send-email 2.34.1
Received: from bmxpxe-virtual-desktop.. ([36.141.79.164]) by smtp.feishu.cn with ESMTPS; Tue, 21 Jul 2026 18:21:47 +0800
Cc: "Johannes Berg" <johannes@sipsolutions.net>, 
	"Zhirun Liu" <zhirunliu@aicsemi.com>, <dijiaxu@aicsemi.com>, 
	<chunqiuliu@aicsemi.com>, <liheng.wei@bedmex.com>
Subject: [RFC PATCH wireless-next 0/4] wifi: aic: add AIC8800 SDIO FullMAC driver
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a5f483c+97fc00+vger.kernel.org+yanli.yang@bedmex.com>
Content-Transfer-Encoding: 7bit

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

Validation performed for this series:

  - default, W=1 and allmodconfig AIC object builds with GCC 11.4.0;
  - strict checkpatch validation for all four patches;
  - sequential git am application on wireless-next commit ac798f757d6475.

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
 .../aic/aic8800_bsp/aic8800dc_compat.c        | 1353 +++++
 .../aic/aic8800_bsp/aic8800dc_compat.h        |   40 +
 .../wireless/aic/aic8800_bsp/aic_bsp_driver.c | 1659 +++++
 .../wireless/aic/aic8800_bsp/aic_bsp_driver.h |  621 ++
 .../wireless/aic/aic8800_bsp/aic_bsp_export.h |   70 +
 .../wireless/aic/aic8800_bsp/aic_bsp_main.c   |  556 ++
 .../aic/aic8800_bsp/aic_chip_8800d80.c        |  116 +
 .../aic/aic8800_bsp/aic_chip_8800dc.c         |  133 +
 .../wireless/aic/aic8800_bsp/aic_chip_8801.c  |  117 +
 .../wireless/aic/aic8800_bsp/aic_chip_ops.c   |   77 +
 .../wireless/aic/aic8800_bsp/aic_chip_ops.h   |   71 +
 .../net/wireless/aic/aic8800_bsp/aicsdio.c    | 1999 ++++++
 .../net/wireless/aic/aic8800_bsp/aicsdio.h    |  176 +
 .../wireless/aic/aic8800_bsp/aicsdio_txrxif.c |  465 ++
 .../wireless/aic/aic8800_bsp/aicsdio_txrxif.h |  180 +
 .../aic/aic8800_bsp/aicwf_txq_prealloc.c      |   66 +
 .../aic/aic8800_bsp/aicwf_txq_prealloc.h      |    8 +
 drivers/net/wireless/aic/aic8800_bsp/md5.c    |  165 +
 drivers/net/wireless/aic/aic8800_bsp/md5.h    |   77 +
 .../aic/aic8800_bsp/rwnx_version_gen.h        |    5 +
 drivers/net/wireless/aic/aic8800_fdrv/Kconfig |  539 ++
 .../net/wireless/aic/aic8800_fdrv/Makefile    |  117 +
 .../wireless/aic/aic8800_fdrv/aic_br_ext.c    | 1598 +++++
 .../wireless/aic/aic8800_fdrv/aic_br_ext.h    |   72 +
 .../aic/aic8800_fdrv/aic_bsp_export.h         |   62 +
 .../wireless/aic/aic8800_fdrv/aic_btsdio.c    | 1164 ++++
 .../wireless/aic/aic8800_fdrv/aic_btsdio.h    |  472 ++
 .../net/wireless/aic/aic8800_fdrv/aic_bus.h   |  191 +
 .../wireless/aic/aic8800_fdrv/aic_priv_cmd.c  | 1967 ++++++
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
 .../wireless/aic/aic8800_fdrv/aicwf_genl.c    |  932 +++
 .../wireless/aic/aic8800_fdrv/aicwf_genl.h    |  112 +
 .../aic/aic8800_fdrv/aicwf_rx_prealloc.c      |  102 +
 .../aic/aic8800_fdrv/aicwf_rx_prealloc.h      |   32 +
 .../wireless/aic/aic8800_fdrv/aicwf_sdio.c    | 2813 +++++++++
 .../wireless/aic/aic8800_fdrv/aicwf_sdio.h    |  264 +
 .../wireless/aic/aic8800_fdrv/aicwf_tcp_ack.c |  572 ++
 .../wireless/aic/aic8800_fdrv/aicwf_tcp_ack.h |  104 +
 .../wireless/aic/aic8800_fdrv/aicwf_txrxif.c  |  753 +++
 .../wireless/aic/aic8800_fdrv/aicwf_txrxif.h  |  217 +
 .../aic/aic8800_fdrv/aicwf_wext_linux.c       | 1137 ++++
 .../aic/aic8800_fdrv/aicwf_wext_linux.h       |   15 +
 .../net/wireless/aic/aic8800_fdrv/hal_desc.h  |  362 ++
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
 drivers/net/wireless/aic/aic8800_fdrv/regdb.c | 2770 +++++++++
 .../wireless/aic/aic8800_fdrv/rwnx_bfmer.c    |   93 +
 .../wireless/aic/aic8800_fdrv/rwnx_bfmer.h    |  100 +
 .../wireless/aic/aic8800_fdrv/rwnx_cfgfile.c  |  265 +
 .../wireless/aic/aic8800_fdrv/rwnx_cfgfile.h  |   33 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_cmds.c |  471 ++
 .../net/wireless/aic/aic8800_fdrv/rwnx_cmds.h |   99 +
 .../wireless/aic/aic8800_fdrv/rwnx_compat.h   |   93 +
 .../wireless/aic/aic8800_fdrv/rwnx_debugfs.c  | 2585 ++++++++
 .../wireless/aic/aic8800_fdrv/rwnx_debugfs.h  |  134 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_defs.h |  744 +++
 .../wireless/aic/aic8800_fdrv/rwnx_events.h   |  938 +++
 .../wireless/aic/aic8800_fdrv/rwnx_fw_trace.c |   50 +
 .../wireless/aic/aic8800_fdrv/rwnx_fw_trace.h |   28 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_gki.c  |  406 ++
 .../net/wireless/aic/aic8800_fdrv/rwnx_gki.h  |   46 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_irqs.c |   44 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_irqs.h |   12 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_main.c | 5406 +++++++++++++++++
 .../net/wireless/aic/aic8800_fdrv/rwnx_main.h |   34 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_mesh.c |   33 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_mesh.h |   35 +
 .../aic/aic8800_fdrv/rwnx_mod_params.c        | 1295 ++++
 .../aic/aic8800_fdrv/rwnx_mod_params.h        |   70 +
 .../wireless/aic/aic8800_fdrv/rwnx_msg_rx.c   | 1742 ++++++
 .../wireless/aic/aic8800_fdrv/rwnx_msg_rx.h   |    8 +
 .../wireless/aic/aic8800_fdrv/rwnx_msg_tx.c   | 3815 ++++++++++++
 .../wireless/aic/aic8800_fdrv/rwnx_msg_tx.h   |  285 +
 .../wireless/aic/aic8800_fdrv/rwnx_mu_group.c |  646 ++
 .../wireless/aic/aic8800_fdrv/rwnx_mu_group.h |  159 +
 .../wireless/aic/aic8800_fdrv/rwnx_platform.c | 2946 +++++++++
 .../wireless/aic/aic8800_fdrv/rwnx_platform.h |  186 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_prof.h |  142 +
 .../wireless/aic/aic8800_fdrv/rwnx_radar.c    | 1965 ++++++
 .../wireless/aic/aic8800_fdrv/rwnx_radar.h    |  278 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_rx.c   | 2443 ++++++++
 .../net/wireless/aic/aic8800_fdrv/rwnx_rx.h   |  358 ++
 .../net/wireless/aic/aic8800_fdrv/rwnx_strs.c |  268 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_strs.h |   31 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_tdls.c |  776 +++
 .../net/wireless/aic/aic8800_fdrv/rwnx_tdls.h |   57 +
 .../wireless/aic/aic8800_fdrv/rwnx_testmode.c |  217 +
 .../wireless/aic/aic8800_fdrv/rwnx_testmode.h |   68 +
 .../wireless/aic/aic8800_fdrv/rwnx_trace.c    |    5 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_tx.c   | 1805 ++++++
 .../net/wireless/aic/aic8800_fdrv/rwnx_tx.h   |  193 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_txq.c  | 1379 +++++
 .../net/wireless/aic/aic8800_fdrv/rwnx_txq.h  |  372 ++
 .../wireless/aic/aic8800_fdrv/rwnx_utils.c    |   36 +
 .../wireless/aic/aic8800_fdrv/rwnx_utils.h    |  131 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_v7.c   |  182 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_v7.h   |   21 +
 .../wireless/aic/aic8800_fdrv/rwnx_version.h  |   14 +
 .../aic/aic8800_fdrv/rwnx_version_gen.h       |    5 +
 .../wireless/aic/aic8800_fdrv/rwnx_wakelock.c |  109 +
 .../wireless/aic/aic8800_fdrv/rwnx_wakelock.h |   24 +
 .../net/wireless/aic/aic8800_fdrv/sdio_host.c |  132 +
 .../net/wireless/aic/aic8800_fdrv/sdio_host.h |   39 +
 132 files changed, 67273 insertions(+)
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
