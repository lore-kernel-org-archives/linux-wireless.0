Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:33765 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000AbaDMTTU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:19:20 -0400
Received: by mail-wg0-f50.google.com with SMTP id x13so7248621wgg.21
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:19:19 -0700 (PDT)
Message-ID: <534AE330.2020805@gmail.com> (sfid-20140413_211928_170533_C013B72C)
Date: Sun, 13 Apr 2014 22:19:12 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: pull request: iwlwifi 2014-04-13
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="KtwPHt6UUAoWb3bI0GFWCTHhQ93qEgISk"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KtwPHt6UUAoWb3bI0GFWCTHhQ93qEgISk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

This is for 3.16.

I have here a bunch of unrelated things. I disabled support for -7.ucode =
which means that I can removed a lot of code. Eliad has a brand new featu=
re: we reduce the Tx power when the link allows - this reduces our power =
consumption. The regular changes in power and scan area. One interesting =
thing though is the patches from Johannes, we have now GRO which allows t=
o increase our throughput in TCP Rx. The main advantage is that it reduce=
s the number of TCP Acks - these TCP Acks are completely useless when we =
are using A-MPDU since the first packet of the A-MPDU generates a TCP Ack=
 which is made obsolete by the next packets.

Same footer as previous pull request, I won't be available this week, so =
let's hope I am not causing any problem here.

Thanks!

The following changes since commit a31267c30880ebdc73e6815f58c69a665052fa=
b8:

  rtl8187: fix use after free on failure path in rtl8187_probe() (2014-03=
-31 13:47:41 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git =
master

for you to fetch changes up to 3cd5279b021de6501a8012dd856d7a78ee58ead9:

  iwlwifi: don't disable SCD chain extension on newer devices (2014-04-13=
 22:02:44 +0300)

----------------------------------------------------------------
Alexander Bondar (2):
      iwlwifi: mvm: Change scan fragmentation condition
      iwlwifi: mvm: Fix scan parameters units

Avri Altman (2):
      iwlwifi: mvm: Handle power management constraints for additional us=
e-cases
      iwlwifi: mvm: Re-factor enabling uAPSD logic

Eliad Peller (4):
      iwlwifi: mvm: add lq_cmd/tx_resp reduced_tpc field
      iwlwifi: mvm: add ATPC implementation
      iwlwifi: mvm: add debugfs file for fixed reduced tx power
      iwlwifi: mvm: don't use d3 fw if d0i3 is used

Emmanuel Grumbach (27):
      iwlwifi: pcie: don't leave the new NICs awake for commands
      iwlwifi: pcie: unify iwl_rx_replenish and iwl_rx_replenish_now
      iwlwifi: mvm: remove redundant empty line
      iwlwifi: mvm: propagate the beamforming status from firmware
      iwlwifi: mvm: don't set AP STA to EINVAL
      iwlwifi: allow to wait for a subset of the queues
      iwlwifi: pcie: WARN upon traffic while flushing TX queues
      iwlwifi: mvm: dump Rx FIFO when the firmware asserts
      iwlwifi: mvm: don't enable bcast filtering on P2P client
      iwlwifi: mvm: replace BUG_ON by WARN_ON in scan.c
      iwlwifi: mvm: deprecate -7 firmware
      iwlwifi: remove IWL_UCODE_TLV_FLAGS_NEWBT_COEX TLV flag
      iwlwifi: remove IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT flag
      iwlwifi: remove IWL_UCODE_TLV_FLAGS_RX_ENERGY_API flag
      iwlwifi: remove IWL_UCODE_TLV_FLAGS_TIME_EVENT_API_V2 flag
      iwlwifi: remove IWL_UCODE_TLV_FLAGS_BF_UPDATED flag
      iwlwifi: remove IWL_UCODE_TLV_FLAGS_D3_CONTINUITY_API flag
      iwlwifi: remove IWL_UCODE_TLV_FLAGS_SCHED_SCAN flag
      iwlwifi: remove IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT flag
      iwlwifi: remove IWL_UCODE_TLV_FLAGS_STA_KEY_CMD flag
      iwlwifi: remove IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD flag
      iwlwifi: mvm: BT Coex - don't use comma operator
      iwlwifi: mvm: BT Coex - minor API change
      iwlwifi: mvm: BT Coex - send priority tables from iwl_send_bt_init_=
conf
      iwlwifi: 7000: bump firmware API version to 9
      iwlwifi: mvm: replace leading spaces by tabs
      iwlwifi: don't disable SCD chain extension on newer devices

Eran Harary (2):
      iwlwifi: mvm: fix the number of channels in family 8000
      iwlwifi: move CPU1_CPU2_SEPARATOR_SECTION to iwl-fw.h

Eyal Shapira (1):
      iwlwifi: mvm: add per rate tx stats

Eytan Lifshitz (2):
      iwlwifi: mvm: Fix warning message when exit thermal throttling
      iwlwifi: mvm: Fix tx-backoff when NIC exit thermal throttling

Haim Dreyfuss (1):
      iwlwifi: mvm: Add support for Energy based scan (EBS)

Johannes Berg (5):
      iwlwifi: pcie: implement GRO without NAPI
      iwlwifi: pcie: clarify RX queue need_update handling and locking
      iwlwifi: pcie: use bool for TX queue where appropriate
      iwlwifi: pcie: fix TX queue locking
      iwlwifi: pcie: clarify TX queue need_update handling

Monam Agarwal (1):
      iwlwifi: mvm: Use RCU_INIT_POINTER(x, NULL)

 drivers/net/wireless/iwlwifi/dvm/lib.c           |   2 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c      |   2 +-
 drivers/net/wireless/iwlwifi/dvm/main.c          |  12 ++
 drivers/net/wireless/iwlwifi/iwl-1000.c          |   1 +
 drivers/net/wireless/iwlwifi/iwl-2000.c          |   2 +
 drivers/net/wireless/iwlwifi/iwl-5000.c          |   1 +
 drivers/net/wireless/iwlwifi/iwl-6000.c          |   3 +
 drivers/net/wireless/iwlwifi/iwl-7000.c          |  13 +-
 drivers/net/wireless/iwlwifi/iwl-config.h        |   5 +
 drivers/net/wireless/iwlwifi/iwl-fw.h            |  27 ++--
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c     |  25 ++--
 drivers/net/wireless/iwlwifi/iwl-op-mode.h       |  25 +++-
 drivers/net/wireless/iwlwifi/iwl-prph.h          |   8 ++
 drivers/net/wireless/iwlwifi/iwl-trans.h         |  10 +-
 drivers/net/wireless/iwlwifi/mvm/coex.c          |  34 +++--
 drivers/net/wireless/iwlwifi/mvm/d3.c            |  94 ++++++-------
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c   |  13 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs.c       |  15 +--
 drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h   |  38 +++---
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h     |  17 +--
 drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h     |   2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h   |  34 +++--
 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h    |  46 +------
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h     |   3 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h        |  54 +-------
 drivers/net/wireless/iwlwifi/mvm/fw-error-dump.h |   6 +-
 drivers/net/wireless/iwlwifi/mvm/fw.c            |  12 +-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c      |   5 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c      |  49 ++++---
 drivers/net/wireless/iwlwifi/mvm/mvm.h           |  26 +++-
 drivers/net/wireless/iwlwifi/mvm/ops.c           |  56 +++++++-
 drivers/net/wireless/iwlwifi/mvm/power.c         | 272 +++++++++++++++++=
+-------------------
 drivers/net/wireless/iwlwifi/mvm/rs.c            | 330 +++++++++++++++++=
+++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/rs.h            |  24 ++++
 drivers/net/wireless/iwlwifi/mvm/rx.c            |  45 +------
 drivers/net/wireless/iwlwifi/mvm/scan.c          |  75 +++++++----
 drivers/net/wireless/iwlwifi/mvm/sf.c            |   3 -
 drivers/net/wireless/iwlwifi/mvm/sta.c           | 177 +++++------------=
-------
 drivers/net/wireless/iwlwifi/mvm/sta.h           |   3 +
 drivers/net/wireless/iwlwifi/mvm/time-event.c    |  71 ++--------
 drivers/net/wireless/iwlwifi/mvm/tt.c            |  10 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c            |  11 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c         |  46 ++++++-
 drivers/net/wireless/iwlwifi/pcie/internal.h     |   9 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c           |  84 ++++++------
 drivers/net/wireless/iwlwifi/pcie/trans.c        |  47 ++++++-
 drivers/net/wireless/iwlwifi/pcie/tx.c           |  62 +++++----
 47 files changed, 1092 insertions(+), 817 deletions(-)


--KtwPHt6UUAoWb3bI0GFWCTHhQ93qEgISk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTSuM0AAoJEC0Llv5uNjIBJ7sQAK8o3vE6DbYe1qBq9stsyZ+k
puCsPA+sa7P3qJ4srYtuWlBgVelPHAWhVCNjtdgV78DRLZUy2LopAs6f256vBVRO
16hFi47XzJJkwx4BhOrNKHiU3gY/qSMWFLr6AlpdmjOB3AeutjbrOPV+ZSLNAPul
0KeBYt408Mhls2WQd7RvcWY10QT0+WA5AQDhzFyqAwtx0GOYo0YTc47FeftTcaj8
qeJPqECoyq8KdUcofkaRr7RynuJ7Lm78MEVifMlGw8WoPpgbTA80eNXsJkXvJNfa
FNM3D6/ki3Hwupoh8+1yAQvJowcZVKTV4ru6VVowTH9PdLzSMFC4WzIQNuAf70ib
O+Q6M1czcwPLJ15omxMFtIB2LnjynafMb5IETvPR/t/hiZUPg1+qTrgJzaoJljJi
2MK36YO5cmROwmnUiw62fdj6zD3poia4IDcyUVvUJAa8IjKr7x57eVZFWG/BrQQx
bFx2phWdZ/IVL/ADnbbHqH65A7ctLmyt4TsooV00MQZquLANIiU14Rm6Lh7quW5w
V5vkM7RxoK4wsUsXlWjvAo/8QnZBCkw8gCMc8Q9rh7nrxsus69YbhYhWnsVxiE5F
jj0KLQNMZe+xnXWUpCrpmHtlgzL6Vt6nkG1g4T9u49L9Y3CSi282T8fdBNcKiPa9
dqIHq6TlLXcEY9AlC7+y
=OFV4
-----END PGP SIGNATURE-----

--KtwPHt6UUAoWb3bI0GFWCTHhQ93qEgISk--
