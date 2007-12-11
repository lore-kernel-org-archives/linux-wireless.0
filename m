Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.250]:63303 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750948AbXLKVKl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2007 16:10:41 -0500
Received: by hs-out-2122.google.com with SMTP id 54so986019hsz
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2007 13:10:40 -0800 (PST)
Message-ID: <b3153e950712111310r7f527068j7997bdceaee3488@mail.gmail.com> (sfid-20071211_211044_648111_43D4FC7C)
Date: Tue, 11 Dec 2007 13:10:38 -0800
From: "mohamed salim abbas" <mabbaswireless@gmail.com>
To: "Stefano Brivio" <stefano.brivio@polimi.it>
Subject: Re: [PATCH 2/4] iwlwifi: Update to changed mac80211 rate control interface
Cc: "Mattias Nissler" <mattias.nissler@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <20071208141953.1233aa30@morte>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1197112439.7472.34.camel@localhost>
	 <1197112911.7472.50.camel@localhost> <20071208141953.1233aa30@morte>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

for any non data frame we should use the lowest rate. the firmware
might not like it if higher rate been used. I just checked out latest
of mac80211 the rate scaling functions have not changed with this
patch it wont work.
Mohamed

On 12/8/07, Stefano Brivio <stefano.brivio@polimi.it> wrote:
> On Sat, 08 Dec 2007 12:21:51 +0100
> Mattias Nissler <mattias.nissler@gmx.de> wrote:
>
> > This brings iwlwifi rate control code back in sync with mac80211.
> >
> > Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
>
> It doesn't apply:
>
> > @@ -674,32 +657,19 @@ static struct ieee80211_rate *rs_get_rate(void *priv_rate,
> >       struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
>
> struct ieee80211_conf *conf = &local->hw.conf;
>
> >       struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
>
>
> --
> Ciao
> Stefano
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
