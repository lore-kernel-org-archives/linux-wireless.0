Received: from va-2-42.ptr.blmpb.com (va-2-42.ptr.blmpb.com [209.127.231.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6937E146A66
	for <linux-wireless@vger.kernel.org>; Sat, 29 Aug 2026 08:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787991686; cv=none; b=O4cA1mFCCQP/UONrf76hGINmMXO/D5zbaH57yOOHRoG95VJf875/7mrzLT4HEkR3B43HgYuaerZneQ8VXq2lKaIWm6lF4KvGcbtefe1h9qUa2KvprFTNu6S1ihSBmmSv3g80wsmZFe8QK69+WEpip4nEbECTj7ZRKcD3CRg5OeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787991686; c=relaxed/simple;
	bh=fQgrxZNLgI1zLDJDhGHtQH24OzKse7QdUQZ7qX5sZow=;
	h=Content-Type:To:Subject:Mime-Version:Cc:From:Message-Id:
	 In-Reply-To:Date:References; b=twvsk5MDWBcUbSu8m5fhLse80oyCpWbiAyfK6XCWsmNy2Bs6Hw+rnDz1w5aVvHpTP+EJGgfcNPIooIB9o7KSYreQdZwHfPt6nhWyg7AyndFWsgCJmXhNP4I1+0EAWIcofldDypanj+5a1cUYiKCuYRwRbl+cTm9C+6layoMhVxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bedmex.com; spf=none smtp.mailfrom=bedmex.com; dkim=pass (2048-bit key) header.d=bedmex-com.20200927.dkim.feishu.cn header.i=@bedmex-com.20200927.dkim.feishu.cn header.b=U3DhA054; arc=none smtp.client-ip=209.127.231.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bedmex.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bedmex.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bedmex-com.20200927.dkim.feishu.cn header.i=@bedmex-com.20200927.dkim.feishu.cn header.b="U3DhA054"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=bedmex-com.20200927.dkim.feishu.cn; t=1787991670;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=uVEEQ3qTCp+LMSgZ+XuX2Wb/P6xC1PIY5ncASUVq/xM=;
 b=U3DhA054/QEreIhlHij8qqTuh4GihAztOZhfX0ew8g2PGpHBuQY0K5E/tEI+yZ1eTVhUwN
 Bjzc8q6BL0IIn5Tb8dcTfp8/Q4YELSBbIJ2VYjf2rCScsX36x4B38ic9Ro/yZR5GT3/R1G
 lDqbzQQbArbJiB+MmocFk4SGy49P+Yw/XbybFzzS8zjka504m48bk+FBBW9Gft7g4IBcFO
 XqVnm5Sv5qPSZ1kPh4BMuq6WD/7NfVlZHivBRMIpdIyKmnVF/nrM/xw8lpNL9ciw9/uFhE
 uKEVBrd6y5iF+tINpJKvaK4LIXxgdl63VKlMWKXLo/fdwXosM4XF9GqpQ1GIsw==
Content-Type: text/plain; charset=UTF-8
To: <linux-wireless@vger.kernel.org>
Subject: [RFC PATCH wireless-next v4 0/4] wifi: aic: add AIC8800D80 SDIO FullMAC driver
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Yanli Yang <yanli.yang@bedmex.com>
Cc: "Yanli Yang" <yanli.yang@bedmex.com>, 
	"Johannes Berg" <johannes@sipsolutions.net>, 
	"Zhirun Liu" <zhirunliu@aicsemi.com>, "Dijia Xu" <dijiaxu@aicsemi.com>, 
	"Chunqiu Liu" <chunqiuliu@aicsemi.com>, 
	"Liheng Wei" <liheng.wei@bedmex.com>
Received: from bmxpxe-virtual-desktop.. ([36.141.79.164]) by smtp.feishu.cn with ESMTPS; Sat, 29 Aug 2026 16:21:08 +0800
From: "Yanli Yang" <yanli.yang@bedmex.com>
Message-Id: <cover.1787991457.git.yanli.yang@bedmex.com>
Content-Transfer-Encoding: 7bit
In-Reply-To: <cover.1787903339.git.yanli.yang@bedmex.com>
Date: Sat, 29 Aug 2026 16:21:02 +0800
References: <cover.1787903339.git.yanli.yang@bedmex.com>
X-Lms-Return-Path: <lba+26a929675+d13310+vger.kernel.org+yanli.yang@bedmex.com>
X-Mailer: git-send-email 2.34.1

Johannes,

This v4 fixes the build failure in v3 against current wireless-next.

Commit 914781c72813 ("wifi: cfg80211: convert cookie output to input
parameter") changed the cfg80211 remain_on_channel and mgmt_tx callbacks
from u64 pointer output parameters to preassigned u64 input parameters.
The driver now accepts each cookie by value, carries it through the
remain-on-channel and management-TX state, and reports the same cookie in
the corresponding cfg80211 completion notification.  The obsolete local
remain-on-channel cookie counter has been removed.

This revision also removes two unused global definitions found during the
rebuild.  The feature scope and the status of the outstanding RFC review
items are otherwise unchanged from v3.

Validation performed for v4 against wireless-next at ca800a9302764:

  - x86-64 GCC build with AIC8800_BSP_SUPPORT=m,
    AIC8800_WLAN_SUPPORT=m and W=1;
  - sequential application of all four patches; and
  - comparison of the applied series with the current AIC source tree.

No runtime retest was performed for v4.  The AIC8800D80 U02 SDIO hardware
validation reported with v3 is unchanged.

Changes since v3:

  - rebase on current wireless-next;
  - adapt remain_on_channel and mgmt_tx to cfg80211's cookie-by-value API;
  - preserve cfg80211-assigned cookies through asynchronous completion;
  - remove the obsolete local ROC cookie counter; and
  - remove two unused global definitions.

v3: https://lore.kernel.org/r/cover.1787903339.git.yanli.yang@bedmex.com
v2: https://lore.kernel.org/r/cover.1784724170.git.yanli.yang@bedmex.com
v1: https://lore.kernel.org/r/cover.1784544076.git.yanli.yang@bedmex.com

Zhirun Liu (4):
  wifi: aic: add SDIO BSP and build configuration
  wifi: aic: add FullMAC firmware and platform interface
  wifi: aic: add FullMAC WLAN driver
  wifi: aic: integrate AIC8800 driver

 MAINTAINERS                                   |   10 +
 drivers/net/wireless/Kconfig                  |    1 +
 drivers/net/wireless/Makefile                 |    1 +
 drivers/net/wireless/aic/Kconfig              |   40 +
 drivers/net/wireless/aic/Makefile             |    7 +
 drivers/net/wireless/aic/aic8800_bsp/Kconfig  |    3 +
 drivers/net/wireless/aic/aic8800_bsp/Makefile |   16 +
 .../aic/aic8800_bsp/aic8800d80_compat.c       |  290 +
 .../aic/aic8800_bsp/aic8800d80_compat.h       |   11 +
 .../aic/aic8800_bsp/aic8800dc_compat.c        | 1342 ++++
 .../aic/aic8800_bsp/aic8800dc_compat.h        |   34 +
 .../wireless/aic/aic8800_bsp/aic_bsp_driver.c | 1670 +++++
 .../wireless/aic/aic8800_bsp/aic_bsp_driver.h |  598 ++
 .../wireless/aic/aic8800_bsp/aic_bsp_export.h |   70 +
 .../wireless/aic/aic8800_bsp/aic_bsp_main.c   |  310 +
 .../aic/aic8800_bsp/aic_chip_8800d80.c        |   98 +
 .../aic/aic8800_bsp/aic_chip_8800dc.c         |  133 +
 .../wireless/aic/aic8800_bsp/aic_chip_8801.c  |  117 +
 .../wireless/aic/aic8800_bsp/aic_chip_ops.c   |   64 +
 .../wireless/aic/aic8800_bsp/aic_chip_ops.h   |   69 +
 .../net/wireless/aic/aic8800_bsp/aicsdio.c    | 2027 ++++++
 .../net/wireless/aic/aic8800_bsp/aicsdio.h    |  176 +
 .../wireless/aic/aic8800_bsp/aicsdio_txrxif.c |  464 ++
 .../wireless/aic/aic8800_bsp/aicsdio_txrxif.h |  180 +
 .../aic/aic8800_bsp/aicwf_txq_prealloc.c      |   72 +
 .../aic/aic8800_bsp/aicwf_txq_prealloc.h      |    8 +
 drivers/net/wireless/aic/aic8800_fdrv/Kconfig |   37 +
 .../net/wireless/aic/aic8800_fdrv/Makefile    |   46 +
 .../aic/aic8800_fdrv/aic_bsp_export.h         |   62 +
 .../net/wireless/aic/aic8800_fdrv/aic_bus.h   |  191 +
 .../wireless/aic/aic8800_fdrv/aic_priv_cmd.c  |  763 +++
 .../wireless/aic/aic8800_fdrv/aic_priv_cmd.h  |  103 +
 .../aic/aic8800_fdrv/aicwf_chip_8800d80.c     |  291 +
 .../aic/aic8800_fdrv/aicwf_chip_8800dc.c      |  300 +
 .../aic/aic8800_fdrv/aicwf_chip_8801.c        |  279 +
 .../aic/aic8800_fdrv/aicwf_chip_ops.c         |  251 +
 .../aic/aic8800_fdrv/aicwf_chip_ops.h         |  184 +
 .../aic/aic8800_fdrv/aicwf_compat_8800d80.c   |   96 +
 .../aic/aic8800_fdrv/aicwf_compat_8800d80.h   |   16 +
 .../aic/aic8800_fdrv/aicwf_compat_8800dc.c    |  505 ++
 .../aic/aic8800_fdrv/aicwf_compat_8800dc.h    |   22 +
 .../wireless/aic/aic8800_fdrv/aicwf_debug.h   |   37 +
 .../wireless/aic/aic8800_fdrv/aicwf_genl.c    |  699 +++
 .../wireless/aic/aic8800_fdrv/aicwf_genl.h    |   84 +
 .../aic/aic8800_fdrv/aicwf_rx_prealloc.c      |  102 +
 .../aic/aic8800_fdrv/aicwf_rx_prealloc.h      |   34 +
 .../wireless/aic/aic8800_fdrv/aicwf_sdio.c    | 2831 +++++++++
 .../wireless/aic/aic8800_fdrv/aicwf_sdio.h    |  275 +
 .../wireless/aic/aic8800_fdrv/aicwf_tcp_ack.c |  565 ++
 .../wireless/aic/aic8800_fdrv/aicwf_tcp_ack.h |  104 +
 .../wireless/aic/aic8800_fdrv/aicwf_txrxif.c  |  752 +++
 .../wireless/aic/aic8800_fdrv/aicwf_txrxif.h  |  217 +
 .../net/wireless/aic/aic8800_fdrv/hal_desc.h  |  359 ++
 .../wireless/aic/aic8800_fdrv/ipc_compat.h    |   25 +
 .../net/wireless/aic/aic8800_fdrv/ipc_host.c  |   42 +
 .../net/wireless/aic/aic8800_fdrv/ipc_host.h  |  169 +
 .../wireless/aic/aic8800_fdrv/ipc_shared.h    |  770 +++
 .../net/wireless/aic/aic8800_fdrv/lmac_mac.h  |  437 ++
 .../net/wireless/aic/aic8800_fdrv/lmac_msg.h  | 3101 ++++++++++
 .../wireless/aic/aic8800_fdrv/lmac_types.h    |   22 +
 .../wireless/aic/aic8800_fdrv/reg_access.h    |  146 +
 drivers/net/wireless/aic/aic8800_fdrv/regdb.c | 2772 +++++++++
 .../wireless/aic/aic8800_fdrv/rwnx_bfmer.c    |   93 +
 .../wireless/aic/aic8800_fdrv/rwnx_bfmer.h    |  100 +
 .../wireless/aic/aic8800_fdrv/rwnx_cfgfile.c  |  265 +
 .../wireless/aic/aic8800_fdrv/rwnx_cfgfile.h  |   33 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_cmds.c |  471 ++
 .../net/wireless/aic/aic8800_fdrv/rwnx_cmds.h |   99 +
 .../wireless/aic/aic8800_fdrv/rwnx_compat.h   |   80 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_defs.h |  704 +++
 .../wireless/aic/aic8800_fdrv/rwnx_events.h   |  938 +++
 .../net/wireless/aic/aic8800_fdrv/rwnx_irqs.c |   49 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_irqs.h |   12 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_main.c | 5435 +++++++++++++++++
 .../net/wireless/aic/aic8800_fdrv/rwnx_main.h |   35 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_mesh.c |   33 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_mesh.h |   35 +
 .../aic/aic8800_fdrv/rwnx_mod_params.c        |  985 +++
 .../aic/aic8800_fdrv/rwnx_mod_params.h        |   74 +
 .../wireless/aic/aic8800_fdrv/rwnx_msg_rx.c   | 1614 +++++
 .../wireless/aic/aic8800_fdrv/rwnx_msg_rx.h   |    8 +
 .../wireless/aic/aic8800_fdrv/rwnx_msg_tx.c   | 3619 +++++++++++
 .../wireless/aic/aic8800_fdrv/rwnx_msg_tx.h   |  266 +
 .../wireless/aic/aic8800_fdrv/rwnx_mu_group.c |  653 ++
 .../wireless/aic/aic8800_fdrv/rwnx_mu_group.h |  159 +
 .../wireless/aic/aic8800_fdrv/rwnx_platform.c | 2868 +++++++++
 .../wireless/aic/aic8800_fdrv/rwnx_platform.h |  183 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_prof.h |  142 +
 .../wireless/aic/aic8800_fdrv/rwnx_radar.c    | 1970 ++++++
 .../wireless/aic/aic8800_fdrv/rwnx_radar.h    |  285 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_rx.c   | 2320 +++++++
 .../net/wireless/aic/aic8800_fdrv/rwnx_rx.h   |  358 ++
 .../net/wireless/aic/aic8800_fdrv/rwnx_strs.c |  269 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_strs.h |   31 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_tdls.c |  772 +++
 .../net/wireless/aic/aic8800_fdrv/rwnx_tdls.h |   57 +
 .../wireless/aic/aic8800_fdrv/rwnx_testmode.c |  217 +
 .../wireless/aic/aic8800_fdrv/rwnx_testmode.h |   68 +
 .../wireless/aic/aic8800_fdrv/rwnx_trace.c    |    5 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_tx.c   | 1634 +++++
 .../net/wireless/aic/aic8800_fdrv/rwnx_tx.h   |  178 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_txq.c  | 1362 +++++
 .../net/wireless/aic/aic8800_fdrv/rwnx_txq.h  |  358 ++
 .../wireless/aic/aic8800_fdrv/rwnx_utils.c    |   35 +
 .../wireless/aic/aic8800_fdrv/rwnx_utils.h    |  131 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_v7.c   |  181 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_v7.h   |   21 +
 .../net/wireless/aic/aic8800_fdrv/sdio_host.c |  132 +
 .../net/wireless/aic/aic8800_fdrv/sdio_host.h |   39 +
 109 files changed, 53876 insertions(+)
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
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/Kconfig
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/Makefile
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aic_bsp_export.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aic_bus.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aic_priv_cmd.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aic_priv_cmd.h
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
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/hal_desc.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/ipc_compat.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/ipc_host.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/ipc_host.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/ipc_shared.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/lmac_mac.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/lmac_msg.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/lmac_types.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/reg_access.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/regdb.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_bfmer.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_bfmer.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_cfgfile.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_cfgfile.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_cmds.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_cmds.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_compat.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_defs.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_events.h
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
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/sdio_host.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/sdio_host.h


base-commit: ca800a9302764c445de0da0e84d2252400a770ee
-- 
2.34.1
