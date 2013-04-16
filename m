Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53220 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082Ab3DPOGX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 10:06:23 -0400
Message-ID: <1366121174.8244.18.camel@jlt4.sipsolutions.net> (sfid-20130416_160633_718456_3CA57571)
Subject: Re: [PATCH 1/2] mac80211: VHT off-by-one NSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Tue, 16 Apr 2013 16:06:14 +0200
In-Reply-To: <1366038570-12457-1-git-send-email-karl.beldan@gmail.com> (sfid-20130415_171410_156381_380D60DE)
References: <1366038570-12457-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20130415_171410_156381_380D60DE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-15 at 17:09 +0200, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> The number of VHT spatial streams (NSS) is found in:
> - s8 ieee80211_tx_rate.rate.idx[6:4] (tx - filled by rate control)
> - u8 ieee80211_rx_status.vht_nss     (rx - filled by driver)
> Tx discriminates valid rates indexes with the sign bit and encodes NSS
> starting from 0 to 7 (note this matches some hw encodings e.g IWLMVM).
> Rx does not have the same constraints, and encodes NSS starting from 1
> to 8 (note this matches what wireshark expects in the radiotap header).
> 
> To handle ieee80211_tx_rate.rate.idx[6:4] ieee80211_rate_set_vht() and
> ieee80211_rate_get_vht_nss() assume their nss parameter and return value
> respectively runs from 0 to 7.
> ATM, there are only 2 users of these: cfg.c:sta_set_rate_info_t() and
> iwlwifi/mvm/tx.c:iwl_mvm_hwrate_to_tx_control(), but both assume nss
> runs from 1 to 8.
> This patch fixes this inconsistency by making ieee80211_rate_set_vht()
> and ieee80211_rate_get_vht_nss() handle an nss running from 1 to 8.
> 
> Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
> ---
> This might feel very verbose for such a trivial thing.

I think it's good, it's clearly a tricky area :-)

Applied both.

Btw, it seems we're missing VHT rates in net/mac80211/status.c, I was
wondering why that wasn't wrong but it's simply not there, heh. In fact
we probably mess it up when using VHT ...

johannes

