Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45311 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbZLXMlk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2009 07:41:40 -0500
Subject: Re: [PATCH 1/5] mac80211: fix race with suspend and
 dynamic_ps_disable_work
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org, Jonathan May <jonathan.may@atheros.com>,
	David Quan <david.quan@atheros.com>
In-Reply-To: <1261616609-518-2-git-send-email-lrodriguez@atheros.com>
References: <1261616609-518-1-git-send-email-lrodriguez@atheros.com>
	 <1261616609-518-2-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-GddbZHlnUccPbOwqhdTe"
Date: Thu, 24 Dec 2009 13:41:30 +0100
Message-ID: <1261658490.28729.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GddbZHlnUccPbOwqhdTe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-12-23 at 20:03 -0500, Luis R. Rodriguez wrote:
> When mac80211 suspends it calls a driver's suspend callback
> as a last step and after that the driver assumes no calls will
> be made to it until we resume and its start callback is kicked.
> If such calls are made, however, suspend can end up throwing
> hardware in an unexpected state and making the device unusable
> upon resume.
>=20
> This situation is observed with ath9k but likely possible
> with any other device which supports and supports dynampic PS
> and enabled. When mac80211 suspends it tears down BA sessions
> with ieee80211_sta_tear_down_BA_sessions() and since this ends
> up transmitting frames through ieee80211_xmit() mac80211 could
> end up scheduling the dynamic_ps_disable_work work onto the
> mac80211 workqueue. This allows for a race between the work
> kicking off and mac80211 completing the suspend work by calling
> the driver's stop callback. If the driver's stop callback is
> run first and the scheduled work runs later (this is expected
> as we don't flush in between) the driver's config callback
> could run after the hardware has been turned off which amongst
> other things could end up leaving the card with enabled
> interrupts and awake leaving the harware in an unpredictable
> state prior to suspend. Upon resume the device can become
> completely unfunctional displaying PCI-express errors such as
> "unsupported request detected" and the driver's respective
> start callback would failing. Apart from leaving the hardware
> in an unresponsive state since mac80211 currently allows failed
> start calls to go through new interrupts will be unhandled and
> as such the interrupt for the device will end up getting disabled
> as follows:
>=20
> irq 18: nobody cared (try booting with the "irqpoll" option)
> Pid: 0, comm: swapper Not tainted 2.6.31.4-intel-menlow #5
> Call Trace:
>  [<c105ca3e>] __report_bad_irq+0x2e/0x6f
>  [<c105cb74>] note_interrupt+0xf5/0x14d
>  [<c105d0a4>] handle_fasteoi_irq+0x7d/0x9b
>  [<c10048c1>] handle_irq+0x3b/0x46
>  [<c1004103>] do_IRQ+0x41/0x95
>  [<c1003189>] common_interrupt+0x29/0x30
>  [<c103007b>] ? ptrace_notify+0x12/0x97
>  [<c1040f07>] ? tick_nohz_stop_sched_tick+0x2ee/0x2f6
>  [<c1001e11>] cpu_idle+0x27/0x5e
>  [<c12feb73>] rest_init+0x53/0x55
>  [<c14b0805>] start_kernel+0x2f6/0x2fb
>  [<c14b0070>] i386_start_kernel+0x70/0x77
>=20
> Fix this by preventing mac80211 to schedule dynamic_ps_disable_work
> by checking for when mac80211 starts to suspend and starts
> quiescing. Frames should be allowed to go through though as
> that is part of the quiescing steps and we do not flush the
> mac80211 workqueue since it was already done towards the
> beginning of suspend cycle.
>=20
> The other mac80211 issue will be hanled in the next patch.
>=20
> For further details see refer to the thread:
>=20
> http://marc.info/?t=3D126144866100001&r=3D1&w=3D2
>=20
> Cc: stable@kernel.org
> Cc: johannes@sipsolutions.net
> Cc: Jonathan May <jonathan.may@atheros.com>
> Cc: David Quan <david.quan@atheros.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>


Looks fine, but the commit log is way too long I think, nobody will
understand that. All the stuff about PCI and interrupts and crap is just
a pure ath9k specific symptom of the bug that isn't really all that
relevant to this commit ... if you want to log that information anyway
then please make it more of a postscriptum by explaining that it's ath9k
specific and putting it after how you fixed it.

johannes

> ---
>  net/mac80211/tx.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index ac48c86..42bfd97 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1418,6 +1418,10 @@ static bool need_dynamic_ps(struct
> ieee80211_local *local)
>  	if (!local->ps_sdata)
>  		return false;
> =20
> +	/* No point if we're going to suspend */
> +	if (local->quiescing)
> +		return false;
> +
>  	return true;
>  }
> =20


--=-GddbZHlnUccPbOwqhdTe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLM2F3AAoJEODzc/N7+QmaFMMP/1zNxtd8SNI6yHD5Z/opzuGH
waAF+7krtrgKrtht7S+JIoYKnX+8ShbQjS5hlUoqjexq+PSozW+HioBX4DSGBpHc
B/PLO5Rt3DstOGC6pEIwYKNnFoxfKImzbze+qITkKAmh5t4C4m/hunT9SJ5IqvaK
3KEzzcKwu8d6+2vg5ud6ecbybtLqrESkSsLlhnFkSlRkiB9pJwLjKd5dpSpbHh4V
tmyl2kbdcvxnPzEixg4n/hpMYULVxmlidjSpieFhdV0r17soZSd6uQvGHG62IV26
TWMri+yznig74WtLwl90HwIwf/rxf4b7r0DT4DzXvJWUAO1qXvOVIMI9yBWF4SGZ
s4y3DMN2P+BSF9spukNJW3BwKVQVkKHHwa636eg/kLfhtV/eXE+IXBI0hZki1k7F
CgbhPdbgwLartCssxVbpB9LlhthjexNcct/qbevmprobQH3w7RI/aH2KiS+E7uUB
+6lc4oGLV9iMNJac6auQ5f8IUaP0SIspi90+IjyKJ22mO7c1lTZatBekktQVJgHp
xkK4Y47ZxTqq81PicD6VV2DiCUTdZVBlgwbFGyZEnbRRwozc9PSH3SUzblQcQT9q
aob2tZs6kb7l77e78RHj2nVmpvHT4CAACmosHBzCuZB2gOQMXsZukLwu2B+EK5Zj
82K2RP1Fe2JxSdg7D2ev
=BmJJ
-----END PGP SIGNATURE-----

--=-GddbZHlnUccPbOwqhdTe--

