Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48233 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab3ACOBu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 09:01:50 -0500
Message-ID: <1357221730.9741.15.camel@jlt4.sipsolutions.net> (sfid-20130103_150153_992678_325AB815)
Subject: pull-request: mac80211-next 2013-01-03
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 03 Jan 2013 15:02:10 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-U432jFILc5x8V518ghzH"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-U432jFILc5x8V518ghzH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

This is my first -next pull request for this cycle. I have random
changes from various people:
 * SGI-20 disabling
 * short slot time config for mesh
 * beacon regulatory improvements
 * use frame control instead of passing a "bool beacon"
 * and more ...

The bigger changes are from myself:
 * lots of regulatory cleanups & improvements
 * some cfg80211/mac80211 fixes/cleanups/optimisations
 * VHT improvements/fixes

I've had to pull in mac80211.git to avoid major merge conflicts, let me
know if that's a problem.

Thanks,
Johannes



The following changes since commit a49f0d1ea3ec94fc7cf33a7c36a16343b74bd565=
:

  Linux 3.8-rc1 (2012-12-21 17:19:00 -0800)

are available in the git repository at:

  git://git.sipsolutions.net/mac80211-next.git for-john

for you to fetch changes up to ba23d2068d85f6616ea5f92320c04e87d4b9e141:

  cfg80211: disallow more station changes (2013-01-03 13:01:45 +0100)

----------------------------------------------------------------
Ben Greear (1):
      mac80211: Allow disabling SGI-20

Chaitanya (1):
      mac80211: fix maximum MTU

Chun-Yeow Yeoh (1):
      mac80211: use short slot time in mesh for 5GHz

Emmanuel Grumbach (1):
      mac82011: use frame control to differentiate probe resp/beacon

Felix Fietkau (1):
      mac80211: flush AP_VLAN stations when tearing down the BSS AP

Johannes Berg (55):
      mac80211: assign VLAN channel contexts
      mac80211: fix station destruction in AP/mesh modes
      mac80211: use del_timer_sync for final sta cleanup timer deletion
      mac80211: fix dtim_period in hidden SSID AP association
      Merge remote-tracking branch 'mac80211/master' into HEAD
      mac80211_hwsim: allow testing paged RX
      mac80211: remove final sta_info_flush()
      mac80211: warn if unexpectedly removing stations
      mac80211: optimise roaming time again
      mac80211: remove a bit of dead mesh code
      regulatory: don't write past array when intersecting rules
      regulatory: don't allocate too much memory
      regulatory: clean up regdom_intersect
      regulatory: clean up reg_copy_regd()
      regulatory: don't test list before iterating
      regulatory: simplify regulatory_hint_11d
      regulatory: code cleanup
      regulatory: remove useless locking on exit
      regulatory: use proper enum for return values
      cfg80211: remove wiphy_idx_valid
      regulatory: remove BUG_ON
      regulatory: simplify restore_regulatory_settings
      regulatory: remove redundant isalpha() check
      regulatory: remove useless warning
      regulatory: simplify freq_reg_info_regd
      regulatory: clarify locking rules and assertions
      regulatory: remove locking from wiphy_apply_custom_regulatory
      regulatory: fix reg_is_valid_request handling
      regulatory: remove handling of channel bandwidth
      regulatory: pass new regdomain to reset function
      regulatory: use RCU to protect global and wiphy regdomains
      regulatory: use RCU to protect last_request
      regulatory: use IS_ERR macro family for freq_reg_info
      mac80211: optimise AP stop RCU handling
      cfg80211: adjacent 80+80 MHz channel segments are invalid
      mac80211: fix ieee80211_ie_build_vht_cap indentation
      mac80211: clean up ieee80211_quiesce
      mac80211: clean up association better in suspend
      mac80211: fix channel context iteration
      mac80211: track enable_beacon explicitly
      mac80211: reconfig bss_info_changed only if beaconing
      mac80211: further simplify ieee80211_bss_info_change_notify
      mac80211: assign bss_conf.bssid only once
      mac80211: restrict assoc request VHT capabilities
      cfg80211: move some AP code to right file
      nl80211/mac80211: support full station state in AP mode
      mac80211: split aggregation stop by reason
      mac80211: split out aggregation TX removal
      mac80211: move ieee80211_remove_tid_tx function
      mac80211: split TX aggregation stop action
      wireless: use __packed in ieee80211.h
      mac80211: support HT notify channel width action
      wireless: use __aligned
      mac80211: unset peer's HT 40 MHz support if not usable
      cfg80211: disallow more station changes

Luis R. Rodriguez (3):
      cfg80211: do not process beacon hints if one is already queued
      cfg80211: move reg_is_world_roaming()
      cfg80211: move world roaming check for beacon hints

Stanislaw Gruszka (1):
      mac80211: fix ibss scanning

Thomas Pedersen (1):
      mac80211: RMC buckets are just list heads

Vladimir Kondratiev (1):
      wireless: more 'capability info' bits

 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |    4 +-
 drivers/net/wireless/ath/ath9k/main.c              |    4 +-
 drivers/net/wireless/ath/carl9170/main.c           |    4 +-
 drivers/net/wireless/ath/regd.c                    |   19 +-
 drivers/net/wireless/brcm80211/brcmsmac/channel.c  |    7 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    4 +-
 drivers/net/wireless/iwlegacy/4965-mac.c           |    4 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |    4 +-
 drivers/net/wireless/mac80211_hwsim.c              |   30 +-
 drivers/net/wireless/mwl8k.c                       |    4 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |    4 +-
 drivers/net/wireless/rtlwifi/core.c                |    4 +-
 drivers/net/wireless/rtlwifi/regd.c                |   17 +-
 drivers/net/wireless/ti/wlcore/main.c              |    4 +-
 include/linux/ieee80211.h                          |  100 +-
 include/net/cfg80211.h                             |   32 +-
 include/net/mac80211.h                             |   33 +-
 include/net/regulatory.h                           |    4 +
 include/uapi/linux/nl80211.h                       |   16 +
 net/mac80211/agg-tx.c                              |  253 +++--
 net/mac80211/cfg.c                                 |  139 ++-
 net/mac80211/chan.c                                |   41 +-
 net/mac80211/driver-ops.h                          |   23 +-
 net/mac80211/ht.c                                  |   33 +-
 net/mac80211/ibss.c                                |   66 +-
 net/mac80211/ieee80211_i.h                         |   39 +-
 net/mac80211/iface.c                               |   76 +-
 net/mac80211/main.c                                |   70 +-
 net/mac80211/mesh.c                                |   42 +-
 net/mac80211/mesh.h                                |    2 +-
 net/mac80211/mlme.c                                |  143 ++-
 net/mac80211/offchannel.c                          |   15 +-
 net/mac80211/pm.c                                  |   64 +-
 net/mac80211/rx.c                                  |   31 +-
 net/mac80211/scan.c                                |   55 +-
 net/mac80211/sta_info.c                            |   66 +-
 net/mac80211/sta_info.h                            |   45 +-
 net/mac80211/util.c                                |   18 +-
 net/wireless/ap.c                                  |   62 ++
 net/wireless/chan.c                                |    4 +
 net/wireless/core.c                                |   14 +-
 net/wireless/core.h                                |   18 +-
 net/wireless/mlme.c                                |   62 --
 net/wireless/nl80211.c                             |  114 +-
 net/wireless/reg.c                                 | 1111 +++++++++-------=
----
 net/wireless/reg.h                                 |    7 +-
 net/wireless/sme.c                                 |    6 +-
 47 files changed, 1580 insertions(+), 1337 deletions(-)


--=-U432jFILc5x8V518ghzH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQ5Y9jAAoJEDBSmw7B7bqryAAP/0fwFsF4WjN2Mbp/5Lcisxv5
KHTwc41tUD9nyPYfzHmzZdi0vh2Dgk1IlOmRRiV1IFirdCnJj8kDq1OR2/LcTxw3
xsDfZQgPHITqd55wrdF6sWY+iWFgl42FCj6S+4gNdnl8KXUQsy6VOL73WwEGrf/B
maDHUdkt38m+qBRqUmrmGyMnIu46PpEBOcF7dXXqFuojdU8G9//U2s9gpjJwS5cY
dguJUDoS95NXFxeMB+AwsjBUsQCfEfvUoh+oBphQJJN5JKLk6Ow4CyBOs1oR8BQ5
Pg36bmpg5dQDdjgg+nhn5Xhq+TIdSED2q00q6m2jqlmyQY0n9SC2XyEEkIaCJxeI
knWQEmWGjJ61xZvNQl/Y2yBj487yiHiIWtVSctx6dcRrJJJVQITFk8M4D5hvrWW2
aiZtBKY6mKBNnqihEgsNnEu8mDl4DqUOUjIJaDhOZgCJRJSiw/O9L6OKJzkPVFU4
g2up1nJY+WJLavpf0IQI2JWfoWmaijR7oR1LQWJZaqkTPMAZC3GpctY8z5YCZTry
xry5/UQL2KaDDc0dA7BE3Bz5Y4vZo+g2q5VkL0NFpvpnjDiYwu22xEYZaWTTcxRn
uVp1xWrZfQ2yCkht6Sahy2ZjN2QDBuYnCcip0hPCYusXuAJTU28Wy6ilGgdslg3Q
8vgUcuAcEbotDoCF5u/B
=q5k9
-----END PGP SIGNATURE-----

--=-U432jFILc5x8V518ghzH--

