Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64797 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab3KSUtj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Nov 2013 15:49:39 -0500
Received: by mail-wi0-f170.google.com with SMTP id f4so7196456wiw.3
        for <linux-wireless@vger.kernel.org>; Tue, 19 Nov 2013 12:49:37 -0800 (PST)
Message-ID: <528BCEDB.8010703@gmail.com> (sfid-20131119_214943_114906_852E231D)
Date: Tue, 19 Nov 2013 22:49:31 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: pull request: iwlwifi 2013-11-19
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="nuXr2QICWnJPP06JE3xVes71Q5rpqaSx3"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nuXr2QICWnJPP06JE3xVes71Q5rpqaSx3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

This is a pull request for 3.13.

I have here a few fixes for BT Coex. One of them is a NULL pointer
dereference. Another one avoids to enable a feature that can make the
firmware unhappy since the firmware isn't ready for it yet. WE also
avoid a WARNING that can be triggered upon association in not-so-bad
cases even if the association succeeded. We add support for new NICs
(not yet on the market) and bump the API so that 3.13 will be able to
work with the new firmware that will be out soon hopefully.
I also have a boundary check from Johannes.

I reset my tree to wireless/master as the time of this writing. I did
that mainly because I needed the changes that were in -next before 3.12
went out even if 3.13-rc1 isn't out yet. I plan to rebase my tree on
3.13-rc2 (or 3.13-rc1 if this pull request makes it to 3.13-rc1 but that
seems unlikely).
Tell me if you have any issues.


The following changes since commit 3b1bace9960b0acbcb5d0ca194077f03df7cc2=
c0:

  brcmfmac: fix possible memory leak (2013-11-18 15:13:01 -0500)

are available in the git repository at:


git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git
for-john

for you to fetch changes up to 8c5ec2eb4a10c588969e6a67239bcabd9a2bf04f:

  iwlwifi: bump required firmware API version for 3160/7260 (2013-11-19
22:32:56 +0200)

----------------------------------------------------------------
Emmanuel Grumbach (5):
      iwlwifi: pcie: refactor a bit the interrupt coalescing
      iwlwifi: mvm: BT Coex - don't enable MULTI_PRIO_LUT
      iwlwifi: mvm: BT Coex fix another NULL pointer dereference
      iwlwifi: mvm: don't WARN about unsuccessful time event
      iwlwifi: bump required firmware API version for 3160/7260

Johannes Berg (1):
      iwlwifi: mvm: check sta_id/drain values in debugfs

Oren Givon (1):
      iwlwifi: add new HW - 7265 series

 drivers/net/wireless/iwlwifi/iwl-7000.c       |   29
+++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-config.h     |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-csr.h        |    5 +----
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c    |    6 ++++-
 drivers/net/wireless/iwlwifi/mvm/debugfs.c    |    4 ++++
 drivers/net/wireless/iwlwifi/mvm/time-event.c |    7 ++++--
 drivers/net/wireless/iwlwifi/pcie/drv.c       |   22 +++++++++++++++++++=

 drivers/net/wireless/iwlwifi/pcie/rx.c        |    4 ++++
 drivers/net/wireless/iwlwifi/pcie/trans.c     |    3 ---
 9 files changed, 73 insertions(+), 12 deletions(-)


--nuXr2QICWnJPP06JE3xVes71Q5rpqaSx3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJSi87fAAoJEC0Llv5uNjIBUV8P/3X2SpgAhjpeJwdTC8xFPoCp
6XxmBrFaQoZ/oPXBEcY3CzDIqzpWdcDEd/d1HAQ3kxmmA1FA+4CF1aNF9HeCToQc
RyBFYFFEf5f44h7bZ4gXBF0X02as6zbkHOskS0O7mK3XieOstvK81KwTAhtWVhm7
IHRBbFoy8TrAcIWwDhXOGTuWOojyyqYjdlhTC1KbzEmgZsrbdSsGQOwtCJXZqQLg
BPcjy6gKg/7N3/7ufCknSJDDyBDA7Q9PH17Cd71kcOvFJuQUra6s2GODnctdJHH7
bsiSTYxabMoRFGx0C0GzpEqMPOW85B6BWHbjCvWyU2KhWlI8gTfw+e53mLMh2H9a
AI1QBxpIrRTpsD4wdnGrgxrq4kEEGdHwhvKHNbElFOra7Q5IdpREp8LTtqUtokCF
HnoCpNB8fLgmXCAZkWsVw5b9zUg+Lf4EHKr7N3EQ0bQ+WYM7Jb1HZZmlniTf4wiI
Buy2uLiAyDz7RabuEAHzg5r05ybAyBXH+c9QyYvj8ePx5z18s6Izun5WPVyGieDf
Q7HtvL9JIfwwZjd7VPuOqMveO55QXR84dGraHeAhgL0MQDmdbULHrg6EhQPK6cn2
hVLMbQk9rI+fxifIVMwEXX6Ix7w9h7QNLWlQhYMjH3wRA4krZ8bwAMeTIXEYX4jl
MyH2VQvdQLq5YoyhQGdl
=n/rz
-----END PGP SIGNATURE-----

--nuXr2QICWnJPP06JE3xVes71Q5rpqaSx3--
