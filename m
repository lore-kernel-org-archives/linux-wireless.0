Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:58442 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbaBWTxM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 14:53:12 -0500
Received: by mail-we0-f173.google.com with SMTP id x48so3978724wes.4
        for <linux-wireless@vger.kernel.org>; Sun, 23 Feb 2014 11:53:10 -0800 (PST)
Message-ID: <530A51A4.6000007@gmail.com> (sfid-20140223_205331_553110_E1D77EF7)
Date: Sun, 23 Feb 2014 21:53:08 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: pull request: iwlwifi-next 2014-02-23
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="HpM3u2XVQVn4gFSbIGDJ5aWR6Kc95O9qb"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HpM3u2XVQVn4gFSbIGDJ5aWR6Kc95O9qb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

Here is pull request intended for 3.15.

I have here a whole bunch of various things. Trivial cleanups, debugfs ha=
ndlers and new stuff for the new generation of devices along with new cap=
abilities for monitor mode. We also have support for power save for dual =
interface mode, but that is not supported by the firmware currently avail=
able.

I had to merge wireless-next to get the new bits for monitor mode I added=
 in mac80211-next.git.

Let me know if you have any issue.
Thanks!

The following changes since commit e57f1734d87aa0e9a00905ed08888f0c62f562=
27:
Starting
  mwifiex: add key material v2 support (2014-02-12 15:36:26 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git =
for-john

for you to fetch changes up to 82b715c211a53e80a1db83b9b71995a05fe32908:

  iwlwifi: mvm: fix a few wd_disable comments (2014-02-23 21:38:54 +0200)=


----------------------------------------------------------------
Alexander Bondar (1):
      iwlwifi: mvm: Enable power save on BSS and P2P client in DCM

Eliad Peller (3):
      iwlwifi: pcie: clean iwl_pcie_[rt]xq_inc_wr_ptr a bit
      iwlwifi: mvm: add debugfs for prph reg read/write
      iwlwifi: mvm: fix a few wd_disable comments

Emmanuel Grumbach (4):
      iwlwifi: mvm: propagate LDPC / STBC status to radiotap
      iwlwifi: mvm: don't dump log of second CPU when not relevant
      iwlwifi: pcie: stop the firmware when we restart it
      iwlwifi: mvm: set immediate apply time bit in time events

Eran Harary (2):
      iwlwifi: mvm: new NVM format in family 8000
      iwlwifi: mvm: prepare infrastructure for more TLV flags

Eyal Shapira (1):
      iwlwifi: mvm: add Rx frames statistics via debugfs

Eytan Lifshitz (1):
      iwlwifi: mvm: fix possible memory leak

Inbal Hacohen (1):
      iwlwifi: mvm: remove redundant define in fw.c

Johannes Berg (4):
      iwlwifi: make various things const
      iwlwifi: mvm: use IEEE80211_TX_CTRL_PORT_CTRL_PROTO flag
      iwlwifi: remove iwl_fw_valid_(tx|rx)_ant inlines
      iwlwifi: nvm: remove reading valid antennas from NVM

 drivers/net/wireless/iwlwifi/dvm/agn.h          |    4 +-
 drivers/net/wireless/iwlwifi/dvm/devices.c      |    2 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c     |    2 +-
 drivers/net/wireless/iwlwifi/dvm/rx.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c          |   53 ++++-
 drivers/net/wireless/iwlwifi/iwl-drv.h          |   14 ++
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h |    5 +-
 drivers/net/wireless/iwlwifi/iwl-fw-file.h      |   17 ++
 drivers/net/wireless/iwlwifi/iwl-fw.h           |   24 +--
 drivers/net/wireless/iwlwifi/iwl-modparams.h    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c    |  245 +++++++++++++++++=
------
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.h    |    3 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h        |    2 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c  |    2 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs.c      |  118 ++++++++++-
 drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h    |    3 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h       |    5 +-
 drivers/net/wireless/iwlwifi/mvm/fw.c           |   14 +-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c     |    2 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c     |   12 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h          |   35 +++-
 drivers/net/wireless/iwlwifi/mvm/nvm.c          |   67 +++++--
 drivers/net/wireless/iwlwifi/mvm/ops.c          |    2 +-
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c     |    4 +-
 drivers/net/wireless/iwlwifi/mvm/power.c        |   48 ++++-
 drivers/net/wireless/iwlwifi/mvm/rs.c           |   93 +++++++--
 drivers/net/wireless/iwlwifi/mvm/rx.c           |   21 ++
 drivers/net/wireless/iwlwifi/mvm/scan.c         |    4 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.c   |    6 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c           |    4 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c        |    6 +-
 drivers/net/wireless/iwlwifi/pcie/internal.h    |    2 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c          |   47 ++---
 drivers/net/wireless/iwlwifi/pcie/tx.c          |   68 +++----
 34 files changed, 713 insertions(+), 225 deletions(-)


--HpM3u2XVQVn4gFSbIGDJ5aWR6Kc95O9qb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJTClGkAAoJEC0Llv5uNjIBfmcQAK44hS1Vd51qAJxNwVBwnJdo
K6kIqJdkHRtssS5jktfBsWdTMKy7ksSStxZ8tOlqbrIDmRXh4J503gOKoaFRtFPC
/QiqgYH6XOIeuLtwLJP7aJ7YLVqe4zuEcupazjzjAwfKYBmCLlS+4z4Op2rHn/zB
XdN+fjDaqoJEJ79n1Yvxha/H0f5ZnSoJuiLl4BpKy5PUDClJJhwZGY8CUxf4teVF
1ykdwMrGjJ0gufuAM9E9EcnRiJylcLl9K4Ro3X1LoivVjPnvq87KTwjPu1Njyumb
FZlHX++w9r/tD0+1N84Q9UeYogqBvsJrjLZ5GFktGdoLN2cXUHtrzCpqYPxQzSHM
xOd6oz93I6GqwLyicVPRBJ+ZI0iuYDpJBfnyHDM0BBWYJphkikKburb+wsmzY0fD
lkC1LvGWeIYD1M21fw1HcWDPG594KIhS7jJoYnzA0wXjL/nb/ci7unVlMhfLhJk8
zkn7I9rNqOR0/YMYiajWiTEVmmaB63rQnewX6DFMCyTkd5ZDiPZdvz48/CUccWhO
4vyI9nNTqb61KhPLpE/2Tw3/MLIksXn68OiPCSQbP6LrsNs6NXEf4hRAMtEufZt9
r0Mga3WFBme1aLe0JxCZYvKhwrLsUo0PtyNJsZFK/9ZIl6g8i00Fo7wZyT7BvSkX
+fsBax3cep8X5490sg8G
=RpeO
-----END PGP SIGNATURE-----

--HpM3u2XVQVn4gFSbIGDJ5aWR6Kc95O9qb--
