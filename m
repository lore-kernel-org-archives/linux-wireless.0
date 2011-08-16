Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41855 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab1HPWwd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 18:52:33 -0400
Message-ID: <4E4AF4A4.9090404@openwrt.org> (sfid-20110817_005237_164977_CB2BE8B2)
Date: Tue, 16 Aug 2011 15:52:20 -0700
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Bill Jordan <bjordan@rajant.com>
CC: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [BUG] ath9k truncated management packets from TKIP connected
 stations
References: <CAFKp-_frLkDEeF3t=-_hXAig-vQebwnouYHqRCv9YCTXDa_LgQ@mail.gmail.com>
In-Reply-To: <CAFKp-_frLkDEeF3t=-_hXAig-vQebwnouYHqRCv9YCTXDa_LgQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-16 2:31 PM, Bill Jordan wrote:
> I'm not quite sure what the correct fix is for this.
>
> Ath9k in AP mode with a TKIP security: If a connected station sends a
> management packet, the packet is truncated by 8 bytes before being
> delivered to hostapd. This prevents the station from reauthenticating
> or connecting to a different SSID on the same radio.
>
> In ath9k_rx_accept, for management packets, strip_mic will be true,
> and RX_FLAG_MMIC_STRIPPED will be set in rxs->flag. In
> ath9k_rx_skb_postprocess, if ah->sw_mgmt_crypto is set,
> RX_FLAG_DECRYPTED will be cleared. However, RX_FLAG_MMIC_STRIPPED will
> still be set, so, in ath_rx_tasklet, 8 bytes will be trimmed off the
> end of the skb.
>
> I'm thinking that in ath9k_rx_accept, is_valid_tkip  should also
> consider ieee80211_is_mgmt(fc). But this wouldn't take into
> consideration ah->sw_mgmt_crypto.
>
> Alternatively, RX_FLAG_MMIC_STRIPPED could be cleared in
> ath9k_rx_skb_postprocess when RX_FLAG_DECRYPTED is cleared.
>
> I'm looking for input from someone who understands this code better.
We should probably just keep strip_mic set to false for mgmt frames.

- Felix
