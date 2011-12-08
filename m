Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:53035 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750988Ab1LHLW4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 06:22:56 -0500
Received: by lagp5 with SMTP id p5so645060lag.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Dec 2011 03:22:53 -0800 (PST)
Subject: pull request: wl12xx 2011-12-08
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-PtUreA1fzEhK/T4K47G3"
Date: Thu, 08 Dec 2011 13:22:50 +0200
Message-ID: <1323343370.8996.262.camel@cumari> (sfid-20111208_122306_197516_1A436CA5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PtUreA1fzEhK/T4K47G3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

This is a long overdue pull-request for 3.3.  Most of the changes are by
Eliad and are related to the phy/vif split.  It took a long time to get
all this stabilized and fix a couple of pending bugs.  Now this should
be stable enough, so it can be taken to wireless-next.

There are also a few other bug fixes and improvements, including a
rework of the way we handle SDIO devices and platform devices, by
Felipe.=20

Please pull or let me know if there's any problem. This tree is based on
wireless-next/master.

Thanks!=20

The following changes since commit 0052d812599fb0327792b6c3f4257b26dcc13239=
:

  wireless: disable wext sysfs by default (2011-12-07 15:19:39 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linvill=
e

Arik Nemtsov (5):
      wl12xx: keep beacon-filtering enabled during STA operation
      wl12xx: configure probe-resp template according to notification
      wl12xx: indicate probe-resp offloading support
      wl12xx: avoid bail out when probe-resp is not set by mac80211
      wl12xx: leave IV calculation to HW for CCMP

Eliad Peller (69):
      wl12xx: replace wl->mac_addr with vif->addr
      wl12xx: start reworking the init sequence
      wl12xx: define wl12xx_vif
      wl12xx: move rate_set into wlvif
      wl12xx: move basic_rate into wlvif
      wl12xx: replace wl->bssid with vif->bss_conf.bssid
      wl12xx: move bss_type into wlvif
      wl12xx: remove set_bss_type field
      wl12xx: move p2p into wlvif
      wl12xx: move ssid and ssid_len into wlvif
      wl12xx: move probereq into wlvif
      wl12xx: move aid into wlvif
      wl12xx: move role_id into wlvif
      wl12xx: move dev_role_id into wlvif
      wl12xx: move sta_hlid into wlvif
      wl12xx: move ap_global_hlid and ap_bcast_hlid into wlvif
      wl12xx: move session_counter into wlvif
      wl12xx: move some logic into wl12xx_init_vif_data
      wl12xx: move dev_hlid into wlvif
      wl12xx: move beacon_int into wlvif
      wl12xx: move default_key into wlvif
      wl12xx: move pspoll_work into wlvif
      wl12xx: move ps_compl into wlvif
      wl12xx: move ps_poll_failures and psm_entry_retry into wlvif
      wl12xx: move rssi_thold and last_rssi_event into wlvif
      wl12xx: move ba fields into wlvif
      wl12xx: move ap_hlid_map into wlvif.ap
      wl12xx: move recorded_ap_keys into wlvif
      wl12xx: refactor fw init into a new function
      wl12xx: move last_tx_hlid into wlvif
      wl12xx: unify STA and AP tx_queue mechanism
      wl12xx: move some functions from remove_interface() to stop()
      wl12xx: move bitrate_masks into wlvif
      wl12xx: add vifs list
      wl12xx: support multiple vifs in the tx path
      wl12xx: configure sleep_policy according to active roles
      wl12xx: make event handling support multirole
      wl12xx: move tx_security_seq into wlvif
      wl12xx: rearm rx streaming per vif
      wl12xx: make WL1271_FLAG_STA_ASSOCIATED flag per-vif
      wl12xx: make WL1271_FLAG_IBSS_JOINED flag per-vif
      wl12xx: make WL1271_FLAG_AP_STARTED flag per-vif
      wl12xx: make WL1271_FLAG_PSM flag per-vif
      wl12xx: make WL1271_FLAG_STA_STATE_SENT flag per-vif
      wl12xx: make WL1271_FLAG_RX_STREAMING_STARTED flag per-vif
      wl12xx: make WL1271_FLAG_IF_INITIALIZED per-vif
      wl12xx: make WL1271_FLAG_PSPOLL_FAILURE flag per-vif
      wl12xx: make WL1271_FLAG_CS_PROGRESS flag per-vif
      wl12xx: add band field to wlvif
      wl12xx: add channel field to wlvif
      wl12xx: add power_level field to wlvif
      wl12xx: make op_config configure all vifs
      wl12xx: replace all remaining wl->vif references
      wl12xx: call stop() on recovery
      wl12xx: use dynamic rate policies
      wl12xx: add elp wakeup/sleep calls to add_interface
      wl12xx: use round-robin policy for tx
      wl12xx: handle injected packets
      wl12xx: couple role_start_dev with roc
      wl12xx: reconfigure rate policies on set_bitrate_mask
      wl12xx: add vifs_state debugfs key
      wl12xx: clear wl->vif on remove_interface
      wl12xx: use p2p rate index when the skb has the NO_CCK flag
      wl12xx: handle idle changes per-interface
      wl12xx: init CMD_TEMPL_KLV to sizeof(ieee80211_qos_hdr)
      wl12xx: don't explicitly check for unjoined ibss
      wl12xx: fix testmode test/interrogate commands
      wl12xx: remove redundant commands from plt init
      wl12xx: send testmode reply in wl1271_tm_cmd_interrogate

Eyal Shapira (2):
      wl12xx: fix SDIO suspend/resume
      wl12xx: minor fix in sched_scan_ssid_list

Felipe Balbi (8):
      wl12xx: add an sdio glue struct to keep wl and device side-by-side
      wl12xx: add an spi glue struct to keep wl and device side-by-side
      wl12xx: add a platform device to the sdio module
      wl12xx: add a platform device to the spi module
      wl12xx: add platform driver to the core module
      wl12xx: move common init code from bus modules to main
      wl12xx: mark some symbols static
      wl12xx: drop unneeded plat_dev

Guy Eilam (1):
      wl12xx: set scan probe requests rate according to the no_cck flag

Luciano Coelho (10):
      wl12xx: remove sdio_test module
      wl12xx: move debugging definitions to a separate file
      wl12xx: sdio: use dev_dbg instead of wl1271_debug
      wl12xx: spi: use dev_err instead of wl1271_error
      wl12xx: use the same plat dev name for both SPI and SDIO
      wl12xx: change blocksize alignment quirk to negative
      wl12xx: use the same SDIO block size for all different chips
      wl12xx: increase firmware upload chunk size
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-n=
ext into wl12xx-next
      Merge branch 'wl12xx-next' into for-linville

Pontus Fuchs (3):
      wl12xx: Validate FEM index from ini file and FW
      wl12xx: Check buffer bound when processing nvs data
      wl12xx: Print nvs/fw file name if loading fails.

Shahar Lev (1):
      wl12xx: remove warning message during IBSS Tx

 drivers/net/wireless/wl12xx/Kconfig                |   10 -
 drivers/net/wireless/wl12xx/Makefile               |    3 -
 drivers/net/wireless/wl12xx/acx.c                  |  146 +-
 drivers/net/wireless/wl12xx/acx.h                  |   83 +-
 drivers/net/wireless/wl12xx/boot.c                 |   15 +
 drivers/net/wireless/wl12xx/cmd.c                  |  368 +++--
 drivers/net/wireless/wl12xx/cmd.h                  |   50 +-
 drivers/net/wireless/wl12xx/conf.h                 |    4 +
 drivers/net/wireless/wl12xx/debug.h                |  101 +
 drivers/net/wireless/wl12xx/debugfs.c              |  141 ++-
 drivers/net/wireless/wl12xx/event.c                |  214 ++-
 drivers/net/wireless/wl12xx/event.h                |    3 -
 drivers/net/wireless/wl12xx/init.c                 |  458 +++---
 drivers/net/wireless/wl12xx/init.h                 |    7 +-
 drivers/net/wireless/wl12xx/io.c                   |   12 +-
 drivers/net/wireless/wl12xx/io.h                   |   23 +-
 drivers/net/wireless/wl12xx/main.c                 | 1967 +++++++++++-----=
---
 drivers/net/wireless/wl12xx/ps.c                   |   56 +-
 drivers/net/wireless/wl12xx/ps.h                   |    9 +-
 drivers/net/wireless/wl12xx/reg.h                  |    2 +-
 drivers/net/wireless/wl12xx/rx.c                   |   34 +-
 drivers/net/wireless/wl12xx/scan.c                 |  102 +-
 drivers/net/wireless/wl12xx/scan.h                 |    8 +-
 drivers/net/wireless/wl12xx/sdio.c                 |  259 ++--
 drivers/net/wireless/wl12xx/sdio_test.c            |  543 ------
 drivers/net/wireless/wl12xx/spi.c                  |  214 +--
 drivers/net/wireless/wl12xx/testmode.c             |   76 +-
 drivers/net/wireless/wl12xx/tx.c                   |  371 +++--
 drivers/net/wireless/wl12xx/tx.h                   |   11 +-
 drivers/net/wireless/wl12xx/wl12xx.h               |  377 ++--
 drivers/net/wireless/wl12xx/wl12xx_80211.h         |    5 -
 drivers/net/wireless/wl12xx/wl12xx_platform_data.c |    4 +-
 include/linux/wl12xx.h                             |    5 +-
 33 files changed, 2955 insertions(+), 2726 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/debug.h
 delete mode 100644 drivers/net/wireless/wl12xx/sdio_test.c

--=20
Cheers,
Luca.



--=-PtUreA1fzEhK/T4K47G3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO4J4AAAoJEKFHnKIaPMX68nQP/0gYt8hZHIc5OBiQhgSvocuW
Pf3CcC9yJTtIMba8nZvREq12HtGjAUM7zzyd+7n8K6dPPQa0632CAa69F2KNjPMq
lBmusRGZSFmVLqa7p8E5WzZRlwx+06ddzvlGu3vOpz71DKI3UaOnPuHeterYYD95
/ngEOGu6VoJgyMxIa/R9Jw8xKxjGs+F4e3YStugXb2ybdsXOhf2mUPIQxYGIgUdD
ZlgT4tfnL2gM0CYVzh5vfAFCeyL5JwPBO/wIQsPBp35GjABGCyO3S+aioAayl95l
sD6oc56tB2wrynOo083NJeA0g35RKJnhA/pMKm3t5fySc3286GFpDOj4VukVpFux
kysVH/p/g4Cmw+BzoGgTpmVntVPn/5fnDZJAGQNMGmccsNB+2jVaKlJnPEUvxrgo
Yb05QE13KZqaPnz2CqfG/ABaF3+zmIeevIrFcPWeCoILyMt0Iq+5dl2uDrlBg5Ag
jt6kxpVNk0QisL7AG0NQMCF58C8faitVa25AQ9zWc0I0IcG/isSYXvFgmhrbo8+g
S6V/JU4SwR7fko/+D5ttPxYabtdJm7jZ0s7tqSvMVSr7C0NLgdXAJRYzMPflKTQy
R3m/+Z0yfTcOil9jgLcpnYvEy+Yh0CuNiYI5/h9LuRbgwc8FXQUxGlDHoYekv53+
GlMI83lWhXGmfgPMK1N7
=bvB3
-----END PGP SIGNATURE-----

--=-PtUreA1fzEhK/T4K47G3--

