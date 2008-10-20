Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39226 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbYJTJMm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 05:12:42 -0400
Subject: Re: [RFC] mac80211: Re-enable aggregation
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"tomasw@gmail.com" <tomasw@gmail.com>
In-Reply-To: <18684.18492.94865.480736@gargle.gargle.HOWL>
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <1224491480.18024.32.camel@johannes.berg>
	 <18684.18492.94865.480736@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ykFe9QYtbjbu0yL2OGx+"
Date: Mon, 20 Oct 2008 11:12:37 +0200
Message-Id: <1224493957.18024.47.camel@johannes.berg> (sfid-20081020_111246_473886_C7BD24EE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ykFe9QYtbjbu0yL2OGx+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-20 at 14:28 +0530, Sujith wrote:
> Johannes Berg wrote:
>  > =20

Can you change your quote string from " > " to "> "? Just asking, if you
can't/don't want to that's fine, it just always confuses me for a
second. I really should try to figure out if I can convince my mailer to
highlight " > " indented text as quote too.

> Well, currently ath9k maintains a buffer list for each tid.
> When mac80211 sends down a frame, if the recipient has an aggr. session g=
oing,
> it is appended to the tid's buffer list. Non-HT frames are sent out immed=
iately.

Incidentally, why the distinction between HT and non-HT frames?

> On TX completion, we run through all the ACs, STAs and TIDs and send out =
pending
> frames as aggregates.

So basically you can always have one frame or one aggregation
"pack" (for lack of a better word) queued to the hw?

> IMO, this is heavy stuff for a driver.

Yeah most of it probably is.

> mac80211 can probably help by maintaining the TX state for each TID, main=
tain the
> buffer list, etc.  and provide appropriate mechanisms for drivers to obta=
in pending
> frames as and when needed.

Sure could. Intel's hw would probably like a way to say "stop this TID"
and "wake this TID" which is what they tried to do using real queues.
mac80211 could queue up the frames in per-station state and provide a
functions like

ieee80211_stop_aggr_stream(struct ieee80211_sta *sta, u8 tid);
ieee80211_wake_aggr_stream(struct ieee80211_sta *sta, u8 tid);

or something like that. Then those frames would flow into the right
queue. We might need a multi-layer start/stop management but we already
do, we've just managed to get away without it without tx stalls. Or they
just haven't been reported yet.

johannes

--=-ykFe9QYtbjbu0yL2OGx+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/EuCAAoJEKVg1VMiehFY7IMQAKzUmbu8pYxndweUzjgZGWyx
QrzlTH+zNhZdowxfG2z/8/SJbzcj1k7YR1yJg4ZDPiqCK8k0Aeevpldc5oWe+wsJ
D15VfA9cc8vDMp6A/54diNQcwIbkERsAs0k2PtIDjLJuINBIOnGU+lkB5PrNhUgj
Si+xgLzqssIOy7Ii+n+dGtsrbynV+HpWHkOMp77H7rnD8JbbS/03/n94L5iLi2Y3
KlPsITxC3gbHlJOgeB8wNyGKrWsXEc48DjlVW4rod0l3XPWr6c8tBywBnQsEyVs2
WFl1vJ7PQeGkGkLFAOSZYfcNag8BLD+YUk1LzoCm9YbEtn2kKuObp4t+ehup7GTu
Zy+Yf+cozy06maxoM3TJSEknVkM2Feo4Omr7qGCk31PKczHZXz9RVvosXv3ryYmh
+kcCuqoPiglnxwwOGLIMkosrpkg4qNlTVH7WBEqRQZhGUVHxvXDRpUefEuERjESz
ZmmrjBXTvlWDRWMyGIT7s54JmeyobxIBaHhC0BwCvIxvCTpOhdQob0p7olJGNFIT
1XYZofTDO77s91Kwb8XmAa7riLFwwMSakFrT7xKRcUOxyO2nQ6iaJ4xuAOt0nRoQ
YXIqQ4U8nmvt3dhNMaBAZ/x5G+8VzwMg7dKCLs53TOl6mNnKc4wWC033PSOJxf4t
2UxfSSnWhVBl6VBb4Tdq
=8B0E
-----END PGP SIGNATURE-----

--=-ykFe9QYtbjbu0yL2OGx+--

