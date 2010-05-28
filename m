Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32188 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755253Ab0E1Fj1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 01:39:27 -0400
Subject: Re: Iwlwifi and LEDS?
From: reinette chatre <reinette.chatre@intel.com>
To: Gregy <p.gregy@gmail.com>
Cc: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTilfa4YPPiroX5yfJ2BNRUVZH6imTvG4I8ukGjBC@mail.gmail.com>
References: <AANLkTikB8WaMyIj6CTY5wfEeVDratQ1Y8W3B_JBVllBp@mail.gmail.com>
	 <1274465242.12391.0.camel@abhi-desktop>
	 <AANLkTilnK6lkypJkajiwUbhl6JlNR7S8dL6YzKUe2yd3@mail.gmail.com>
	 <1274740231.2091.15472.camel@rchatre-DESK>
	 <AANLkTilfa4YPPiroX5yfJ2BNRUVZH6imTvG4I8ukGjBC@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 22:39:23 -0700
Message-ID: <1275025163.2091.20502.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-05-27 at 13:14 -0700, Gregy wrote:
> > What did you do before that does not work anymore?
> No, led never gets registered in /sys/class/leds.

Right, and the patch you reference explains why. At no point was support
for LEDs removed.

>  Also I found this:
> http://article.gmane.org/gmane.linux.kernel.wireless.general/40328/

The intention and supported LED behavior has always been for a single
LED to blink according to data. The led_mode module parameter was added
to support the additional RF status indication capability. 

If you want to be able to manipulate the LED in other ways than the
driver supports you could look into adding a debugfs file that
manipulates the driver's led variables (allow_blinking,
last_blink_time, ...). There is already a readable led file in debugfs,
but not writable. 

Reinette


