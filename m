Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:42236 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243Ab3LBUvp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 15:51:45 -0500
Received: by mail-we0-f178.google.com with SMTP id u57so6830271wes.37
        for <linux-wireless@vger.kernel.org>; Mon, 02 Dec 2013 12:51:43 -0800 (PST)
Message-ID: <529CF2D6.1080008@gmail.com> (sfid-20131202_215208_885220_AB8D0BC4)
Date: Mon, 02 Dec 2013 22:51:34 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: pull request: iwlwifi-next 2013-12-2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="qkjHnB1PJASw29JxS4N6HmLMhjrmsJNbs"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qkjHnB1PJASw29JxS4N6HmLMhjrmsJNbs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

This is the fixed and enlarged pull request for 3.14. It includes the
patches in my previous pull request that was based on a bad patch.

I have here a big rework of the rate control by Eyal. This is obviously
the biggest part of this batch.
I also have enhancement of protection flags by Avri and a few bits for
WoWLAN by Eliad and Luca. Johannes cleans up the debugfs plus a few
fixes. I provided a few things for Bluetooth coexistence.
Besides this we have an implementation for low priority scan.

Note that I had to merge iwlwifi-fixes into -next to solve conflicts
before they hit linux-next.
Please let me know about issues you may face - Thanks!

The following changes since commit 9d8506cc2d7ea1f911c72c100193a3677f6668=
c3:

  gso: handle new frag_list of frags GRO packets (2013-11-21 14:11:50 -05=
00)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
for-john

for you to fetch changes up to d4da46c073ebc5d74d53649bcc091deea46cb81a:

  Merge remote-tracking branch 'iwlwifi-fixes/master' into iwlwifi-next
(2013-12-02 22:28:46 +0200)

----------------------------------------------------------------

Alexander Bondar (2):
      iwlwifi: pcie: stop sending commands to dead firmware
      iwlwifi: mvm: Add debugfs entry to generate NMI to NIC

Avri Altman (1):
      iwlwifi: mvm: fix ht protection flags

Eliad Peller (4):
      iwlwifi: mvm: enable d3_test even if d3_test_pme_ptr is not availab=
le
      iwlwifi: mvm: disconnect on disconnection wakeup event
      iwlwifi: mvm: allow keeping connections in d3_test
      iwlwifi: mvm: fix scan offloading flag definition

Emmanuel Grumbach (11):
      iwlwifi: pcie: fix interrupt coalescing for 7260 / 3160
      iwlwifi: mvm: BT Coex - don't enable MULTI_PRIO_LUT
      iwlwifi: mvm: BT Coex fix another NULL pointer dereference
      iwlwifi: mvm: don't WARN about unsuccessful time event
      iwlwifi: bump required firmware API version for 3160/7260
      iwlwifi: remove TX_CMD id from transport layer
      iwlwifi: mvm: BT Coex - fine tune the aggregation size
      iwlwifi: mvm: a few more SKUs for 7260 and 3160
      iwlwifi: mvm: dump NVM from debugfs
      iwlwifi: mvm: BT Coex - enable Sync to SCO
      Merge remote-tracking branch 'iwlwifi-fixes/master' into iwlwifi-ne=
xt

Eyal Shapira (21):
      iwlwifi: mvm: fix and improve printing of rate scale table
      iwlwifi: mvm: simplify iwl_mvm_send_lq_cmd
      iwlwifi: mvm: refactor iwl_mvm_rs_rate_init
      iwlwifi: mvm: implement rate_update hook in rs
      iwlwifi: mvm: add LQ flags definitions
      iwlwifi: fix check for a single rx antenna
      iwlwifi: mvm: stop using MIMO in case BT doesn't allow it
      iwlwifi: mvm: don't enable VHT MCS9 in 20Mhz
      iwlwifi: mvm: don't configure mimo rates if nss is limited to 1
      iwlwifi: mvm: rs: improve debug prints
      iwlwifi: mvm: rs: reduce min failures to end test window
      iwlwifi: mvm: rs: update expected TPT tables if aggregation changed=

      iwlwifi: mvm: rs: rename thresholds defines
      iwlwifi: mvm: rs: increase stay in column timeout
      iwlwifi: mvm: rs: remove unused timestamp field
      iwlwifi: mvm: rs: refactor to use rs_rate
      iwlwifi: mvm: rs: remove unused parameter to rs_get_supported_rates=

      iwlwifi: mvm: rs: set dual_stream_ant_msk to ANT_AB always
      iwlwifi: mvm: rs: fix mapping from HT/VHT rates to legacy
      iwlwifi: mvm: rs: use the proper channel width define for legacy ra=
te
      iwlwifi: mvm: rs: overhaul search cycle state machine

Haim Dreyfuss (1):
      iwlwifi: mvm: Implement low-priority scan

Johannes Berg (8):
      iwlwifi: mvm: check sta_id/drain values in debugfs
      iwlwifi: pcie: remove useless condition test
      iwlwifi: mvm: small debugfs cleanups
      iwlwifi: mvm: move interface-specific debugfs to a new file
      iwlwifi: mvm: don't use void pointers in debugfs
      iwlwifi: mvm: refactor debugfs copy_from_user()
      iwlwifi: mvm: add iwl_mvm_sta_from_mac80211
      iwlwifi: mvm: quota command max_duration should be zero

Luciano Coelho (3):
      iwlwifi: mvm: set seqno also when no keys are set
      iwlwifi: mvm: use a cast to calculate the last seqno from the next =
one
      iwlwifi: mvm: don't restart HW if suspending fails before D3 image
is loaded

Michal Nazarewicz (1):
      iwlwifi: pcie: remove minor dead code

Oren Givon (1):
      iwlwifi: add new HW - 7265 series

 drivers/net/wireless/iwlwifi/dvm/rs.h             |    7 -
 drivers/net/wireless/iwlwifi/dvm/tx.c             |    1 +
 drivers/net/wireless/iwlwifi/iwl-7000.c           |   29 +-
 drivers/net/wireless/iwlwifi/iwl-config.h         |   11 +
 drivers/net/wireless/iwlwifi/iwl-csr.h            |    5 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c      |    3 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h           |    3 +
 drivers/net/wireless/iwlwifi/mvm/Makefile         |    1 +
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c        |   19 +-
 drivers/net/wireless/iwlwifi/mvm/d3.c             |   43 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c    |  190 +++
 drivers/net/wireless/iwlwifi/mvm/debugfs.c        |  640 +-------
 drivers/net/wireless/iwlwifi/mvm/debugfs.h        |  101 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h |    1 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h      |   27 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h    |    5 +-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c       |   51 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c       |   19 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h            |   11 +-
 drivers/net/wireless/iwlwifi/mvm/nvm.c            |   23 +
 drivers/net/wireless/iwlwifi/mvm/quota.c          |    3 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c             | 1685
+++++++++++----------
 drivers/net/wireless/iwlwifi/mvm/rs.h             |  150 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c           |   55 +-
 drivers/net/wireless/iwlwifi/mvm/sta.c            |   14 +-
 drivers/net/wireless/iwlwifi/mvm/sta.h            |    6 +
 drivers/net/wireless/iwlwifi/mvm/time-event.c     |    7 +-
 drivers/net/wireless/iwlwifi/mvm/tt.c             |    2 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c             |   11 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c          |    8 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c           |   26 +
 drivers/net/wireless/iwlwifi/pcie/internal.h      |    8 +
 drivers/net/wireless/iwlwifi/pcie/rx.c            |   33 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c         |    3 -
 drivers/net/wireless/iwlwifi/pcie/tx.c            |   37 +-
 35 files changed, 1628 insertions(+), 1610 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/debugfs.h


--qkjHnB1PJASw29JxS4N6HmLMhjrmsJNbs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJSnPLcAAoJEC0Llv5uNjIBcioP/jBu2qnxyoBdugWi2+rxhABX
bV2Z3g40ih1EisvskpP85PYEhwvY9FMdTihpIUxySXNcR4lYmMAIR/bpQM2SLqX2
FPVZA/AH0sHAY3gMe78wXuS/Jxm14qy3TK49eQA2mUXnaZ2RryWl79v7sbVHH733
ylcobmGYcv1Y8BaMYpRrDf+K6bn4g88PJZFjSfPZ/mcMv546AvdWfT2fSMMhc+Dj
mYNO/T5G2bbF94qjkuGw/5RXL/HO38YdH/uv3HEBoOAGdWIdWkdVbpRUhUCXghFe
5ILPMxWbLJMkaDKKDniLChy3cqJQ1SYnnQyDLDSmRg8VUWbtiPMEqT7kMMCilxNY
2SYpFZpj5yHgLbVPWTBTGO20CAS8w1w+IqGOKJJi6OM2Tl8Wga+gLogAwIj3+Lxf
hmN1oJA9PvlRwWuV4/0hwwj1OQ4ZUZDQZQGFIl0/yihp8ExpBh5jwyfv2Jr5OpBn
8dGQRNgYwYV0wlzJpvnv2Cw7ZIiwdhfDdcZPZNyhRYdBLgAlKAuLp2ulcM8Lt64L
2UcCvS1jy1QO/HIR/YiJAgIykX0iPYG2PFXP3iNygsO+y/1TKykihbis8H6norEm
9/cOHNH7WBSXVlHpqPY/m9G2uXrNYOBiliJEL8tsb8XtXofimNlLQ1ywX3T2dFsk
ijpacTTO6D5gfyuu6XOr
=csGT
-----END PGP SIGNATURE-----

--qkjHnB1PJASw29JxS4N6HmLMhjrmsJNbs--
