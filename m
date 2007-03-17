Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:51074
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965555AbXCQN73 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 09:59:29 -0400
From: Michael Buesch <mb@bu3sch.de>
To: andy@warmcat.com
Subject: Re: [PATCH 2/2] mac80211: Monitor mode radiotap-based packet injection
Date: Sat, 17 Mar 2007 14:59:21 +0100
Cc: linux-wireless@vger.kernel.org
References: <20070317105800.659633351@warmcat.com> <20070317110751.352850972@warmcat.com>
In-Reply-To: <20070317110751.352850972@warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200703171459.23246.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 17 March 2007 11:58, andy@warmcat.com wrote:
> From: Andy Green <andy@warmcat.com>
> 
> Try #2
>  - took Michael Wu's advice about better tools and basing on wireless-dev
>  - took Luis Rodriguez's advice about coding style makeover
>  - took Pavel Roskin's advice about little-endian radiotap
> 
> Index: linux-2.6.20.i386/include/net/mac80211.h
> ===================================================
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 4fc8edc..bb5777e 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -189,6 +189,7 @@ struct ieee80211_tx_control {
>  #define IEEE80211_TXCTL_FIRST_FRAGMENT	(1<<8) /* this is a first fragment of
>  						* the frame */
>  #define IEEE80211_TXCTL_TKIP_NEW_PHASE1_KEY (1<<9)
> +#define IEEE80211_TXCTL_INJECTED_PACKET (1<<10) /* tx into monitor IF */

What is a driver supposed to do on this flag? More documentation, please.

-- 
Greetings Michael.
