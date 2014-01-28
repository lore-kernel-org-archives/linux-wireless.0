Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:50661 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513AbaA1OmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jan 2014 09:42:07 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Sujith Manoharan <sujith@msujith.org>
Subject: Re: [PATCH] mac80211: Fix IBSS join
Date: Tue, 28 Jan 2014 15:42:03 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, stable@vger.kernel.org
References: <1390874095-28008-1-git-send-email-sujith@msujith.org>
In-Reply-To: <1390874095-28008-1-git-send-email-sujith@msujith.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201401281542.03451.sw@simonwunderlich.de> (sfid-20140128_154212_064573_77F68DE5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> Currently, when a station leaves an IBSS network, the
> corresponding BSS is not dropped from cfg80211 if there are
> other active stations in the network. But, the small
> window that is present when trying to determine a station's
> status based on IEEE80211_IBSS_MERGE_INTERVAL introduces
> a race.
> 
> Instead of trying to keep the BSS, always remove it when
> leaving an IBSS network. There is not much benefit to retain
> the BSS entry since it will be added with a subsequent join
> operation.
> 
> This fixes an issue where a dangling BSS entry causes ath9k
> to wait for a beacon indefinitely.

Thank you Sujith, works fine with and without setting a fixed BSSID.

Feel free to add

Tested-by: Simon Wunderlich <sw@simonwunderlich.de>

Cheers,
    Simon
