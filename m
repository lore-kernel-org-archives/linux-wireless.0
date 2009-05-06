Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:36211 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbZEFQgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2009 12:36:14 -0400
Received: by yx-out-2324.google.com with SMTP id 3so116618yxj.1
        for <linux-wireless@vger.kernel.org>; Wed, 06 May 2009 09:36:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1241626486.30590.13.camel@mj>
References: <1241626486.30590.13.camel@mj>
Date: Wed, 6 May 2009 12:36:13 -0400
Message-ID: <b6c5339f0905060936u37f3994cx97cc2344224777a5@mail.gmail.com>
Subject: Re: [ath5k-devel] ath5k: scanning while transmitting causes oops on
	802.11a capable card
From: Bob Copeland <me@bobcopeland.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 6, 2009 at 12:14 PM, Pavel Roskin <proski@gnu.org> wrote:
> Hello!
>
> If I scan by "iw dev wlan0 scan" while sending data through the
> interface, I get a BUG in net/mac80211/tx.c:

Agreed... Also I think the same thing happens for rx for ath5k,
explaining the 'unknown rate index' warnings (sc->curband changes
during scan but we process a beacon from 2ghz band, that one at
least just needs some synchronization in the driver).

> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* RC is busted */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (WARN_ON_ONCE(info->control.rates[i=
].idx >=3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sband=
->n_bitrates)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0info->control.rates[i]=
=2Eidx =3D -1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}

I had a patch here to return rate_lowest_index().  But it still
crashed eventually.

> =A0 =A0 =A0 =A0rate =3D ieee80211_get_tx_rate(sc->hw, info);
> + =A0 =A0 =A0 if (!rate)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;

There are a few more rates here for MRR and RTS/CTS etc.

--=20
Bob Copeland %% www.bobcopeland.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
