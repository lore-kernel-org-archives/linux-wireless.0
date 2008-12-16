Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:44631 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbYLPRd3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 12:33:29 -0500
Received: by wf-out-1314.google.com with SMTP id 27so3315212wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 16 Dec 2008 09:33:27 -0800 (PST)
Message-ID: <b6c5339f0812160933q1670f646iab25dff161450ef9@mail.gmail.com> (sfid-20081216_183334_499445_930EC5D9)
Date: Tue, 16 Dec 2008 12:33:27 -0500
From: "Bob Copeland" <bcopeland@gmail.com>
To: "Krzysztof Halasa" <khc@pm.waw.pl>
Subject: Re: ath5k + AP mode?
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <m3skopuq6t.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <m3skopuq6t.fsf@maximus.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 15, 2008 at 3:41 PM, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> Hi,
>
> Is AP mode with ath5k supposed to work?

I think it needs some love from interested parties...

>        hw->wiphy->interface_modes =
>                BIT(NL80211_IFTYPE_STATION) |
> +               BIT(NL80211_IFTYPE_AP) |
>                BIT(NL80211_IFTYPE_ADHOC) |
>                BIT(NL80211_IFTYPE_MESH_POINT);

Definitely needed.

> Failed to set interface wlan0 to master mode.
> nl80211 driver initialization failed.
> wlan0: Unable to setup interface.

It's probably worth taking a look at hostapd to see what exactly is failing.
We should be able to create an IFTYPE_AP interface with your above patch
applied.  No telling whether the rest works.

-- 
Bob Copeland %% www.bobcopeland.com
