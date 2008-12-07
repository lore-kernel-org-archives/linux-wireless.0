Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:41242 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246AbYLGQlv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 11:41:51 -0500
Received: by ey-out-2122.google.com with SMTP id 6so308131eyi.37
        for <linux-wireless@vger.kernel.org>; Sun, 07 Dec 2008 08:41:49 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFT] mac80211: fix HT channel selection
Date: Sun, 7 Dec 2008 17:41:46 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Mats Johannesson <spamcan1@abrasax.se>,
	Tomas Winkler <tomasw@gmail.com>
References: <1228667447.22164.46.camel@johannes.berg>
In-Reply-To: <1228667447.22164.46.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200812071741.46741.IvDoorn@gmail.com> (sfid-20081207_174201_809112_99E689B3)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 07 December 2008, Johannes Berg wrote:
> HT management is done differently for AP and STA modes, unify
> to just the ->config() callback since HT is fundamentally a
> PHY property and cannot be per-BSS.

Ah very nice, I was recently hit this for the rt2x00 implementation,
intended to send a mail about it when I had done some more research. :)

Thanks!

> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> Please test. Mats, this might fix your problem (if it applies on top of
> the patch that fixes the panic)
> 
>  drivers/net/wireless/ath9k/main.c      |   71 ---------------------------------
>  drivers/net/wireless/iwlwifi/iwl-agn.c |   21 ++++++---
>  drivers/net/wireless/mac80211_hwsim.c  |    7 ---
>  include/net/mac80211.h                 |    5 --
>  net/mac80211/ht.c                      |   57 --------------------------
>  net/mac80211/ieee80211_i.h             |    3 -
>  net/mac80211/mlme.c                    |   67 +++++++++++++++++++++++++++++++
>  7 files changed, 85 insertions(+), 146 deletions(-)



