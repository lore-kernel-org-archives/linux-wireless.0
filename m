Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:62562 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaAMUTY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 15:19:24 -0500
Received: by mail-ee0-f45.google.com with SMTP id d49so3397094eek.32
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 12:19:23 -0800 (PST)
Message-ID: <52D44A46.4000805@gmail.com> (sfid-20140113_211929_309230_AE62D3C6)
Date: Mon, 13 Jan 2014 22:19:18 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: pull request: iwlwifi-next 2014_1_12
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="VK8ePRL46dM6cQLjbeWA40vnq9uOLb6or"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VK8ePRL46dM6cQLjbeWA40vnq9uOLb6or
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

This is the last pull request for 3.14 - (exact same beginning as my
last pull request :)).
I have here a bunch of things that accumulated since my last pull request=
=2E

Besides a few trivial patches, I have an important workaround for a HW
issue that has kept me busy for a long time. Along with it, a fix that
prevents an error from being printed.
Eyal fixes our behavior against SISO APs and Ilan fixes an issue with
multiple interface scenarios.
Eliad fixes an error path in our init flow.
We also have a few "static analyzers" fix.

I want to hope that this makes it to 3.14 through net-next.git. If not,
I'll have to sent a few of them to net.git which is not a big disaster.

The following changes since commit 14648d6534477952633ee3ecadb31cf227414f=
13:

  iwlwifi: mvm: fix coccinelle warnings (2013-12-31 19:03:53 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
for-john

for you to fetch changes up to cf38e4f756d6396657c76f72ef42b6f47c523f97:

  iwlwifi: mvm: don't use highest rate in VHT MCS Set (2014-01-13
22:17:22 +0200)

----------------------------------------------------------------
David Spinadel (1):
      iwlwifi: mvm: add REPLY_SF_CFG_CMD to cmd strings

Eliad Peller (2):
      iwlwifi: mvm: fix missing cleanup in .start() error path
      iwlwifi: mvm: fix tx seq_ctrl debug print

Emmanuel Grumbach (6):
      iwlwifi: mvm: don't set the drain bit when we flush the AP station
      iwlwifi: pcie: enable oscillator for L1 exit
      iwlwifi: mvm: send all the NVM sections to the NIC
      iwlwifi: mvm: fix SRAM dump debugfs handler
      iwlwifi: mvm: remove unused flags from add station command
      iwlwifi: mvm: reset Thermal Throttling's SMPS request upon
disassociation

Eyal Shapira (4):
      iwlwifi: mvm: rs: fix handling of column switch error
      iwlwifi: mvm: rs: fix a theoretical out of bounds access
      iwlwifi: change beamformee STS cap
      iwlwifi: mvm: don't use highest rate in VHT MCS Set

Eytan Lifshitz (1):
      iwlwifi: mvm: fix theoretical uninitialized function return value

Ilan Peer (2):
      iwlwifi: mvm: clear ap_ibss_active in case of failure
      iwlwifi: mvm: update power after binding in start_ap_ibss()

Johannes Berg (2):
      iwlwifi: mvm: use array indexing instead of treating it as a pointe=
r
      iwlwifi: add inline helper for packet lengths

 drivers/net/wireless/iwlwifi/dvm/mac80211.c   |    3 +--
 drivers/net/wireless/iwlwifi/dvm/rx.c         |    7 ++-----
 drivers/net/wireless/iwlwifi/dvm/ucode.c      |    7 +------
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c  |    9 +-------
 drivers/net/wireless/iwlwifi/iwl-prph.h       |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-trans.h      |   10 +++++++++
 drivers/net/wireless/iwlwifi/mvm/d3.c         |   15 ++++++-------
 drivers/net/wireless/iwlwifi/mvm/debugfs.c    |    2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h |    3 ---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c   |   28
+++++++++++++++++++------
 drivers/net/wireless/iwlwifi/mvm/nvm.c        |   13 ++++++------
 drivers/net/wireless/iwlwifi/mvm/ops.c        |    2 ++
 drivers/net/wireless/iwlwifi/mvm/rs.c         |   13 ++++++------
 drivers/net/wireless/iwlwifi/mvm/time-event.c |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/tx.c         |    9 ++++----
 drivers/net/wireless/iwlwifi/mvm/utils.c      |    4 ++--
 drivers/net/wireless/iwlwifi/pcie/rx.c        |    2 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c     |   22 +++++++++++++++++++=

 18 files changed, 94 insertions(+), 63 deletions(-)


--VK8ePRL46dM6cQLjbeWA40vnq9uOLb6or
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJS1EpIAAoJEC0Llv5uNjIBpTIP/28ojxX+RH+NOa5FQMR5yWHX
ezh+WEH1SELkzofiLn+Qh768EM3VH8p2JeUbA0BtD9hZycMHuADLz6UqsxC1R41+
solfvCb1QTzn31IblhEH+SvIjgsku/HQTS0yxs7zvdHSV4BJ9nyUEwsIZ45TTIZS
CPDpzXXQT5lbr40HoDXK4YTmW7lDMDIxYIJ2lJPJO55K8BOyejRysPBVfm/e8x2x
VgsbxSx4XZWVFpz1JnWAyA/vt8Vi3I/D3jAQ3JHASih0Mi78yJ6d4O0co5w4DlGg
yGCH15h9fgX6I0TPNHrvV+vytcRoP22lGtBi0DnGYp6eutcr8agZ3snJ23zDoM7V
EsuOSys6NMBC29UMMMUgRmBEJp9XFdRTvNvZwAK0VkEhxRA/DkoTDyBEVpq7BXv3
9ehi8XhojQuMK0jvaJrqp8hqPue6prB4t7nAawfM6FWqw1PY464+T3LtDaGV5MP+
mowjKHQoCP5ns5gNQLNiwKf9ZUBavFr3B3nALLd7cAdwaV/1OKioVnM+uGH+spij
oMQvv3ERnmqdPZmYjw8g5UxOZweGnWwaDv977HQgl1dbBC9nwj7ryvSf1h3xQDSN
LKJJjbwbmxEv3MK9TWjSJMVpVEmxDejTl9sWncuTnvJOZH+lR7TVOUC0s1XZ+2Ul
MNJFjRrHkEKnxYjbBKgU
=R50I
-----END PGP SIGNATURE-----

--VK8ePRL46dM6cQLjbeWA40vnq9uOLb6or--
