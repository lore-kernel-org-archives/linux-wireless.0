Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54717 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab2KITxs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 14:53:48 -0500
Message-ID: <1352490859.28302.5.camel@jlt4.sipsolutions.net> (sfid-20121109_205352_123102_BB711875)
Subject: pull-request: mac80211-next 2012-11-09
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 09 Nov 2012 20:54:19 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-H4xDvIIKa3qnbi3So8mH"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-H4xDvIIKa3qnbi3So8mH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Pull request #3 (and I have #4 coming up too...)

This is for mac80211, for -next (3.8). Plenty of changes, as you can see
below. Some fixes for previous changes like the export.h include, the
beacon listener fix from Ben Greear, etc. Overall, no exciting new
features, though hwsim does gain channel context support for people to
try it out and look at.

johannes

The following changes since commit ab3d59d265e772e734c36fe738809cb1a910f566=
:

  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/li=
nville/wireless (2012-10-29 16:05:51 -0400)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 6352c87ff69daa2211419ec2c34ddb8bc116c505:

  mac80211: reassign channel contexts before stations (2012-11-09 17:34:36 =
+0100)

----------------------------------------------------------------
Antonio Quartulli (4):
      nl/cfg80211: add the NL80211_CMD_SET_MCAST_RATE command
      mac80211: implement set_mcast_rate() callback
      cfg80211: store the ssid into wirless_dev in AP mode
      nl80211: send the NL80211_ATTR_SSID in nl80211_send_iface()

Arend van Spriel (1):
      wireless: add peer-to-peer related definitions

Ben Greear (1):
      cfg80211: allow registering more than one beacon listener

Emmanuel Grumbach (1):
      mac80211: include export.h in aes_cmac

Johannes Berg (23):
      mac80211: a few formatting fixes
      mac80211: move AP teardown code to correct place
      mac80211: add explicit AP/GO driver operations
      Merge remote-tracking branch 'wireless-next/master' into mac80211-nex=
t
      mac80211_hwsim: allow using channel contexts
      nl80211: move "can set channel" check
      cfg80211: allow per interface TX power setting
      mac80211: handle TX power per virtual interface
      mac80211_hwsim: print per interface TX power
      mac80211: combine status/drop reporting
      mac80211: use a counter for remain-on-channel cookie
      mac80211: send deauth only with channel context
      wireless: add utility function to get P2P attribute
      mac80211: pass P2P powersave parameters to driver
      mac80211: use mac_pton
      mac80211: fix race in TKIP MIC test debugfs file
      mac80211: use kstrtoull return value
      mac80211: fix TX error path
      mac80211: add debugfs file for HW queues
      mac80211: remove unused tracepoint
      mac80211: call driver method when restart completes
      mac80211: clarify interface iteration and make it configurable
      mac80211: reassign channel contexts before stations

 drivers/net/wireless/ath/ath5k/base.c              |  10 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |   5 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |   9 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c    |   6 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |  20 +-
 drivers/net/wireless/ath/ath9k/main.c              |  15 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   6 +-
 drivers/net/wireless/mac80211_hwsim.c              | 500 ++++++++++++++++-=
----
 drivers/net/wireless/mwifiex/cfg80211.c            |   1 +
 drivers/net/wireless/rndis_wlan.c                  |  10 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |  19 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |   6 +-
 drivers/net/wireless/ti/wlcore/main.c              |   2 +-
 include/linux/ieee80211.h                          |  32 ++
 include/net/cfg80211.h                             |  38 +-
 include/net/mac80211.h                             |  53 ++-
 include/uapi/linux/nl80211.h                       |   7 +
 net/mac80211/aes_cmac.c                            |   1 +
 net/mac80211/cfg.c                                 | 123 +++--
 net/mac80211/chan.c                                |   2 +
 net/mac80211/debugfs_netdev.c                      |  66 +--
 net/mac80211/driver-ops.h                          |  35 ++
 net/mac80211/ieee80211_i.h                         |  17 +-
 net/mac80211/iface.c                               |  57 ++-
 net/mac80211/main.c                                |  27 +-
 net/mac80211/mlme.c                                | 104 +++--
 net/mac80211/offchannel.c                          |   7 +-
 net/mac80211/pm.c                                  |   4 +
 net/mac80211/rx.c                                  |  41 +-
 net/mac80211/status.c                              | 145 +++---
 net/mac80211/trace.h                               |  76 ++--
 net/mac80211/tx.c                                  |   1 +
 net/mac80211/util.c                                |  59 ++-
 net/wireless/ap.c                                  |   1 +
 net/wireless/core.c                                |   7 +
 net/wireless/core.h                                |   7 +-
 net/wireless/nl80211.c                             | 148 ++++--
 net/wireless/rdev-ops.h                            |  11 +-
 net/wireless/trace.h                               |  24 +-
 net/wireless/util.c                                |  99 ++++
 net/wireless/wext-compat.c                         |   4 +-
 41 files changed, 1324 insertions(+), 481 deletions(-)


--=-H4xDvIIKa3qnbi3So8mH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQnV9rAAoJEDBSmw7B7bqrzcwQANOymTIPp2XWAEdk0pjT19IY
odPnF+4eFSdF4hAegOp7SbjIp3G/1Vnojnop6zRQ0gzr4/pJNkcB+Y1vUdnfs7sD
jvG4Q2dCP56qxnnHhmh0eQhtVlRbubVMiC1O/Aktw08n8HlEDuQc6dOX8DO8aekb
vfY1DNVRB8p0NFqREd3+aVHQ5RIlsnfbAC4z51mdga9WfbNXnj4pvJjL9oSzSp/G
OKFdlPMdD6EGmksR+w7q/JRmEFUPkNbsYh2tKgZ58n3qE25OWrY046oOblPUQ8yv
6iaZ0JWdf3El+8hhUILPwhe5Q9ewnCAO6RJC4OvTgh7jg/gsy0IENRLikyct84g+
oXOfoXRO+YxxhCizznpTMe4FVi8Sr+LDHZkkbTzqQaICQzATseL51U+RsS7nDfh7
P90BiXUh5SY0LDbezkCWbS6uFsOKcX4c3X34z4pnBnkMSJkDa72gDw3bwsLtR+G6
o1KqokGHrCDBZCLpZoBHni+1kGPgjOpmzDnWARAA0SiR0A+M7Fa2O/rhjdiXC9aR
JHnlZYOJFBpEsV111EtCksy9NEik06sCHnRX87MiQrM8ovA6kf+cnfDuG7+5ep+s
+0VodaYLwQbouSVilpfJZ2aK3SOd7sNpNE/ONiqyZZ2XoLL/bXV+HDIJGUXb4T48
0XW6NEKbVOF/mYeHA5al
=0ChM
-----END PGP SIGNATURE-----

--=-H4xDvIIKa3qnbi3So8mH--

