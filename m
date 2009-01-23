Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42965 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757615AbZAWXQM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 18:16:12 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Sat, 24 Jan 2009 00:16:10 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <20090123122921.GA2745@sortiz.org>
Message-ID: <20090123231610.50410@gmx.net> (sfid-20090124_001617_436761_FCD66EBE)
MIME-Version: 1.0
References: <4979269F.1060500@lwfinger.net>
 <20090123021413.GB3177@tuxdriver.com> <4979567D.2020005@lwfinger.net>
 <20090123071345.270730@gmx.net> <20090123122921.GA2745@sortiz.org>
Subject: Re: Regression caused by commit
	e32b1b9a33759e8a83ac566c4c43f23ed5d6343b
To: kalle.valo@iki.fi, maximlevitsky@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Larry.Finger@lwfinger.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Samuel!

> I dont think we should ignore the if_config() return value.

I can write a warning in the kernel log, to help the low-level driver d=
evelopers to debug this problem, but I don't want to stop the new mergi=
ng process, so that the driver hangs in a mostly undefined state.

> Is the 4965 error code sent when trying to set a fixed BSSID in IBSS =
?
> I dont see it in STA mode, when associating to my AP.

I unfortunately don't know the error code, because I don't have the car=
d, but I think if the setting of the BSSID fails here, I should work in=
 the new initiated normal joining process, even in broken low-level dri=
vers.

Regards
Alina

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
