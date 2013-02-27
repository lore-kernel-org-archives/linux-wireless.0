Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49482 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672Ab3B0IRS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 03:17:18 -0500
Message-ID: <1361953028.8172.2.camel@jlt4.sipsolutions.net> (sfid-20130227_091721_391651_72498EDB)
Subject: Re: pull-request: iwlwifi-fixes 2013-02-26
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 27 Feb 2013 09:17:08 +0100
In-Reply-To: <1361914034.8440.27.camel@jlt4.sipsolutions.net> (sfid-20130226_222736_869147_FAE81193)
References: <1361914034.8440.27.camel@jlt4.sipsolutions.net>
	 (sfid-20130226_222736_869147_FAE81193)
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-UiLvVziAniSQrqJ6InCm"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UiLvVziAniSQrqJ6InCm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Second version of the the first set of fixes for iwlwifi... sorry.

I have a fix for a pretty important bug regarding DMA mapping, that
could cause the DMA engine to overwrite data we wanted to send to it, so
that the next time we send it it would be bad. This particularly affects
calibration results. Other than that, three little fixes for the MVM
driver.

Please pull.

Thanks,
johannes


The following changes since commit dc4a787c8f52f9d6e46156953f8014a3353bcbc7=
:

  brcmfmac: fix missing unlock on error in brcmf_notify_vif_event() (2013-0=
2-22 14:50:47 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git f=
or-john

for you to fetch changes up to e477598351a40769f5b46ccea78479a1aad6f161:

  iwlwifi: mvm: Remove testing of static PIC in PhyDB (2013-02-27 09:14:08 =
+0100)

----------------------------------------------------------------
Dor Shaish (1):
      iwlwifi: mvm: Remove testing of static PIC in PhyDB

Johannes Berg (3):
      iwlwifi: always copy first 16 bytes of commands
      iwlwifi: mvm: fix AP/GO mode station removal
      iwlwifi: fix wakeup status query and packet reporting

 drivers/net/wireless/iwlwifi/iwl-devtrace.h  |  10 ++-
 drivers/net/wireless/iwlwifi/iwl-phy-db.c    |  16 -----
 drivers/net/wireless/iwlwifi/mvm/d3.c        | 104 ++++++++++++++++++++---=
----
 drivers/net/wireless/iwlwifi/mvm/mac80211.c  |  19 +++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h       |   4 ++
 drivers/net/wireless/iwlwifi/pcie/internal.h |   9 +++
 drivers/net/wireless/iwlwifi/pcie/tx.c       |  75 ++++++++++++++-----
 7 files changed, 166 insertions(+), 71 deletions(-)


--=-UiLvVziAniSQrqJ6InCm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRLcEEAAoJEDBSmw7B7bqrweQQANRLPSa1vm7j0OyONsYA7jmz
J+/TPyPdkGOVHqGfdab7aFnYYme4ShiKsLH5YW1NaTCgShNiCh5/5GmbMJajDyWK
YlY7nqFLUZDwGt9iy8vGNNI5IllKdnNXwhX7I8ariyLDKbQQlcAqHoGYSr5r7Gfj
UPm+EU250lGVyMJBRHVnjZYAxlUzZf5ramrub4CsSacrsmTInDjb4tS/6ePK/30z
pASCJTMFnIBwz3McVc6WBPak32fIL+lK1UFwjztY5uqoy8ZmfAWCjEPu9cRXClxI
VlUXXQtlO2Zyseg63Qu5h3xhoyzXXBo85gkqReXTji8XoqENByvNLOkQZ5mlwkqJ
g8KJtSubKHrc7Fe0W6OwGPJSoJofAXiUUn4SuELjOsyYJeKzYsgqiF0X7RyySIgZ
T7yO0UUJX5f7E+1qApBFot5pYXNabW/dSi4snMZAAFE4NoVWYeddUAtY3LSRFRBn
x53oVll+NEFCc+UkQ3FmitnZzppGCIYG/LpbQfvdn8tUjF9K2/ZE+snQ383zz1Ba
fbXGJDur8rZ/phXh/kSsgxyxRtFaNn9FDbQfba4lbfh1KkkVNQuY1H14rkJjCOZ5
+vmTPSzEZhHrlrwv2IlvMYP4cFxC5VD65KXRzfMvQUa5iiAtLQ/JBFQu9u6wF+EV
x7yZaT8tZXNlrdLjqOZK
=pGCp
-----END PGP SIGNATURE-----

--=-UiLvVziAniSQrqJ6InCm--

