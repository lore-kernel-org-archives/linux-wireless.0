Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:27056 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab3DQIWF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 04:22:05 -0400
Date: Wed, 17 Apr 2013 10:23:06 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 07/11] rt2800: add rt2800_rx_filter_calibration procedure
Message-ID: <20130417082306.GA2410@localhost.localdomain> (sfid-20130417_102230_042910_D93AA2B5)
References: <1365519930-3230-1-git-send-email-stf_xl@wp.pl>
 <1365519930-3230-8-git-send-email-stf_xl@wp.pl>
 <948863C1-A75D-4625-A880-5589875479D0@gmail.com>
 <5E4C3175-16F8-4FA1-9353-548A8CA854A3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5E4C3175-16F8-4FA1-9353-548A8CA854A3@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 14, 2013 at 10:17:56PM +0200, Gertjan van Wingerde wrote:
> >> +    /*
> >> +     * Set back to initial state
> >> +     */
> >> +    rt2800_bbp_write(rt2x00dev, 24, 0);
> >> +
> >> +    rt2800_rfcsr_read(rt2x00dev, 22, &rfcsr);
> >> +    rt2x00_set_field8(&rfcsr, RFCSR22_BASEBAND_LOOPBACK, 0);
> >> +    rt2800_rfcsr_write(rt2x00dev, 22, rfcsr);
> >> +
> >> +    /*
> >> +     * Set BBP back to BW20
> >> +     */
> >> +    rt2800_bbp_read(rt2x00dev, 4, &bbp);
> >> +    rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 0);
> >> +    rt2800_bbp_write(rt2x00dev, 4, bbp);
[snip]
> >> +
> >> +    rt2800_rx_filter_calibration(rt2x00dev);
> >> }
> > 
> > This looks a bit fishy to me, as the original code doesn't completely apply to RT3290, but now it does.

On vendor DPO_RT3290_LinuxSTA_V2600_20120508 we do not do this
"set back to initial state" code at all, so I'll remove
rt2800_rx_filter_calibration() from 3290 procedure.

Stanislaw 
