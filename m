Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55948 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759227AbYARMiu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2008 07:38:50 -0500
Subject: Re: [PATCH 05/12] iwlwifi: delay firmware loading from pci_probe
	to network interface open
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Zhu Yi <yi.zhu@intel.com>, Ian Schram <ischram@telenet.be>
In-Reply-To: <1200361585-31801-6-git-send-email-reinette.chatre@intel.com> (sfid-20080115_022710_198103_7FE5555D)
References: <1200361585-31801-1-git-send-email-reinette.chatre@intel.com>
	 <1200361585-31801-2-git-send-email-reinette.chatre@intel.com>
	 <1200361585-31801-3-git-send-email-reinette.chatre@intel.com>
	 <1200361585-31801-4-git-send-email-reinette.chatre@intel.com>
	 <1200361585-31801-5-git-send-email-reinette.chatre@intel.com>
	 <1200361585-31801-6-git-send-email-reinette.chatre@intel.com>
	 (sfid-20080115_022710_198103_7FE5555D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FiXiXF/N5X/Ww1xgPLcq"
Date: Fri, 18 Jan 2008 13:35:20 +0100
Message-Id: <1200659720.5716.24.camel@johannes.berg> (sfid-20080118_123853_454568_DE2741B7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FiXiXF/N5X/Ww1xgPLcq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> This patch moves the firmware loading (read firmware from disk and load
> it into the device SRAM) from pci_probe time to the first network
> interface open time. There are two reasons for doing this:

I have a bit of a problem with this patch...

You're supposed to register your hw modes before registering the hw,
that is no longer the case after this patch!

That's actually totally killing my cfg80211 rate API patch because that
complains if the bands in the registered hw/wiphy aren't assigned
properly.

Can you call *_init_geos() before registering the hw, i.e. before
initialising the firmware?

johannes

--=-FiXiXF/N5X/Ww1xgPLcq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR5CdBqVg1VMiehFYAQKLWQ//acup0Ao5BPyyvzYULp+8oowVbn215KU0
8DTNkzdf8M6zF0BRkL6uLRbXxPm5ZreqjokYEQOFyeKPzA+0MFObQTO1CkXx7LuX
CJNhhVGcF4OPrXwJC4eO4h/H9yV3lHpLou4iqRAGuWaQ4keHuWCsrrakIY5yogcv
5iM7wG99Q2tonrTgoe5fMQDSUx2ktKDOyCfWhiCS0x+7L5zRQ65uKn7JUJTqDBWl
yDK2hNk1ZXdEXfIxIpvrwJPXfdPORBw5806I3XMiNNCOdXQ8ZQqLb1WB73KEgVgM
n8LC0RtxE77sSIjSlqx+aK6z3nI/yEasQ9gyQwNLPoPvkeM6ThgyighWyQOPNnfZ
5z433LFfRb+/NS3Q49hDJbHT6VQ7uNpndb61sn/GKeL9JerkkCU8DUcyS2a8z9+Q
dVJNGPf7pDbLifpL2MVDJf+i3GBe0ikvBfi5EdupEwnjL2idurpQ0DF8IU4DWA6s
fvwe+KnL6y3CdO/7QCW7Gof4JzPLITW0UMDQ9MJgv/vz6k40TswebKVoP3y0Qhri
ryzBV9aiouP8m6JgUF043fv+rHd8TRSRiy6UgCBAP+7bRdgTvUZytruI54okBIho
MfFWU4Q3i10JGhESR+9MO+oqX8YPaqkhNzMcXJBAlXotym416pijA7Ki775O2QN4
4/VRoYx+yms=
=MqN8
-----END PGP SIGNATURE-----

--=-FiXiXF/N5X/Ww1xgPLcq--

