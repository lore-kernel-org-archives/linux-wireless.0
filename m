Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55860 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbZEMIaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 04:30:24 -0400
Subject: Re: [BUG] scans can still hang with -EBUSY on iwl3945
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1242175833.5154.2.camel@maxim-laptop>
References: <1241179203.8086.3.camel@maxim-laptop>
	 <1241193513.10498.97.camel@rc-desk> <1241208792.7082.47.camel@maxim-laptop>
	 <1241227946.5192.3.camel@maxim-laptop>
	 <1241374060.13562.37.camel@johannes.local>
	 <1241387163.10486.6.camel@maxim-laptop>
	 <1241421545.6866.2.camel@johannes.local>
	 <1242161643.26484.2.camel@maxim-laptop>
	 <1242169824.5146.31.camel@maxim-laptop>
	 <1242169934.14227.16.camel@johannes.local>
	 <1242170080.5146.32.camel@maxim-laptop>
	 <1242170403.14227.18.camel@johannes.local>
	 <1242175833.5154.2.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0rrDGfhlvrs1M91UVQBt"
Date: Wed, 13 May 2009 10:29:47 +0200
Message-Id: <1242203387.14227.26.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0rrDGfhlvrs1M91UVQBt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-13 at 03:50 +0300, Maxim Levitsky wrote:

> > Also you could stick some printks into
> > net/mac80211/scan.c:ieee80211_scan_work() at strategic places and see..=
.
> > but if they never happen you haven't turned off hw scan.

> You know, you are right, it turns out that hw scan was active (due to
> all the experimentation, I forgot to turn it off...) and it is obvious
> that iwlwifi has rfkill related bugs there, I handle that later.

Ok.

> But without hw scan, something is still there, I sooneer or later will
> understand.

Ok, I can't say I can see any issue, but if you put printks into the
mac80211 scan code and reproduce it (I don't have rfkill) I'll be happy
to take a look.

johannes

--=-0rrDGfhlvrs1M91UVQBt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKCoT3AAoJEODzc/N7+QmazYQP/26VI20pe1Zpwbf9dgUtTEQF
+buRev0DBE/aNKkeEHp0taPva7wVEZAvF1Fpo8kTG6DcB4HbVnuzh2b3VaNmaU+l
0A0e1Oky7qV6oac9sh4PyeMH6Mn2ttp5q1eyHpuT4OFTXYACOdrJQGTgpmQ/mySn
zAcTiT0sE410kY+/GAmgPgLse7693cooSid8CRUwYK05p19LOp9pVCIUv2vozgNR
tXs4cWbJYtZfupOSacmWf+rUlXzF3b3nK41DJIyitZfjtLfui1DDdncDuj0/ER3+
59AeMYiW3+O4sxLcyJydNfGV7UKebBO3HkRf6H2CwzmM1NtdIp7H3zdg4pVm5zTw
4llocJWAx6To9I07+XypdRMzrbebborgmTj9RRBd26TH2nYta4nGqxivqakgjLDJ
aX/Q0wy3jVnKL1U0VYysmJhNAFuNma1+3JHLk8n7wU0ABaxB5gwaLNnzj1DmOlqM
7EjoiPtEYzbvM42yivr1bpYHFz++jwiJlk51u8vmYmDxgCDzPcefqa/rS8t5o1m8
SrQsbgPJrm2ZiDQ7UMNWN3Mr2mRZt0hHeYe6qnUZMo1qnmPsB/48QR6oWLEABNt+
3wzXQsTnMtc5hswGPjWpkXWpi6w7NVJ9+9TJLYSQUjWPbOsin/VFbNjyPxaSS02E
FpWrSFN5AhjGu2q4RLQg
=PQpd
-----END PGP SIGNATURE-----

--=-0rrDGfhlvrs1M91UVQBt--

