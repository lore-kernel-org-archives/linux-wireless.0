Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:41988 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101AbaFXTvw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:51:52 -0400
Received: by mail-wi0-f169.google.com with SMTP id hi2so6414946wib.2
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:51:46 -0700 (PDT)
Message-ID: <53A9D6CF.9040100@gmail.com> (sfid-20140624_215156_258273_D79B210F)
Date: Tue, 24 Jun 2014 22:51:43 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com
Subject: pull request: iwlwifi-next 2014-06-24
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="3fMpeV9hWvWJNxBBQ5B05idpAq6cQQ0qV"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3fMpeV9hWvWJNxBBQ5B05idpAq6cQQ0qV
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

This is a pull request for 3.17.

I have here a whole bunch of various things. Andy contributes better debu=
g prints for dvm specific flows and a module parameter to completely disa=
ble power save for dvm. Andrei is sharing the premises of his work on CSA=
 - more to come. Eran and Liad keep on working on the new devices. I have=
 the regular amount of BT Coex stuff and I continue to work on the firmwa=
re error report system adding more debug capabilities. More to come on th=
at subject too.

I merged iwlwifi-fixes in order to be able to apply patches that relied o=
n patches there.

Let me know if you have problems - please pull.

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b3=
8f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git =
master

for you to fetch changes up to c47af22ad630e03053f3eeefd19bd8274989ffbb:

  iwlwifi: mvm: handle device start failures during restart (2014-06-24 2=
1:55:41 +0300)

----------------------------------------------------------------
Andrei Otcheretianski (1):
      iwlwifi: mvm: Introduce an API to set STA_FLG_DISABLE_TX flag

Andy Lutomirski (3):
      iwlwifi: pcie: log when waking the NIC for hcmd submission fails
      iwlwifi: pcie: improve debugfs queue info
      iwlwifi: dvm: add a force_cam module parameter to fully disable pow=
er saving

David Spinadel (4):
      iwlwifi: mvm: use ksize to memset scan_command
      iwlwifi: mvm: don't use hardcoded num of scan channels
      iwlwifi: fix NVM channel attribute map.
      iwlwifi: mvm: support extended beacon notification

Eliad Peller (3):
      iwlwifi: mvm: rework sched scan channel configuration
      iwlwifi: remove MCS32 support declaration
      iwlwifi: mvm: disable beacon filtering escape timer in d0i3

Emmanuel Grumbach (11):
      iwlwifi: bump API version for 8000 devices
      Merge remote-tracking branch 'iwlwifi-fixes/master' into iwlwifi-ne=
xt
      iwlwifi: add device / firmware to fw-error-dump file
      iwlwifi: rename iwl_mvm_fw_error_next_data
      iwlwifi: pcie: add firmware monitor capabilities
      iwlwifi: mvm: BT Coex - allow to force the antenna allocation
      iwlwifi: mvm: BT Coex - allow MIMO in more cases
      iwlwifi: mvm: BT Coex - don't limit rate control if TTC is on
      iwlwifi: mvm: BT Coex - add reduced Tx power thresholds to constant=
s
      iwlwifi: mvm: BT Coex - avoid the shared antenna for management fra=
mes
      iwlwivi: mvm: BT Coex - properly set the priority of beacons

Eran Harary (2):
      iwlwifi: mvm: fixes for 8000 NVM flow
      iwlwifi: mvm: fix bug in set_hw_address function

Johannes Berg (2):
      iwlwifi: mvm: add back support for low-priority scan
      iwlwifi: mvm: handle device start failures during restart

Liad Kaufman (3):
      iwlwifi: update trans->hw_rev 8000 hw family format
      iwlwifi: nvm: update maximal parsed values in external nvm
      iwlwifi: mvm: assure no overflows occur while reading otp

 drivers/net/wireless/iwlwifi/dvm/power.c         |   9 +++++++++
 drivers/net/wireless/iwlwifi/iwl-8000.c          |   5 ++---
 drivers/net/wireless/iwlwifi/iwl-config.h        |   2 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c           |  15 +++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c  |   1 -
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h |  46 +++++++++++++++++=
+++++++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-fw-file.h       |   6 ++++--
 drivers/net/wireless/iwlwifi/iwl-fw.h            |   8 ++++++++
 drivers/net/wireless/iwlwifi/iwl-modparams.h     |   2 ++
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c     |  56 +++++++++++++++++=
+++++++++++++++++++++++----------------
 drivers/net/wireless/iwlwifi/iwl-prph.h          |   6 ++++++
 drivers/net/wireless/iwlwifi/mvm/coex.c          |  77 +++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++-------------
 drivers/net/wireless/iwlwifi/mvm/constants.h     |   2 ++
 drivers/net/wireless/iwlwifi/mvm/debugfs.c       |  39 +++++++++++++++++=
++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h   |  10 +++++++++-
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h  |   2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h   |  47 ++++++++++++++---=
------------------------------
 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h    |   7 ++-----
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h     |  14 ++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c      |  45 +++++++++++++++++=
++++++++++++----------------
 drivers/net/wireless/iwlwifi/mvm/mac80211.c      |  15 ++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h           |  14 ++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/nvm.c           |  29 +++++++++++++++++=
++++++++----
 drivers/net/wireless/iwlwifi/mvm/ops.c           |  31 +++++++++++++++++=
++++++++------
 drivers/net/wireless/iwlwifi/mvm/scan.c          | 115 +++++++++++++++++=
+++++++++++++++++++++++++++++++++----------------------------------------=
-------------------------
 drivers/net/wireless/iwlwifi/mvm/sta.c           |  20 +++++++++++++++++=
+++
 drivers/net/wireless/iwlwifi/mvm/sta.h           |   2 ++
 drivers/net/wireless/iwlwifi/mvm/tx.c            |   8 +++++++-
 drivers/net/wireless/iwlwifi/pcie/internal.h     |   7 +++++++
 drivers/net/wireless/iwlwifi/pcie/trans.c        | 145 +++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++------
 drivers/net/wireless/iwlwifi/pcie/tx.c           |   1 +
 31 files changed, 609 insertions(+), 177 deletions(-)


--3fMpeV9hWvWJNxBBQ5B05idpAq6cQQ0qV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTqdbPAAoJEC0Llv5uNjIBGWYQAJGSB7NY5IeyxQAt6Or7jHHw
wLsipR74edKT7P4NcA1czSKAKGAPnv4mmMBDgBlbb+mzL0eB7k1HLiLTrTJSbDoh
+gN2iDu6+RoPCPGxXsnwpQ8uSZUOfMMZ7+RnDHy4lT6e+tvvqwHO+fMgwOzL8KLp
vwI0rlDFE26DwdHIMdNOjz5r0NFtfsujaMtB+URfqh1AiXyd1cRuvfT56xPY5cuf
kvyz1Z3ZWdj+frwoIS4h1TDzldjve6e7y4YBUf0ovLEuC2RYkulgNfttmWxf2P/s
mb3+Fs/QiA+OoF27gnzol9szwYgRYZYBT+n2xTAb2TgdxITeDdfWKEK7eXLJcNhc
nZVm0QB0FeFRvZ8Ngx3zE0+v+b4hLClRziundihtmtnilYbn5OtXXDeHQtE+Zg82
YWZBL7s684bPGizB5n5zT/3PLYA3ma82sLYwRv31mG9XqMaf9J5HG/P+0XlTU1yd
ZBvFVoPBRDCOL2tiEwe6fISxeJspA+z9c5Ux0N3rf82PZqCUk2gF72t7464mTKil
meHdaG9arU/wqzuUmwOLC38rqYWkc6Il3cinNOXi36BQXmxdhL0o8NaIaE/qAMuB
H70rJ4lid1X+W0HF1xHHUJqHk6MZuOqgbZcbdjmSeay62aUpvyUcTG+tWMGz0RO+
+gKP2A6oafl2fNjaZTgm
=gFS4
-----END PGP SIGNATURE-----

--3fMpeV9hWvWJNxBBQ5B05idpAq6cQQ0qV--
