Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43546 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab1JKRVA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 13:21:00 -0400
Received: by ggnv2 with SMTP id v2so5917393ggn.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 10:20:59 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: Re: [PATCH 1/2] mac80211: Build TX radiotap header dynamically
Date: Tue, 11 Oct 2011 19:19:02 +0200
Message-ID: <3634905.slyix8Dz5L@helmutmobil.site> (sfid-20111011_192104_132195_B8AB4D28)
In-Reply-To: <1318350345.3965.11.camel@jlt3.sipsolutions.net>
References: <1318349335-22514-1-git-send-email-helmut.schaa@googlemail.com> <1318350345.3965.11.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 11. Oktober 2011, 18:25:45 schrieb Johannes Berg:
> On Tue, 2011-10-11 at 18:08 +0200, Helmut Schaa wrote:
> Since there's no over-all memset I think you need to clear the padding
> explicitly now.

Like this one? :)

> +	rthdr = (struct ieee80211_radiotap_header *) skb_push(skb, rtap_len);
> +
> +	memset(rthdr, 0, rtap_len);

Helmut
