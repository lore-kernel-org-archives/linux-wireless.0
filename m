Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59659 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbXFNJJz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2007 05:09:55 -0400
Subject: Re: [Take 2] mac80211 IEEE802.11e/WMM code cleanup
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	David Lamparter <lists@diac24.net>
In-Reply-To: <1181635570.4758.22.camel@debian.sh.intel.com>
References: <20070611085950.GA5540@mail.intel.com>
	 <1181584907.29767.30.camel@johannes.berg>
	 <1181635570.4758.22.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Xg72uLcrSD4cVBNYp05D"
Date: Thu, 14 Jun 2007 09:36:47 +0200
Message-Id: <1181806608.9058.22.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Xg72uLcrSD4cVBNYp05D
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Alright, let me try to summarise what we want as API for DLS:

 * NL80211_CMD_GET_DLS_PEER
   doit: simple boolean answer: is DLS set up with given peer?
   dump: give all DLS peers
 * NL80211_CMD_SET_DLS_PEER [_CMD_REQUEST_DLS]
   request setup of DLS
 * NL80211_CMD_NEW_DLS_PEER
   kernel notification about a newly setup DLS connection
 * NL80211_CMD_DEL_DLS_PEER [_CMD_TEARDOWN_DLS]
   request teardown of DLS connection

 * NL80211_CMD_NEW_DLS_REQUEST
   kernel notification for DLS request from the other side
 * NL80211_CMD_SET_DLS_REQUEST
   send DLS response to given peer with given status
(* NL80211_CMD_GET_DLS_REQUEST
 * NL80211_CMD_DEL_DLS_REQUEST
   make no sense)

I tried ordering these by get/set/new/del quads as David suggested but I
don't think it makes sense for DLS request, I suppose we have somewhat
different requirements and I think I'd rather have different names as in
brackets above. Then again, that could get confusing with
_CMD_REQUEST_DLS and _CMD_NEW_DLS_REQUEST...

For me, that settles the DLS API. That API is easily implementable by
the userspace MLME as well.


Now, for TS, it seems that most of the work is with handling the
response to an ADD TS request. Also, the current code doesn't seem to
allow using TCLAS or TCLAS processing information for the ADDTS request
frame. For the response, I suppose you'll be adding it, but I'm not sure
we want to have all the complexity for the request. Maybe we should
simply require the ADDTS/DELTS request frames to be injected and we
handle the responses with some notifications via nl80211?


johannes

--=-Xg72uLcrSD4cVBNYp05D
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGcPAP/ETPhpq3jKURAhpiAJ9z7ItWSfRX8BVewPMa3Z3yHhzlfwCdFjZ6
F41WRTHiM8HKxCfsjR3B6vg=
=0ivp
-----END PGP SIGNATURE-----

--=-Xg72uLcrSD4cVBNYp05D--

