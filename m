Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34405 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbZGYIfS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 04:35:18 -0400
Subject: Re: [PATCH] mac80211: redefine usage of the mac80211 workqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	Dan Williams <dcbw@redhat.com>,
	Lennert Buytenhek <buytenh@marvell.com>,
	Daniel Drake <ddrake@brontes3d.com>
In-Reply-To: <1248482853-17032-2-git-send-email-lrodriguez@atheros.com>
References: <1248482853-17032-1-git-send-email-lrodriguez@atheros.com>
	 <1248482853-17032-2-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-6SedbXaedLH+DLTyqnwM"
Date: Sat, 25 Jul 2009 10:35:09 +0200
Message-Id: <1248510909.32151.48.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6SedbXaedLH+DLTyqnwM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-24 at 20:47 -0400, Luis R. Rodriguez wrote:
> The mac80211 workqueue exists to enable mac80211 and drivers
> to queue their own work on a single threaded workqueue. mac80211
> takes care to flush the workqueue during suspend but we never
> really had requirements on drivers for how they should use
> the workqueue in consideration for suspend.
>=20
> We extend mac80211 to document how the mac80211 workqueue should
> be used, how it should not be used and finally move raw access to
> the workqueue to mac80211 only. Drivers and mac80211 use helpers
> to queue work and flush the mac80211 workqueue:
>=20
>   * ieee80211_queue_work()
>   * ieee80211_queue_delayed_work()
>   * ieee80211_flush_workqueue()

I would prefer to have wait_on_work() and/or cancel_work_sync() instead
of flushing? It's often preferable due to locking constraints to
cancel_work_sync() instead of flush_workqueue(). Do people really need
flush_workqueue()?

johannes

--=-6SedbXaedLH+DLTyqnwM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKasO5AAoJEODzc/N7+QmazJ0QAKZPGq4lOl2V4BgDPHjqVbaJ
cw3g+AjgnLDeg5iuO+Bs5v9Ngy/QCI1RITJ9nyMbS0FEePqwUX4gkFRuDq6JOVFT
ouWNg57OALkI5u7lSfVuKdwOmTTbJBQ+bTc+W2dDOQGqUZfcbN4a6GKFb3UvNYzc
pcH+M8o/SGEGCZAo/mRPLqGfS3njAv+IuIawJ9fUkhEP8xYidI2KTus0/Ojcze6m
2/NTxn+vwVeLBUjpbk5OUPLKK1y7LYA8c7mXi0/iw3/YzsHpklAH6o1Pnm2/mZJ+
fs88G95hQ2HVHWx3ORb1U7/fey3RsKeJMopVCVmKG4WIMVrf3YG+Ujv7yLJrd7Mw
usTHE09TBs5AL8H2LTHRurjX5Ph75bUm2gNBmZfMWa4VtHwTw2O29NUEe2BgEcuX
RqBIqXbQq6xBcA8Csd/dB7sjhDqVvPvexntsI4M4O5KmqdDaWqyfA+Jhpm8pNn2E
zGv8lrhlwg99v60Hnnw+HduIhSGFrrr/uMJgS4Dfheadc/wCpyguykPNqFRKdg9v
q4yvRjCmmGsIxD/WkKpELbJk9RKxLs8evziuTLbllnYwWd2UAbk2KHt7zFs6aBq9
YLjrphhlN01QDLC0YskXC9rg5yO9bJwCN72r183KpJE2hfN4d0PvBXWYH5KR7fU5
SjKk2QIYBVtOpGgjdz9y
=vzJE
-----END PGP SIGNATURE-----

--=-6SedbXaedLH+DLTyqnwM--

