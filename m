Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n1.bullet.mail.re3.yahoo.com ([68.142.237.108]:33345 "HELO
	n1.bullet.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752143AbYLHN43 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 08:56:29 -0500
Date: Mon, 8 Dec 2008 05:56:28 -0800 (PST)
From: Igor Trindade Oliveira <igor_trindade@yahoo.com.br>
Reply-To: igor_trindade@yahoo.com.br
Subject: Re: [PATCH] mac80211_hwsim: configfs support
To: Jouni Malinen <j@w1.fi>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <20081208130536.GA6026@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <773281.43301.qm@web59306.mail.re1.yahoo.com> (sfid-20081208_145634_864431_8452E4D0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>




--- Em seg, 8/12/08, Jouni Malinen <j@w1.fi> escreveu:

> De: Jouni Malinen <j@w1.fi>
> Assunto: Re: [PATCH] mac80211_hwsim: configfs support
> Para: "Igor Trindade Oliveira" <igor_trindade@yahoo.com.br>
> Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org, linvil=
le@tuxdriver.com
> Data: Segunda-feira, 8 de Dezembro de 2008, 11:05
> On Fri, Dec 05, 2008 at 01:37:48PM -0800, Igor Trindade
> Oliveira wrote:
>=20
> > Mac80211_hwsim: Support to configfs operations for
> create a new radio
>=20
> The change in general looks reasonable, but I have couple
> of comments
> about the details.
>=20
> Could you please also update
> Documentation/networking/mac80211_hwsim/
> README to replace the kernel module parameter with
> description on how to
> add virtual radios?
Ok i will go to do that.

>=20
> > +++
> wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2008-12-02
> 06:21:56.000000000 -0400
> > @@ -140,10 +138,15 @@ struct mac80211_hwsim_data {
> >  		PS_DISABLED, PS_ENABLED, PS_AUTO_POLL,
> PS_MANUAL_POLL
> >  	} ps;
> >  	bool ps_poll_pending;
> > -	struct dentry *debugfs;
> > -	struct dentry *debugfs_ps;
> > +	struct config_item item;
> >  };
> > =20
> > +struct mac80211_hwsim_attr {
> > +	struct configfs_attribute attr;
> > +	 ssize_t(*show) (struct mac80211_hwsim_data *hwsim,
> char *buf);
> > +	 ssize_t(*store) (struct mac80211_hwsim_data *hwsim,
> > +			  const char *buf, ssize_t count);
>=20
> There is extra space (<TAB><SPACE>ssize_t) in
> indentation here. As far
> as function pointer style is concerned, my preference would
> be to move
> the space to be before the variable name: ssize_t
> (*show)(struct..).
>=20
> > +static struct configfs_atribbute
> *mac80211_hwsim_attrs[] =3D {
>=20
> Has this been even compile tested? I would assume no, since
> that struct
> name has two typos in it..
>=20
> > +/*
> > + * now we just have one attribute with this function
> we can
> > + * add new attributes in mac80211_hwsim_attrs and do
> not change
> > + * others parts of the code
> > + */
>=20
> Is that comment specific to this function or is it just
> description of
> what the change in whole is doing? Is it describing the
> change, it
> should be in commit message, not in the source code. If it
> describe this
> particular function, I would suggest somewhat different
> wording to make
> that cleaner. It could also be moved above
> mac80211_hwsim_attrs
> initialization if it is describing how new attributes are
> added.
It's a comment to describing what we need to do for add new attributes.

>=20
> > @@ -875,3 +993,4 @@ static void __exit
> exit_mac80211_hwsim(v
> > =20
> >  module_init(init_mac80211_hwsim);
> >  module_exit(exit_mac80211_hwsim);
> > +
>=20
> Please don't add unnecessary (and unwanted) whitespace
> changes.
>=20

Ok. i will to go to fix that.
> --=20
> Jouni Malinen                                          =20
> PGP id EFC895FA
> --
> To unsubscribe from this list: send the line
> "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=20
> http://vger.kernel.org/majordomo-info.html

cheers,

igor


      Veja quais s=E3o os assuntos do momento no Yahoo! +Buscados
http://br.maisbuscados.yahoo.com

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
