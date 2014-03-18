Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:40345 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647AbaCROlv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:41:51 -0400
Received: by mail-wi0-f182.google.com with SMTP id d1so3795752wiv.3
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:41:49 -0700 (PDT)
Message-ID: <53285AF8.7050305@gmail.com> (sfid-20140318_154155_771557_CBCDFEE2)
Date: Tue, 18 Mar 2014 16:40:56 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com
Subject: pull request: iwlwifi-next 2013-03-18
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="2veFrPnrFEfX2gHHDFE2AedieKbdbntLr"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2veFrPnrFEfX2gHHDFE2AedieKbdbntLr
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

Here is another pull request for 3.15. I guess it will be the last one un=
less some issue arises.
I have a fix for a "merge damage" which is not really a merge damage: it =
enables scheduled scan which has been disabled in wireless.git. Since you=
 merged wireless.git into wireless-next.git, this can now be fixed in wir=
eless-next.git.

Besides this, Alex made a workaround for a hardware bug. This fix allows =
us to consume less power in S3. Arik and Eliad continue to work on D0i3 w=
hich is a run-time power saving feature. Eliad also contributes a few bit=
s to the rate scaling logic to which Eyal adds his own contribution. Avri=
 dives deep in the power code - newer firmware will allow to enable power=
 save in newer scenarios. Johannes made a few clean-ups. I have the regul=
ar amount of BT Coex boring stuff. I disable uAPSD since we identified fi=
rmware bugs that cause packet loss. One thing that do stand out is the ud=
ev event that we now send when the FW asserts. I hope it will allow us to=
 debug the FW more easily.

The udev thing will need tiny effort from distributions: to put the scrip=
t and the udev rule (copied in the commit message) in place. Note that we=
 have a debugfs hook to trigger a FW assert, so that it shouldn't really =
be an issue to put that in place and test that it actually works. The pur=
pose of this is to have a file in /var/log (or wherever) with FW state / =
logs that we can give to the FW teams. I took the idea from the GPU folks=
 who have a similar concept and Ubuntu even has a udev rule that dumps th=
e error when something bad occurs (/sys/kernel/debug/dri/0/i915_error_sta=
te). I used debugfs, but I saw that Ubuntu ships with debugfs compiled an=
d mounted (I hope this is the standard configuration). I haven't done an =
extensive research about other distros though...

Let me know if you have issues with this!


The following changes since commit 3e3831c4fdc53aabf3a56419ef6d96a841c524=
35:

  brcmfmac: reset suspend flag upon sdio suspend failure (2014-02-28 14:3=
3:49 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git =
for-john

for you to fetch changes up to 4a482d61e0f87a655f1e022a09ec48bca11dd898:

  iwlwifi: mvm: disable uAPSD due to bugs in the firmware (2014-03-18 16:=
32:45 +0200)

----------------------------------------------------------------
Alexander Bondar (4):
      iwlwifi: pcie: enable LP XTAL to reduce power consumption
      iwlwifi: mvm: Change beacon filter enablement condition
      iwlwifi: mvm: restructure scan parameters calculation
      iwlwifi: mvm: configure low latency dependent scan parameters

Arik Nemtsov (3):
      iwlwifi: mvm: wait for stop sched-scan completion
      iwlwifi: mvm: abort scan on sched_scan request
      iwlwifi: mvm: reconfigure qos seq on D0i3 exit

Avri Altman (1):
      iwlwifi: mvm: disable power on P2P client when BSS is added

Eliad Peller (5):
      iwlwifi: mvm: check for d0i3 fw capability
      iwlwifi: rs: split rs_collect_tx_data
      iwlwifi: add rs_rate_scale_clear_tbl_windows helper function
      iwlwifi: mvm: configure seq_num to D0i3
      iwlwifi: mvm: configure protocol offloading on D0i3

Emmanuel Grumbach (12):
      iwlwifi: mvm: fix quota for D3 image
      iwlwifi: mvm: fix scan offload for BGN SKU
      iwlwifi: mvm: BT Coex add support for Co-running block
      iwlwifi: mvm: make bt-coex.c generic
      iwlwifi: mvm: BT Coex - classify packet priority in BT code
      iwlwifi: mvm: BT Coex - enable per-AC BT priority
      iwlwifi: mvm: fix merge damage
      iwlwifi: mvm: don't fail completely if led mode is not supported
      iwlwifi: mvm: send udev event upon firmware error to dump logs
      iwlwifi: mvm: BT Coex - add debugfs hook to set BT Tx priority
      iwlwifi: mvm: fix theoretical NULL ptr dereference
      iwlwifi: mvm: disable uAPSD due to bugs in the firmware

Eyal Shapira (3):
      iwlwifi: mvm: cleanups in iwl_dbgfs_frame_stats_read
      iwlwifi: mvm: rs: fix search cycle rules
      iwlwifi: mvm: don't enable protection for all AMPDUs

Johannes Berg (7):
      iwlwifi: mvm: init drv_stats_lock
      iwlwifi: pcie: suppress ACPI related error message
      iwlwifi: nvm: fix VHT capability antenna-dependent fields
      iwlwifi: return whether to stop from rfkill method
      iwlwifi: mvm: remove using max_duration in firmware API
      iwlwifi: mvm: remove spurious blank line
      iwlwifi: mvm: ignore unchanged low-latency flag

 drivers/net/wireless/iwlwifi/dvm/main.c                              |  =
 4 +-
 drivers/net/wireless/iwlwifi/iwl-7000.c                              |  =
 4 +
 drivers/net/wireless/iwlwifi/iwl-config.h                            |  =
 1 +
 drivers/net/wireless/iwlwifi/iwl-csr.h                               |  =
38 +++++++++
 drivers/net/wireless/iwlwifi/iwl-fw.h                                |  =
16 ++++
 drivers/net/wireless/iwlwifi/iwl-io.c                                |  =
 4 +-
 drivers/net/wireless/iwlwifi/iwl-io.h                                |  =
 2 +
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c                         |  =
19 +++--
 drivers/net/wireless/iwlwifi/iwl-op-mode.h                           |  =
11 +--
 drivers/net/wireless/iwlwifi/iwl-prph.h                              |  =
23 +++++-
 drivers/net/wireless/iwlwifi/mvm/Makefile                            |  =
 4 +-
 drivers/net/wireless/iwlwifi/mvm/{bt-coex.c =3D> coex.c}               |=
 336 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++++++++--
 drivers/net/wireless/iwlwifi/mvm/constants.h                         |  =
 4 +-
 drivers/net/wireless/iwlwifi/mvm/d3.c                                | 1=
95 ++++++++--------------------------------------
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c                       |  =
 5 ++
 drivers/net/wireless/iwlwifi/mvm/debugfs.c                           | 1=
09 ++++++++++++++++++++++----
 drivers/net/wireless/iwlwifi/mvm/{fw-api-bt-coex.h =3D> fw-api-coex.h} |=
   4 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h                         |  =
 8 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h                         |  =
 3 +
 drivers/net/wireless/iwlwifi/mvm/fw-api.h                            |  =
 3 +-
 drivers/net/wireless/iwlwifi/mvm/fw-error-dump.h                     | 1=
06 +++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/led.c                               |  =
 2 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c                          | 1=
45 ++++++++++++++++++++++++++++-------
 drivers/net/wireless/iwlwifi/mvm/mvm.h                               |  =
56 ++++++++++++--
 drivers/net/wireless/iwlwifi/mvm/offloading.c                        | 2=
15 +++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/ops.c                               | 2=
29 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/net/wireless/iwlwifi/mvm/power.c                             |  =
17 ++--
 drivers/net/wireless/iwlwifi/mvm/quota.c                             |  =
23 +-----
 drivers/net/wireless/iwlwifi/mvm/rs.c                                |  =
88 +++++++++++----------
 drivers/net/wireless/iwlwifi/mvm/scan.c                              | 2=
40 ++++++++++++++++++++++++++++++++++++---------------------
 drivers/net/wireless/iwlwifi/mvm/sta.c                               |  =
12 ++-
 drivers/net/wireless/iwlwifi/mvm/tx.c                                |  =
16 ++--
 drivers/net/wireless/iwlwifi/mvm/utils.c                             |  =
49 ++++++++----
 drivers/net/wireless/iwlwifi/pcie/drv.c                              |  =
 5 +-
 drivers/net/wireless/iwlwifi/pcie/internal.h                         |  =
 2 +
 drivers/net/wireless/iwlwifi/pcie/rx.c                               |  =
 2 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c                            | 1=
43 +++++++++++++++++++++++++++++++++-
 37 files changed, 1705 insertions(+), 438 deletions(-)
 rename drivers/net/wireless/iwlwifi/mvm/{bt-coex.c =3D> coex.c} (70%)
 rename drivers/net/wireless/iwlwifi/mvm/{fw-api-bt-coex.h =3D> fw-api-co=
ex.h} (99%)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-error-dump.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/offloading.c


--2veFrPnrFEfX2gHHDFE2AedieKbdbntLr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTKFsWAAoJEC0Llv5uNjIB4PwP/2rDIyOlk9fQT1/Ju6lqn+Ea
A/ANeV39kSZ72j04kHqkvzJEFIAZxP2rj/PYCmzBIBBi5AtMRHVsL66GfAFeV6F1
HUH/4tAK5h+xHs/6AmswJBg9dG5qm0wJrUE0LHOIIdDs+SgU4JWKytfqcuOuiOth
WaaU1NkGKZ/aM5/O2MxQKx/IXrOvUR1c+KFrtW2sIEZan0Rw05c/Ldz3SI+HsEtC
iWkKt/7LjYCm9DgMAnOC1LvUUJaPXORPj1DMKeUKFqmTMJ/afe9E/2mAgDzYxnzc
NRFgBElcb2Zo3jkELbSXw0zdTNveB7oNPhjKVRk4siCQT3uGvEWLBRfpUqY1mKU1
EwmiFgg8EaVKcsEYGujBb9bTDR3HQhA0S+sYifBYIQSiTP3Y22ZByFOOVa/fCBAu
mVqgc3F+6vydkGG8MFlSUVOGsORKoVJyAT3wZFXRmV7+WBDEc/yeh4Gy3Xew4wy/
WTrnTozIIWRRK9TNQ091iYUuxs2wUUoX10JH46OWPDEcfKBd/ldJPC2EHUKz3uf1
YwOMnXeREofxKHDKlpYYvQWI486WrBNQJeQaCCaXwPcnf3iwdYjAqBWi/QyVdIa9
QbBaykS/1kCGIbNnwt+6Ek9iEHSmCy30unCL7f8oMf+Ykt4zYhNwHyOlv6aOai8M
rA4q4MxtvHHmVr6UTp8Z
=zJIq
-----END PGP SIGNATURE-----

--2veFrPnrFEfX2gHHDFE2AedieKbdbntLr--
