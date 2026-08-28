Received: from va-2-54.ptr.blmpb.com (va-2-54.ptr.blmpb.com [209.127.231.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BA9440626
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 12:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787919121; cv=none; b=W/csBGmd/pmpKkrc2KBubgqj4VcxHG5OUcc0Ygy12YhFTzFKYBSiGSiFjHEpWPH2P4tWPYFMyVTaDwbq6AKFhfy2NNWEE2VJTbPccxeaeyWbRhI6G9xvDxaPYhVqtNZy6ahzBOig3I+snhLdxUhcAqrJ6y4HTgzktFLt9RTCKis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787919121; c=relaxed/simple;
	bh=1CSj4vRiti70d2euukXlspxrZzspX+WdIi2uFPC4z3c=;
	h=In-Reply-To:To:Subject:Date:Message-Id:Cc:From:Mime-Version:
	 References:Content-Type; b=Zw3tRIAix2ELPAZ4Gl5j5slZL+gwAUnZH+84HWL+4k5E22ugRd/5hi/p0hG1ICHvL2hzRvUJhSLYsDWzdNk2uyTJnQnfMwLaiAxJhDyixvNs8hJLBk+WXFXrIGk7WCCPgTnks1w7ulFOJjlaOAX3kF6oqgAytZ7QPIcskh4UXng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bedmex.com; spf=none smtp.mailfrom=bedmex.com; dkim=pass (2048-bit key) header.d=bedmex-com.20200927.dkim.feishu.cn header.i=@bedmex-com.20200927.dkim.feishu.cn header.b=knS64IP+; arc=none smtp.client-ip=209.127.231.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bedmex.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bedmex.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bedmex-com.20200927.dkim.feishu.cn header.i=@bedmex-com.20200927.dkim.feishu.cn header.b="knS64IP+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=bedmex-com.20200927.dkim.feishu.cn; t=1787919099;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=YL9uL9tjjh0qTdy6gHAJ5IupAsGoqAfT5kLp/6mr22A=;
 b=knS64IP+Rfl0wbRdFXZncEopRrN7K6pRHZ++xgy6T5vz2sBn8jTr/6xbt4CQ8onBcJh1Jb
 4wY8s2e63piPue+vmVZXKmiObjlz78oYoGgpi7q7JGEaGt5hBxQitZilcEPM14sbMeDnwC
 XIj642tCsWlBLsXn/+s1Ztdr2QkBNS18lfaGe48SMS8qVOC8wqIx/YveuHd2n8wSdmvfQW
 8QtvPdqs7XN7WYoX0tazstVR+PPPXnadSBZwfcvyvfe0CPf3P+r0ZMKkprm8SSoj04et+f
 ECjTtY92nVE4OYlehzavRt1gy04iwHBB4y0b5q1Rr65ZhVeyES/tLPOe/yie2w==
Received: from bmxpxe-virtual-desktop.. ([36.141.79.164]) by smtp.feishu.cn with ESMTPS; Fri, 28 Aug 2026 20:11:36 +0800
In-Reply-To: <007a0362a36d2318ea7a50c6feb8ad2ce1361c0d.camel@sipsolutions.net>
X-Lms-Return-Path: <lba+26a917af9+098ed9+vger.kernel.org+yanli.yang@bedmex.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: [RFC PATCH wireless-next v3 0/4] wifi: aic: add AIC8800D80 SDIO FullMAC driver
Date: Fri, 28 Aug 2026 20:11:29 +0800
Message-Id: <cover.1787903339.git.yanli.yang@bedmex.com>
X-Original-From: Yanli Yang <yanli.yang@bedmex.com>
Cc: <linux-wireless@vger.kernel.org>, "Zhirun Liu" <zhirunliu@aicsemi.com>, 
	"Dijia Xu" <dijiaxu@aicsemi.com>, "Chunqiu Liu" <chunqiuliu@aicsemi.com>, 
	"Liheng Wei" <liheng.wei@bedmex.com>
From: "Yanli Yang" <yanli.yang@bedmex.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1784724170.git.yanli.yang@bedmex.com> <ef855527f564086a498e95d31a35935762fa60e1.camel@sipsolutions.net> <007a0362a36d2318ea7a50c6feb8ad2ce1361c0d.camel@sipsolutions.net>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8

Johannes,

Thank you for the detailed review of v2.  This RFC updates the AIC8800
driver based on that feedback and narrows the initial upstream target to
the AIC8800D80 U02 SDIO station path.

Compared with v2, the AIC directory is reduced from 132 to 109 submitted
files and from 67,352 to 53,879 lines.  The Kconfig interface is reduced
to nine symbols and no longer exposes the old-kernel, GKI, Bluetooth,
bridge, Android or other downstream build variants.

For ease of comparison with the v2 review, the status of each item is
listed below in the same order and under the same headings.  "Addressed"
means the reported interface or implementation has been removed or
replaced in v3.  "Partly addressed" and "Open" items are not claimed as
fixed by this RFC.

Custom/duplicate userspace ABIs (hard blockers)

  - Private generic-netlink interface -- Open.  aicwf_genl.c and
    aicwf_genl.h, providing the string-based AICWF_NL family, remain as
    the optional AIC8800_GENL build.  We have confirmed this point. 
    The implementation uses the unmodified in-kernel
    genl_family API, and deployed customer userspace already issues
    commands through this interface.  Therefore we considers
    these files necessary: deleting them would require a substantial,
    coordinated change to existing userspace and is not feasible for this
    revision.  We nevertheless understand that use of the standard
    generic-netlink transport does not by itself answer the upstream
    objection to an additional private, string-based userspace ABI.  This
    item therefore remains open rather than being claimed as fixed.

  - Android priv_cmd ioctl interpreter -- Partly addressed.  The netdev
    ioctl entry point, android_priv_cmd(), struct android_wifi_priv_cmd,
    and all ifr_data handling have been removed.  aic_priv_cmd.c was
    reduced from about 2,000 to 766 lines and is no longer reachable
    through that ioctl ABI.  After reviewing the reduced implementation,
    we confirmed that the remaining command set and its firmware
    helpers are required and must be retained.  This revision therefore
    keeps aic_priv_cmd.c in its reduced form.  The remaining commands
    still need a per-command upstream review to determine whether any can
    use nl80211/cfg80211, cfg80211 testmode or a narrowly scoped vendor
    command instead.

  - cfg80211 internals reimplementation/GKI shim -- Addressed.  rwnx_gki.c
    was removed.  The driver no longer includes net/wireless/core.h,
    declares a private nl80211 family, reimplements cfg80211 helpers, or
    uses the invalid include/linux/types.h include path.

  - Legacy Wireless Extensions layer -- Addressed.  aicwf_wext_linux.c
    and AIC8800_USE_WIRELESS_EXT were removed; the submitted build uses
    cfg80211/nl80211.

  - procfs suspend control -- Addressed.  The "suspend" procfs node and
    AIC8800_WIFI_SUSPEND_FOR_LINUX path were removed.  Suspend and resume
    are now connected through struct dev_pm_ops on the SDIO drivers.

  - Vendor-HAL grab-bag with stubs -- Addressed.  aic_vendor.c and its
    keep-alive, APF, ring-buffer and wake-reason stub interfaces were
    removed.

Kconfig / Makefile

  - Config explosion -- Partly addressed.  The visible and hidden Kconfig
    interface was reduced from more than 50 symbols to nine, and the
    *_FOR_OLD_KERNEL, RWNX_TL4, RWNX_OLD_IPC, AIC8800_GKI,
    AIC8800_BR_SUPPORT, AIC8800_SDIO_BT and other downstream switches are
    no longer present or hidden behind BROKEN.  The submitted build is
    restricted to the AIC8800D80 U02 SDIO station path.  Some source for
    unselected chips/modes and disabled conditional branches still
    remains; it will be deleted rather than exposed as more Kconfig
    switches.

  - ccflags-$(CONFIG_x) += -DCONFIG_y -- Open.  The number of such defines
    was reduced, but the Makefiles still define CONFIG_SDIO_PWRCTRL,
    CONFIG_RWNX_FULLMAC and several driver-local feature macros.  The
    remaining real choices need to use Kconfig symbols/IS_ENABLED(), and
    fixed properties of the initial baseline need ordinary internal
    constants after the disabled branches are removed.

Structural

  - BSP/fdrv split with a private exported ABI -- Open.  The two modules
    and cross-module exports, including aicbsp_set_subsys(),
    aicbsp_get_feature(), get_sdio_func() and set_irq_handler(), remain.
    They need to become one cleanly layered driver, with the transport
    and device lifecycle internal to it and the private exports removed.

  - Bluetooth over SDIO -- Addressed.  aic_btsdio.c, its private character
    device and AIC8800_SDIO_BT were removed from the series.

  - br_ext repeater bridge -- Addressed.  aic_br_ext.c and
    AIC8800_BR_SUPPORT were removed.

  - Reinvented in-tree infrastructure -- Partly addressed.  Both bundled
    md5.c copies were replaced by CRYPTO_LIB_MD5, and rwnx_wakelock.c was
    removed.  The private regdb.c/self-managed regulatory path remains.
    The RX, TX-queue and reserved-memory preallocation sources or disabled
    branches, and the TCP-ACK filtering source, also remain in the tree,
    although their feature macros are not enabled by the submitted build.
    These remaining implementations must be removed and the normal kernel
    regulatory and allocation infrastructure used.

Portability / style

  - Kernel-version and Android compatibility shims -- Partly addressed.
    The LINUX_VERSION_CODE/HIGH_KERNEL_VERSION/ANDROID_PLATFORM branches
    were removed and the submitted code targets current wireless-next.
    rwnx_compat.h still exists with current-kernel aliases and an obsolete
    old-kernel comment; those aliases and the stale wrapper structure
    still need cleanup.

  - Private _l typedefs -- Addressed.  u8_l, u16_l and bool_l were removed,
    including the erroneous u16 definition of u8_l.  The code now uses
    kernel fixed-width types.

  - Too many module parameters -- Open.  Debug levels, SDIO queue/thread
    tuning, country_code/ccode_channels, saved_sdk_ver and many FullMAC
    feature parameters remain.  Policy/configuration parameters must be
    removed or replaced by standard nl80211, cfg80211 or firmware/DT
    interfaces where appropriate.

  - Generated version headers -- Addressed.  The duplicated
    rwnx_version_gen.h files and their generated branch/release strings
    were removed.

  - Dead/commented code and busy waits -- Partly addressed.  The
    msleep(2000) private-command path and some dead/commented code were
    removed, but mdelay(100) remains in rwnx_msg_tx.c, other busy waits
    remain, and further dead/commented source still needs deletion.  Each
    remaining delay must be audited and changed to a sleepable wait where
    its calling context permits.

In short, v3 removes the GKI/cfg80211 reimplementation, Wireless
Extensions, procfs control, vendor-HAL stubs, Bluetooth character device,
bridge extension, bundled MD5, private wakelocks, private _l types and
generated version headers.  Following confirmation, it
retains the private generic-netlink interface and the reduced private
command implementation because deployed customer userspace depends on
them and removal requires a substantial coordinated userspace change.
This dependency does not resolve the upstream ABI objection.  The module
split/private exports, Makefile CONFIG_* defines, private regulatory
implementation and module-parameter cleanup also remain open.  Those
unresolved hard blockers are why this remains an RFC.

Validation performed for v3 against wireless-next at ac798f757d6475:

  - x86-64 GCC 15.2.0 module build with AIC8800_BSP_SUPPORT=m,
    AIC8800_WLAN_SUPPORT=m and AIC8800_GENL=y using W=1;
  - scripts/checkpatch.pl, sparse and coccicheck, with no new compiler or
    sparse warnings;
  - sequential application of all four patches; and
  - comparison of the generated patch snapshot with the current AIC
    source directory.

Runtime validation was performed on AIC8800D80 U02 SDIO hardware with
firmware fmacfw_8800d80_u02.bin v6.9.1.1.  The following tests passed:

  - driver probe/firmware boot and module unload/reload, 50 iterations
    each;
  - active and passive scanning on 2.4 and 5 GHz;
  - station mode with open, WPA2-PSK and WPA3-SAE networks;
  - disconnect/reconnect, 50 iterations, and IPv4/IPv6 connectivity;
  - TCP TX/RX throughput of 196/210 Mbps on 2.4 GHz and 375/445 Mbps on
    5 GHz;
  - UDP TX/RX throughput of 218/225 Mbps on 2.4 GHz and 422/511 Mbps on
    5 GHz;
  - suspend/resume, 50 iterations, and rfkill; and
  - 10 hours of continuous traffic.

No crashes, warnings, lockdep reports or firmware crashes were observed
in the kernel log.  Built-in and Clang builds, smatch and AP mode were not
tested.  Firmware redistribution permission and DT power/wake bindings
also remain outstanding.

Please review whether the changes made so far meet the upstream community
requirements.  Since this revision is based on a refreshed set of
commits, I would also appreciate another review for regressions or any
additional issues exposed by the new changes.

---
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
 .../aic/aic8800_bsp/aic8800d80_compat.c       |  292 +
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
 .../wireless/aic/aic8800_fdrv/aic_priv_cmd.c  |  766 +++
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
 .../net/wireless/aic/aic8800_fdrv/rwnx_main.c | 5439 +++++++++++++++++
 .../net/wireless/aic/aic8800_fdrv/rwnx_main.h |   35 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_mesh.c |   33 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_mesh.h |   35 +
 .../aic/aic8800_fdrv/rwnx_mod_params.c        |  985 +++
 .../aic/aic8800_fdrv/rwnx_mod_params.h        |   74 +
 .../wireless/aic/aic8800_fdrv/rwnx_msg_rx.c   | 1620 +++++
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
 .../net/wireless/aic/aic8800_fdrv/rwnx_tdls.c |  773 +++
 .../net/wireless/aic/aic8800_fdrv/rwnx_tdls.h |   57 +
 .../wireless/aic/aic8800_fdrv/rwnx_testmode.c |  217 +
 .../wireless/aic/aic8800_fdrv/rwnx_testmode.h |   68 +
 .../wireless/aic/aic8800_fdrv/rwnx_trace.c    |    5 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_tx.c   | 1635 +++++
 .../net/wireless/aic/aic8800_fdrv/rwnx_tx.h   |  176 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_txq.c  | 1362 +++++
 .../net/wireless/aic/aic8800_fdrv/rwnx_txq.h  |  358 ++
 .../wireless/aic/aic8800_fdrv/rwnx_utils.c    |   35 +
 .../wireless/aic/aic8800_fdrv/rwnx_utils.h    |  131 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_v7.c   |  181 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_v7.h   |   21 +
 .../net/wireless/aic/aic8800_fdrv/sdio_host.c |  132 +
 .../net/wireless/aic/aic8800_fdrv/sdio_host.h |   39 +
 109 files changed, 53891 insertions(+)
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


base-commit: ac798f757d6475dc6fee2ec899980d6740714596
-- 
2.34.1
