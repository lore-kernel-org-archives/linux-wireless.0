Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44791 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbZD3IyP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 04:54:15 -0400
Subject: Re: [RFC v6] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>,
	Matthew Garrett <mjg@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20090430031903.GD18827@khazad-dum.debian.net>
References: <1238349195.24972.5.camel@johannes.local>
	 <1239745712.4205.17.camel@johannes.local>
	 <1239750483.4205.28.camel@johannes.local>
	 <20090430031903.GD18827@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-eAIrBz7WQojCx97DDBi1"
Date: Thu, 30 Apr 2009 10:53:41 +0200
Message-Id: <1241081621.27613.14.camel@johannes.local> (sfid-20090430_105421_358776_872FFE73)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eAIrBz7WQojCx97DDBi1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 2009-04-30 at 00:19 -0300, Henrique de Moraes Holschuh wrote:
> I am halfway on the thinkpad-acpi conversion. It is going slow because
> I have to cleanup the entire thing to have the code look even remotely
> sane now that HW and SW states are to be tracked separately by the
> backend driver, and I lost the RFKILL_STATE_* stuff.

Hmm. I didn't think it was that much of a problem for the other drivers
at least.

> Anyway, in the process (using v7 of the patch, taken from the URL you
> posted sometime ago), I noticed this:
>=20
> The return values for rfkill_alloc() are not the same on the stub and
> real functions.  The stub function uses ERR_PTR, while the real
> function uses NULL for any errors.   Please make them do the same
> thing, and it is probably a damn good idea to document in the
> kerneldoc what kind of return values one should expect when you return
> a pointer and the function can fail (i.e. NULL or ERR_PTR).

Oops, yes, will fix that. I think I intended to use ERR_PTR but then
thought it was too much of an API change. Don't really remember though.

> Also, I have a question: are hooks ever called in atomic/interrupt
> context?  Just about every ACPI and I2C driver needs to sleep to do
> their magic, so I sure hope the answer is "no", otherwise life
> suddenly got a whole lot more complicated for thinkpad-acpi..

The answer is "no" unless there's a bug, this didn't really change,
they're called only from the input handler.

> Also, due to races, it is _impossible_ to assure the backend driver
> that the set_block hook will never be called when the radio is
> hard-blocked.  Best to change the description of that hook to make it
> clear that it could happen, but that the rfkill core will try to
> optimize away such changes.  Here's the race:
>=20
>            A                                  B
> rfkill_set_block
>     saves state in "prev"
>     ...                            rfkill_set_hw_state(true)
>     call set_block hook
>       but radio IS hard-blocked
>       and the core WAS informed
>       of this

Good point. I wonder what's more important -- it would be almost trivial
to change this by using a spinlock instead of atomic bit operations.

> Also, it looks like the SW state rollback done by rfkill_set_block can
> sw-unblock a radio when it shouldn't on races very similar as the one
> above, but involving sw-blocking.
>=20
> I don't see a way to do safe state rollback in a lockless rfkill core
> if set_sw_state can happen at any time.  Please enlighten me if I am
> wrong (and I hope I am) :-(
>=20
> If I am not wrong, one could change rfkill_set_sw_state and
> rfkill_set_states to return an error if rfkill_set_block is on the way
> (that can be done lockless).  For rfkill_set_states, document that the
> hw state WILL be updated regardless, but that the sw state might not
> be.
>=20
> Or one could kick the problem to the backend driver (which will have
> any required locking anyway), by giving the set_block hook the duty of
> calling set_sw_state when it succeeds.  The return status might be
> kept should we ever start passing it down to other layers like
> userspace, or you can remove it.

Thanks for your analysis. It does seem like a problem, and even locking
in rfkill can't really avoid the problem [1]. However, why would we
require the driver to postpone that? Your idea is sound, but I think we
can do it in the core. It might require a spinlock there, but that's
acceptable, I didn't use atomic operations to make it faster but to make
it simpler.

 * rfkill_set_block can set a flag "I'm in an update"
 * a concurrent rfkill_set_sw_state will check that flag, and update the
   "prev" variable instead of the real variable
 * on errors, rfkill_set_block will then revert to whatever the last
   set_sw_state said

That way, if the driver returns an error from ops->set_block, we will
really revert to what the driver last told us with set_sw_state. It
would seem to get this prev/in-update handling correct we need to add a
spinlock, but concurrent rfkill_set_block()s are already prevented by
the mutex so no additional locking would be needed there.

Does that sound correct/acceptable?

johannes

[1] unless we want to use a mutex or require ops->set_block to be atomic
but then we can't really do either


--=-eAIrBz7WQojCx97DDBi1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ+WcSAAoJEKVg1VMiehFYLE0QAKBJvHZQaKbX/cmRKb+Nuk+l
sG9N/G4k+f/azF8SwGpcaZ+6DdTMfPUn1FbhqO63lw6daV7Te98+2Js5xmjWfDT/
yLgBUkeBpQxZfENKUdufbz7KyEJrPauljE1B+gPATEPobTqTBpHQCvolT46TVPmb
7ThnV/h9ADFYrVqT57zznQBuWuR6UqRJheGH7nOby3ojhxoAl/7TFvPNYugD3FXU
9KECmLAp2LsVsVAqD0OlkvdCni+kJjzwNw7ER1Mqmn2sBmRGzEYFc9ZabVV1jmMh
44VyaQU2u+WNMi4L8N1+NbwNXvjTD5E9pF6S7dmMIZYXFmXydQBe0GaNWUsc/y0r
ho67zyq+zLbeW8MQt1FHhJp6loaVMnJMS3Slv5py9FnveNRumAym4mIkNx8onYMS
JeD6UdSeehSl5zXp/0kK9WwYxfGrPrFUvhC3IBx0Mg6XE9OUTG5f4lY2SwnIoS4h
g5382xwsn1jDnn46/gg0Mqur/WRlwj5NpMDHOLPLG3j4bZfMoVwbw4tnVvZZp2UX
PNL0ixZ8WV4yZ9YAvOWpFCL5kIR7i3xAUq3Ki+WvCrz51/o575K3TuRSJW1JhldN
LuhqMov/NyqoRoiGuFF9LF/Lmf8HCL/fKgSsw8Zot6wHCAH1K05pwVckk8LmAC12
+Xkk7lnUsF3wG1A1TDHP
=k3b0
-----END PGP SIGNATURE-----

--=-eAIrBz7WQojCx97DDBi1--

