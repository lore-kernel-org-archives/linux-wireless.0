Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41126 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758297AbcH3Lgx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Aug 2016 07:36:53 -0400
Message-ID: <1472556999.27868.86.camel@coelho.fi> (sfid-20160830_133709_435551_1032FBE4)
From: Luca Coelho <luca@coelho.fi>
To: kvalo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>
Date: Tue, 30 Aug 2016 14:36:39 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-e7UNDpCOJRRhpXzXPdsh"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2016-08-30-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-e7UNDpCOJRRhpXzXPdsh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is a v2 of my pull request with the potential below array bounds
access, reported by kbuild bot, fixed.

> Another pull request, this time intended for 4.9.=C2=A0=C2=A0I have a lot=
 of
> patches to send, but I'll send smaller batches this time. :)
>=20
> These patches contain mostly preparation for new HW, but also some
> improvements in the dynamic queue allocation code and the
> implementation to support GMAC.

Let me know if everything's fine (or not). :)

Luca.


The following changes since commit 60747ef4d173c2747bf7f0377fb22846cb422195=
:

=C2=A0 Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2016-=
08-18 01:17:32 -0400)

are available in the git repository at:

=C2=A0 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.g=
it tags/iwlwifi-next-for-kalle-2016-08-30-2

for you to fetch changes up to 76f8c0e17edc6eba43f84952e5a87c7f50f69370:

=C2=A0 iwlwifi: pcie: remove dead code (2016-08-30 14:16:43 +0300)

----------------------------------------------------------------
* Preparation for new HW continues;
* Some DQA improvements;
* Support for GMAC;

----------------------------------------------------------------
Ayala Beker (1):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: support GMAC protocol

Liad Kaufman (5):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: re-aggregate shared queue=
 after unsharing
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: keep track of tid associa=
ted with each queue
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: re-assign old queues afte=
r hw restart in dqa mode
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: use defines for SCD_CONFI=
G_CMD enablement
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: support txq tid owner cha=
nge

Oren Givon (5):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: rename and reorder 9000 series=
 configuration structs
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: add a new series 9460 with new=
 PCI ID
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: add new 9460 series PCI IDs
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: add the new 9270 series
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: add the new 9170 series

Sara Sharon (5):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: allow same PN for de-aggr=
egated AMSDU
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: support new paging comman=
d format
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: pcie: refrain from SCD accesse=
s
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: pcie: fix ucode load flow for =
a000 devices
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: pcie: remove dead code

=C2=A0drivers/net/wireless/intel/iwlwifi/iwl-9000.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A083 +++++++++++-------
=C2=A0drivers/net/wireless/intel/iwlwifi/iwl-config.h=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0|=C2=A0=C2=A0=C2=A06 +-
=C2=A0drivers/net/wireless/intel/iwlwifi/iwl-fh.h=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A015 ++--
=C2=A0drivers/net/wireless/intel/iwlwifi/iwl-prph.h=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A019 ++---
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h |=C2=A0=C2=A031 +=
++++--
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h=C2=A0=C2=A0|=C2=A0=
=C2=A012 ++-
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0|=C2=A0=C2=A0=C2=A08 +-
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/fw.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A028 +++++--
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c=C2=A0=C2=A0=C2=A0|=
=C2=A0=C2=A018 +++-
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/mvm.h=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A026 +++++-
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A06 +-
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/sta.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0| 342 +++++++++++++++++++++++++++++++++++++++++++++=
++++++++++++++++++++++--------
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/sta.h=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A04 +
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/tx.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A038 ++++++++-
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/utils.c=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0|=C2=A0=C2=A024 ++++--
=C2=A0drivers/net/wireless/intel/iwlwifi/pcie/drv.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A041 +++++----
=C2=A0drivers/net/wireless/intel/iwlwifi/pcie/trans.c=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0|=C2=A0=C2=A045 ++++++----
=C2=A0drivers/net/wireless/intel/iwlwifi/pcie/tx.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A013 ++-
=C2=A018 files changed, 603 insertions(+), 156 deletions(-)
--=-e7UNDpCOJRRhpXzXPdsh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXxW/HAAoJEKFHnKIaPMX6oWYP/1B5tgIxvsRaNA8OgdHzXzcW
tl96pQsK6tfRZg4nlSBBQd+ORWO+wfIN9GzQ0DKRey/nrflnIWxYsf/iAYmlxXiu
TEUUjF041ZWckwa8n3gabc2Dy55qZOlFJPgHOLXWQ8RUeg5Q/ZOsagyr53r4YalZ
Prg7DwXIpPn7MncywwPF1PXLEkz6/Ih82Bxyn8qo0H7BOxT80Lt/ZtNiNHBnj7ae
Itz1CFCe9Nenp3WBpl5o1Bfd8ohXWzXZZrx+vGky5iy1Cpo4pztD2IVz8hSixY0V
GlmbeeMXLb+9m4b0J6N+XaUozaO5hFzBKrFhMyLlmIO0zQFWbv6u/5efJVvHbN+1
Eo8Pw7Fx1HPGA3xJPSNF8pcbbGtTNksR0hg66uUtOVJfY3QMZjfVy+6q58g69mxI
2poKXImQSwgE4ijJgTExmE1fmtDfWxxE2nF7bwyc2tJObzRm/xVtlqEr5TXkL61L
7yz1jFiDVBsyfMIUXWtsuE5EG9Rctd5I1kE2Gw/+xJIW+Clyt7C5mdfMJ08S+ygp
OuoHMvHW9BEPwBFJATBqAeRHPnHdybqdy35xbVTOL1AJYn6TEHY5HG1vi7qX+pFB
r4x1dwsbwZy3Mzi0uGKkrZfD+UHjRjK0gzZ/XXfNgc9zLsVDr+h/5hyoYvTxGs+7
FyeSP9cNyA5OJ+H1BdR5
=qRCa
-----END PGP SIGNATURE-----

--=-e7UNDpCOJRRhpXzXPdsh--
