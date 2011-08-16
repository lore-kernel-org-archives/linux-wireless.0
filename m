Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36809 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab1HPVbD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 17:31:03 -0400
Received: by qwk3 with SMTP id 3so248149qwk.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Aug 2011 14:31:02 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 16 Aug 2011 17:31:02 -0400
Message-ID: <CAFKp-_frLkDEeF3t=-_hXAig-vQebwnouYHqRCv9YCTXDa_LgQ@mail.gmail.com> (sfid-20110816_233108_163121_B10FE90A)
Subject: [BUG] ath9k truncated management packets from TKIP connected stations
From: Bill Jordan <bjordan@rajant.com>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm not quite sure what the correct fix is for this.

Ath9k in AP mode with a TKIP security: If a connected station sends a
management packet, the packet is truncated by 8 bytes before being
delivered to hostapd. This prevents the station from reauthenticating
or connecting to a different SSID on the same radio.

In ath9k_rx_accept, for management packets, strip_mic will be true,
and RX_FLAG_MMIC_STRIPPED will be set in rxs->flag. In
ath9k_rx_skb_postprocess, if ah->sw_mgmt_crypto is set,
RX_FLAG_DECRYPTED will be cleared. However, RX_FLAG_MMIC_STRIPPED will
still be set, so, in ath_rx_tasklet, 8 bytes will be trimmed off the
end of the skb.

I'm thinking that in ath9k_rx_accept, is_valid_tkip  should also
consider ieee80211_is_mgmt(fc). But this wouldn't take into
consideration ah->sw_mgmt_crypto.

Alternatively, RX_FLAG_MMIC_STRIPPED could be cleared in
ath9k_rx_skb_postprocess when RX_FLAG_DECRYPTED is cleared.

I'm looking for input from someone who understands this code better.

Thanks,
Bill Jordan
