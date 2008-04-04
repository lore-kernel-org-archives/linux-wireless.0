Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54066 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbYDDXrj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 19:47:39 -0400
Subject: Re: [PATCH] mac80211: notify mac from low level driver (iwlwifi)
From: Johannes Berg <johannes@sipsolutions.net>
To: mohamed salim abbas <mabbaswireless@gmail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mabbas@linux.intel.com>
In-Reply-To: <b3153e950804041634k2c3fd960h3e118deb7c42f0e7@mail.gmail.com> (sfid-20080405_003409_229099_3DAFE7D7)
References: <1207264130-25437-1-git-send-email-reinette.chatre@intel.com>
	 <1207264130-25437-2-git-send-email-reinette.chatre@intel.com>
	 <1207320389.19189.30.camel@johannes.berg>
	 <b3153e950804041435p7233fe3bn23bc017967687e9a@mail.gmail.com>
	 <1207345183.3625.18.camel@johannes.berg>
	 <b3153e950804041634k2c3fd960h3e118deb7c42f0e7@mail.gmail.com>
	 (sfid-20080405_003409_229099_3DAFE7D7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BwkqKF41rljqbxuAAwEC"
Date: Sat, 05 Apr 2008 01:47:25 +0200
Message-Id: <1207352845.6675.5.camel@johannes.berg> (sfid-20080405_004753_575788_54A6709D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BwkqKF41rljqbxuAAwEC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> for iwl the driver on suspend behave like the device is going down, on
> resume the driver reload the firmware and start fresh. the driver does
> save some data to restore on resume.

Right, I think most drivers/hw behave that way.

> I guess we can enhance on this to handle more scenario, but atleast
> this is good enough for iwl driver.

What happens, for example, when you enable hardware crypto and set a WEP
key? With b43, after suspend/resume, mac80211 and the driver think the
key is set in hardware, but it was obviously cleared. It would of course
be possible to handle that in the driver, but I'd prefer it to be done
in mac80211 because then the driver doesn't need all the extra code.

johannes

--=-BwkqKF41rljqbxuAAwEC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/a+DKVg1VMiehFYAQIong/9HoUSm+P7q3eUdwqQKDzR8E9nL7jNNq9J
KMS7yx1vF0acy1yqSfgTvqW/o/I9VPOHpMRzjdt7TElvK8xINGy8EAubJZMa4NtX
EmIa3LnelUnw1UvlPZz8AG0h67aNZnahOhhQJxJUr60wIHl/rvFpyrv04tZRRTv7
xueKFLD3gj4XFberjYQOq1/eWtaeewOD2pQXz3+pD8HbwmR3LLy51WbHJgcrdoEd
A/Shga6OOrTZpEK1rufuRMvbHSPgkyD+WfTxmFsZwOpxF6GrBAJGQXYx0ur9UREN
ZkS+laVwtCnnX1kxKOjZwy8O44WIVKy3rmUkcKHtRpq71S8irXvYVOTXX9c27iRl
ibrVYMiUlWUWA9aw+Gkn3Ysd17+Md0ONTZ9dK/gWgDpWWP4QwW1Gpr9CKDdKeXTD
iEIFKR7eLvg/Fm8y83/Du2m9hg8eOhCJ9wL8//XxYUDHm1b2hjEn0MNQEtPsrpya
t5xKZC/VNdlrj/tVrS7s1gki74N12X7KwFCO91qWBNT2pNiTSjzzgZVlemtg7CP3
FZ8uw3+bpWr6z+lIsCIatejrTQpd98Bes/AYUhO4rHzyKSwh4Q77WcsXQiGE2doQ
uVWV+eiuo/vNmSr0DnZlEsn0anC7oIwcm/EC9/AXWg/wifJxBMiSaWKLj98faPgc
arwDcz7QbLY=
=cO+k
-----END PGP SIGNATURE-----

--=-BwkqKF41rljqbxuAAwEC--

