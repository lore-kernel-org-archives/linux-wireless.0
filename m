Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:63310 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbZJMWeR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 18:34:17 -0400
Received: by iwn10 with SMTP id 10so3040787iwn.4
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2009 15:33:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20091013173313.13021.80289.stgit@tikku>
References: <20091013173313.13021.80289.stgit@tikku>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 14 Oct 2009 08:33:21 +1000
Message-ID: <646765f40910131533hccd7403jf3e4a66074dd7143@mail.gmail.com>
Subject: Re: [PATCH 1/2] mac80211: add ieee80211_rx_ni()
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 14, 2009 at 03:33, Kalle Valo <kalle.valo@iki.fi> wrote:
> From: Kalle Valo <kalle.valo@nokia.com>
>
> ieee80211_rx() must be called with bottom halves disabled. To simplify
> driver development implement ieee80211_rx_ni() which disables BH. This
> function must be used when in process context.
>
> Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
> ---
>
>  include/net/mac80211.h |   32 ++++++++++++++++++++++++++------
>  1 files changed, 26 insertions(+), 6 deletions(-)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index c75b960..c42c4a8 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1665,11 +1665,11 @@ void ieee80211_restart_hw(struct ieee80211_hw *hw);
>  * header if %RX_FLAG_RADIOTAP is set in the @status flags.
>  *
>  * This function may not be called in IRQ context. Calls to this function
> - * for a single hardware must be synchronized against each other. Calls
> - * to this function and ieee80211_rx_irqsafe() may not be mixed for a
> - * single hardware.
> + * for a single hardware must be synchronized against each other. Calls to
> + * this function, ieee80211_rx_ni() and ieee80211_rx_irqsafe() may not be
> + * mixed for a single hardware.

[snip]

> - * Calls to this function and ieee80211_rx() may not be mixed for a
> - * single hardware.
> + * Calls to this function, ieee80211_rx() or ieee80211_rx_ni() may not
> + * be mixed for a single hardware.

You missed out ieee80211_rx_irqsafe() here.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
