Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41106 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751916AbZB0IZt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 03:25:49 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Fri, 27 Feb 2009 09:25:45 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <18855.26210.618690.891378@gargle.gargle.HOWL>
Message-ID: <20090227082545.291220@gmx.net> (sfid-20090227_092552_501093_BAB3359A)
MIME-Version: 1.0
References: <18855.26210.618690.891378@gargle.gargle.HOWL>
Subject: Re: IBSS issues
To: Sujith <Sujith.Manoharan@atheros.com>,
	linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sujith!

> I am seeing some strange behavior in IBSS mode with current
> wireless-testing.
>=20
> Scenario:
>=20
>  * Create a new cell using ath9k.
>  * Wait for a while to do a background merge scan run.
>  * Join the cell from another peer ( say, using ath5k ).
>  * Station dump in peer1 1 doesn't show the new peer right away.
>  * The merge runs are not supposed to happen if a cell has more than =
one
> peer.
>    It didn't happen before, but it keeps running repeatedly now.
>  * Ping from peer2 to peer1 doesn't go through - peer1 to peer2 works
> though.

The strange thing is after the ping from peer1 to peer2, the ping from =
peer2 to peer1 works too. The same is if I start tcpdump on peer1. Afte=
r stopping tcpdump it keeps working. Looking...

> I identified one bug, where the timestamp in the beacon template was =
not
> updated.
> Patch below. But it doesn't fix the issue.

The TSF of the beacon is setted by the hardware automatically, so to wr=
ite it in the template is not needed.

Regards
Alina

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger01
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
