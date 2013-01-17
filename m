Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:50863 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab3AQOVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2013 09:21:37 -0500
Date: Thu, 17 Jan 2013 15:21:26 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv6 0/6] Add DFS master ability
Message-ID: <20130117142125.GF19552@pandem0nium> (sfid-20130117_152140_976035_39545369)
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1358378574.15012.62.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+jhVVhN62yS6hEJ8"
In-Reply-To: <1358378574.15012.62.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--+jhVVhN62yS6hEJ8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Johannes,=20

as always, thanks for the detailed review!

On Thu, Jan 17, 2013 at 12:22:54AM +0100, Johannes Berg wrote:
> On Tue, 2013-01-08 at 14:04 +0100, Simon Wunderlich wrote:
>=20
> > Any comment/review/etc are very much appreciated!
>=20
> I'm still confused about what the desired behaviour should be.
>=20
> >From what we discussed the following are valid use cases:
>=20
>  1) do CAC on all channels, select one that is usable later
>  2) do CAC with one NIC, use it with another NIC (hot standby)
>=20
> We can address 2) by storing the "channel is clear" evaluation in the
> channel struct -- although then it'll only work with the same driver
> etc. This can be resolved later anyway.
>=20
> Case 1) certainly implies that we need something like "channel
> considered usable until ..." timer. You don't have that at all. Instead,
> you seem to consider it clear until an AP interface is started & stopped
> on that channel, or otherwise forever. That seems wrong.
>=20
> So I think that in the channel struct/globally we really only need the
> "channel_usable_until" value, which is X seconds (? I don't know what
> the reg rules say) after the radar detection completed.

As stated before: "available until ..." time is not neccessary as far
as I know. Also the channel must stay available when AP stops operation,
I'll change that.

> Actually with your current patch 2) cannot be implemented at all because
> the initial CAC never really finishes?

Yeah, for this case it is flawed - one could start radar detection on
different channels one after another in short time, and we would just
set "cac_started" and the timeout - which eventually might mark all channels
available without checking for the required time on it. That seems wrong.

>=20
> I think the operations here should be like this:
>=20
>  * start radar detection
>    - cfg80211: store radar detect chandef in wdev struct to use it in
>                cfg80211_get_chan_state()
>    - mac80211: configure chanctx, call driver
>    - driver: start radar detection

OK.

>  * radar detection finished:
>    - driver: call mac80211 with result (radar detected or not)
>    - mac80211: free up channel context (probably needs workqueue!)
>                pass result to cfg80211
>    - cfg80211: clear wdev radar detect chandef
>                if OK to use: store availability in channel struct
>                send result to userspace

Right now we only have the event for radar detect (i.e. detection
failed).

We could add a timer to mark the channel available after the CAC time,
if no radar has been detected in this time. Don't know if mac80211 or
cfg80211 would be the best place for this, but I think the driver is not
- this timer must be shared over various drivers after all.

>  * start AP:
>    - cfg80211: check channel availability
>    - cfg80211/mac80211/driver? - enable radar detection while operating

mac80211 can instruct the driver to use radar detection while operating.
E.g. pass it in sdata->vis.bss_conf ?


>  * AP channel switch:
>    - if due to radar, mark channel as not clear
OK - in AP case, we would have got the radar event anyway so the channel
would already be marked "not clear". In IBSS however, that is possible
(another station may have asked us to switch channel because of radar).
>    - if not due to radar, mark channel as clear until X seconds in the
>      future
Timeout not needed.

>  * stop AP:
>    - cfg80211: mark channel as clear until X seconds in the future,
>                unless it was marked not clear by a radar detect event
Timeout not needed, just keep it clear.
>  * radar detected event:
>    - cfg80211: mark channel as not clear

OK
>=20
>=20
> Note how I'm also letting the drivers determine the duration of the
> radar check. Maybe the duration should be passed to the driver, or maybe
> not, but I think for full-MAC chips it would be more likely that they
> get an event for both cases from the device, not just the timeout you
> have in software ...

Hm, I don't know. CAC times are subject to regulation changes. In ETSI
it's one minute, for weather channels (5600-5650 MHz) 10 minutes (but we
better don't support them anyway as they require incredible radar=20
detection rates).

> Actually, now that I think about it, I have my doubts about the mac80211
> "start_radar_detect()" API. It seems that it really just starts the
> detection, and has no way to stop it etc. So maybe that timer should be
> in *mac80211* (for the current drivers), and should also be called after
> adding a chanctx when starting the AP vif. Or maybe it should actually
> be tied to "add_chanctx()" (or "config()" for backward compat) -- when a
> channel requiring radar detection is configured, detection should be
> enabled?

The radar detect command was originally planned to just start the detection,
yes. Userspace should just "try" to use the channel after CAC time - if the
channel should be used earlier, start_ap or whatever will just fail. So yes,
it just starts the radar detection, stopping it didn't seem neccesary yet.

If we change the concept to explicitly handle the end of CAC in the kernel,
the timer approach is imho the best.

Cheers,
	Simon

--+jhVVhN62yS6hEJ8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlD4COUACgkQrzg/fFk7axZcggCfVbnyyIMevuS5ppcw6zDO8S5G
JtcAn3P8aQUHxXSS35DBDZkpK4TFZbtL
=GPvo
-----END PGP SIGNATURE-----

--+jhVVhN62yS6hEJ8--
