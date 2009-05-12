Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57088 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbZELXMu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 19:12:50 -0400
Subject: Re: [BUG] scans can still hang with -EBUSY on iwl3945
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1242169824.5146.31.camel@maxim-laptop>
References: <1241179203.8086.3.camel@maxim-laptop>
	 <1241193513.10498.97.camel@rc-desk> <1241208792.7082.47.camel@maxim-laptop>
	 <1241227946.5192.3.camel@maxim-laptop>
	 <1241374060.13562.37.camel@johannes.local>
	 <1241387163.10486.6.camel@maxim-laptop>
	 <1241421545.6866.2.camel@johannes.local>
	 <1242161643.26484.2.camel@maxim-laptop>
	 <1242169824.5146.31.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-D/k54pt5A+OhKRvZ+KCJ"
Date: Wed, 13 May 2009 01:12:14 +0200
Message-Id: <1242169934.14227.16.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-D/k54pt5A+OhKRvZ+KCJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-13 at 02:10 +0300, Maxim Levitsky wrote:

> > May 13 01:44:33 maxim-laptop kernel: [ 1093.991176] iwl3945 0000:06:00.=
0: Radio Frequency Kill Switch is On:
> ^^^^^^^^^^ Kernel notices the rfkill state
> > May 13 01:44:33 maxim-laptop kernel: [ 1093.991179] Kill switch must be=
 turned off for wireless networking to work.
> > May 13 01:44:35 maxim-laptop kernel: [ 1095.789455]  ieee80211_ioctl_si=
wessid: called
> ^^^^^^^^^^ Evil NM notices Rfkill too, and sends bogus bssid to driver
> > May 13 01:44:35 maxim-laptop kernel: [ 1095.789462] ieee80211_sta_req_a=
uth: called
> > May 13 01:44:35 maxim-laptop kernel: [ 1095.789498] iwl3945 0000:06:00.=
0: Error sending REPLY_LEDS_CMD: enqueue_hcmd failed: -5
> > May 13 01:44:35 maxim-laptop kernel: [ 1095.789530] iwl3945 0000:06:00.=
0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
> > May 13 01:44:35 maxim-laptop kernel: [ 1095.789536] iwl3945 0000:06:00.=
0: Error clearing ASSOC_MSK on current configuration (-5).
> > May 13 01:44:35 maxim-laptop kernel: [ 1095.870202] iwl3945 0000:06:00.=
0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
> > May 13 01:44:35 maxim-laptop kernel: [ 1095.870210] iwl3945 0000:06:00.=
0: Error clearing ASSOC_MSK on current configuration (-5).
> > May 13 01:44:35 maxim-laptop kernel: [ 1095.870223] iwl3945 0000:06:00.=
0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
> > May 13 01:44:35 maxim-laptop kernel: [ 1095.870227] iwl3945 0000:06:00.=
0: Error clearing ASSOC_MSK on current configuration (-5).
> > May 13 01:44:35 maxim-laptop kernel: [ 1095.870234] wlan0: direct probe=
 to AP 00:0e:2e:a4:12:3e try 1
> > May 13 01:44:35 maxim-laptop kernel: [ 1095.960876] cfg80211: scan requ=
ested
> ^^^^^^^^^^^ This results in a scan
> > May 13 01:44:35 maxim-laptop kernel: [ 1095.960884] __ieee80211_start_s=
can: scan requested
> > May 13 01:44:35 maxim-laptop kernel: [ 1096.042972] wlan0: deauthentica=
ting by local choice (reason=3D3)
> ^^^^^^^^^^^ And deauth....
> > May 13 01:44:35 maxim-laptop kernel: [ 1096.331307] ieee80211_ioctl_siw=
ap: called
> ^^^^^^^^^^^ And NM sets ESSID on top of that....
> > May 13 01:44:35 maxim-laptop kernel: [ 1096.331310] ieee80211_sta_req_a=
uth: called
> >=20
>=20
> Now I press rfkill again, but scan is hung

So it's a bug in iwlwifi, it neither rejects nor executes a scan when in
rfkill.

johannes

--=-D/k54pt5A+OhKRvZ+KCJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKCgJKAAoJEODzc/N7+QmaQ20P/Aswin16EEoAm2nG+cP5i4d7
AUG+HsJ1rhM9o2M9gh1nH9omTUy+CIGDXOOCTazdAF7ju7HTxocw4qnsN6vBee0V
ykLjqc1UjMUY2yrcn6B0xx3a8qUlIq0p/gS6Pr7ruycjVTfC6PaDiIa8bz7Fig++
Lv9TY17n2aSokrVHeiGT/WG2Or1vy/ev4uA449prB5GppRdb8w/bmxdJbD/EWnSS
l/QF7C7hoe71zHxs1GouVz0W5sJXFpXCtpud8AGXQsg6PppQCVjd1OkX1sX7vKeW
W/6udit/9XEq6YKzGXbDMSSULQWGzMQMeL5o3O2AUjFHf0NA539dS/018+mId2kd
jT/lBJLGZswUmdGLVVb32lH6v7P2vkgvHfsXRIKvH7iRZAbHnI/fwD3jr/NQr5pO
oz5ShTgm1/W5aU5og3+5nfIxQP/f20adjCIS3zogOwNkZD8nA2YS0snaDIfWxLCg
igv7ZSjmdS9Bb7F/zHuyIN1eXUXmJsoE1A+YG63u6GfHxXFEywNPtQxjIznME48t
p6YjSKnaJTUmED6FB63ywhB86pckloKLcsx9/uhcQQnLHlzRJPhWiJTRK+QjcPgm
YpXxVz9STVr4PUqe9T9NWyK9Je1JrKePAoh+G0kUynoCKf0ovj1/MQSt/JoTCENS
Un1EkP61dWoiMO2QlITQ
=1JSn
-----END PGP SIGNATURE-----

--=-D/k54pt5A+OhKRvZ+KCJ--

