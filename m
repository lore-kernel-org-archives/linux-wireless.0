Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:41661 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752432AbXFTQ0A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2007 12:26:00 -0400
Date: Wed, 20 Jun 2007 18:25:58 +0200
From: Jiri Benc <jbenc@suse.cz>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: Hong Liu <hong.liu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [patch]mac80211: add support for iwlist channel
Message-ID: <20070620182558.47871535@griffin.suse.cz>
In-Reply-To: <4679672D.4060503@linux.intel.com>
References: <1182156425.15928.7.camel@napa-sdv1.sh.intel.com>
	<20070619105024.3c6c68e3@griffin.suse.cz>
	<1182305425.19178.12.camel@napa-sdv1.sh.intel.com>
	<20070620115559.301e10eb@griffin.suse.cz>
	<4679672D.4060503@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 20 Jun 2007 10:43:09 -0700, James Ketrenos wrote:
> [...]
> /**
>  * enum ieee80211_channel_flags - Channel flag bit values
>  * @IEEE80211_CHAN_W_TUNE: Hardware can tune to this channel
>  * @IEEE80211_CHAN_W_ACTIVE: Channel can be used for active scanning
>  * @IEEE80211_CHAN_W_IBSS: Hardware can act as IBSS Master
>  * @IEEE80211_CHAN_W_RADAR: Radar spectrum enforcement applies
>  * @IEEE80211_CHAN_W_TX_ALLOWED: Tx is allowed

Looks good, except...

> [...]
>  * A channel without the TX_ALLOWED bit set *can not* be used
>  * for any type of transmission and can only be used for passive
>  * listening.  This is useful for performing network audits.

I don't find this useful. The stack isn't aware of anything like this.
Do you plan to add a support for this flag? Also, cfg80211/nl80211
would need to be taught of it.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
