Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45071 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab0IBN3p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 09:29:45 -0400
Date: Thu, 2 Sep 2010 09:18:29 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: WARNING: at net/mac80211/tx.c:653 ieee80211_tx_h_rate_ctrl+0x460
Message-ID: <20100902131828.GA6802@tuxdriver.com>
References: <AANLkTiko4XRM=xQWHy2H5WUMbYBzRE+NfUeqS20S2D_S@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTiko4XRM=xQWHy2H5WUMbYBzRE+NfUeqS20S2D_S@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 01, 2010 at 04:45:46PM -0700, Luis R. Rodriguez wrote:
> Just hit this
> 
>         /*
>          * Lets not bother rate control if we're associated and cannot
>          * talk to the sta. This should not happen.
>          */
>         if (WARN(test_bit(SCAN_SW_SCANNING, &tx->local->scanning) &&
>                  (sta_flags & WLAN_STA_ASSOC) &&
>                  !rate_usable_index_exists(sband, &tx->sta->sta),
>                  "%s: Dropped data frame as no usable bitrate found while "
>                  "scanning and associated. Target station: "
>                  "%pM on %d GHz band\n",
>                  tx->sdata->name, hdr->addr1,
>                  tx->channel->band ? 5 : 2))
>                 return TX_DROP;

Also seeing that here:

	https://bugzilla.redhat.com/show_bug.cgi?id=606393

"I surmise that the device is exiting dynamic power saving mode and
attempting to transmit a frame to notify the AP that it is awake.
Instead, it is hitting this check in ieee80211_tx_h_rate_ctrl". -- me
 
John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
