Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:46483 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933131AbXBWQ2T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Feb 2007 11:28:19 -0500
Date: Fri, 23 Feb 2007 17:28:15 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] d80211: Split antenna selection into TX and RX  antenna
Message-ID: <20070223172815.359080e8@griffin.suse.cz>
In-Reply-To: <200702211702.48001.IvDoorn@gmail.com>
References: <200702211702.48001.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 21 Feb 2007 17:02:47 +0100, Ivo van Doorn wrote:
> With the split antenna selection rt2x00 can now read the default
> value for both selections from the EEPROM and can now configure
> the card correctly based on the individual RX and TX antenna selections.
> 
> [...]
> @@ -468,7 +469,7 @@ static void rt2400pci_config_antenna(struct rt2x00_dev *rt2x00dev, int antenna)
>  	/*
>  	 * Only continue when there is something to be done.
>  	 */
> -	if (rt2x00dev->rx_params.antenna == antenna)
> +	if (rt2x00dev->rx_status.antenna == antenna_rx)

drivers/net/wireless/d80211/rt2x00/rt2400pci.c:472: error: 'struct rt2x00_dev' has no member named 'rx_status'

 Jiri

-- 
Jiri Benc
SUSE Labs
