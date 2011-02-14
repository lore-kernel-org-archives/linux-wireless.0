Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48154 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1BNUPe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 15:15:34 -0500
Date: Mon, 14 Feb 2011 15:14:29 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Mohammed Shafi <mshajakhan@atheros.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	Mohammed Shajakhan <Mohammed.Shajakhan@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
Subject: Re: [PATCH] ath9k: make use of slot time macros
Message-ID: <20110214201429.GF2722@tuxdriver.com>
References: <1297407704-4029-1-git-send-email-mshajakhan@atheros.com>
 <4D553107.3020402@openwrt.org>
 <20110211161551.GA2224@tuxdriver.com>
 <4D5561F2.3050404@openwrt.org>
 <20110211162944.GD2224@tuxdriver.com>
 <4D58B25D.4040507@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4D58B25D.4040507@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 14, 2011 at 10:11:01AM +0530, Mohammed Shafi wrote:
> On Friday 11 February 2011 09:59 PM, John W. Linville wrote:
> >On Fri, Feb 11, 2011 at 05:21:06PM +0100, Felix Fietkau wrote:
> >>On 2011-02-11 5:15 PM, John W. Linville wrote:
> >>>On Fri, Feb 11, 2011 at 01:52:23PM +0100, Felix Fietkau wrote:
> >>>>On 2011-02-11 8:01 AM, Mohammed Shafi Shajakhan wrote:
> >>>>>From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
> >>>>>
> >>>>>Instead of using raw numbers to assign slot time it would be better to
> >>>>>make use of predefined slot time macros
> >>>>How does this make it better?
> >>>Maybe if it was ATH9K_SHORT_SLOT_TIME it would make more sense?
> >>Well, neither the unit of this variable, nor the values that can be used
> >>are ath9k specific.
> >True -- the patch is probably an unnecessarily zealous attempt to avoid
> >"magic numbers" in the code. :-)
> John there are two instances where these macros are used:
> 
> htc_drv_beacon.c 242 if (ah->slottime == ATH9K_SLOT_TIME_20)
>  init.c           517 sc->beacon.slottime = ATH9K_SLOT_TIME_9;

Maybe you should just get rid of those instead?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
