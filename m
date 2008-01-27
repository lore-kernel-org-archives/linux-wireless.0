Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp114.sbc.mail.mud.yahoo.com ([68.142.198.213]:37215 "HELO
	smtp114.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752039AbYA0Q36 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2008 11:29:58 -0500
From: David Brownell <david-b@pacbell.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH 12/14] [rndis_host] Add RNDIS physical medium checking into generic_rndis_bind()
Date: Sun, 27 Jan 2008 08:29:53 -0800
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	bjd@jooz.net
References: <20080125225032.11716.77713.stgit@fate.lan> <20080125225139.11716.91641.stgit@fate.lan>
In-Reply-To: <20080125225139.11716.91641.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200801270829.53470.david-b@pacbell.net> (sfid-20080127_163032_273159_F0DAD3E7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 25 January 2008, Jussi Kivilinna wrote:
> +=A0=A0=A0=A0=A0=A0=A0if(flags & FLAG_RNDIS_PHYM_WIRELESS &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
*phym !=3D RNDIS_PHYSICAL_MEDIUM_WIRELESS_LAN) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dev_err(&intf->dev, "dr=
iver requires wireless physical "
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"medium, but device is =
not.\n");
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0retval =3D -ENODEV;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto halt_fail_and_rele=
ase;
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0if(flags & FLAG_RNDIS_PHYM_NOT_WIRELESS &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
*phym =3D=3D RNDIS_PHYSICAL_MEDIUM_WIRELESS_LAN) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dev_err(&intf->dev, "dr=
iver requires non-wireless physical "
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"medium, but device is =
wireless.\n");
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0retval =3D -ENODEV;

Well, other than the obvious checkpatch.pl warnings waiting to trigger
("if" is not a function; put a space before the paren) and what I'd cal=
l
missing parens around the "flags & ...", those are *not* errors.  No
wonder you thought this would cause too many messages!!

Just make those be dev_dbg() calls instead.  The strongest message leve=
l
you can argue for there would be KERN_NOTICE, "normal but significant";
except it's not especially significant.  Filtering by netif_msg_probe()
may be a good idea too; that's normally enabled in this framework.

- Dave

p.s. Before these get submitted, *all* of them need to pass "checkpatch=
=2Epl".
  Ideally, "checkpatch.pl --strict" ...


-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
