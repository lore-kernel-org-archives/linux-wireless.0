Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:44461 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277Ab2BOMSZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 07:18:25 -0500
Received: by mail-lpp01m010-f45.google.com with SMTP id i5so1140295lah.32
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2012 04:18:24 -0800 (PST)
Message-ID: <1329307917.16529.5.camel@cumari> (sfid-20120215_131830_120972_DC5E4309)
Subject: pull request: wl12xx 2012-02-15
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Wed, 15 Feb 2012 14:11:57 +0200
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-OdnOHWEv8XqOoBSa3QHF"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OdnOHWEv8XqOoBSa3QHF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

The first pull request for 3.4.  There is a bunch of fixes, some small
new features and so on.  The biggest change is that there was a
considerable change in the firmware API to which we had to adapt.  The
latter is also my excuse for accumulating so many patches. ;) We had to
wait until the new firmware became stable enough.=20

Please pull or let me know if there's any problem. This tree is based on
wireless-next/master.

Thanks!=20

The following changes since commit 12325280dfeba18164f9c47e226a40ab34e23ee7=
:

  rtlwifi: Modify rtl_pci_init to return 0 on success (2012-02-09 14:49:37 =
-0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linvill=
e

Dan Carpenter (1):
      wl12xx: remove some dead code in wl1271_plt_init()

Eliad Peller (19):
      wl12xx: check bss_conf->assoc on CHANGED_BSSID
      wl12xx: remove wl1271_tx_update_filters
      Revert "wl12xx: Change claiming of the SDIO bus"
      wl12xx: don't release/claim sdio on suspend/resume
      wl12xx: fw api change - add role_id to set_template
      wl12xx: use dev_role_id for scans
      wl12xx: fw api change - add role_id to tsf_info
      wl12xx: fw api change - update cmd/acx/event enums
      wl12xx: add TX_HW_ATTR_HOST_ENCRYPT flag
      wl12xx: add new coex params
      wl12xx: consider encryption and QoS in auto arp template
      wl12xx: Revert "wl12xx: disable auto-arp"
      wl12xx: configure arp filtering only after association
      wl12xx: declare support for hw scan while idle
      wl12xx: don't fail on AP scan
      wl12xx: Use a dedicated fw for PLT
      wl12xx: dynamically change fw according to number of active roles
      wl12xx: enter forced-psm on fw change
      wl12xx: delete wl->vif (and allow multiple vifs)

Eyal Shapira (12):
      wl12xx: remove PS management code
      wl12xx: add support for HW dynamic PS
      wl12xx: add dynamic_ps_timeout debugfs file
      wl12xx: remove 2 unused parameters in wl1271_ps_set_mode()
      wl12xx: enable/disable BET with AUTO_PS/ACTIVE
      wl12xx: change WLVIF_FLAG_PSM name and remove WLVIF_FLAG_PSM_REQUESTE=
D
      wl12xx: Set different wake up conditions in case of suspend
      wl12xx: add suspend_listen_interval debugfs file
      wl12xx: add forced_ps mode
      wl12xx: add forced_ps debugfs file
      wl12xx: use split scan for normal scan
      wl12xx: add split_scan_timeout debugfs file

Ido Reis (1):
      wl12xx: increase max probe-req template size to WL1271_CMD_TEMPL_MAX_=
SIZE

Ido Yariv (3):
      wl12xx: Acquire lock before stopping plt
      wl12xx: Power off after flushing work
      wl12xx: Fix potential interrupt storm

Luciano Coelho (11):
      wl1251: fix sparse warning
      wl1251: convert 32-bit values to le32 before writing to the chip
      wl1251: enable sparse endianess check by default
      wl12xx: enable sparse endianess check by default
      wl12xx: cancel delayed elp work and clear flags when stopping PLT
      wl12xx: move partition table definition to io.c
      wl12xx: read chip ID and HW PG version during probe
      wl12xx: use two MAC addresses based on the NVS or from fuse ROM
      wl12xx: add testmode operation to read the BD_ADDR from Fuse ROM
      wl12xx: remove unnecessary shadow declaration
      wl12xx: fix typo in fwlog module param description

Pontus Fuchs (3):
      wl12xx: Make sure HW is available in sched scan ops
      wl12xx: Set IEEE80211_TX_RC_MCS on MCS rates on TX complete.
      wl12xx: Set IEEE80211_TX_RC_SHORT_GI if short GI was used on

 drivers/net/wireless/wl1251/Makefile       |    2 +
 drivers/net/wireless/wl1251/boot.c         |    2 -
 drivers/net/wireless/wl1251/io.h           |    9 +-
 drivers/net/wireless/wl1251/wl1251.h       |    2 +-
 drivers/net/wireless/wl12xx/Makefile       |    2 +
 drivers/net/wireless/wl12xx/acx.c          |   17 +-
 drivers/net/wireless/wl12xx/acx.h          |  149 ++++---
 drivers/net/wireless/wl12xx/boot.c         |  105 +----
 drivers/net/wireless/wl12xx/boot.h         |   10 -
 drivers/net/wireless/wl12xx/cmd.c          |  143 +++++--
 drivers/net/wireless/wl12xx/cmd.h          |  148 ++++---
 drivers/net/wireless/wl12xx/conf.h         |   51 ++-
 drivers/net/wireless/wl12xx/debug.h        |    1 +
 drivers/net/wireless/wl12xx/debugfs.c      |  241 ++++++++++-
 drivers/net/wireless/wl12xx/event.c        |  154 +-------
 drivers/net/wireless/wl12xx/event.h        |   20 +-
 drivers/net/wireless/wl12xx/init.c         |   55 ++-
 drivers/net/wireless/wl12xx/io.c           |   59 +++
 drivers/net/wireless/wl12xx/io.h           |    2 +
 drivers/net/wireless/wl12xx/main.c         |  674 +++++++++++++++++++-----=
----
 drivers/net/wireless/wl12xx/ps.c           |   34 +-
 drivers/net/wireless/wl12xx/ps.h           |    2 +-
 drivers/net/wireless/wl12xx/reg.h          |   27 ++
 drivers/net/wireless/wl12xx/rx.c           |    2 +-
 drivers/net/wireless/wl12xx/scan.c         |   56 ++--
 drivers/net/wireless/wl12xx/scan.h         |    2 +-
 drivers/net/wireless/wl12xx/sdio.c         |   29 +-
 drivers/net/wireless/wl12xx/spi.c          |    8 +-
 drivers/net/wireless/wl12xx/testmode.c     |   50 ++
 drivers/net/wireless/wl12xx/tx.c           |   75 ++--
 drivers/net/wireless/wl12xx/tx.h           |    5 +-
 drivers/net/wireless/wl12xx/wl12xx.h       |   46 ++-
 drivers/net/wireless/wl12xx/wl12xx_80211.h |    2 +-
 33 files changed, 1386 insertions(+), 798 deletions(-)

--=20
Cheers,
Luca.





--=-OdnOHWEv8XqOoBSa3QHF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPO6ENAAoJEKFHnKIaPMX6HmIP/18+DAEFs2lhE7K21HGIi0hK
0BKLL2KEcZWvEU0Rxukfh9MdeAfR0JYGI76hif9X5J265t4zZc2wWvRbSCOGRhcl
Tt8m7Bl/01GQlWuAyWcedMCXB6WM9BkxOPTjg4NwZqOtTJtGbaqFBMJS44lNRx7S
L/8cyqmYJGHBODac3PounWmsCKiFmXZfW1piypN/vqmGjtWkdUJ0gJHPgcJNVWXA
GhJAmitfzHghTQWk7uY9eL+BB2TYq9X8/PzFRf7Pbbeescapie6W+cdQGm+9DsQQ
rWqUAnCR4MXZe+QVztcWpknTBVNy3EJL9bYLtO02jhfBFN+nJFEWFfmVGGcxnCUG
dyu+/dQ3ZAEVEZWyxvifqqe78L6ZVG2O0fQDz2i6cUgH6Cf2OS7Nf4Gya4xTRGPz
uWoomQ5bqDiSlhCyjZ0SENwXx5b03dSsAhSBMmqc6A85eKfqVc2pg9fRMqvanZ0b
pJkL4MnGVObQ+CdENu4KcPHABrumXMRVdwrL11yysgiGJNLhkrrzw+/l92MpImaw
0egViuw1IzsTE2J/G7nD6XCA2z+UfqnUr6WFReVSiOsptpUEj1fcCljW4Ljoh5/9
T/bjyy7UyGJy0wmjSme/aaGrHffGzQole/AgNMiOPJMqBW2mNOBkbxDY4Mgb1Q0s
85jfqDhuvHTWTaeZf49+
=5lMw
-----END PGP SIGNATURE-----

--=-OdnOHWEv8XqOoBSa3QHF--

