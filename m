Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41502 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753680AbZB0KTO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 05:19:14 -0500
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Fri, 27 Feb 2009 11:19:11 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <18855.45396.45156.609477@gargle.gargle.HOWL>
Message-ID: <20090227101911.291200@gmx.net> (sfid-20090227_111916_230380_2819D597)
MIME-Version: 1.0
References: <18855.26210.618690.891378@gargle.gargle.HOWL>
	<20090227082545.291220@gmx.net>	<20090227090140.291190@gmx.net>
 <18855.45396.45156.609477@gargle.gargle.HOWL>
Subject: Re: IBSS issues
To: Sujith <Sujith.Manoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sujith!

> Yep, that is the problem. But that chunk of code (and the bug) has be=
en
> there forever,
> so am not sure why it is creating a problem now.

Maybe because the scanning code was changed? But I have discovered this=
 bug at the end of the last year before the scanning code was changed t=
he last time.

> And it can be fixed by
> making use of the scan start/stop mac80211 callbacks.

I think a much cleaner way would be if the ath9k_hw_write_associd() hon=
or the FIF_BCN_PRBRESP_PROMISC flag and determine with it if sc->curbss=
id should be set or ath_bcast_mac. So the the old sc->curbssid setting =
is saved. And then remove the following code...

if (*total_flags & FIF_BCN_PRBRESP_PROMISC) {
        memcpy(sc->curbssid, ath_bcast_mac, ETH_ALEN);
        sc->curaid =3D 0;

=2E..so that ath9k_hw_write_associd() is called if the FIF_BCN_PRBRESP_=
PROMISC is cleared at the end of the scanning, too. So that it can set =
the BSSID in the hardware back to sc->curbssid.

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
