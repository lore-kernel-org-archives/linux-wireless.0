Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42421 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729542AbeG3U0j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 16:26:39 -0400
Received: by mail-ed1-f67.google.com with SMTP id r4-v6so4548969edp.9
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jul 2018 11:50:19 -0700 (PDT)
Subject: Re: [PATCH] ath10k: Limit available channels via DT
 ieee80211-freq-limit
To: Sven Eckelmann <sven.eckelmann@openmesh.com>,
        ath10k@lists.infradead.org
References: <20180730153933.3771-1-sven.eckelmann@openmesh.com>
Cc: linux-wireless@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B5F5DE8.9060101@broadcom.com> (sfid-20180730_205022_300979_77862F99)
Date: Mon, 30 Jul 2018 20:50:16 +0200
MIME-Version: 1.0
In-Reply-To: <20180730153933.3771-1-sven.eckelmann@openmesh.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ Rafał

On 7/30/2018 5:39 PM, Sven Eckelmann wrote:
> Tri-band devices (1x 2.4GHz + 2x 5GHz) often incorporate special filters in
> the RX and TX path. These filtered channel can in theory still be used by
> the hardware but the signal strength is reduced so much that it makes no
> sense.
>
> There is already a DT property to limit the available channels but ath10k
> has to manually call this functionality to limit the currrently set wiphy
> channels further.

Wondering whether we can call it in wiphy_register() like below. Not 
sure why we did not explore that with the introduction of it by Rafał. 
Maybe he remembers. I did not find something in that direction in 
patchwork, but may have missed it. I know mt76 drops the band reference 
if it ends up with all channels disabled. Maybe that was the reason.

Regards,
Arend
---
diff --git a/net/wireless/core.c b/net/wireless/core.c
index a88551f..2e00cb1 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -742,6 +742,8 @@ int wiphy_register(struct wiphy *wiphy)
	if (res)
		return res;

+	wiphy_read_of_freq_limits(wiphy);
+
	/* sanity check supported bands/channels */
	for (band = 0; band < NUM_NL80211_BANDS; band++) {
		u16 types = 0;
