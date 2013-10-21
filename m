Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60498 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab3JUNJH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 09:09:07 -0400
Message-ID: <1382360937.14310.49.camel@jlt4.sipsolutions.net> (sfid-20131021_150912_469573_448E0A13)
Subject: pull-request: mac80211-next 2013-10-21
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 21 Oct 2013 15:08:57 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-ftNCO+EFSHt94HZpR2uN"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ftNCO+EFSHt94HZpR2uN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Now with build fixes for !MESH and a channel switch parsing fix.

In this round for mac80211-next I have:
 * mesh channel switch support
 * a CCM rewrite, using potential hardware offloads
 * SMPS for AP mode
 * RF-kill GPIO driver updates to make it usable as an ACPI driver
 * regulatory improvements
 * documentation fixes
 * DFS for IBSS mode
 * and a few small other fixes/improvements

Let me know if there's any problem.

johannes

The following changes since commit 7578d57520f51093f590d68e16965e2714e69747=
:

  mac80211: implement STA CSA for drivers using channel contexts (2013-10-0=
2 18:18:23 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to cf867bc30d9af3c2cdbf876224f400a81606eebe:

  nl80211: fix channel switch parsing (2013-10-21 14:36:56 +0200)

----------------------------------------------------------------
Andrei Otcheretianski (1):
      nl80211: fix channel switch parsing

Ard Biesheuvel (1):
      mac80211: port CCMP to cryptoapi's CCM driver

Chun-Yeow Yeoh (5):
      mac80211: refactor the parsing of chan switch ie
      mac80211: process the CSA frame for mesh accordingly
      {nl,cfg,mac}80211: enable the triggering of CSA frame in mesh
      {nl,cfg,mac}80211: implement mesh channel switch userspace API
      mac80211: process mesh channel switching using beacon

Emmanuel Grumbach (1):
      mac80211: implement SMPS for AP

Felix Fietkau (1):
      mac80211: add ieee80211_tx_prepare_skb() helper function

Heikki Krogerus (5):
      net: rfkill: gpio: convert to resource managed allocation
      net: rfkill: gpio: clean up clock handling
      net: rfkill: gpio: spinlock-safe GPIO access
      net: rfkill: gpio: prepare for DT and ACPI support
      net: rfkill: gpio: add ACPI support

Johannes Berg (2):
      mac80211: add missing IEEE80211_HW_SUPPORTS_HT_CCK_RATES docs
      cfg80211: fix docbook references

Luis R. Rodriguez (5):
      cfg80211: fix nl80211.h documentation for DFS enum states
      cfg80211: rename regulatory_hint_11d() to regulatory_hint_country_ie(=
)
      cfg80211: enable regulatory hints for strict custom settings
      cfg80211: simplify strict custom alpha2 regdomain check
      cfg80211: export reg_initiator_name()

Marco Porsch (1):
      mac80211: fixes for mesh powersave logic

Michal Kazior (1):
      mac80211: fix uninitialized variable

Seth Forshee (1):
      mac80211: Remove check for offchannel state when waking netdev queues

Simon Wunderlich (2):
      nl80211/cfg80211: enable DFS for IBSS mode
      mac80211: enable DFS for IBSS mode

Sunil Dutt (1):
      cfg80211: pass station supported channel and oper class info

 Documentation/DocBook/80211.tmpl |   4 +-
 include/linux/ieee80211.h        |  20 +++
 include/net/cfg80211.h           |  23 +++
 include/net/mac80211.h           |  18 +++
 include/uapi/linux/nl80211.h     |  27 +++-
 net/mac80211/Kconfig             |  12 ++
 net/mac80211/aes_ccm.c           | 169 ++++++++--------------
 net/mac80211/aes_ccm.h           |  14 +-
 net/mac80211/cfg.c               | 142 +++++++++++++++++-
 net/mac80211/debug.h             |  10 ++
 net/mac80211/debugfs_netdev.c    |  25 ++--
 net/mac80211/ht.c                |  41 ++++--
 net/mac80211/ibss.c              | 116 +++++++--------
 net/mac80211/ieee80211_i.h       |  50 +++++--
 net/mac80211/iface.c             |   2 +
 net/mac80211/key.h               |   2 +-
 net/mac80211/mesh.c              | 302 +++++++++++++++++++++++++++++++++++=
+++-
 net/mac80211/mesh_plink.c        |   3 +-
 net/mac80211/mesh_ps.c           |  33 +++--
 net/mac80211/mlme.c              |  34 +++--
 net/mac80211/rx.c                |   5 +-
 net/mac80211/spectmgmt.c         |  33 +++--
 net/mac80211/sta_info.c          |  72 ++++++++++
 net/mac80211/sta_info.h          |   5 +
 net/mac80211/status.c            |  31 ++--
 net/mac80211/tx.c                |  45 ++++++
 net/mac80211/util.c              | 124 +++++++++++++++-
 net/mac80211/wpa.c               |  44 +++---
 net/rfkill/Kconfig               |   2 +-
 net/rfkill/rfkill-gpio.c         | 211 +++++++++++++--------------
 net/wireless/chan.c              |   3 +-
 net/wireless/ibss.c              |  24 +++-
 net/wireless/nl80211.c           |  62 +++++++-
 net/wireless/reg.c               |  39 +++--
 net/wireless/reg.h               |   4 +-
 net/wireless/sme.c               |   4 +-
 net/wireless/util.c              |  14 +-
 37 files changed, 1306 insertions(+), 463 deletions(-)


--=-ftNCO+EFSHt94HZpR2uN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJSZSdpAAoJEDBSmw7B7bqrBS0QAJkzoIykUldhact+RhXnJjQx
OvujQ509jLD9cFyQ2qOOLFgMbzv+k/9xzQo/4FqbLbMigwmMKSfQeVCF09tRgJin
2a67Y8T2cbfGw4ByhBSKB41G3BRvbyXbTwPwZEiD/bjp+/1lKxUG77GyU+DyOiyr
KbIrHemfAXYxqn7kCwEa9QZsFVkyIo9wH6I/2ZtQbxr3RzXNhlUrJjjNxqcccYzW
sNcJ4h5LUck1dcZ4+RFRaNOWvOn51C+WRDk2hl+vTbGGPwVLGlqBQgUae/1b1qv/
WIbGCAREQ0z+UGyDjt0px6R8+vFNecs35pyRvab9M9VaSvUEgQh3Z66uO3/Uq9Bd
FCa+N6RCP4vlLH9d2O023N5sseW+CJKbvj2jlEQ6LzDKBDgxN4dIB0ZulYHZei6X
CRYa43NtF5E/PO31udCxeDMNBMQjSBxoa6Eplew3sGi9cPzXlWwZSFtpA58t7Npr
JNpVR3ckphaU4gggc+Z4z+l6AH8vAsfx1Vvzsy75fMzlth1dfNOiL3963DC7IaAB
bvPpdcKDTQTFYfbIytjFeYo+6r1fer3lxKD9wT69fMOO9ttH7RGMIaT25h7G9eZQ
QhHH+T4I2dNDORDWZzoZqiVISLq8EOw94JuKYHA3zUXRthUeG2d+dvhGoOz8bxk8
G92Q8lbKRSguUAv1S0lz
=yFHS
-----END PGP SIGNATURE-----

--=-ftNCO+EFSHt94HZpR2uN--

