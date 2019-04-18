Return-Path: <SRS0=x8ok=SU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8F32C10F0E
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 13:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 904B82083D
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 13:48:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kHp+hvgK";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WzVMy/qM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388902AbfDRNs0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:48:26 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59832 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727807AbfDRNs0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Apr 2019 09:48:26 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9625660265; Thu, 18 Apr 2019 13:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555595304;
        bh=0/AKpzArhzKtM9lEGvPwab+lvTQFSCr5egiCgHuBSuA=;
        h=From:To:Cc:Subject:Date:From;
        b=kHp+hvgKUxKZuo3wBELosRo971ggTF88lpK7YqoT/EN8T7GgQxfCHbmaFnR/nLESs
         P4AS0Nrc0mHSby0seSXR/8TQbh6GrUwJL70iTufg6hXii125Y/P6YK652TP5D0hTl1
         /SpgNZFjtVOo8EVVXb/x7Z0vlNTt+2/8V5NN63l4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 801DC60265;
        Thu, 18 Apr 2019 13:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555595303;
        bh=0/AKpzArhzKtM9lEGvPwab+lvTQFSCr5egiCgHuBSuA=;
        h=From:To:Cc:Subject:Date:From;
        b=WzVMy/qMtD/4D3+cl6Q8w6Uc4G0KkhXEGsLa0nNVnpUB7SafPB6gfM1vlshfRKglc
         LI4oAOLuTWMYqnbJI/5/AN6f78MhYjhZ6uOw2NGHEliYxKJng2CiCT8iKnokcuw+YF
         QDF92WIHlVNDiOsuZkiX1LU2m2XlZ5eqPleSteZ0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 801DC60265
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers-next 2019-04-18
Date:   Thu, 18 Apr 2019 16:48:20 +0300
Message-ID: <87sguf2zmj.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

here's a pull request to net-next for v5.2, more info below. But do note
that this time we have two trivial conflicts in iwlwifi, here are
Stephen's example resolutions:

https://lkml.kernel.org/r/20190415120133.40c0f343@canb.auug.org.au

https://lkml.kernel.org/r/20190415120853.39e0e46a@canb.auug.org.au

The only change to Stephen's resolution I recommend is to have in drv.c
an empty line between group 0x2723 and group 0x1a56, but that's just
cosmetic anyway so it doesn't matter really in the end.

As always, please do let me know if there any problems.

Kalle

The following changes since commit 35f861e3c58e128f0ecb5669c43159285ea5254a:

  net: bridge: use netif_is_bridge_port() (2019-03-29 13:48:40 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next=
.git tags/wireless-drivers-next-for-davem-2019-04-18

for you to fetch changes up to b5250c9c14c139f467a935a4b7edfcf202772c52:

  rtlwifi: rtl8188ee: Remove extraneous file (2019-04-18 16:08:23 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for 5.2

Nothing really special standing out this time, iwlwifi being the most
active driver.

Major changes:

iwlwifi

* send NO_DATA events so they can be captured in radiotap

* support for multiple BSSID

* support for some new FW API versions

* support new hardware

* debugfs cleanups by Greg-KH

qtnfmac

* allow each MAC to specify its own regulatory rules

----------------------------------------------------------------
Arnd Bergmann (1):
      b43: shut up clang -Wuninitialized variable warning

Avraham Stern (1):
      iwlwifi: mvm: use correct GP2 register address for 22000 family

Colin Ian King (2):
      iwlegacy: remove redundant assignment to *res
      brcmfmac: fix leak of mypkt on error return path

Dan Carpenter (1):
      mwifiex: add a bounds check in mwifiex_process_sta_rx_packet()

Greg Kroah-Hartman (2):
      iwlwifi: mvm: no need to check return value of debugfs_create functio=
ns
      iwlwifi: pcie: no need to check return value of debugfs_create functi=
ons

Gustavo A. R. Silva (2):
      qtnfmac: replace qtnf_cmd_acl_data_size() with struct_size()
      brcmfmac: Use struct_size() in kzalloc()

Igor Mitsyanko (10):
      qtnfmac: make regulatory notifier work on per-phy basis
      qtnfmac: simplify error reporting in regulatory notifier
      qtnfmac: include full channels info to regulatory notifier
      qtnfmac: pass complete channel info in regulatory notifier
      qtnfmac: flexible regulatory domain registration logic
      qtnfmac: allow each MAC to specify its own regulatory rules
      qtnfmac: pass DFS region to firmware on region update
      qtnfmac: update bands information on CHANGE_INTF command
      qtnfmac: send EAPOL frames via control path
      qtnfmac: use scan duration param for different scan types

Ihab Zhaika (1):
      iwlwifi: remove misconfigured pci ids from 22260 series

Ilan Peer (1):
      iwlwifi: mvm: Support new format of SCAN_OFFLOAD_PROFILES_QUERY_RSP

Jeff Xie (1):
      rtlwifi: move spin_lock_bh to spin_lock in tasklet

Johannes Berg (5):
      iwlwifi: mvm: report all NO_DATA events to mac80211
      iwlwifi: mvm: enable HT/VHT IBSS
      iwlwifi: pcie: switch to correct RBD/CD layout for 22560
      iwlwifi: mvm: IBSS: use BE FIFO for multicast
      iwlwifi: mvm: remove buggy and unnecessary hw_queue initialization

Kalle Valo (2):
      Merge tag 'iwlwifi-next-for-kalle-2019-03-22' of git://git.kernel.org=
/.../iwlwifi/iwlwifi-next
      Merge tag 'iwlwifi-next-for-kalle-2019-04-03' of git://git.kernel.org=
/.../iwlwifi/iwlwifi-next

Kangjie Lu (3):
      brcmfmac: fix missing checks for kmemdup
      net: mwifiex: fix a NULL pointer dereference
      rtlwifi: fix a potential NULL pointer dereference

Larry Finger (3):
      rtlwifi: Fix duplicate tests of one of the RX descriptors
      rtlwifi: Convert the wake_match variable to local
      rtlwifi: rtl8188ee: Remove extraneous file

Liad Kaufman (1):
      iwlwifi: mvm: fix pointer reference when setting HE QAM thres

Luca Coelho (1):
      iwlwifi: remove unnecessary goto out in iwl_parse_nvm_mcc_info()

Mordechay Goodstein (1):
      iwlwifi: mvm: set max amsdu for TLC offload

Ondrej Jirman (1):
      brcmfmac: Loading the correct firmware for brcm43456

Ping-Ke Shih (1):
      rtlwifi: fix potential NULL pointer dereference

Piotr Figiel (7):
      brcmfmac: fix WARNING during USB disconnect in case of unempty psq
      brcmfmac: fix NULL pointer derefence during USB disconnect
      brcmfmac: fix race during disconnect when USB completion is in progre=
ss
      brcmfmac: remove pending parameter from brcmf_usb_free_q
      brcmfmac: remove unused variable i from brcmf_usb_free_q
      brcmfmac: fix Oops when bringing up interface during USB disconnect
      brcmfmac: convert dev_init_lock mutex to completion

Rafa=C5=82 Mi=C5=82ecki (3):
      brcmfmac: support repeated brcmf_fw_alloc_request() calls
      brcmfmac: add a function designated for handling firmware fails
      brcmfmac: reset PCIe bus on a firmware crash

Sara Sharon (8):
      iwlwifi: mvm: report delayed beacon count to FW
      iwlwifi: mvm: implement CSA abort
      iwlwifi: mvm: track CSA beacons
      iwlwifi: mvm: notify FW on quiet mode in CSA
      iwlwifi: mvm: disconnect in case of bad channel switch parameters
      iwlwifi: mvm: track changes in beacon count during channel switch
      iwlwifi: mvm: support multiple BSSID
      iwlwifi: mvm: support HE context cmd API change

Sergey Matyukevich (3):
      qtnfmac: fix core attach error path in pcie backend
      qtnfmac: simplify firmware state tracking
      qtnfmac: allow changing the netns

Shahar S Matityahu (19):
      iwlwifi: dbg: use dump mask for tx command dumping length
      iwlwifi: mvm: use dump worker during restart instead of sync dump
      iwlwifi: dbg: add DRAM monitor support for AX210 device family
      iwlwifi: dbg_ini: separate between ini and legacy dump flows
      iwlwifi: dbg_ini: align to FW api version 1
      iwlwifi: dbg_ini: support HW error trigger
      iwlwifi: dbg_ini: enforce always on domain checking
      iwlwifi: dbg_ini: fix iwl_dump_ini_dev_mem_iter memory base address
      iwlwifi: dbg_ini: add memory offset to the base address of a memory r=
egion
      iwlwifi: dbg_ini: add version to dump header
      iwlwifi: dbg_ini: add region id to the region dump
      iwlwifi: dbg_ini: add registers addresses in fifo dump
      iwlwifi: dbg_ini: change memory range base address to u64
      iwlwifi: dbg_ini: fix the dram monitor header size
      iwlwifi: dbg_ini: add monitor header to smem monitor
      iwlwifi: dbg_ini: remove redundant curly brackets from trigger collec=
tion flow
      iwlwifi: dbg_ini: remove redundant type argument from iwl_dump_ini_mem
      iwlwifi: dbg_ini: apply rx fifo offset after reading the region regis=
ters
      iwlwifi: dbg: fill radio registers data regardless of fifos data dump=
ing

Shaul Triebitz (6):
      iwlwifi: mvm: be more forgiving if num of channels is too big
      iwlwifi: add support for 6-7 GHz channels
      iwlwifi: support new NVM response API
      iwlwifi: for AX210 device support radio GF4
      iwlwifi: trust calling function
      iwlwifi: set 512 TX queue slots for AX210 devices

YueHaibing (3):
      iwlwifi: Use struct_size() in kzalloc
      mwifiex: Fix mem leak in mwifiex_tm_cmd
      rtlwifi: rtl8723ae: Make rtl8723e_dm_refresh_rate_adaptive_mask static

 drivers/net/wireless/broadcom/b43/phy_lp.c         |   6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    |  11 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.h    |   6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |   8 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  12 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   4 +
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  36 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   2 +
 .../broadcom/brcm80211/brcmfmac/firmware.c         |   5 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |  58 +--
 .../broadcom/brcm80211/brcmfmac/fwsignal.h         |   3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  37 +-
 .../wireless/broadcom/brcm80211/brcmfmac/proto.c   |  10 +-
 .../wireless/broadcom/brcm80211/brcmfmac/proto.h   |   3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   8 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  44 +--
 drivers/net/wireless/intel/iwlegacy/4965.c         |   1 -
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |  22 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |  10 +-
 .../net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h    | 177 ++++++---
 drivers/net/wireless/intel/iwlwifi/fw/api/mac.h    |  77 +++-
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |  39 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |  67 +---
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |  54 ++-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        | 426 ++++++++++++++---=
----
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |  27 +-
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h |  39 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |  12 +
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |  13 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |  10 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 146 ++++---
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |   6 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  90 ++++-
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |  17 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  91 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  47 +--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 228 ++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  32 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  23 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |  44 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  31 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  25 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c      |   7 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |  12 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  11 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  37 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |  14 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  48 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   6 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   6 +-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |   6 +
 drivers/net/wireless/marvell/mwifiex/sta_rx.c      |   3 +-
 drivers/net/wireless/quantenna/qtnfmac/bus.h       |  25 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |  86 ++---
 drivers/net/wireless/quantenna/qtnfmac/commands.c  | 377 +++++++++---------
 drivers/net/wireless/quantenna/qtnfmac/commands.h  |   6 +-
 drivers/net/wireless/quantenna/qtnfmac/core.c      |  56 ++-
 drivers/net/wireless/quantenna/qtnfmac/core.h      |   5 +-
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c |  32 +-
 .../wireless/quantenna/qtnfmac/pcie/pcie_priv.h    |   3 +-
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   |  23 +-
 .../wireless/quantenna/qtnfmac/pcie/topaz_pcie.c   |  31 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     |  85 ++--
 .../net/wireless/quantenna/qtnfmac/qlink_util.c    | 117 ++++++
 .../net/wireless/quantenna/qtnfmac/qlink_util.h    |   5 +
 drivers/net/wireless/realtek/rtlwifi/base.c        |   5 +
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/fw.c    |   2 +
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.c   |  17 +-
 .../wireless/realtek/rtlwifi/rtl8192c/fw_common.c  |   2 +
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    |   2 +
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   |  15 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/dm.c    |   2 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/fw.c    |   2 +
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.c    |   2 +
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.c   |  16 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    |   4 +
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.c   |  14 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |   1 -
 85 files changed, 1980 insertions(+), 1143 deletions(-)
