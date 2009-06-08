Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43848 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbZFHKdO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 06:33:14 -0400
Subject: Re: [RFC] rfkill: remove set_global_sw_state()
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Marcel Holtmann <marcel@holtmann.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <4A2CE4A2.2090308@tuffmail.co.uk>
References: <1243885494.3015.29.camel@localhost.localdomain>
	 <4A24559D.7010201@tuffmail.co.uk>
	 <1243928308.3192.38.camel@localhost.localdomain>
	 <1243929706.20064.7.camel@johannes.local>
	 <1243930703.3192.59.camel@localhost.localdomain>
	 <20090603040315.GA10464@khazad-dum.debian.net>
	 <1244008652.4145.7.camel@localhost.localdomain>
	 <20090603213340.GB22809@khazad-dum.debian.net>
	 <1244088806.4145.24.camel@localhost.localdomain>
	 <9b2b86520906070538s7def28f0nb269914e03207228@mail.gmail.com>
	 <20090607125715.GC3340@khazad-dum.debian.net>
	 <1244394963.12956.1.camel@johannes.local> <4A2BF833.1050906@tuffmail.co.uk>
	 <4A2CE4A2.2090308@tuffmail.co.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-76E2e8MC3ZqvVOFIPFGG"
Date: Mon, 08 Jun 2009 12:32:39 +0200
Message-Id: <1244457159.18863.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-76E2e8MC3ZqvVOFIPFGG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-08 at 11:14 +0100, Alan Jenkins wrote:
> rfkill_set_global_sw_state() (previously rfkill_set_default()) will no
> longer be exported by the rewritten rfkill core.
>=20
> Instead, platform drivers which can provide persistent soft-rfkill state
> across power-down/reboot should indicate their initial state by calling
> rfkill_set_sw_state() before registration.  Otherwise, they will be
> initialized to a default value during registration by a set_block call.
>=20
> We remove existing calls to rfkill_set_sw_state() which happen before
> registration, since these had no effect in the old model.  If these
> drivers do have persistent state, the calls can be put back (subject
> to testing :-).  This affects hp-wmi and acer-wmi.

Cool.

> Drivers with persistent state will affect the global state only if
> rfkill-input is enabled.  This is required, otherwise booting with
> wireless soft-blocked and pressing the wireless-toggle key once would
> have no apparent effect.  This special case will be removed in future
> along with rfkill-input, in favour of a more flexible userspace daemon
> (see Documentation/feature-removal-schedule.txt).

How does that work?

> --- a/drivers/platform/x86/acer-wmi.c
> +++ b/drivers/platform/x86/acer-wmi.c

> @@ -996,8 +995,6 @@ static struct rfkill *acer_rfkill_register(struct dev=
ice *dev,
>  				  (void *)(unsigned long)cap);
>  	if (!rfkill_dev)
>  		return ERR_PTR(-ENOMEM);
> -	get_u32(&state, cap);
> -	rfkill_set_sw_state(rfkill_dev, !state);

That does seem persistent, I'd think? get_u32 here hits ACPI iirc.

> diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.=
c
> index 8d93114..16fffe4 100644
> --- a/drivers/platform/x86/hp-wmi.c
> +++ b/drivers/platform/x86/hp-wmi.c
> @@ -422,7 +422,6 @@ static int __init hp_wmi_bios_setup(struct platform_d=
evice *device)
>  					   RFKILL_TYPE_WLAN,
>  					   &hp_wmi_rfkill_ops,
>  					   (void *) 0);
> -		rfkill_set_sw_state(wifi_rfkill, hp_wmi_wifi_state());
>  		err =3D rfkill_register(wifi_rfkill);
>  		if (err)
>  			goto register_wifi_error;
> @@ -433,8 +432,6 @@ static int __init hp_wmi_bios_setup(struct platform_d=
evice *device)
>  						RFKILL_TYPE_BLUETOOTH,
>  						&hp_wmi_rfkill_ops,
>  						(void *) 1);
> -		rfkill_set_sw_state(bluetooth_rfkill,
> -				    hp_wmi_bluetooth_state());
>  		err =3D rfkill_register(bluetooth_rfkill);
>  		if (err)
>  			goto register_bluetooth_error;
> @@ -445,7 +442,6 @@ static int __init hp_wmi_bios_setup(struct platform_d=
evice *device)
>  					   RFKILL_TYPE_WWAN,
>  					   &hp_wmi_rfkill_ops,
>  					   (void *) 2);
> -		rfkill_set_sw_state(wwan_rfkill, hp_wmi_wwan_state());
>  		err =3D rfkill_register(wwan_rfkill);
>  		if (err)
>  			goto register_wwan_err;

Hmm. Anyone know anything about HP? That kinda looks persistent too.

> @@ -1200,8 +1185,20 @@ static int __init tpacpi_new_rfkill(const enum tpa=
cpi_rfk_id id,
>  	atp_rfk->id =3D id;
>  	atp_rfk->ops =3D tp_rfkops;
> =20
> -	rfkill_set_states(atp_rfk->rfkill, initial_sw_state,
> -				tpacpi_rfk_check_hwblock_state());
> +	initial_sw_status =3D (tp_rfkops->get_status)();
> +	if (initial_sw_status < 0) {
> +		printk(TPACPI_ERR
> +			"failed to read initial state for %s, error %d; "
> +			"will turn radio off\n", name, initial_sw_status);

That message seems wrong now, it would not turn off but impose the
current default, I think?

>  /**
> - * rfkill_set_global_sw_state - set global sw block default

There's a static inline in the !RFKILL case, please remove that too.

> @@ -916,7 +885,17 @@ int __must_check rfkill_register(struct rfkill *rfki=
ll)
>  	if (rfkill->ops->poll)
>  		schedule_delayed_work(&rfkill->poll_work,
>  			round_jiffies_relative(POLL_INTERVAL));
> -	schedule_work(&rfkill->sync_work);
> +
> +	if (!rfkill->persistent || rfkill_epo_lock_active) {
> +		schedule_work(&rfkill->sync_work);
> +	} else {
> +#ifdef CONFIG_RFKILL_INPUT
> +		bool soft_blocked =3D !!(rfkill->state & RFKILL_BLOCK_SW);
> +
> +		if (!atomic_read(&rfkill_input_disabled))
> +			__rfkill_switch_all(rfkill->type, soft_blocked);
> +#endif
> +	}

Ah, this is the quirky backward compat code you're talking about. I
guess we need it, although I don't particularly like it.

Looks good except for these few comments!

johannes

--=-76E2e8MC3ZqvVOFIPFGG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKLOjCAAoJEODzc/N7+Qma5KIP/1cjz/X7zjUJkEiKWz+8BuIt
pt20KwmWrUegIMWhA4z82VlOGu4iLpMUIDlzo3TtWwLhm5Dfk4/dYK9izOvDKQjO
8vwpuIeq48LO/Q0XnHzhQjGx6ocbG0J2lBUL4m8a94tyzKj2VMoahBK+lttXFl+8
b88NdoWOMj5pf10v7mw4c3CV6AVET5GAxlkuFEAj5mHWRlyerkl29Rm2JmBwrKl+
yPGEJ+ATNbN9t5dw0Q7okiVxxhEiO7zGtSjIefXF/Ud1rsdNUG9hFP2GJThw2GVx
0ie/EUCqwb7gePeu8fhW/fkRvsiKPVQRoOjWweBUKDbRPyggqL1UO1V9E3ERME4d
Fgxg8jIEyPfen0Nhfolx5WrYUCwYBFJd2ZVpKviYrx9CeDCGY2rZwAsFW79TG6cG
mRG7VvDR9JtZVUOEgMMkeJ0/8aKagEmzYZWTRvGN06xGZlgzA+Net3Xq5wdxsk3X
CuTbTMG5iol/f2839MpVAu+aOwKLqucpI3qE7fak6v3YVmMZ5Ygh5/VC3D1fHV1K
WUdbGhKdWull9kV3ANWc1bILAQjkqIH3HWFZScNQpw03Ye7WeLhqpGnSAoD7/CMP
3e6A+2SJP7PgsgEb4Rfzy0sv3IBw0Q7M1wsxoeU++SbdTxf4LQE3tvnsNayQzAtj
/RVy7dYhfAxxM6VR2Vqe
=ggGs
-----END PGP SIGNATURE-----

--=-76E2e8MC3ZqvVOFIPFGG--

