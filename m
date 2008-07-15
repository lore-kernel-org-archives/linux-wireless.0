Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49893 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbYGOIlI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 04:41:08 -0400
Subject: Re: [PATCH 2/2] mac80211: make listen_interval be configurable by
	low level driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Kalle Valo <kalle.valo@nokia.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240807150129v4906b7bcyba66ab62b57c5d71@mail.gmail.com> (sfid-20080715_102953_982307_5BF8D17D)
References: <1216038684-29725-1-git-send-email-tomas.winkler@intel.com>
	 <1216038684-29725-2-git-send-email-tomas.winkler@intel.com>
	 <1216039127.11189.15.camel@johannes.berg>
	 <1ba2fa240807140546w4f08e32l59ed88dfa1b86403@mail.gmail.com>
	 <87fxqcoaue.fsf@nokia.com> <1216109543.23746.21.camel@johannes.berg>
	 <1ba2fa240807150129v4906b7bcyba66ab62b57c5d71@mail.gmail.com>
	 (sfid-20080715_102953_982307_5BF8D17D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Pxi/pStDFwjHtQVlsfR7"
Date: Tue, 15 Jul 2008 10:41:01 +0200
Message-Id: <1216111261.3535.7.camel@johannes.berg> (sfid-20080715_104113_162448_2594C528)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Pxi/pStDFwjHtQVlsfR7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-15 at 11:29 +0300, Tomas Winkler wrote:

> We are providing power save user interface reach enough to specify all
> the above requirements.
> I think you are both misinterpreting listen interval meaning.
> Listen interval merely says to AP for how many beacons save direct
> packets for this STA. It doesn't mean
> it's can be shorter and it  does say it's won't be longer.=20

Right, but it does make sense to advertise what we're using, and this
patch just adds a strict "driver tells mac80211 what it's using" flow.
That's mostly what I'm objecting to. If you were calling the variable
"max_listen_interval" and having mac80211 send it back to the driver in
the BSS config as bssconf->listen_interval, and, for now, simply use the
max, I wouldn't have a problem with it.

> It's
> doesn't affect power save dynamics it's just sets upper limit.
> This value for iwlwifi hw is derived from maximal supported  beacon
> interval and size of the internal HW timers.
> This value is hard coded in the driver.

Shouldn't it depend on the beacon interval then?

johannes

--=-Pxi/pStDFwjHtQVlsfR7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIfGKZAAoJEKVg1VMiehFYV9oP/3yhlvw/9Nj9SiIbAy40rBT3
FsB4ZCfYIBd5By0YZcVgDpfqes6SXWY6vbG9YcY0q1Fc1fniTlv2DCem7GIUZIyh
dafGnNNM6omziYWM3qTa5gjzGu8Qlfabzkd/H7oVlCLrLNX7IKv0kW3A6Vb4SVg5
LYFfUlA/8/hqrpi5osIR6rEe4ZkuL8PimbeMh5BgDZoVc+au+sTAKGZz9lcmCCCO
sF7FAIf6SqriDd5OEVSAQ6xjShreTZ5RTBuLbfTMvcbGdghCqKMX7U7CYzAC8V4H
PLgLiUh2Srw9km/Mzt87O5/k+p8kzXV6iJoLBRdgNDlsGEjeCgdy1aTDGxGA87cG
9EyuOqAZyOxgBQhOP4AavfjDAHv1mYaEFDr19a4nTlLfyGH66naM3rSLpcRYLfmB
d8vdCx+7OOXCLaIa+cJWOb+27BdeTRWTtUAmnkipAcwa+2F8DLIrxAj1N/aa4Xx2
tilG91MC2V8ay8G47ypN3Ens7sGOMmGvUjWNdz7FtKYrcmYBnbOu3b1dwglYkqlI
/NnXlQk11n7+mTP+LOpdtkkCGV81+52EQxk2pgk4AiBhPZIiyfzqq/Lr6atU3Qv2
whhDRSynMBky9sqw33cb+ibxFF+Rlq/UYcMOsuX/XjHuqJTop9Ma3LGh4gk9FYzQ
nyteq3A7X141N7wyLyly
=9rzO
-----END PGP SIGNATURE-----

--=-Pxi/pStDFwjHtQVlsfR7--

