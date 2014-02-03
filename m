Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:42779 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbaBCUc5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:32:57 -0500
Received: by mail-ea0-f171.google.com with SMTP id f15so3933579eak.2
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:32:56 -0800 (PST)
Message-ID: <52EFFCE8.6070505@gmail.com> (sfid-20140203_213300_738136_E899F348)
Date: Mon, 03 Feb 2014 22:32:40 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: pull request: iwlwifi 2014-02-03
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="IBSJ4guOH9we4Jv2u9dpJtG0u6pWTFkIK"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IBSJ4guOH9we4Jv2u9dpJtG0u6pWTFkIK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

since you updated your trees, here is a set of fixes for 3.14.

I have an important fix that disables A band in case the driver thought
it was enabled, and the firmware disagreed. We ended up making the
firmware unhappy. I also fix the station table in AP mode and fix the
scan while we have BT working.
Johannes removes a static variable that could potentially lead to to
issues on multi-device setups and disables scheduled scan to avoid
issues with old versions of wpa_supplicant.
A small fix from David on scan and a few new device IDs for 7265.

Let me know about issues you may have!

The following changes since commit 9b0cd304f26b9fca140de15deeac2bf357d1f3=
88:

  Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux
(2014-01-29 20:49:12 -0800)

are available in the git repository at:



git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git
for-john

for you to fetch changes up to c512865446e6dd5b6e91e81187e75b734ad7cfc7:

  iwlwifi: mvm: don't allow A band if SKU forbids it (2014-02-02
11:08:42 +0200)

----------------------------------------------------------------
David Spinadel (1):
      iwlwifi: mvm: notify match found without filtering

Emmanuel Grumbach (4):
      iwlwifi: mvm: print the version of the firmware when it asserts
      iwlwifi: mvm: don't leak a station when we drain
      iwlwifi: mvm: BT Coex - disable BT when TXing probe request in scan=

      iwlwifi: mvm: don't allow A band if SKU forbids it

Johannes Berg (2):
      iwlwifi: mvm: make local pointer non-static
      iwlwifi: mvm: disable scheduled scan

Oren Givon (1):
      iwlwifi: add more 7265 HW IDs

 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c   |    5 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h |    4 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c    |    2 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c        |    5 +-
 drivers/net/wireless/iwlwifi/mvm/sta.c         |    2 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c          |   73
++++++++++++------------
 drivers/net/wireless/iwlwifi/mvm/utils.c       |    2 +
 drivers/net/wireless/iwlwifi/pcie/drv.c        |    7 ++-
 8 files changed, 59 insertions(+), 41 deletions(-)


--IBSJ4guOH9we4Jv2u9dpJtG0u6pWTFkIK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJS7/zxAAoJEC0Llv5uNjIBNOoP/3L9ASoDGogQIgz5kA324yd3
o+ZLHs17hRSnsRJlN+0XBnDdNjJG0FZZ9oqFfWMTlWAYoTPC+kt0GwItUWwXwu9B
h5gCKyz3yVfL3czpAMTcE4pZxC017JmFDRxZixt+8tchzZtS+bh/5kSdWkuK0T8k
Zh0RTkAc3BTAz5GzVayihhD0kocDk5cbccXdXHIW+CX1t7abkLCk1qpYBG6X+L9q
bLlgQ5N27LzDm7dmg3ryqN0ej2Lt9lzKEx8Mpj+adrI1jzncES7+ms1fVEBxWtlI
vTMwuJRVBmcyaUbElKdA/LcxMO9DfehfRql7edCw5KdpuZj+n0ToTDSgm+OEdQgE
I1Uy2+swFE4F4d+xte0iZvgiGhtfQN7Wx0010UVa3CVSWb4TnPhsYCM09LJnxkY0
yWxEUeDpPju843SmphlOipxiwXSqfRXIIckS5tWJEpG8mRCEFP2nwkVxIuFnLzK7
P4ssLCzDvIiJEc02w7NjE93/iO36WGOBOVBHijX5OPQ7FWIplPp2yauPW2Iu2zx1
fF6xPLQe4m8YBCQRHLMLlkBLFoe21LJ47qI2f4aTknnpWywOjhdFyteGbzoxMRAC
Wenmmus+QCuxypMZy4kLuTCQWtwjsXSBE1grcKhr/AIexGPedUMqQJDkk/AylK6U
L0UfxSfseLhAwy9ifYco
=WAP4
-----END PGP SIGNATURE-----

--IBSJ4guOH9we4Jv2u9dpJtG0u6pWTFkIK--
