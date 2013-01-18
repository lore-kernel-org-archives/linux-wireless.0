Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:45771 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab3ARIjw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 03:39:52 -0500
Message-ID: <1358498334.6252.75.camel@cumari.coelho.fi> (sfid-20130118_093956_643133_2C07A8B9)
Subject: pull request: TI wireless drivers 2013-01-17 v2 (for 3.9)
From: Luciano Coelho <coelho@ti.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Date: Fri, 18 Jan 2013 10:38:54 +0200
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-LLMftS0v14UajKBYsgEo"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-LLMftS0v14UajKBYsgEo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

This is v2 of the pull request I sent yesterday.  The only difference is
that I fixed my merge and removed a stray __devexit from wl12xx/main.c.


Lots of bugfixes and improvements in our TI wireless drivers,
including support for multi-channel.  Intended for 3.9.

There is a lot of patches.  This is because I couldn't do integration
for a while and then we missed the 3.8 window.

Please let me know if you have any problems with it!


The following changes since commit 660b9caaad380758c756a7e60397e33dab44fe3f=
:

  bcma: use consistent case for 'hex' constants (2013-01-14 15:10:41 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linvill=
e

for you to fetch changes up to 5b37649bbcfc14c1ecfb76c5b018dd686924b946:

  Merge branch 'wl12xx-next' into for-linville (2013-01-18 09:59:08 +0200)

----------------------------------------------------------------

Arik Nemtsov (23):
      wlcore: use new set bandwidth command to adjusting channel BW
      wlcore/wl18xx/wl12xx: separate channel count between chips
      wlcore/wl12xx: make sure session id is always zero for AP
      wlcore: clear roc_vif on iface removal
      wlcore: take the mutex before resetting Tx queues
      wlcore: consolidate free_link and always call it
      wlcore: initialize per-link FW freed blocks correctly
      wlcore: track wlvif inside per-link structure
      wlcore: count packets held per AC in each vif
      wlcore: track FW-allocated packets per link
      wlcore: improved Tx scheduling algorithm
      wl18xx: set last Tx rate from FW status
      wlcore: remove support for injected Tx
      wlcore: improve handling for Rx errors
      wlcore: set 5Ghz probe-req template for DFS channels
      wlcore/wl18xx: change priority calculations for links
      wl18xx: limit Tx for the AP single-STA-in-PSM case
      wlcore: use link count for single-STA-PSM optimization
      wlcore: use separate HW queue for each AC in each vif
      wlcore: don't take mutex before stopping queues
      wlcore: consolidate Rx BA bitmap management to links struct
      wl18xx: support MIMO only if HT mode is not forced to SISO
      wl18xx: count HW block spare based correctly on keys

Chuansheng Liu (1):
      wlcore: Fix the usage of wait_for_completion_timeout

Eliad Peller (36):
      wlcore: start sta role on CHANGED_BSSID
      wlcore: workaround start_sta problem in wl12xx fw
      wlcore: implement .remain_on_channel() callback
      wlcore: get channel from bss_conf instead of hw->conf
      wlcore: add chanctx implementation
      wlcore: initiate ROC/CROC on sta state updates
      wlcore: set active psm on association
      wlcore: specify correct supported_rates
      wlcore: reconfigure rate policy on association
      wlcore: refactor CHANGED_HT handling
      wlcore: configure the remote rates with our own rates
      wlcore: print role_id on bss_info_changed
      wlcore: don't leak wl->mbox
      wlcore: don't call ieee80211_sched_scan_stopped directly
      wlcore: make scan scan configuration functions more generic
      wl18xx: change fw name and temporarily fail loading
      wlcore: update commands enum to new fw api
      wlcore: split 18xx and 12xx scan mechanism
      wl18xx: increase MAX_CHANNELS_5GHZ
      wlcore: update acx enum
      wlcore: update channel_switch/stop_channel_switch commands
      wlcore: update events enum/struct to new fw api
      wlcore: pass wmm configuration to the fw
      wlcore: save session_id per-link
      wlcore: call ieee80211_sched_scan_stopped on interface removal
      wl18xx: make driver operational again
      wlcore: configure dwell times according to scan type
      wlcore: don't stop fwlog if dbgpins are used
      wlcore: use sta_state-based ROCs for AP mode
      wlcore: mask out CCK rates when starting GO
      wlcore: move ps change handling to .bss_info_changed()
      wlcore: allow fw commands to fail
      wlcore: allow ACX_BA_SESSION_RX_SETUP to fail
      wlcore: remove WLCORE_QUIRK_NO_ELP
      wl18xx: declare support for greenfield ht_cap
      wlcore: add ACX_PEER_CAP command

Eyal Shapira (2):
      wlcore: increase scan dwell times if no activity
      wlcore: support scan reports during periodic scan

Ido Reis (1):
      wl18xx: update default mac/phy parameters

Ido Yariv (1):
      wlcore: Always pass DMA-able buffers to mmc functions

Janusz.Dziedzic@tieto.com (1):
      wlcore: SPI - fix spi transfer_list

Julia Lawall (1):
      drivers/net/wireless/ti/wlcore/main.c: eliminate possible double powe=
r off

Kees Cook (1):
      drivers/net/wireless/ti/wl1251: remove CONFIG_EXPERIMENTAL

Luciano Coelho (11):
      wlcore: avoid using goto in normal code flow
      wlcore: remove a bunch of unnecessary parentheses
      wlcore: gather information about firmware stability
      wlcore/wl12xx: move wl12xx chip ID defines to the lower driver
      wlcore/wl12xx: remove deprecated FW version check
      wlcore: change way of checking the firmware version
      wl12xx: ignore some of the firmware version fields
      wlcore/wl12xx/wl18xx: verify multi-role and single-role fw versions
      wl18xx: ignore irrelevant firmware version fields
      Merge branch 'wl12xx-next' into for-linville
      Merge branch 'wl12xx-next' into for-linville

Tushar Behera (1):
      wlcore: Remove redundant check on unsigned variable

Victor Goldenshtein (3):
      wlcore: add new reg-domain configuration command
      wlcore: remove unnecessary WARN_ON in wl12xx_tx_reset
      wlcore: restore default channel configuration

Wei Yongjun (2):
      wlcore: spi: use platform_device_unregister in wl1271_remove()
      wlcore: sdio: use platform_device_unregister in wl1271_remove()

Yair Shapira (3):
      wlcore/wl18xx/wl12xx: add recovery settings to conf
      wl18xx: support 2nd set of mac/phy tx-power params
      wl18xx: fix a bug in wl->num_rx_desc initialization

 drivers/net/wireless/ti/wl1251/Kconfig    |    2 +-
 drivers/net/wireless/ti/wl12xx/Makefile   |    2 +-
 drivers/net/wireless/ti/wl12xx/cmd.c      |   37 ++
 drivers/net/wireless/ti/wl12xx/cmd.h      |   20 +
 drivers/net/wireless/ti/wl12xx/event.c    |  116 ++++
 drivers/net/wireless/ti/wl12xx/event.h    |  111 ++++
 drivers/net/wireless/ti/wl12xx/main.c     |  192 +++++--
 drivers/net/wireless/ti/wl12xx/scan.c     |  501 +++++++++++++++++
 drivers/net/wireless/ti/wl12xx/scan.h     |  140 +++++
 drivers/net/wireless/ti/wl12xx/wl12xx.h   |   40 +-
 drivers/net/wireless/ti/wl18xx/Makefile   |    2 +-
 drivers/net/wireless/ti/wl18xx/acx.c      |   87 ++-
 drivers/net/wireless/ti/wl18xx/acx.h      |   55 +-
 drivers/net/wireless/ti/wl18xx/cmd.c      |   80 +++
 drivers/net/wireless/ti/wl18xx/cmd.h      |   52 ++
 drivers/net/wireless/ti/wl18xx/conf.h     |   21 +-
 drivers/net/wireless/ti/wl18xx/event.c    |  111 ++++
 drivers/net/wireless/ti/wl18xx/event.h    |   77 +++
 drivers/net/wireless/ti/wl18xx/main.c     |  267 +++++++--
 drivers/net/wireless/ti/wl18xx/scan.c     |  326 +++++++++++
 drivers/net/wireless/ti/wl18xx/scan.h     |  127 +++++
 drivers/net/wireless/ti/wl18xx/tx.c       |   54 +-
 drivers/net/wireless/ti/wl18xx/wl18xx.h   |   50 +-
 drivers/net/wireless/ti/wlcore/acx.c      |   15 +-
 drivers/net/wireless/ti/wlcore/acx.h      |    1 -
 drivers/net/wireless/ti/wlcore/boot.c     |   77 ++-
 drivers/net/wireless/ti/wlcore/cmd.c      |  419 +++++++++-----
 drivers/net/wireless/ti/wlcore/cmd.h      |   81 ++-
 drivers/net/wireless/ti/wlcore/conf.h     |  110 +++-
 drivers/net/wireless/ti/wlcore/debugfs.c  |   10 +-
 drivers/net/wireless/ti/wlcore/event.c    |  326 +++++------
 drivers/net/wireless/ti/wlcore/event.h    |   99 +---
 drivers/net/wireless/ti/wlcore/hw_ops.h   |   41 ++
 drivers/net/wireless/ti/wlcore/init.c     |   19 +-
 drivers/net/wireless/ti/wlcore/io.h       |   12 +-
 drivers/net/wireless/ti/wlcore/main.c     | 1589 +++++++++++++++++++++++++=
+++++++++--------------------
 drivers/net/wireless/ti/wlcore/ps.c       |   11 +-
 drivers/net/wireless/ti/wlcore/rx.c       |   33 +-
 drivers/net/wireless/ti/wlcore/rx.h       |    3 +-
 drivers/net/wireless/ti/wlcore/scan.c     |  696 ++++++------------------
 drivers/net/wireless/ti/wlcore/scan.h     |  144 ++---
 drivers/net/wireless/ti/wlcore/sdio.c     |    3 +-
 drivers/net/wireless/ti/wlcore/spi.c      |    5 +-
 drivers/net/wireless/ti/wlcore/tx.c       |  298 ++++++----
 drivers/net/wireless/ti/wlcore/tx.h       |   35 +-
 drivers/net/wireless/ti/wlcore/wlcore.h   |  118 +++-
 drivers/net/wireless/ti/wlcore/wlcore_i.h |   49 +-
 47 files changed, 4632 insertions(+), 2032 deletions(-)
 create mode 100644 drivers/net/wireless/ti/wl12xx/event.c
 create mode 100644 drivers/net/wireless/ti/wl12xx/event.h
 create mode 100644 drivers/net/wireless/ti/wl12xx/scan.c
 create mode 100644 drivers/net/wireless/ti/wl12xx/scan.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/cmd.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/cmd.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/event.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/event.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/scan.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/scan.h


--=20
Cheers,
Luca.


--=-LLMftS0v14UajKBYsgEo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQ+QoeAAoJEKFHnKIaPMX6RCAP/2t58ER+rLGqldujlfXavyqk
uC+HsjQ+npDeNxK4o5bsO3opEB3hYJyl3LrHTAG7WYUOPnlzIg3/pQO+/E3ec1sy
l5FPr7OwntMKQnY8TVDDIiNgYmaSmkMNDEm2ccSvqETzenYUzgmbt9RBnIFBR4ev
3mz94krrxo/VW/dV1+VYyogydzMQ3LdobO/TDkZpLTF7eKxUmmPKDgpfH9RYd/FX
wa+elX79lRduNVEYEsCfCTXnRkDbnYPICVs2folXWJ9WrlJCVXXGIqfMF0I/nKpy
JJStXsV4xrkRnHZx5ACIIMQDJ1ZrBRet7jIXEXpY7xFWC6/fO35+0QVDBHRowZe7
m9zvisWLil8eQfR7XuIPSsFxB5Oxfn2x9GORlPHHwfYoLEtAHtPxLJCzyn+M6apG
fMULJjhvqShpMdhbTOyjRvE+Ehhf3oPKZaZnx3V9hSrCgv5hZaqEEeOHqitkIJ13
LRkZWRYVB+C6VMifnpIdais3rXFyWQ3NYEHOMg5UG969LbQoDPEbQLyBi+V1lZAF
4jZy3VYUuoPyG9H4YEqzz/mzZ3WxODjWnurLBDZMQGp6LXQYIpwLwAxN7EZJViDI
SSAkE+gdfeaonNgyYVlUwVbVktmpOxtdGjXhZefOvKobqOvspdeSZsGFAPPKJrVo
yNjdxAV9ibZChI95la3C
=FuvX
-----END PGP SIGNATURE-----

--=-LLMftS0v14UajKBYsgEo--
