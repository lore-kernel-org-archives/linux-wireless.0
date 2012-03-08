Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:45447 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345Ab2CHM4K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 07:56:10 -0500
Received: by mail-lpp01m010-f42.google.com with SMTP id l5so479244lah.29
        for <linux-wireless@vger.kernel.org>; Thu, 08 Mar 2012 04:56:09 -0800 (PST)
Message-ID: <1331211366.18015.65.camel@cumari> (sfid-20120308_135614_415960_E0B81D05)
Subject: pull request: wl12xx 2012-03-08
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Thu, 08 Mar 2012 14:56:06 +0200
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-kxBo1suLVNphwI1c8k0o"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kxBo1suLVNphwI1c8k0o
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

This is another pull request intended for 3.4.  It contains a few fixes
that were still pending in our internal tree and alignment with the
latest mac80211/cfg80211 code.  Nothing major.

Please pull or let me know if there's any problem. This tree is based on
wireless-next/master and the head I want you to pull from is
cc4bf501a237f5232df6d4aeb7b24ac0362958c8.=20

Thanks!=20

The following changes since commit 41b58f189ada1a12d3c9417c3eedd5b910d8d09f=
:

  rtl8187: Add AD-HOC support (2012-03-07 13:56:37 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linvill=
e

Arik Nemtsov (8):
      wl12xx: set the ELP entry delay to the FW dyn-ps timeout
      wl12xx: change bits in the link_map under spin lock
      wl12xx: reset link Tx queues when freeing it
      wl12xx: avoid starving the system hlid
      wl12xx: flush all Tx queues on tx_flush timeout
      wl12xx: flush Tx during suspend and 802.11h chan switch
      wl12xx: increase dynamic PS timeout to 200ms
      wl12xx: implement SW Tx watchdog

Eliad Peller (11):
      wl12xx: don't start dev role on ibss vifs
      wl12xx: consider bss_conf->idle instead of hw->conf.flags
      wl12xx: implement sta_state callback
      wl12xx: set authorized AP on sta_state notification
      wl12xx: increment session_counter for device role as well
      wl12xx: set correct vif type in change_interface callback
      wl12xx: don't handle change_channel while associated
      wl12xx: don't allow scanning while device is in ROC
      wl12xx: configure the correct beacon_interval
      wl12xx: avoid bug_on_recovery during fw switch
      wl12xx: print the tx packet len

Luciano Coelho (1):
      Merge branch 'wl12xx-next' into for-linville

 drivers/net/wireless/wl12xx/cmd.c    |   26 ++-
 drivers/net/wireless/wl12xx/conf.h   |    3 +
 drivers/net/wireless/wl12xx/main.c   |  438 +++++++++++++++++++-----------=
----
 drivers/net/wireless/wl12xx/ps.c     |    4 +-
 drivers/net/wireless/wl12xx/scan.c   |    6 +
 drivers/net/wireless/wl12xx/tx.c     |   41 +++-
 drivers/net/wireless/wl12xx/tx.h     |    1 +
 drivers/net/wireless/wl12xx/wl12xx.h |    7 +-
 8 files changed, 321 insertions(+), 205 deletions(-)

--=20
Cheers,
Luca.






--=-kxBo1suLVNphwI1c8k0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPWKxmAAoJEKFHnKIaPMX6O2IP/Rdqv4YqINlu823+iAmjj0+q
4ED3qaRXH+S8NjkL47HNot5CHIa0YysfNwyJpoedOcdDfUMOY0zb/Ox6by7cdIzO
Pmpf1IsXaOHy3STJbJr984JDB84JueZb629Up1ZPPcLJFnrsuMMEyFswGvlm6+s7
MBmkkJ5UMxdWpxWlGWQBLx0EHkzbJiksj8yxeY5HS6QRZjZ3NdqnAlwl6rh0mmYZ
v14Rx2UKDNkX9Z32oeWO8iOAC7LU4unh2fLfM1mXhdEJWdUFzg/PYEme5RDuevqK
WH8b1t7iNncLKC+kqWyK0KH7EmbPJIjr18FEREuhhPqumX0zKZahluHHxCE7E2PH
wSVC0wvhxIUOWitRLXAI2OQoCixGFDXV1QnUp4Q1Tg+g71c0KkBMSImnzRdlFfs9
LqRQvjQgnLInp00eD/yXB546qf9HGlPMH+u0Guc+UNkYVowcdZj/eBiEy/zPfisO
qlMG9sHsTzIfdg2vPT68VheA0C5NepO3BkMHW8XEZQWtVmbqS/rluKii7pj7ZIdJ
AKARtfH7CZDtRKdmQr8KTavziqzBtYUeLP/TMd5P2ujhIxwX48491t4Ei/IAjDkX
QZFJq4EzbYQN0tvokWApMGshgn88/n/AI7sl3MaohQSrh0vZGKeXrmkKnlAFc3Os
oW41d2x2od5FgabpuSUP
=WwgT
-----END PGP SIGNATURE-----

--=-kxBo1suLVNphwI1c8k0o--

