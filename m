Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:37295 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935753Ab3DJPOH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 11:14:07 -0400
Date: Wed, 10 Apr 2013 17:15:01 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 02/11] rt2800: move rf init calibration code
Message-ID: <20130410151500.GA2175@localhost.localdomain> (sfid-20130410_171414_316355_CC44713D)
References: <1365519930-3230-1-git-send-email-stf_xl@wp.pl>
 <1365519930-3230-3-git-send-email-stf_xl@wp.pl>
 <516510D6.5090700@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <516510D6.5090700@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 10, 2013 at 09:12:22AM +0200, Gabor Juhos wrote:
> > -	if (rt2x00_rt(rt2x00dev, RT3290) ||
> > -	    rt2x00_rt(rt2x00dev, RT5390) ||
> > -	    rt2x00_rt(rt2x00dev, RT5392)) {
> > -		rt2800_rfcsr_read(rt2x00dev, 2, &rfcsr);
> > -		rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_EN, 1);
> > -		rt2800_rfcsr_write(rt2x00dev, 2, rfcsr);
> > -		msleep(1);
> > -		rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_EN, 0);
> > -		rt2800_rfcsr_write(rt2x00dev, 2, rfcsr);
> > -	} else {
> > -		rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
> > -		rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
> > -		rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
> > -		msleep(1);
> > -		rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
> > -		rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
> > -	}
> 
> The code in the else branch is required by the 305x_soc devices. However the
> change moves it into the 'rt2800_init_rfcsr_30xx' function and that is only
> called for RT3070, RT3071, RT3090.
> 
> Either add the code into the 'rt2800_init_rfcsr_305x_soc function' as well or
> create a helper function and call that from 'rt2800_init_rfcsr_30xx' and from
> 'rt2800_init_rfcsr_305x_soc'.

Right. 3352 and 3572 need that too. I'll post v2 shortly.

Thanks
Stanislaw
 
