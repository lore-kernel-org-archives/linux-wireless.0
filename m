Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:40264 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759880AbYJNAAm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 20:00:42 -0400
Subject: Re: [RFC/RFT] p54: Fix for big-endian architecture
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Christian Lamparter <chunkeey@web.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223941001.28019.3.camel@dv>
References: <48EE20FB.4060700@lwfinger.net>
	 <1223936680.10113.7.camel@johannes.berg> <1223937392.27118.2.camel@dv>
	 <200810140055.34065.chunkeey@web.de>  <1223938526.27118.6.camel@dv>
	 <1223939151.27769.3.camel@dv>  <1223939271.10113.10.camel@johannes.berg>
	 <1223941001.28019.3.camel@dv>
Content-Type: text/plain
Date: Mon, 13 Oct 2008 20:00:39 -0400
Message-Id: <1223942439.28019.9.camel@dv> (sfid-20081014_020109_556603_EBF590B3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-10-13 at 19:36 -0400, Pavel Roskin wrote:

> p54_config() calls p54_set_freq(), which can fail with -EINVAL.  I'm
> looking why it can happen.

The calibration table only has frequencies in the 2.4GHz band, but the
scan goes through the 5GHz band as well.  That's how it fails:

freq = 5825
i = 0, priv->iq_autocal[i].freq = 2412
i = 1, priv->iq_autocal[i].freq = 2417
i = 2, priv->iq_autocal[i].freq = 2422
i = 3, priv->iq_autocal[i].freq = 2427
i = 4, priv->iq_autocal[i].freq = 2432
i = 5, priv->iq_autocal[i].freq = 2437
i = 6, priv->iq_autocal[i].freq = 2442
i = 7, priv->iq_autocal[i].freq = 2447
i = 8, priv->iq_autocal[i].freq = 2452
i = 9, priv->iq_autocal[i].freq = 2457
i = 10, priv->iq_autocal[i].freq = 2462
i = 11, priv->iq_autocal[i].freq = 2467
i = 12, priv->iq_autocal[i].freq = 2472
i = 13, priv->iq_autocal[i].freq = 2484
phy9: frequency change failed
ret = -22

Either we should be using a different table for the 5GHz band, or the
driver should not announce 5GHz channels if the calibration table lacks
them.

-- 
Regards,
Pavel Roskin
