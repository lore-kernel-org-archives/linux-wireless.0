Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56680 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750959AbXLWMTy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2007 07:19:54 -0500
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Content-Type: text/plain; charset=iso-8859-1
Date: Sun, 23 Dec 2007 13:19:51 +0100
From: "Mattias Nissler" <Mattias.Nissler@gmx.de>
In-Reply-To: <20071223131135.391cc0bb@morte>
Message-ID: <20071223121951.39030@gmx.net> (sfid-20071223_121957_800643_0F46084B)
MIME-Version: 1.0
References: <20071223033633.710907923@polimi.it>
	<20071223043917.7ec437e9@morte>	<20071223120124.39050@gmx.net>
 <20071223131135.391cc0bb@morte>
To: Stefano Brivio <stefano.brivio@polimi.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey,

I'm a little late on this and away from my development machine anyway, =
but when reading my email, I noticed the following and thought this is =
important enough to point out, even though I only have that crappy webm=
ailer and the only kernel tree I can look at is wireless-2.6/everything=
 on git.kernel.org

In rc80211_pid.h, you have the following (this from the wireless-2.6 tr=
ee):

        /* Sampling period for measuring percentage of failed frames. *=
/
        #define RC_PID_INTERVAL (HZ / 8)

But rc80211_pid_algo.c says:

        period =3D (HZ * pinfo->sampling_period + 500) / 1000;
        if (!period)
                period =3D 1;

You see this is completely bogus. My original patch had:

        /* Sampling period for measuring percentage of failed frames in=
 0.001s. */
        #define RC_PID_INTERVAL 1000

You see why what you posted and John commited is bogus?

I'm getting a little fed up with this, you keep screwing up the code wi=
th my name on it *sigh*

And again, I still don't think guarding against period =3D=3D 0 is the =
right thing to do. As I explained privately in IRC, we should make sure=
 the sample_interval is larger than HZ when setting the sample_interval=
 variable  (once nl80211 is done). It doesn't make sense to do this che=
ck every time we execute the code when we can do it once in advance.

Sigh.

Mattias
--=20
Der GMX SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!=20
Ideal f=FCr Modem und ISDN: http://www.gmx.net/de/go/smartsurfer
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
