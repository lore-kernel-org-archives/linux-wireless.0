Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55579 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760524AbXLUMJv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2007 07:09:51 -0500
From: Andreas Schwab <schwab@suse.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] mac80211: remove useless sdata variable
References: <1198195385.16241.68.camel@johannes.berg>
Date: Fri, 21 Dec 2007 13:09:49 +0100
In-Reply-To: <1198195385.16241.68.camel@johannes.berg> (Johannes Berg's
	message of "Fri\, 21 Dec 2007 01\:03\:05 +0100")
Message-ID: <je63ysp7ua.fsf@sykes.suse.de> (sfid-20071221_121012_286000_386B63BC)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Dunno why I slipped that variable in...

Perhaps because it is used?

> --- everything.orig/net/mac80211/ieee80211_sta.c	2007-12-21 01:02:11.=
253160428 +0100
> +++ everything/net/mac80211/ieee80211_sta.c	2007-12-21 01:02:32.11316=
5907 +0100
> @@ -458,12 +458,10 @@ static void ieee80211_set_associated(str
>  		return;
> =20
>  	if (assoc) {
> -		struct ieee80211_sub_if_data *sdata;
>  		struct ieee80211_sta_bss *bss;
> =20
>  		ifsta->flags |=3D IEEE80211_STA_ASSOCIATED;
> =20
> -		sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
>  		if (sdata->vif.type !=3D IEEE80211_IF_TYPE_STA)
                    ^^^^^

Andreas.

--=20
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstra=DFe 5, 90409 N=FCrnberg, Germany
PGP key fingerprint =3D 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4=
ED5
"And now for something completely different."
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
