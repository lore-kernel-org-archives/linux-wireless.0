Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45405 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243AbaGUKeV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 06:34:21 -0400
Message-ID: <1405938856.32255.22.camel@jlt4.sipsolutions.net> (sfid-20140721_123425_020086_AD186C03)
Subject: Re: [PATCH] mac80211: fix a potential NULL access in
 ieee80211_crypto_hw_decrypt
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Max Stepanov <Max.Stepanov@intel.com>
Date: Mon, 21 Jul 2014 12:34:16 +0200
In-Reply-To: <1404914132-13614-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1404914132-13614-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-07-09 at 16:55 +0300, Emmanuel Grumbach wrote:
> From: Max Stepanov <Max.Stepanov@intel.com>
> 
> The NULL pointer access could happen when ieee80211_crypto_hw_decrypt
> is called from ieee80211_rx_h_decrypt with the following condition:
> 1. rx->key->conf.cipher is not WEP, CCMP, TKIP or AES_CMAC
> 2. rx->sta is NULL
> 
> When ieee80211_crypto_hw_decrypt is called, it verifies
> rx->sta->cipher_scheme and it will cause Oops if rx->sta is NULL.
> 
> This path adds an addirional rx->sta == NULL verification in
> ieee80211_crypto_hw_decrypt for this case.

Applied.

johannes

