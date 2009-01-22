Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:8789 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbZAVKow convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 05:44:52 -0500
Received: by fk-out-0910.google.com with SMTP id f33so648847fkf.5
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 02:44:50 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/2] iwl3945: Remove unused variables
Date: Thu, 22 Jan 2009 11:44:27 +0100
Cc: linux-wireless@vger.kernel.org
References: <200901190955.32818.helmut.schaa@gmail.com> <20090121192329.GB14710@tuxdriver.com>
In-Reply-To: <20090121192329.GB14710@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200901221144.27380.helmut.schaa@gmail.com> (sfid-20090122_114504_169211_A5BDDC31)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, 21. Januar 2009 schrieb John W. Linville:
> On Mon, Jan 19, 2009 at 09:55:32AM +0100, Helmut Schaa wrote:
> > Fix the following warnings in iwl-3945-rs.c by removing unused vari=
ables.
> >=20
> > drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function =E2=80=98iw=
l3945_rate_scale_flush_windows=E2=80=99:
> > drivers/net/wireless/iwlwifi/iwl-3945-rs.c:186: warning: unused var=
iable =E2=80=98priv=E2=80=99
> > drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function =E2=80=98iw=
l3945_bg_rate_scale_flush=E2=80=99:
> > drivers/net/wireless/iwlwifi/iwl-3945-rs.c:219: warning: unused var=
iable =E2=80=98priv=E2=80=99
> > drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function =E2=80=98iw=
l3945_collect_tx_data=E2=80=99:
> > drivers/net/wireless/iwlwifi/iwl-3945-rs.c:293: warning: unused var=
iable =E2=80=98priv=E2=80=99
> > drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function =E2=80=98rs=
_free_sta=E2=80=99:
> > drivers/net/wireless/iwlwifi/iwl-3945-rs.c:441: warning: unused var=
iable =E2=80=98priv=E2=80=99
> > drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function =E2=80=98iw=
l3945_get_adjacent_rate=E2=80=99:
> > drivers/net/wireless/iwlwifi/iwl-3945-rs.c:559: warning: unused var=
iable =E2=80=98priv=E2=80=99
> >=20
> > Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
>=20
> With this applied, I get these:
>=20
>   CC [M]  drivers/net/wireless/iwlwifi/iwl-3945-rs.o
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function =E2=80=98iwl3=
945_rate_scale_flush_windows=E2=80=99:
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c:199: error: =E2=80=98priv=E2=
=80=99 undeclared (first use in this function)
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c:199: error: (Each undeclar=
ed identifier is reported only once
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c:199: error: for each funct=
ion it appears in.)
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function =E2=80=98iwl3=
945_bg_rate_scale_flush=E2=80=99:
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c:222: error: =E2=80=98priv=E2=
=80=99 undeclared (first use in this function)
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function =E2=80=98iwl3=
945_collect_tx_data=E2=80=99:
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c:293: error: =E2=80=98priv=E2=
=80=99 undeclared (first use in this function)
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function =E2=80=98rs_f=
ree_sta=E2=80=99:
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c:441: error: =E2=80=98priv=E2=
=80=99 undeclared (first use in this function)
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function =E2=80=98iwl3=
945_get_adjacent_rate=E2=80=99:
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c:594: error: =E2=80=98priv=E2=
=80=99 undeclared (first use in this function)
> make[2]: *** [drivers/net/wireless/iwlwifi/iwl-3945-rs.o] Error 1
> make[1]: *** [drivers/net/wireless/iwlwifi] Error 2
> make: *** [drivers/net/wireless/] Error 2
>=20
> Dropping...

Ah, sorry for that. I compiled without CONFIG_IWL_DEBUG. Instead of rem=
oving
these lines they should be surrounded by an CONFIG_IWL_DEBUG check. I'l=
l send
that soon.

Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
