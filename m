Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63695 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaGFJdy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:33:54 -0400
Received: by mail-wg0-f44.google.com with SMTP id k14so3121142wgh.27
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:33:53 -0700 (PDT)
Message-ID: <53B917DC.5050902@gmail.com> (sfid-20140706_113359_823727_DB2B935B)
Date: Sun, 06 Jul 2014 12:33:16 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: pull request: iwlwifi-next 2014-07-06
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="0tqAV2XCgevmNPmIr1cnKCcVX0DFJc6jo"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0tqAV2XCgevmNPmIr1cnKCcVX0DFJc6jo
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

This is a pull request intended for 3.17. Note that I merged wireless-nex=
t because of dependencies on mac80211.
I also merged iwlwifi-fixes to avoid conflicts.

Highlight here is the continuation of CSA by Andrei and Luca and Arik's w=
ork on TDLS - both are yet to be continued.
David has a new firmware API for Scan, and I add a new API for BT Coex. A=
long with that, the usual amount of work on new devices and fixes.

Please pull. Thanks!

The following changes since commit 15be8e89cdd999124a2307ffd6dacb895c3b80=
2e:

  b43: add more bcma cores (2014-07-01 14:29:39 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git =
for-john

for you to fetch changes up to 0620b78632d4d3799d67ae846d30b3f07cba3862:

  iwlwifi: mvm: minor fix in comment (2014-07-06 12:28:04 +0300)

----------------------------------------------------------------
Andrei Otcheretianski (4):
      iwlwifi: mvm: Use beacon_get_template instead of beacon_get
      iwlwifi: mvm: Protect mvm->csa_vif with RCU
      iwlwifi: mvm: Reflect GO channel switch in NoA
      iwlwifi: mvm: Use CS tx block bit for AP/GO

Arik Nemtsov (5):
      Revert "iwlwifi: remove IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT flag"
      iwlwifi: mvm: disallow new TDLS stations when appropriate
      iwlwifi: mvm: protect TDLS discovery session
      iwlwifi: disable PSM on vifs with associated TDLS peers
      iwlwifi: mvm: teardown TDLS peers when initiating DCM

David Spinadel (3):
      iwlwifi: mvm: add unified LMAC scan API
      iwlwifi: mvm: init lmac scan command
      iwlwifi: mvm: fix endianity in scan command

Eliad Peller (2):
      iwlwifi: mvm: rs: don't clear persistent fields
      iwlwifi: mvm: rs: don't save debugfs files

Emmanuel Grumbach (21):
      iwlwifi: dvm: don't enable CTS to self
      iwlwifi: mvm: disable CTS to Self
      Merge remote-tracking branch 'iwlwifi-fixes/master' into iwlwifi-ne=
xt
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-ne=
xt
      iwlwifi: fix naming mistake for the fw_monitor module parameter
      iwlwifi: remove wrong comment about alignment in iwl-fw-error-dump.=
h
      iwlwifi: mvm: don't collect logs in the interrupt thread
      iwlwifi: mvm: kill iwl_mvm_fw_error_rxf_dump
      iwlwifi: mvm: update layout of firmware error dump
      iwlwifi: rename iwl_fw_error_fw_mon to iwl_fw_error_dump_fw_mon
      iwlwifi: mvm: remove unused flags from TX command
      iwlwifi: mvm: BT Coex - prepare towards new API
      iwlwifi: mvm: BT Coex - new API
      iwlwifi: mvm: BT Coex - convert the sw boost update to new API
      iwlwifi: mvm: BT Coex - convert the co-running update to new API
      iwlwifi: mvm: BT Coex - convert reduced Tx power to new API
      iwlwifi: mvm: BT Coex - add High Band retention
      iwlwifi: mvm: BT Coex - fix debugfs with old API
      iwlwifi: mvm: BT Coex - fix the ACK / CTS kill mask
      iwlwifi: mvm: BT Coex - relax constraints when TTC / RRC is active
      iwlwifi: mvm: minor fix in comment

Eran Harary (3):
      iwlwifi: mvm: read the mac address in family 8000
      iwlwifi: mvm: warn about empty OTP
      iwlwifi: 8000: drop a print when the address is invalid

Gregory Greenman (1):
      iwlwifi: mvm: wait for d0i3 exit in add interface flow

Ilan Peer (1):
      iwlwifi: mvm: Fix broadcast filtering

Johannes Berg (4):
      iwlwifi: mvm: don't send zero quota to the firmware
      iwlwifi: mvm: validate that we don't send zero quota
      iwlwifi: mvm: don't pass update type to quota iterator
      iwlwifi: mvm: remove update type argument from quota update

Liad Kaufman (1):
      iwlwifi: mvm: remove 8000 HW family setting of adc sampling on nic =
config

Luciano Coelho (3):
      iwlwifi: mvm: let iwl_mvm_update_quotas disregard a disabled vif
      iwlwifi: mvm: add switch_vif_chanctx operation
      iwlwifi: mvm: CSA unbind-bind flow support for client

Oren Givon (1):
      iwlwifi: update the 7265 series HW IDs

 drivers/net/wireless/iwlwifi/dvm/rxon.c          |   12 -
 drivers/net/wireless/iwlwifi/iwl-drv.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h |    8 +-
 drivers/net/wireless/iwlwifi/iwl-fw.h            |    5 +
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c     |   63 ++++-
 drivers/net/wireless/iwlwifi/mvm/Makefile        |    2 +-
 drivers/net/wireless/iwlwifi/mvm/coex.c          |  442 ++++++++++++++--=
-------------------
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c   | 1260 ++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++++++++
 drivers/net/wireless/iwlwifi/mvm/debugfs.c       |  202 ++++++++++++----=

 drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h   |  230 ++++++++++++++--=
--
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h   |  209 ++++++++++++++++=
-
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h     |   16 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h        |   11 +-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c      |   71 +++++-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c      |  495 ++++++++++++++++=
++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/mvm/mvm.h           |   95 ++++++--
 drivers/net/wireless/iwlwifi/mvm/nvm.c           |    2 +
 drivers/net/wireless/iwlwifi/mvm/ops.c           |  133 +++--------
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c      |   26 +++
 drivers/net/wireless/iwlwifi/mvm/power.c         |   39 ++--
 drivers/net/wireless/iwlwifi/mvm/quota.c         |   38 +--
 drivers/net/wireless/iwlwifi/mvm/rs.c            |   96 ++++----
 drivers/net/wireless/iwlwifi/mvm/rs.h            |   19 +-
 drivers/net/wireless/iwlwifi/mvm/rx.c            |   17 ++
 drivers/net/wireless/iwlwifi/mvm/scan.c          |  457 ++++++++++++++++=
+++++++++++++++-----
 drivers/net/wireless/iwlwifi/mvm/sta.c           |   54 +++++
 drivers/net/wireless/iwlwifi/mvm/sta.h           |   10 +
 drivers/net/wireless/iwlwifi/mvm/time-event.c    |   73 ++++++
 drivers/net/wireless/iwlwifi/mvm/time-event.h    |   29 +++
 drivers/net/wireless/iwlwifi/mvm/tx.c            |   17 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c         |   65 ------
 drivers/net/wireless/iwlwifi/pcie/drv.c          |    3 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c        |    4 +-
 33 files changed, 3375 insertions(+), 830 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c


--0tqAV2XCgevmNPmIr1cnKCcVX0DFJc6jo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTuRftAAoJEC0Llv5uNjIBCn8QAIlHq1qL3rsgB8WHhvxkInCc
asB5yROQB1c9jTPrJYPXMD6vbFZAaMjYM83Tvk5mhQ7r84kcswQ3/WzWP3/3vxgh
3fNpQsoDGymZFNP8xlQw6fGMVfmzClJnOkci+1CMuGK+w+D0PmlK+clsIQj00pOj
4TcdKIJbh/vFlNyFh/fSPIU+RgcexQSrkelHIvZWteq9xBe8noXHFeYC8PwnGYSl
XgC5zjR8NP59cXisukcURo8VzmXEERp89jbyjWlYInyFjjBDMtwHYRj9sziu+2+i
9zBcK/1aOvf288hyk+csO94MPHjzOEApmRT2ojPMGRTfYUWXuhpOoRhW0GE7D2LB
L+EYyngvtWnQag3YbETZ6ywX8toomcqF0vzwqrWQIQ2XSzxGya9y9Fm2HZbrRPtg
HE1O2fg/BopvZECI26a5DG/ginif3KrerujL2KroVYBfjj7pGPh8ACiF8YFr4lf6
uU04jowXkz9BtCBvz32JtiGOuXE5TM78ASwo4QQvAvUoKbDRrsf6NWOreawlUSIg
Gjq5GzHVB00cY6Oyn1roiYbDJbM+zkeh5kbydC7X8XtsZk0e6D/oWiK5WPAhVNoj
bVkClhAGjm4gkXCps50cmcqi0K0Eu2TnWMOwHdnk56YRhQGu/5jimYQ78b5kkdr6
I5/wv5rvZGE14JYXgtuL
=/lKQ
-----END PGP SIGNATURE-----

--0tqAV2XCgevmNPmIr1cnKCcVX0DFJc6jo--
