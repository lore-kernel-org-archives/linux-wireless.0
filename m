Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41592 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751832AbdHAKV6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2017 06:21:58 -0400
Message-ID: <1501582910.2588.45.camel@coelho.fi> (sfid-20170801_122204_444159_2EDA9FA9)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 01 Aug 2017 13:21:50 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-lLv+VPpThbFZ0427Kt70"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2017-08-01
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lLv+VPpThbFZ0427Kt70
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here's my first pull-request intended for v4.14.=C2=A0 It contain=C2=A0gene=
ric
development work, with improvements, bug fixes and
cleanup all around.=C2=A0 More=C2=A0details in the tag description.

As I mentioned earlier today, I left Emmanuel's "iwlwifi: mvm: fix TCP
CSUM offload with WEP and A000 series" patch out of this pull-req,
because I'll include it in the one for 4.13.

I have sent this out before, and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit d28ac7be15c70343cb270648e252f54d770eca6a=
:

  rtlwifi: rtl8821ae: Fix HW_VAR_NAV_UPPER operation (2017-07-28 18:42:59 +=
0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2017-08-01

for you to fetch changes up to d20e30af7e65811955af5bc2a268ae75cd14e99e:

  iwlwifi: mvm: don't retake the pointer to skb's CB (2017-08-01 12:41:46 +=
0300)

----------------------------------------------------------------
First batch of iwlwifi patches for 4.14

* Reorganization of the code into separate directories continues;
* A couple of new minor features;
* Fixes and cleanups here and there.

----------------------------------------------------------------
Emmanuel Grumbach (3):
      iwlwifi: mvm: fix the FIFO numbers in A000 devices
      iwlwifi: pcie: fix A-MSDU on gen2 devices
      iwlwifi: mvm: don't retake the pointer to skb's CB

Johannes Berg (13):
      iwlwifi: refactor out paging code
      iwlwifi: refactor shared mem parsing
      iwlwifi: track current firmware image in common code
      iwlwifi: refactor firmware debug code
      iwlwifi: reorganize firmware API
      iwlwifi: fw api: fix various kernel-doc warnings
      iwlwifi: mvm: add and use iwl_mvm_has_unified_ucode()
      iwlwifi: mvm: check family instead of new TX API for workarounds
      iwlwifi: mvm: byte-swap constant instead of variable
      iwlwifi: pcie: rename iwl_trans_check_hw_rf_kill() to pcie
      iwlwifi: mvm: require AP_LINK_PS for TVQM
      iwlwifi: mvm: simplify bufferable MMPDU check
      iwlwifi: mvm: remove non-DQA mode

Liad Kaufman (1):
      iwlwifi: mvm: support fw reading empty OTP

Luca Coelho (2):
      iwlwifi: mvm: refactor beacon template command code
      iwlwifi: mvm: rename p2p-specific sta functions to include p2p in the=
 names

Mordechai Goodstein (1):
      iwlwifi: implement fseq version mismatch warning

Seraphime Kirkovski (1):
      iwlwifi: dvm: remove unused defines

Sharon Dvir (1):
      iwlwifi: mvm: fix uninitialized var while waiting for queues to empty

Zamir, Roee (1):
      iwlwifi: mvm: add compile-time option to disable EBS

 drivers/net/wireless/intel/iwlwifi/Makefile                               =
|    2 +
 drivers/net/wireless/intel/iwlwifi/dvm/commands.h                         =
|   16 -
 drivers/net/wireless/intel/iwlwifi/fw/api/alive.h                         =
|  206 ++++
 drivers/net/wireless/intel/iwlwifi/fw/api/binding.h                       =
|  144 +++
 drivers/net/wireless/intel/iwlwifi/fw/{api.h =3D> api/cmdhdr.h}           =
  |   78 +-
 drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-coex.h =3D> fw/api/coex.h} =
  |   11 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/commands.h                      =
|  664 ++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/api/config.h                        =
|  192 ++++
 drivers/net/wireless/intel/iwlwifi/fw/api/context.h                       =
|   94 ++
 drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-d3.h =3D> fw/api/d3.h}     =
  |   11 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h                      =
|  127 +++
 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h                         =
|  345 +++++++
 drivers/net/wireless/intel/iwlwifi/fw/api/filter.h                        =
|  183 ++++
 drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h                       =
|  152 +++
 drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-mac.h =3D> fw/api/mac.h}   =
  |   33 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h                       =
|  386 +++++++
 drivers/net/wireless/intel/iwlwifi/fw/api/offload.h                       =
|  101 ++
 drivers/net/wireless/intel/iwlwifi/fw/api/paging.h                        =
|  108 ++
 drivers/net/wireless/intel/iwlwifi/fw/api/phy-ctxt.h                      =
|  164 +++
 drivers/net/wireless/intel/iwlwifi/fw/api/phy.h                           =
|  258 +++++
 drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-power.h =3D> fw/api/power.h=
} |   13 +-
 drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-rs.h =3D> fw/api/rs.h}     =
  |   13 +-
 drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-rx.h =3D> fw/api/rx.h}     =
  |   31 +-
 drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-scan.h =3D> fw/api/scan.h} =
  |   11 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/sf.h                            =
|  138 +++
 drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-sta.h =3D> fw/api/sta.h}   =
  |   15 +-
 drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-stats.h =3D> fw/api/stats.h=
} |   13 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tdls.h                          =
|  208 ++++
 drivers/net/wireless/intel/iwlwifi/fw/api/time-event.h                    =
|  386 +++++++
 drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-tof.h =3D> fw/api/tof.h}   =
  |    9 +-
 drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-tx.h =3D> fw/api/tx.h}     =
  |   42 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/txq.h                           =
|  163 +++
 drivers/net/wireless/intel/iwlwifi/fw/common_rx.c                         =
|   88 ++
 drivers/net/wireless/intel/iwlwifi/{mvm/fw-dbg.c =3D> fw/dbg.c}           =
  |  438 ++++----
 drivers/net/wireless/intel/iwlwifi/{mvm/fw-dbg.h =3D> fw/dbg.h}           =
  |  125 ++-
 drivers/net/wireless/intel/iwlwifi/fw/init.c                              =
|   75 ++
 drivers/net/wireless/intel/iwlwifi/fw/paging.c                            =
|  414 ++++++++
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h                           =
|  156 +++
 drivers/net/wireless/intel/iwlwifi/fw/smem.c                              =
|  152 +++
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h                            =
|    3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/Makefile                           =
|    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c                             =
|    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h                        =
|    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c                      =
|    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c                          =
|   21 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h                           =
| 2845 +---------------------------------------------------
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c                               =
|  482 +--------
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c                         =
|  382 +++----
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c                         =
|  194 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h                              =
|  121 +--
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c                              =
|    7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c                              =
|  152 +--
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c                         =
|    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/power.c                            =
|   25 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c                               =
|   11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c                             =
|    9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c                             =
|    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c                              =
|  452 ++-------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h                              =
|   18 +-
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c                       =
|   20 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tof.c                              =
|    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tof.h                              =
|    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c                               =
|    6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c                               =
|  155 +--
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c                            =
|   18 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c                             =
|    4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h                        =
|    2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c                      =
|    4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c                           =
|    8 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c                         =
|    8 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c                              =
|    5 +-
 71 files changed, 5936 insertions(+), 4799 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/alive.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/binding.h
 rename drivers/net/wireless/intel/iwlwifi/fw/{api.h =3D> api/cmdhdr.h} (82=
%)
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-coex.h =3D> fw/api/c=
oex.h} (96%)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/config.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/context.h
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-d3.h =3D> fw/api/d3.=
h} (98%)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/filter.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-mac.h =3D> fw/api/ma=
c.h} (93%)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/offload.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/paging.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/phy-ctxt.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/phy.h
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-power.h =3D> fw/api/=
power.h} (98%)
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-rs.h =3D> fw/api/rs.=
h} (97%)
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-rx.h =3D> fw/api/rx.=
h} (95%)
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-scan.h =3D> fw/api/s=
can.h} (98%)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/sf.h
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-sta.h =3D> fw/api/st=
a.h} (98%)
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-stats.h =3D> fw/api/=
stats.h} (97%)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/tdls.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/time-event.h
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-tof.h =3D> fw/api/to=
f.h} (98%)
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-tx.h =3D> fw/api/tx.=
h} (98%)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/txq.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/common_rx.c
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-dbg.c =3D> fw/dbg.c} (69=
%)
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-dbg.h =3D> fw/dbg.h} (59=
%)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/init.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/paging.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/runtime.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/smem.c


--=-lLv+VPpThbFZ0427Kt70
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlmAVj4ACgkQoUecoho8
xfpfhg//SoNL/VD01kzWbszVi1x1l0Nfl2blaaq/AqmVleYYUdIKthPglEbxRNHV
uffQivyVbU+lVRy1IG8SFQehdGnZHh6SepBnIoehmi5HYVk+kJksimBEJf9C9EGS
4YuNs3R9Qber1vnb4ylFIWDIk6l//eIyukNLEthPy37tDzDM1pHWmumMTs2TXrUD
+ufgIyf21T5luGzXeEFxhz/LPQ45K8THtH0lqBbz4sg5XQ8Xobpc523QjuKAKa1i
ZulLLQpiuWlUHKdPoFRsQ4fmv34hJnBbFh8GGrj21Tu4pnNbZsQjrsaXjzBB9QB8
YfSm0atrsGp9tP4srn3QfETPPB3gvlcKj0r9WGVYL+/Xz2BIIe21R4ZBSMeXtJqw
/16qArF31XwippQuqg+M10wTcBL/MO0p9NH6EqzdoXe0k5aJ6SfIndsGlSFdT+Q8
9qJZJpcItybKDxqjxjXPJlvYIQ8FkTefQt1SbtEL+hpKlZSEvRX/fuw7rWbz7Xvp
qlkPuTbgTu/Mh7bWZmeRMfrmtfsFoiR6j3XGP1QhgcCm+gGpp5m7h5ncusvCbAv3
uNf1DV9QM3kD8PIt/yiqGxqz/21vFIO5MQy4UjoiXLH9U/W0JMpC9Xgon7P42KQb
bVnnq0tALqDroRqYB3PlEjLaQF3z9p55zqyZDavPtnst7gbXXts=
=57rX
-----END PGP SIGNATURE-----

--=-lLv+VPpThbFZ0427Kt70--
