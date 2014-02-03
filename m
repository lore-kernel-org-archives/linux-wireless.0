Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:41382 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaBCU4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:56:38 -0500
Received: by mail-la0-f42.google.com with SMTP id hr13so5939281lab.29
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:56:36 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 3 Feb 2014 22:56:36 +0200
Message-ID: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com> (sfid-20140203_215641_715766_713121DD)
Subject: pull request: iwlwifi-next 2014-02-03
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: multipart/mixed; boundary=001a11c268186b70d304f186c268
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--001a11c268186b70d304f186c268
Content-Type: text/plain; charset=ISO-8859-1

Hi John,

It seems that the team worked hard based on the size of the pull request:)
Let me know if this is too big, so that I can find the right balance.

I have here support for D0i3 which is runtime power saving state. This
work is still on going. Along with that I have implementation of
broadcast filtering by Eliad. I provide the usual amount of clean ups
etc... Note that we begin to warn users that are still using the old
firmware but we still support it in 3.15. I will remove support for this
old firmware in 3.16.
Eran begins to add support for next-gen devices while Johannes
implemented uAPSD for AP / GO along with other various things.
Ilan is tuning the quota allocation and Ido Yariv contributes a new
feature that allows to limit the power we consume based on entries in
ACPI tables.

Here again, let me know of issues if any!

The following changes since commit 9b0cd304f26b9fca140de15deeac2bf357d1f388:

  Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux
(2014-01-29 20:49:12 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
for-john

for you to fetch changes up to 8e305d171ab58dbd79ad8e13d93db2237fde5749:

  iwlwifi: mvm: remove duplicate assignment to ap_ibss_active
(2014-02-03 22:43:53 +0200)

----------------------------------------------------------------
Arik Nemtsov (2):
      iwlwifi: add very first D0i3 support
      iwlwifi: mvm: add D0i3 ref/unref for scan

David Spinadel (2):
      iwlwifi: mvm: don't stop sched scan in restart
      iwlwifi: mvm: notify scan completed even if no fw_restart

Eliad Peller (15):
      iwlwifi: mvm: add basic bcast filtering implementation
      iwlwifi: mvm: add predefined broadcast filter configuration
      iwlwifi: mvm: add dest ip to bcast filter configuration
      iwlwifi: mvm: add bcast_filtering debugfs entries
      iwlwifi: add D0i3 references boiler plate
      iwlwifi: add enter/exit D0i3 ops
      iwlwifi: mvm: add D0i3 power configurations
      iwlwifi: mvm: configure vifs upon D0i3 entry/exit
      iwlwifi: mvm: allow transport sleep when FW is operational
      iwlwifi: mvm: add D0i3 ref/unref for ROC commands
      iwlwifi: mvm: add D0i3 ref/unref when ap, ibss or p2p_cli vifs are
running
      iwlwifi: mvm: add d0i3_refs debugfs file
      iwlwifi: mvm: configure WOWLAN_CONFIGURATION on D0i3 entry
      iwlwifi: mvm: get status on D0i3 exit
      iwlwifi: mvm: add debugfs hook to take an mvm ref

Emmanuel Grumbach (13):
      iwlwifi: 7000: warn about old firmware
      iwlwifi: remove obsolete TODO
      iwlwifi: mvm: provide helper to fetch the iwl_mvm_sta from sta_id
      iwlwifi: mvm: check ARRAY_SIZE(mvm->fw_id_to_mac_id) =
IWL_MVM_STATION_COUNT
      iwlwifi: pcie: fix unused variable gcc warning
      iwlwifi: mvm: BT Coex - set low latency vif as primary
      iwlwifi: mvm: BT Coex - change SMPS settings in AP mode
      iwlwifi: mvm: change the format of the SRAM dump
      iwlwifi: mvm: allow to force reduced tx power from debugfs
      iwlwifi: mvm: add vif type in debugfs output
      iwlwifi: fix kerneldoc format
      iwlwifi: mvm: BT Coex - fix SYNC2SCO flags
      iwlwifi: mvm: remove duplicate assignment to ap_ibss_active

Eran Harary (7):
      iwlwifi: Add 8000 HW family support
      iwlwifi: mvm: support NVM sections for family 8000
      iwlwifi: pcie: disable APMG configurations for family 8000
      iwlwifi: pcie: change CSR reset in family 8000
      iwlwifi: pcie: Disable L0S exit timer for 8000 HW family
      iwlwifi: pcie: fix secure section / dual cpu firmware loading
      iwlwifi: mvm: support multiple firmware sections

Ido Yariv (3):
      iwlwifi: pcie: retrieve and parse ACPI power limitations
      iwlwifi: mvm: handle platform PCIe power limitation
      iwlwifi: 7265: add power limit/tx backoff translation table

Ilan Peer (2):
      iwlwifi: mvm: add the quota remainder to a data binding
      iwlwifi: mvm: fix quota allocation

Johannes Berg (10):
      iwlwifi: mvm: implement AP/GO uAPSD support
      iwlwifi: pcie: make FH debugfs file code easier to understand
      iwlwifi: mvm: add low-latency framework
      iwlwifi: mvm: disable powersave in low-latency
      iwlwifi: mvm: reserve bandwidth for low-latency interface
      iwlwifi: mvm: limit non-low-latency binding scheduling duration
      iwlwifi: rs: use const u16 for throughput tables
      iwlwifi: mvm: remove unneeded calculations
      iwlwifi: mvm: abort scheduled scan on scan request
      iwlwifi: mvm: clean up iwl_mvm_bss_info_changed_ap_ibss

Liad Kaufman (1):
      iwlwifi: fix potential buffer overrun in fw name

 drivers/net/wireless/iwlwifi/Kconfig              |   14 +
 drivers/net/wireless/iwlwifi/Makefile             |    2 +-
 drivers/net/wireless/iwlwifi/dvm/rs.c             |   19 +-
 drivers/net/wireless/iwlwifi/dvm/rs.h             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-7000.c           |   23 +-
 drivers/net/wireless/iwlwifi/iwl-8000.c           |  123 ++++++
 drivers/net/wireless/iwlwifi/iwl-config.h         |   17 +
 drivers/net/wireless/iwlwifi/iwl-csr.h            |   32 --
 drivers/net/wireless/iwlwifi/iwl-debug.h          |    2 +
 drivers/net/wireless/iwlwifi/iwl-drv.c            |    5 +-
 drivers/net/wireless/iwlwifi/iwl-fw.h             |    7 +-
 drivers/net/wireless/iwlwifi/iwl-io.c             |   15 +
 drivers/net/wireless/iwlwifi/iwl-io.h             |    2 +
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c      |    6 +-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h        |   24 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h           |   46 +++
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   38 ++
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c        |  138 ++++---
 drivers/net/wireless/iwlwifi/mvm/constants.h      |    4 +
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c    |  105 ++++-
 drivers/net/wireless/iwlwifi/mvm/debugfs.c        |  283 +++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h |   17 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h      |    6 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h   |   33 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h     |   31 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h         |   99 ++++-
 drivers/net/wireless/iwlwifi/mvm/fw.c             |    7 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c       |  427
+++++++++++++++++++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h            |  102 ++++-
 drivers/net/wireless/iwlwifi/mvm/nvm.c            |   34 +-
 drivers/net/wireless/iwlwifi/mvm/ops.c            |  252 ++++++++++--
 drivers/net/wireless/iwlwifi/mvm/power.c          |  117 +++++-
 drivers/net/wireless/iwlwifi/mvm/quota.c          |  119 +++++-
 drivers/net/wireless/iwlwifi/mvm/rs.c             |   23 +-
 drivers/net/wireless/iwlwifi/mvm/rs.h             |    2 +-
 drivers/net/wireless/iwlwifi/mvm/rx.c             |    8 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c           |   12 +-
 drivers/net/wireless/iwlwifi/mvm/sta.c            |  175 ++++++---
 drivers/net/wireless/iwlwifi/mvm/sta.h            |   60 ++-
 drivers/net/wireless/iwlwifi/mvm/time-event.c     |    2 +
 drivers/net/wireless/iwlwifi/mvm/tt.c             |    7 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c             |   23 ++
 drivers/net/wireless/iwlwifi/mvm/utils.c          |   36 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c           |   82 ++++
 drivers/net/wireless/iwlwifi/pcie/rx.c            |    3 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c         |  267 +++++++------
 drivers/net/wireless/iwlwifi/pcie/tx.c            |    5 +-
 47 files changed, 2371 insertions(+), 485 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-8000.c

--001a11c268186b70d304f186c268
Content-Type: application/pgp-signature; name="signature.asc"
Content-Disposition: attachment; filename="signature.asc"
Content-Transfer-Encoding: base64
X-Attachment-Id: 2273981b822c3140_0.1

LS0tLS1CRUdJTiBQR1AgU0lHTkFUVVJFLS0tLS0NClZlcnNpb246IEdudVBHIHYxLjQuMTEgKEdO
VS9MaW51eCkNCg0KaVFJY0JBRUJBZ0FHQlFKUzhBSmtBQW9KRUMwTGx2NXVOaklCcDlZUC9pOFRE
WGtpRFB1TWllMVZaNlRqQTlzMg0KMEowemZ5QXl5Q2x2N2R6TCs4Z3R3a3gwYW9Ka2pHZ240dmRL
UnZac240YXBlQnV3MlpZUmFnU015V20zWjUxOA0KSENjaG9qYkRoaHdJaDA3ZUFzeENTOWFXMnFp
SXFMakRGNDJCUjNybW12dDNnYVBITTNiY2FnMzBjWTlIdlpHRw0KUFNOQkZwNkRvdFNXY1B2QW9a
SFFSOUNsSnZXR0tscXdDM3dWNVZHWDRnR2plVnNYc0I1bmtJRG41MXRYc3JkQw0KREVvMEoxSXJa
KzRIZUE1V3F2WW9nNkMyOVlPcldrSS9UMVRTZ1VhaFlxTlZ1RjZpb0g5MVFaa3FRWEFtbGVIWA0K
UXZjNVp2NGlqcjZpUmtnckpBaWp6L296c1RRN2YrU3lqQlRCam45ZU40b2lQbEl5QnQ0b29ZajRy
NC9PWllRVQ0Kb3BoK1l6QXhMa2ZWY3hiTFNmV3FvTkFWQjdaWmhhMkpwRGdvdHYwVlNxRXV1eWRL
c2ZwcTl5c1NZUEx4T0lPOA0KRDR3a1NNMUpidytFWVJtNEVkL0ZUTWZZeXRGQ1VCd05PdTVhQURw
Nm5yeFhobjBKam1GdHJvUUQzaGtYZWRVQg0KNjBHT21oTTF2bnVJWjVjaXF2MEtnZmRLclc0UFJ1
N2NkT3RTQ3JySndkay9Cd29OblRPK2VCVVdiR3JvOVZ6Kw0KSytVYmovcG5FanZTY2ppa1RmVUxl
RURodzVQWFhvT0JGRmJFaldKMzh2emM5RkVqdnFoNUI5UFpqdXErNm55Rw0KeWtTK2pZdHVlV2or
WGsveUtwY1dRYWVpNmRGV1NobitQTDlXUXhXQkJaUUZuVlc0Q1hSemkyZWFjNjlraFNGYw0KTjNM
emNjV1FBc3QrWURzWDBJZksNCj0weDlLDQotLS0tLUVORCBQR1AgU0lHTkFUVVJFLS0tLS0NCg==
--001a11c268186b70d304f186c268--
