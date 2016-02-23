Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59164 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbcBWKKw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 05:10:52 -0500
Message-ID: <1456222250.2041.8.camel@sipsolutions.net> (sfid-20160223_111057_162167_1CB1E757)
Subject: Re: [PATCH v2 2/2] mac80211: parse VHT info in injected frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 23 Feb 2016 11:10:50 +0100
In-Reply-To: <1455878585-5525-3-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20160219_114311_450464_CF0925C0)
References: <1455878585-5525-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1455878585-5525-3-git-send-email-lorenzo.bianconi83@gmail.com>
	 (sfid-20160219_114311_450464_CF0925C0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-02-19 at 11:43 +0100, Lorenzo Bianconi wrote:
> Add VHT radiotap parsing support to ieee80211_parse_tx_radiotap().
> That capability has been tested using a d-link dir-860l rev b1
> running
> OpenWrt trunk and mt76 driver
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
> ---
>  Documentation/networking/mac80211-injection.txt | 10 ++++++++
>  net/mac80211/tx.c                               | 31
> +++++++++++++++++++++++++
>  2 files changed, 41 insertions(+)
> 
> diff --git a/Documentation/networking/mac80211-injection.txt
> b/Documentation/networking/mac80211-injection.txt
> index ec8f934..ef57cc0 100644
> --- a/Documentation/networking/mac80211-injection.txt
> +++ b/Documentation/networking/mac80211-injection.txt
> @@ -45,6 +45,16 @@ radiotap headers and used to control injection:
>     number of retries when either IEEE80211_RADIOTAP_RATE or
>     IEEE80211_RADIOTAP_MCS was used
>  
> + * IEEE80211_RADIOTAP_VHT
> +
> +   VHT rate for the transmission (only for devices without own rate
> control).
> +   Also some flags are parsed
> +
> +   IEEE80211_TX_RC_SHORT_GI: use short guard interval
> +   IEEE80211_TX_RC_40_MHZ_WIDTH: send in HT40 mode
> +   IEEE80211_TX_RC_80_MHZ_WIDTH: send in HT80 mode
> +   IEEE80211_TX_RC_160_MHZ_WIDTH: send in HT160 mode
> 
This makes no sense, those are mac80211 internal flags, should document
the radiotap flags here, not what they map to internally.

johannes
