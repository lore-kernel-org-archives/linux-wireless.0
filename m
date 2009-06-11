Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f216.google.com ([209.85.220.216]:62017 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbZFKP1e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 11:27:34 -0400
Received: by fxm12 with SMTP id 12so51262fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2009 08:27:36 -0700 (PDT)
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211: Do not try to associate with an empty SSID
References: <20090611105411.GA13825@jm.kir.nu>
	<20090611151945.GA17284@jm.kir.nu>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 11 Jun 2009 18:27:29 +0300
In-Reply-To: <20090611151945.GA17284@jm.kir.nu> (Jouni Malinen's message of "Thu\, 11 Jun 2009 18\:19\:45 +0300")
Message-ID: <878wjyyen2.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen <jouni.malinen@atheros.com> writes:

> It looks like some programs (e.g., NM) are setting an empty SSID with
> SIOCSIWESSID in some cases. This seems to trigger mac80211 to try to
> associate with an invalid configuration (wildcard SSID) which will
> result in failing associations (or odd issues, potentially including
> kernel panic with some drivers) if the AP were to actually accept this
> anyway).
>
> Only start association process if the SSID is actually set. This
> speeds up connection with NM in number of cases and avoids sending out
> broken association request frames.
>
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Thanks, I think I have an internal bug report about a similar issue and
I hope this fixes that as well. But I need to investigate to be sure.

> v2: Allow disassociation in ssid_len=0 case and only avoid starting a
> new association. This function is difficult to understand and for now, I
> just want to fix the critical issue here. Eventually, this code should
> be redesigned or at least commented clearly.

Like we have talked earlier in this list, mlme.c requires a rewrite.

-- 
Kalle Valo
