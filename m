Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:36224 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab3KYVGI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 16:06:08 -0500
Received: by mail-we0-f173.google.com with SMTP id t61so4458194wes.32
        for <linux-wireless@vger.kernel.org>; Mon, 25 Nov 2013 13:06:05 -0800 (PST)
Message-ID: <5293BBB5.80302@gmail.com> (sfid-20131125_220613_788759_CA634ED4)
Date: Mon, 25 Nov 2013 23:05:57 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi 2013-11-19
References: <528BCEDB.8010703@gmail.com> <529231A4.5010503@gmail.com> <20131125204113.GC8228@tuxdriver.com>
In-Reply-To: <20131125204113.GC8228@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="2lIsf5ceShElOoWSr6gjQEKeu4uCdMp3Q"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2lIsf5ceShElOoWSr6gjQEKeu4uCdMp3Q
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable



On 11/25/2013 10:41 PM, John W. Linville wrote:
> On Sun, Nov 24, 2013 at 07:04:36PM +0200, Emmanuel Grumbach wrote:
>>
>>
>> On 11/19/2013 10:49 PM, Emmanuel Grumbach wrote:
>>> Hi John,
>>>
>>> This is a pull request for 3.13.
>>>
>>> I have here a few fixes for BT Coex. One of them is a NULL pointer
>>> dereference. Another one avoids to enable a feature that can make the=

>>> firmware unhappy since the firmware isn't ready for it yet. WE also
>>> avoid a WARNING that can be triggered upon association in not-so-bad
>>> cases even if the association succeeded. We add support for new NICs
>>> (not yet on the market) and bump the API so that 3.13 will be able to=

>>> work with the new firmware that will be out soon hopefully.
>>> I also have a boundary check from Johannes.
>>>
>>> I reset my tree to wireless/master as the time of this writing. I did=

>>> that mainly because I needed the changes that were in -next before 3.=
12
>>> went out even if 3.13-rc1 isn't out yet. I plan to rebase my tree on
>>> 3.13-rc2 (or 3.13-rc1 if this pull request makes it to 3.13-rc1 but t=
hat
>>> seems unlikely).
>>> Tell me if you have any issues.
>>>
>>>
>>
>> FWIW - since 3.13-rc1 is already out and you haven't pulled yet, I
>> rebased this pull request --onto v3.13-rc1.
>=20
> 3.13-rc1 is not in the wireless tree (because it isn't in the net
> tree).  If it is in your tree, then I can't pull from you -- sorry!
>=20


Sure - sorry... still starting with all this...
Anyway - I rebased my tree on yours - so here is a new pull request.

Can you please make sure you pull -no-ff?
It makes it easier for people to see when you pull from others rather
than apply patches.

Thanks!

The following changes since commit 9d8506cc2d7ea1f911c72c100193a3677f6668=
c3:

  gso: handle new frag_list of frags GRO packets (2013-11-21 14:11:50 -05=
00)

are available in the git repository at:


git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git
master

for you to fetch changes up to 3c5da7eefce5835acfc73ebd0a4f961cdae4ae67:

  iwlwifi: mvm: use a cast to calculate the last seqno from the next one
(2013-11-25 23:00:21 +0200)

----------------------------------------------------------------
Alexander Bondar (1):
      iwlwifi: pcie: stop sending commands to dead firmware

Emmanuel Grumbach (5):
      iwlwifi: pcie: fix interrupt coalescing for 7260 / 3160
      iwlwifi: mvm: BT Coex - don't enable MULTI_PRIO_LUT
      iwlwifi: mvm: BT Coex fix another NULL pointer dereference
      iwlwifi: mvm: don't WARN about unsuccessful time event
      iwlwifi: bump required firmware API version for 3160/7260

Johannes Berg (1):
      iwlwifi: mvm: check sta_id/drain values in debugfs

Luciano Coelho (2):
      iwlwifi: mvm: set seqno also when no keys are set
      iwlwifi: mvm: use a cast to calculate the last seqno from the next =
one

Oren Givon (1):
      iwlwifi: add new HW - 7265 series

 drivers/net/wireless/iwlwifi/iwl-7000.c       |   29
+++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-config.h     |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-csr.h        |    5 +----
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c    |    6 ++++-
 drivers/net/wireless/iwlwifi/mvm/d3.c         |    5 +++--
 drivers/net/wireless/iwlwifi/mvm/debugfs.c    |    4 ++++
 drivers/net/wireless/iwlwifi/mvm/time-event.c |    7 ++++--
 drivers/net/wireless/iwlwifi/pcie/drv.c       |   21 ++++++++++++++++++
 drivers/net/wireless/iwlwifi/pcie/internal.h  |    8 +++++++
 drivers/net/wireless/iwlwifi/pcie/rx.c        |    7 +++++-
 drivers/net/wireless/iwlwifi/pcie/trans.c     |    3 ---
 drivers/net/wireless/iwlwifi/pcie/tx.c        |    6 ++---
 12 files changed, 88 insertions(+), 18 deletions(-)



--2lIsf5ceShElOoWSr6gjQEKeu4uCdMp3Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJSk7u7AAoJEC0Llv5uNjIBOXUP/RJmTl9vI/00xYZamuX/1xeV
O7Nz3n3TJ9tDav8WPYCTw+DzMDa/tqUPpWoY/FkSkp3aQxta+ZvDk9vx7xq/3Wwi
CPKAfuLthFF30tNELo/SGuXzKvT2dRus7fAREDKp/Mpo2GugtpHTr8cUleMR6Gl8
aTLz2iRtF0WVcB4Ckvo1FVFprxHjot+TH+onbzvPcjt4vRzMoA5GLyLsM6hAXma2
Dc5M2vR9bAtpxHT3xBBrhBNe+DgZR0HtQXiRk1bvIPOC3g1gKwaopSBviHDBCshs
vPq13xcr+J0uSAd/ka3Fz/ET/X0nGhqAXFL7pPC1PlKzXRVc2HnpFyLTTsImBZbb
F+EDHDXjmvnOzH320VCnNEmMHpGktZLFTzamqkKsArMkHUosAgxoJFzR7Mbx7c4K
s95qJhJ3CB//Dfg4k9smoxbe/xt5xag09INLyy3lngWRUGAldersyqpKeFi+uA9x
9ZE3nrszbAHG7myBtz7a6qhZ2kYcihn4qAU9bBmLfMbr7cpQ6Qd1uo50VwhkVvU/
Bc+yEVMxtyAfRZgo8oMytpEpiTO0F+xuIwdbbxjkELVfwMdB/BFheC3RSy9GZX8s
yzZkC63rjR1dyD3B3m8bTPVNafi4gSS8duKUAfR2/G8htMaVe9zYy2zBRALA68nL
G9ZzUD28svy67dzMSNuH
=xFNt
-----END PGP SIGNATURE-----

--2lIsf5ceShElOoWSr6gjQEKeu4uCdMp3Q--
