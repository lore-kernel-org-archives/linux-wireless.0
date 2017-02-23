Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from edge01.uni-rostock.de ([139.30.8.12]:32445 "EHLO
        edge01.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751220AbdBWTGd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 14:06:33 -0500
Subject: Re: [PATCH 2/2][RFC] mac80211_hwsim: Report radio addresses in
 NEW_RADIO/GET_RADIO
To: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        <linux-wireless@vger.kernel.org>
References: <20170223120211.22358-1-andrew.zaborowski@intel.com>
 <20170223120211.22358-2-andrew.zaborowski@intel.com>
From: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Message-ID: <484d045e-d4ca-2073-9a16-8d3556027d75@uni-rostock.de> (sfid-20170223_200641_071694_D1B0C423)
Date: Thu, 23 Feb 2017 20:01:12 +0100
MIME-Version: 1.0
In-Reply-To: <20170223120211.22358-2-andrew.zaborowski@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature";
        boundary="i83acKnhFhVrq0W6s25Oj8rLSRuMDlgM6"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--i83acKnhFhVrq0W6s25Oj8rLSRuMDlgM6
Content-Type: multipart/mixed; boundary="FS0Wfl8FsAc0qPGew8qKjwSfG4HhAnUEr";
 protected-headers="v1"
From: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>,
 linux-wireless@vger.kernel.org
Message-ID: <484d045e-d4ca-2073-9a16-8d3556027d75@uni-rostock.de>
Subject: Re: [PATCH 2/2][RFC] mac80211_hwsim: Report radio addresses in
 NEW_RADIO/GET_RADIO
References: <20170223120211.22358-1-andrew.zaborowski@intel.com>
 <20170223120211.22358-2-andrew.zaborowski@intel.com>
In-Reply-To: <20170223120211.22358-2-andrew.zaborowski@intel.com>

--FS0Wfl8FsAc0qPGew8qKjwSfG4HhAnUEr
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

> Add a HWSIM_ATTR_RADIO_ADDR attribute to those to events/response so
> that a userspace medium can query the list of addresses in the
> simulator.
>
> When a userspace medium needs to handle a broadcast frame it can't
> easily implement the equivalent of what the default kernel medium does
> because it doesn't know who to forward the frame to.  The
> HWSIM_CMD_GET_RADIO command is a little useless in this respect.
> Userspace needs to use HWSIM_CMD_GET_RADIO, then cross-reference the
> radio names with wiphy names using NL80211_CMD_GET_WIPHY dump, map the
> wiphy names to wiphy indexes (those are more useful than wiphy names
> because they don't change -- a wiphy name change doesn't generate an
> event so this can't be easily tracked), and use the
> NL80211_CMD_GET_INTERFACES dump to obtain the wiphy_idx to mac address
> mapping.
I'm a bit confused, I think the medium should always know by its
internal knowledge base, which node would be reachable by a broadcast.

We are also working on the MAC-Management of hwsim, which especially got
weird, if you try to manage many nodes within one kernel. But I don't
understand how this array with addresses could help to improve. When
these addresses do not exactly match to the preconfigured MACs of hwsim,
the frames would not be delivered, since they are only checked against
the internal ones (or you may add a check against your list).

I test to use a internal hashmap, which maps a receiver MAC-Address of a
Frame to a corresponding wiphy node to efficiently deliver frames.
Additionally it would allow to add VIF with different MAC-Addresses (see
corresponding Callback for this) and update the hashmap according to
this. I believe you want to do something similar, but in the userspace.

I also would propose a parameter (like you propose here) as internal
permanent MAC-Address, instead of the automatic increasing
MAC-Addresses, since it become complicated, if you want to use multiple
userspace medium in different network namespaces, as the hwsim MACs are
globally assigned. You may need to handle collisions (I don't know
whether different wiphy could use the same permanent MAC), but this
would be more logical for a simulation, than discover every address
after creation.


>
> Additionally there are two addresses used by hwsim radios
> (data->addresses[0] and [1]), first used at the network level and the
> second used at hwsim radio level and in HWSIM_ATTR_ADDR_TRANSMITTER /
> _RECEIVER.  By default they differ by 0x40 in the first byte but I'm no=
t
> sure userspace can make this assumption to do the mapping from the
> address inside the frame headers to the address of the hwsim receiving
> radio.  I suspect the network layers can change address 0 and they will=

> be out of sync.
>
> Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
> ---
> Additionally I tried to add a HWSIM_ATTR_WIPHY to report the wiphy inde=
x
> directly without users going through wiphy name to index mapping, but
> get_wiphy_idx() is internal to cfg80211.  The index is exposed to
> userspace and is more useful than the name so I wonder if this function=

> should be exported from cfg80211.
I also think that would be nice to have ;-)

kind regards

Benjamin

--=20
M.Sc. Benjamin Beichler

Universit=E4t Rostock, Fakult=E4t f=FCr Informatik und Elektrotechnik
Institut f=FCr Angewandte Mikroelektronik und Datentechnik

University of Rostock, Department of CS and EE
Institute of Applied Microelectronics and CE

Richard-Wagner-Stra=DFe 31
18119 Rostock
Deutschland/Germany

phone: +49 (0) 381 498 - 7278
email: Benjamin.Beichler@uni-rostock.de
www: http://www.imd.uni-rostock.de/



--FS0Wfl8FsAc0qPGew8qKjwSfG4HhAnUEr--

--i83acKnhFhVrq0W6s25Oj8rLSRuMDlgM6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJYrzGCAAoJEBWbfeAC1ejUoRYP/ius6sV5dY35BI3B7zH7lxnt
XgHKY2zVhWuOinIXc7RUDvt4rae4v/mc4hZrzr0Yn1oNQdMjbUTQhJSjbuyWoKbg
uWU7ny74CALpcYiJ86xR+KLMr3pcwS03tF0rlz+lP67KLIDSEZ5lC4W/pVmS0ODv
MQflJAUpb2cYvolOZHKFpmMvd2KxHUq7jWRGzYn4hoNqSm7lxxaGMB5gZOwcmxgk
P9rRqzsK8H7B1E+oGdmpOnWWPDdZebNvCZMNiY2SzXqFCYtvnldH/JBEt2jHt5RC
MT7X2F15tRoUks2g++0vdA290U3OxYVORZBstlecNrWvdwScOsBDDkxwMn3enKTE
w8JwLSre5Y/Qjn+gJBXN8rGfHUNhBV+8m6j9YQr/QwWBTZZ7P2ln7+eV1e0qrdne
iHY8rpVSg0efPDTUdLJROLq+k5uljMUUREXW0zKeIsu3wjrqWyiX3C14A+D5TQAU
zbKJP4v/JSzh2PDSKEliPZvSktoOjRhJ5cL1+iq4VFqJev2Lhc2mGDZ8ScozftoK
fb8YhRiELsOjHFQTd5aMQgovY3IXzaOXvRX0JYdO3BzmmkIAjA0ru7SavCq4zI7B
RbQsqgPgfgmd75d23NKRWtXp3cSaXxn9aLzUk1nOgJbAcYRaNX8JSLT+3EZpztw2
b3Oe9Q2Mo1Aqos0v1ZQC
=8ec/
-----END PGP SIGNATURE-----

--i83acKnhFhVrq0W6s25Oj8rLSRuMDlgM6--
