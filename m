Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCD3BC282CC
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 11:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE61F207E0
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 11:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbfBDLJy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 06:09:54 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:54778 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730005AbfBDKkZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 05:40:25 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gqbfq-0007o4-A8; Mon, 04 Feb 2019 12:40:23 +0200
Message-ID: <398c36d2200bce61e943f728aded412e9b4cf0cc.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date:   Mon, 04 Feb 2019 12:40:20 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-t5KXOFHEmrf9dVMI9rLV"
User-Agent: Evolution 3.30.4-1 
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2019-02-04
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--=-t5KXOFHEmrf9dVMI9rLV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is the third batch of patches intended for v5.1.  This includes
the last two patchsets I sent.  Usual development work.  More details
about the contents in the tag description.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 030b43671ae88f827a415ad35700705ffc10d10d=
:

  wireless: prefix header search paths with $(srctree)/ (2019-02-01 14:42:2=
5 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2019-02-04

for you to fetch changes up to b998fbbd531fe33d9dd50fd37056f48b4257113d:

  iwlwifi: implement BISR HW workaround for 22260 devices (2019-02-04 12:28=
:10 +0200)

----------------------------------------------------------------
Third batch of iwlwifi patches intended for v5.1

* Work on the new debugging infrastructure continues;
* HE radiotap;
* Support for new FW version 44;
* A couple of new FW API changes;
* A bunch of fixes for static analyzer reported issues;
* General bugfixes;
* Other cleanups and small fixes;

----------------------------------------------------------------
Avigail Grinstein (1):
      iwlwifi: mvm: support absolute thresholds in bf configuration

Emmanuel Grumbach (2):
      iwlwifi: mvm: support new format for the beacon notification
      iwlwifi: mvm: fix AP mode in WEP

Johannes Berg (8):
      iwlwifi: mvm: remove redundant condition
      iwlwifi: dvm: use %u for sscanf() into unsigned variable
      iwlwifi: mvm: add HE TB PPDU SIG-A BW to radiotap
      iwlwifi: move config structs to C file
      iwlwifi: mvm: don't hide HE radiotap data in SKB
      iwlwifi: refactor NIC init sequence
      iwlwifi: mvm: fix RFH config command with >=3D10 CPUs
      iwlwifi: implement BISR HW workaround for 22260 devices

Liad Kaufman (2):
      iwlwifi: mvm: add tlc command name to output
      iwlwifi: mvm: config mac ctxt to HE before TLC

Luca Coelho (3):
      iwlwifi: bump FW API to 44 for 9000 and 22000 series
      iwlwifi: dvm: fix some fall through warnings
      iwlwifi: mvm: add fall through comments where needed

Naftali Goldstein (1):
      iwlwifi: mvm: add description to second BAD_COMMAND assert number

Sara Sharon (4):
      iwlwifi: mvm: simplify some return conditions
      iwlwifi: mvm: support CHANNEL_SWITCH_TIME_EVENT_CMD command
      iwlwifi: mvm: limit AMSDU size to 8K
      iwlwifi: mvm: fix RSS config command

Shahar S Matityahu (16):
      iwlwifi dbg_ini: update ini structs doc
      iwlwifi: dbg_ini: fix iwl_fw_ini_buffer_location field enum bad namin=
g
      iwlwifi: dbg_ini: give better naming to region struct fields
      iwlwifi: fix bad dma handling in page_mem dumping flow
      iwlwifi: differentiate between alive timeout and alive flow failure
      iwlwifi: dbg_ini: update ini triggers enum
      iwlwifi: dbg_ini: update max region id num to  support 64 regions
      iwlwifi: Fix pre operational dumping flows
      iwlwifi: dbg_ini: update ini structs meta doc
      iwlwifi: dbg_ini: remove redundant dram buffer allocation
      iwlwifi: dbg_ini: align struct iwl_fw_ini_region_cfg to the FW
      iwlwifi: dbg_ini: create new dump flow and implement prph dump
      iwlwifi: dbg_ini: implement csr memory dump
      iwlwifi: dbg_ini: implement device internal memory dump
      iwlwifi: dbg_ini: implement paging memory dump
      iwlwifi: fix send hcmd timeout recovery flow

YueHaibing (1):
      iwlwifi: mvm: remove duplicated include from ops.c

 drivers/net/wireless/intel/iwlwifi/cfg/22000.c       |   5 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c     |   3 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c          |   6 +-
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c        |   3 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h  | 168 +++++++++++++++=
++-------------
 drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h  |  27 +++++
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h    |  11 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h       |  18 +++-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c          | 540 +++++++++++++++=
++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------=
-------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h          |   9 +-
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h   |  49 ++++++---
 drivers/net/wireless/intel/iwlwifi/fw/file.h         |   8 ++
 drivers/net/wireless/intel/iwlwifi/fw/img.h          |  19 ++--
 drivers/net/wireless/intel/iwlwifi/fw/init.c         |   3 +
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h      |   3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h      |  35 +------
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c     |  23 ++++-
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c |  47 ++++-----
 drivers/net/wireless/intel/iwlwifi/iwl-io.c          |  72 +++++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-io.h          |   5 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h       |  31 ++++++
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c        |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c          |  41 +++++---
 drivers/net/wireless/intel/iwlwifi/mvm/led.c         |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c    |  94 ++++++++++-----=
--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c    | 106 ++++++++++++++-=
----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h         |  15 +--
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c         |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c    |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/power.c       |  20 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c          |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c          |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c        |  70 +++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c        |  11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c         | 149 +++++++++++++++=
------------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h         |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c       |  19 +---
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c  |   6 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h   |  19 +---
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c |  21 +---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c      | 106 +++++++--------=
----
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c    |   8 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c         |   8 +-
 include/net/ieee80211_radiotap.h                     |   6 ++
 45 files changed, 1164 insertions(+), 652 deletions(-)

--=-t5KXOFHEmrf9dVMI9rLV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlxYFpQACgkQoUecoho8
xfrKqA//dSaTkKhCiHrDa4gQQQ5y73a8hWRwJvDZfO3/xsSfNEZfB8iO1zZEy2cj
6dbq7bhJvofM1M9NLWwFjev2VpSMaisurnHzRGL90c39HbVl2FnB/EkvGSeQDJsf
PDhDMhV+Sx2NewkQu+lQWg6SMqEuL6ElvS05I4DVNXbd23af/wVG/k8JRFRyjE21
nddJz4ugfpGUQgDhDglguU8b5ZBgD52rx8cpyeXPtTnTdQtbN+fkCAyJ2BN+YnIR
hHXw4+cDDzD8C2in09HgFiudx97h8XQNbyiK+P/VIRqVOkK+W+5ylX1NBhphraQS
9HNoit0B+h0NRvDslxPbkNmLwK9ffiNAbTq40NTFi2M48Tz5rbeKpCcYLvQdfKKQ
Oikp5Cg2N3ppW4sCrPjWBipbk9i8+2bu63JsTXbfpmHjWgeWrshZ7e3OZJ4QNqDd
C7+jjbF6cTz5uoFtL8bF2o3MsgIssd57lvaOIK0srVyyHUKPAUcZODNsa9s5YurM
N5s/gK8aEdvQZhk6nsIrO9Cmjs+6ZqjZM7UemmZMZsX4VVaV546QXK5wH5G8g/fQ
1DUJeITE2evkSj9KCnsPm92PEQlDHE5vdk3797CGDxcHIcw72FMll142Qi6RsLKR
yPEAsHRrJBsTnpSuQ4aY6Zdny2IUU/C3035E1vyNWiSUcYaW0Ok=
=be2R
-----END PGP SIGNATURE-----

--=-t5KXOFHEmrf9dVMI9rLV--

