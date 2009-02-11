Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:2168 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbZBKVtE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 16:49:04 -0500
Received: by yx-out-2324.google.com with SMTP id 8so220130yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 13:49:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090210131418.9c3408a9.rumi_ml@rtfm.hu>
References: <20081112224810.8d4ca179.rumi_ml@rtfm.hu>
	 <1226530010.15173.0.camel@dv>
	 <20081113004632.d8d821c5.rumi_ml@rtfm.hu>
	 <20081113181155.c556bde1.rumi_ml@rtfm.hu>
	 <1226598550.5839.3.camel@johannes.berg>
	 <20081113235928.3ed79ff6.rumi_ml@rtfm.hu>
	 <40f31dec0811131507x7449112cy5746d28c848a2146@mail.gmail.com>
	 <20081114111559.56530874.rumi_ml@rtfm.hu>
	 <20090210131418.9c3408a9.rumi_ml@rtfm.hu>
Date: Wed, 11 Feb 2009 23:49:01 +0200
Message-ID: <40f31dec0902111349q222bce42y50345dafe244b267@mail.gmail.com> (sfid-20090211_224909_409512_780CAE2B)
Subject: Re: ath5k master (AP) mode
From: Nick Kossifidis <mickflemm@gmail.com>
To: RUMI Szabolcs <rumi_ml@rtfm.hu>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Pavel Roskin <proski@gnu.org>,
	Matteo Brusa <matteo.brusa@kaasa.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/2/10 RUMI Szabolcs <rumi_ml@rtfm.hu>:
> Hello Everyone!
>
> To put it simple: IT WORKS! :)
>
> The recipe:
>
> wireless-testing-git pull from earlier today with the only
> modification being this:
>
> -----8<----------------------------------------
>
> --- wireless-testing/drivers/net/wireless/ath5k/base.c      2009-02-10 06:11:43.186470883 +0100
> +++ wireless-testing/drivers/net/wireless/ath5k/base.c.old       2008-11-14 09:36:40.000000000 +0100
> @@ -522,6 +501,7 @@
>        hw->wiphy->interface_modes =
>                BIT(NL80211_IFTYPE_STATION) |
>                BIT(NL80211_IFTYPE_ADHOC) |
> +               BIT(NL80211_IFTYPE_AP) |
>                BIT(NL80211_IFTYPE_MESH_POINT);
>
>        hw->extra_tx_headroom = 2;
>
> -----8<----------------------------------------
>
> Otherwise hostapd-0.6.7, nothing special on the userland.
>
> In detail:
>
> - Open System mode works with Tx fluctuating between 4-6 Mbps
> and Rx between 10-14 Mbps regardless of the distance or signal
> strength. It was tested standing 1m away from the AP antenna
> (signal 100/100) up to 15m away with several thick walls in
> between (signal 60/100) but throughput figures remained the
> same.
>
> - MAC address filtering does work. It probably always did,
> I think I've just messed up the configuration the last time
> and that was the reason back then, sorry.
>
> - WEP mode does not work, apparently the driver does not allow
> setting it and hostapd is exiting on that error.
>
> - WPA and WPA2 have been tested and they seem to be working!
>
> A small hint is that the WPA pre-shared key should be given
> in hex both for hostapd and on the clients, otherwise there can
> be differences in translation from ASCII to hex which in turn
> may lead to an authentication failure.
>
> I've tried to push some 100 MBs through the link in both directions
> both with WPA/WPA2 turned off and then on and it seems to be rock
> solid so far. CPU usage both on the AP host and the client is
> negligible in any case, the throughput isn't affected by turning
> on WPA/WPA2 either.
>
> Thank you all!
>
> Best regards,
> Sab
>

The only reason we haven't enabled AP support yet is that it didn't
work on some devices and we need to make more tests to be sure that
it's ok.


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
