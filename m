Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:38377 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758783AbZASL77 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 06:59:59 -0500
Received: by bwz14 with SMTP id 14so8214009bwz.13
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2009 03:59:57 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/2] iwl3945: fix some warnings when compiled  without debug
Date: Mon, 19 Jan 2009 12:59:34 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <200901190955.04622.helmut.schaa@gmail.com> <1232359746.3758.0.camel@johannes>
In-Reply-To: <1232359746.3758.0.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200901191259.35309.helmut.schaa@gmail.com> (sfid-20090119_130004_726419_AD2559C6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 19. Januar 2009 schrieb Johannes Berg:
> On Mon, 2009-01-19 at 09:55 +0100, Helmut Schaa wrote:
> > Fix the following warnings if compiled without CONFIG_IWLWIFI_DEBUG=
=2E
> >=20
> > drivers/net/wireless/iwlwifi/iwl3945-base.c: In function =E2=80=98i=
wl3945_rx_reply_add_sta=E2=80=99:
> > drivers/net/wireless/iwlwifi/iwl3945-base.c:2748: warning: unused v=
ariable =E2=80=98pkt=E2=80=99
> > drivers/net/wireless/iwlwifi/iwl3945-base.c: In function =E2=80=98i=
wl3945_rx_scan_results_notif=E2=80=99:
> > drivers/net/wireless/iwlwifi/iwl3945-base.c:2903: warning: unused v=
ariable =E2=80=98notif=E2=80=99
> > drivers/net/wireless/iwlwifi/iwl3945-base.c: In function =E2=80=98i=
wl3945_rx_scan_complete_notif=E2=80=99:
> > drivers/net/wireless/iwlwifi/iwl3945-base.c:2928: warning: unused v=
ariable =E2=80=98scan_notif=E2=80=99
> >=20
> > Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> > ---
> > diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/=
net/wireless/iwlwifi/iwl3945-base.c
> > index b437cac..15d36d8 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > @@ -2744,7 +2744,9 @@ static void iwl3945_rx_reply_alive(struct iwl=
_priv *priv,
> >  static void iwl3945_rx_reply_add_sta(struct iwl_priv *priv,
> >  				 struct iwl_rx_mem_buffer *rxb)
> >  {
> > +	#ifdef CONFIG_IWLWIFI_DEBUG
> >  	struct iwl_rx_packet *pkt =3D (void *)rxb->skb->data;
> > +	#endif=20
>=20
> I for one would definitely prefer you didn't indent preprocessor
> statements, but I don't care all that much about iwl3945.

Indeed. My fault. I'll resend this one.

Thanks,
Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
