Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36690 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbZEHPbJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 11:31:09 -0400
Date: Fri, 8 May 2009 11:21:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org
Subject: pull request: wireless-next-2.6 2009-05-08
Message-ID: <20090508152114.GE12507@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dave,

The usual gaggle of patches intended for -next...

This round includes the wl12xx driver for the TI wl1251 chipset,
supporting both SDIO and SPI busses.  Also included is rudimentary
support for the Ralink RT2800 USB chipset.  On top of those are the
usual round of driver fixes and mac80211 changes from Johannes and
Jouni.

Most of this has been in linux-next for several days, all of it for at
least a couple of days.

Please let me know if there are problems!

Thanks,

John

---

Individual patches are available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-next-2=
=2E6/

---

The following changes since commit c7ae011dc8306d982c25fb4f679752e790a0=
8dc4:
  Greg Kroah-Hartman (1):
        net: remove driver_data direct access of struct device from mor=
e drivers

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-=
2.6.git master

Abhijeet Kolekar (1):
      iwl3945: fix lock dependency

Alban Browaeys (1):
      rt2x00: Style fix for interval defines

Alexander Beregalov (1):
      ar9170: fix build when !CONFIG_PM

Andrew Morton (1):
      net/rfkill/rfkill.c: fix build with CONFIG_RFKILL_LEDS=3Dn

Bob Copeland (3):
      ath5k: correct interrupt storm warning
      ath5k: use ctl settings based on current regdomain
      wl12xx: correct printk format warnings

Chris Wright (1):
      cfg80211: remove superfluous !last_request check in reg_device_re=
move()

Christian Lamparter (5):
      ar9170: handle otus' A-MPDU density definitions
      ar9170: uncomment powermgt case handle
      p54usb: remove some dead code
      p54usb: rework driver for resume
      ar9170usb: reset device on resume

Gabor Juhos (2):
      ath9k: uninline ath9k_io{read,write}32 routines
      ath9k: remove redundant AR9285 checks

Greg Kroah-Hartman (1):
      Wireless: remove driver_data direct access of struct device

G=E1bor Stefanik (5):
      mac80211: Fix handling of retry count of NO_ACK frames in minstre=
l
      mac80211: Fix handling of retry count of NO_ACK frames in PID
      iwlwifi: Fix handling of retry count of NO_ACK frames in iwl-{394=
5|agn}-rs
      ath9k: Fix handling of retry count of NO_ACK frames
      mac80211: Warn if the rate controller requests retries for a NO_A=
CK frame

Hauke Mehrtens (1):
      p54usb: Fixes compile error with CONFIG_PM=3Dn

Ivo van Doorn (7):
      rt2x00: Move iv_len into tx descriptor data
      rt2x00: Add support for L2 padding during TX/RX
      rt2x00: Implement support for 802.11n
      rt2x00: Implement support for rt2800usb
      rt2x00: Add new USB ID for rt2800usb
      rt2x00: Synchronize initialization with rt2870 driver
      rt2x00: Simplify rt2x00_check_rev

Jiri Slaby (2):
      ath5k: 5211, don't crypt every protected frame
      ath5k: Enable AP mode

Johannes Berg (12):
      mac80211: fix various problems in ibss code
      mac80211: fix PS vs. scan race
      mac80211: rename max_sleep_interval to max_sleep_period
      mac80211: internally clear failed scans properly
      mac80211: fix scan races and rework scanning
      mac80211: clean up beacon interval settings
      mac80211: unify config_interface and bss_info_changed
      mac80211: add driver ops wrappers
      mac80211_hwsim: fix bogus warning
      mac80211: fix probe response processing
      mac80211: tell driver when idle
      mac80211: report operating frequency rather than current

John W. Linville (1):
      p54: correct merge damage from "p54: more SoftLED updates"

Jouni Malinen (5):
      nl80211: Send timeout event on failed direct probe
      mac80211: Use a shared function to release frames from RX reorder=
 buf
      mac80211: Add a timeout for frames in the RX reorder buffer
      mac80211: Comment the order of HT RX reorder handler vs. RX handl=
ers
      mac80211: Update SA Query transaction id length

Kalle Valo (1):
      wl12xx: add driver

Luis R. Rodriguez (3):
      cfg80211: make nl80211_send_mlme_timeout() static
      mac80211: Fix sparse warning for ssid_len on ieee80211_sta_config=
_auth()
      ath9k: make private driver rate tables const

Max Filippov (1):
      p54: call p54_wake_free_queues on every p54_free_skb and p54_rx_f=
rame_sent

Michael Buesch (2):
      cfg80211: Remove unnecessary ksize() call
      cfg80211: Use the correct IE buffer pointer

Nick Kossifidis (6):
      ath5k: Allow user/driver to set txpower
      ath5k: Read Spur channels from EEPROM
      ath5k: Put remaining EEPROM data on ee struct
      ath5k: Beaconing fixes
      ath5k: Implement antenna control
      ath5k: Add Spur filter support on newer chips

Paride Legovini (1):
      Add LED support for AR5BXB6 IBM Thinkpad PCIe adapters

Reinette Chatre (1):
      iwlagn: disable PS support for iwlagn

Roel Kluin (1):
      ar9170: wrong test on outlen in ar9170_usb_exec_cmd() ?

Tobias Klauser (1):
      ath5k: Storage class should be before const qualifier

Tomas Winkler (1):
      iwlwifi: replace test_and_set_bit by set_bit in clear stations fu=
nction

Wey-Yi Guy (1):
      iwlwifi: "is_fat" bit in rate scale match RXON flag

 drivers/net/wireless/Kconfig                |    1 +
 drivers/net/wireless/Makefile               |    2 +
 drivers/net/wireless/adm8211.c              |   14 +-
 drivers/net/wireless/at76c50x-usb.c         |   15 +-
 drivers/net/wireless/ath/ar9170/hw.h        |    2 +
 drivers/net/wireless/ath/ar9170/mac.c       |   33 +-
 drivers/net/wireless/ath/ar9170/main.c      |   48 +-
 drivers/net/wireless/ath/ar9170/usb.c       |    6 +-
 drivers/net/wireless/ath/ath5k/ath5k.h      |   37 +-
 drivers/net/wireless/ath/ath5k/attach.c     |    1 -
 drivers/net/wireless/ath/ath5k/base.c       |  210 ++-
 drivers/net/wireless/ath/ath5k/eeprom.c     |   73 +-
 drivers/net/wireless/ath/ath5k/eeprom.h     |   46 +-
 drivers/net/wireless/ath/ath5k/led.c        |    6 +-
 drivers/net/wireless/ath/ath5k/pcu.c        |    6 +-
 drivers/net/wireless/ath/ath5k/phy.c        |  493 ++++-
 drivers/net/wireless/ath/ath5k/qcu.c        |    7 +-
 drivers/net/wireless/ath/ath5k/reg.h        |    9 +-
 drivers/net/wireless/ath/ath5k/reset.c      |   70 +-
 drivers/net/wireless/ath/ath9k/ath9k.h      |   39 +-
 drivers/net/wireless/ath/ath9k/beacon.c     |   11 +-
 drivers/net/wireless/ath/ath9k/calib.c      |    6 +-
 drivers/net/wireless/ath/ath9k/hw.c         |   37 +-
 drivers/net/wireless/ath/ath9k/hw.h         |    3 +-
 drivers/net/wireless/ath/ath9k/main.c       |  206 +-
 drivers/net/wireless/ath/ath9k/rc.c         |   70 +-
 drivers/net/wireless/ath/ath9k/xmit.c       |   10 +-
 drivers/net/wireless/atmel_cs.c             |    2 +-
 drivers/net/wireless/b43/main.c             |   76 +-
 drivers/net/wireless/b43legacy/main.c       |   73 +-
 drivers/net/wireless/ipw2x00/ipw2100.c      |    8 +-
 drivers/net/wireless/ipw2x00/ipw2200.c      |   47 +-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |    7 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |   31 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   24 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |  168 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    3 -
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   69 +-
 drivers/net/wireless/libertas_tf/main.c     |   56 +-
 drivers/net/wireless/mac80211_hwsim.c       |   45 +-
 drivers/net/wireless/mwl8k.c                |   18 +-
 drivers/net/wireless/p54/p54.h              |    4 +-
 drivers/net/wireless/p54/p54common.c        |   86 +-
 drivers/net/wireless/p54/p54usb.c           |  314 ++--
 drivers/net/wireless/p54/p54usb.h           |   16 +-
 drivers/net/wireless/rt2x00/Kconfig         |   17 +
 drivers/net/wireless/rt2x00/Makefile        |    2 +
 drivers/net/wireless/rt2x00/rt2400pci.c     |    1 -
 drivers/net/wireless/rt2x00/rt2500pci.c     |    1 -
 drivers/net/wireless/rt2x00/rt2500usb.c     |    3 +-
 drivers/net/wireless/rt2x00/rt2800usb.c     | 3071 +++++++++++++++++++=
++++++++
 drivers/net/wireless/rt2x00/rt2800usb.h     | 1945 +++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00.h        |   32 +-
 drivers/net/wireless/rt2x00/rt2x00config.c  |    5 +
 drivers/net/wireless/rt2x00/rt2x00crypto.c  |   87 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c     |  125 +-
 drivers/net/wireless/rt2x00/rt2x00ht.c      |   69 +
 drivers/net/wireless/rt2x00/rt2x00lib.h     |   65 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c     |   88 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c   |   48 +-
 drivers/net/wireless/rt2x00/rt2x00queue.h   |   53 +-
 drivers/net/wireless/rt2x00/rt61pci.c       |    1 -
 drivers/net/wireless/rt2x00/rt73usb.c       |    4 +-
 drivers/net/wireless/rtl818x/rtl8180_dev.c  |   33 +-
 drivers/net/wireless/rtl818x/rtl8187_dev.c  |   48 +-
 drivers/net/wireless/wl12xx/Kconfig         |   11 +
 drivers/net/wireless/wl12xx/Makefile        |    4 +
 drivers/net/wireless/wl12xx/acx.c           |  689 ++++++
 drivers/net/wireless/wl12xx/acx.h           | 1245 +++++++++++
 drivers/net/wireless/wl12xx/boot.c          |  295 +++
 drivers/net/wireless/wl12xx/boot.h          |   40 +
 drivers/net/wireless/wl12xx/cmd.c           |  353 +++
 drivers/net/wireless/wl12xx/cmd.h           |  265 +++
 drivers/net/wireless/wl12xx/debugfs.c       |  508 +++++
 drivers/net/wireless/wl12xx/debugfs.h       |   33 +
 drivers/net/wireless/wl12xx/event.c         |  127 ++
 drivers/net/wireless/wl12xx/event.h         |  121 ++
 drivers/net/wireless/wl12xx/init.c          |  200 ++
 drivers/net/wireless/wl12xx/init.h          |   40 +
 drivers/net/wireless/wl12xx/main.c          | 1358 ++++++++++++
 drivers/net/wireless/wl12xx/ps.c            |  151 ++
 drivers/net/wireless/wl12xx/ps.h            |   36 +
 drivers/net/wireless/wl12xx/reg.h           |  745 +++++++
 drivers/net/wireless/wl12xx/rx.c            |  208 ++
 drivers/net/wireless/wl12xx/rx.h            |  122 ++
 drivers/net/wireless/wl12xx/spi.c           |  358 ++++
 drivers/net/wireless/wl12xx/spi.h           |  109 +
 drivers/net/wireless/wl12xx/tx.c            |  557 +++++
 drivers/net/wireless/wl12xx/tx.h            |  215 ++
 drivers/net/wireless/wl12xx/wl1251.c        |  709 ++++++
 drivers/net/wireless/wl12xx/wl1251.h        |  165 ++
 drivers/net/wireless/wl12xx/wl12xx.h        |  409 ++++
 drivers/net/wireless/wl12xx/wl12xx_80211.h  |  156 ++
 drivers/net/wireless/zd1211rw/zd_mac.c      |   80 +-
 include/linux/ieee80211.h                   |    2 +-
 include/linux/spi/wl12xx.h                  |   31 +
 include/net/mac80211.h                      |   77 +-
 net/mac80211/agg-rx.c                       |   19 +-
 net/mac80211/agg-tx.c                       |   13 +-
 net/mac80211/cfg.c                          |   49 +-
 net/mac80211/debugfs.c                      |   20 +-
 net/mac80211/driver-ops.h                   |  184 ++
 net/mac80211/ibss.c                         |  102 +-
 net/mac80211/ieee80211_i.h                  |   14 +-
 net/mac80211/iface.c                        |  100 +-
 net/mac80211/key.c                          |    8 +-
 net/mac80211/main.c                         |  165 +-
 net/mac80211/mesh.c                         |    6 +-
 net/mac80211/mlme.c                         |   74 +-
 net/mac80211/pm.c                           |    9 +-
 net/mac80211/rc80211_minstrel.c             |    8 +-
 net/mac80211/rc80211_pid_algo.c             |    8 +-
 net/mac80211/rx.c                           |  138 +-
 net/mac80211/scan.c                         |  414 ++--
 net/mac80211/sta_info.c                     |   26 +-
 net/mac80211/sta_info.h                     |    2 +
 net/mac80211/tkip.c                         |    6 +-
 net/mac80211/tx.c                           |    9 +-
 net/mac80211/util.c                         |   31 +-
 net/mac80211/wext.c                         |    2 +-
 net/rfkill/rfkill.c                         |    5 +
 net/wireless/nl80211.c                      |    6 +-
 net/wireless/reg.c                          |    8 +-
 net/wireless/scan.c                         |   10 +-
 125 files changed, 17180 insertions(+), 1883 deletions(-)
 create mode 100644 drivers/net/wireless/rt2x00/rt2800usb.c
 create mode 100644 drivers/net/wireless/rt2x00/rt2800usb.h
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00ht.c
 create mode 100644 drivers/net/wireless/wl12xx/Kconfig
 create mode 100644 drivers/net/wireless/wl12xx/Makefile
 create mode 100644 drivers/net/wireless/wl12xx/acx.c
 create mode 100644 drivers/net/wireless/wl12xx/acx.h
 create mode 100644 drivers/net/wireless/wl12xx/boot.c
 create mode 100644 drivers/net/wireless/wl12xx/boot.h
 create mode 100644 drivers/net/wireless/wl12xx/cmd.c
 create mode 100644 drivers/net/wireless/wl12xx/cmd.h
 create mode 100644 drivers/net/wireless/wl12xx/debugfs.c
 create mode 100644 drivers/net/wireless/wl12xx/debugfs.h
 create mode 100644 drivers/net/wireless/wl12xx/event.c
 create mode 100644 drivers/net/wireless/wl12xx/event.h
 create mode 100644 drivers/net/wireless/wl12xx/init.c
 create mode 100644 drivers/net/wireless/wl12xx/init.h
 create mode 100644 drivers/net/wireless/wl12xx/main.c
 create mode 100644 drivers/net/wireless/wl12xx/ps.c
 create mode 100644 drivers/net/wireless/wl12xx/ps.h
 create mode 100644 drivers/net/wireless/wl12xx/reg.h
 create mode 100644 drivers/net/wireless/wl12xx/rx.c
 create mode 100644 drivers/net/wireless/wl12xx/rx.h
 create mode 100644 drivers/net/wireless/wl12xx/spi.c
 create mode 100644 drivers/net/wireless/wl12xx/spi.h
 create mode 100644 drivers/net/wireless/wl12xx/tx.c
 create mode 100644 drivers/net/wireless/wl12xx/tx.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251.h
 create mode 100644 drivers/net/wireless/wl12xx/wl12xx.h
 create mode 100644 drivers/net/wireless/wl12xx/wl12xx_80211.h
 create mode 100644 include/linux/spi/wl12xx.h
 create mode 100644 net/mac80211/driver-ops.h

Omnibus patch is available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-next-2=
=2E6-2009-05-08.patch.bz2

--=20
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
