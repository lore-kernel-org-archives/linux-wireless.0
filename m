Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:37837 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756509Ab0KPWhE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 17:37:04 -0500
Date: Wed, 17 Nov 2010 00:36:58 +0200
From: Jouni Malinen <j@w1.fi>
To: Ben Greear <greearb@candelatech.com>
Cc: hostap@lists.shmoo.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: RFC/PATCH:  Allow wpa_supplicant to share scan results.
Message-ID: <20101116223658.GA5310@jm.kir.nu>
References: <4CE1CEC6.2050103@candelatech.com>
 <20101116094512.GB21872@jm.kir.nu>
 <4CE2B953.9090509@candelatech.com>
 <20101116193156.GA32723@jm.kir.nu>
 <4CE2E215.1090906@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4CE2E215.1090906@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 16, 2010 at 11:57:09AM -0800, Ben Greear wrote:
> I earlier attempted to put this sharing/propagation directly into
> the kernel (instead of -EBUSY, the kernel would just keep a list of
> interested interfaces and then send results to all interested parties).
> 
> However, Johannes didn't like this approach, so I'm trying to do a
> similar thing in user-space.

Johannes is not the only one having something against the kernel
approach.. ;-)

>  My understanding is that you cannot
> read scan results from the kernel for one VIF if they were initiated on another
> VIF.  I might be wrong about that, however.  At any rate, you certainly can't
> have two VIFS on the same phy scanning at the same time, as you get -EBUSY instead.
> That makes wpa_supplicant take a long time to scan & associate lots
> of VIFS, and speeding that up is my primary goal at this point.

Hmm.. Maybe I'm missing something in your patch, but it seems to be
doing exactly what you are describing it should not be doing.. It seems
to share the scan-done event with all interfaces that are from the same
radio and then each interface would try to read the scan result from
their own VIF which would be different from the one that actually
initiated the scan.. Similarly, I did not notice any changes that would
actually restrict requesting new scans when there is a known scan
request pending on another interface that shares the same radio.

Are these still waiting to be implemented or did I miss something in
your patch? Anyway, they approach in the newer version looked reasonable
to me based on what I believe you are now trying to do.

> I think I see where to propagate the scan results in the hostap NL driver, except
> that I cannot find a global list of driver-data structs.  I could
> do some casting of drv->ctx->global, but perhaps we are not supposed
> to do that sort of thing?

You would need to maintain a local list in driver_nl80211.c after
converting it to use global_init/init2 callbacks.. Anyway, it sounds
like this would not be the approach to make this work cleanly with
wpa_supplicant becoming more aware of when to request new scans and with
the assumed limitation on which vif the scan results can be read from.

> If I put the phyname (or radio_name, or whatever) in wpa_s, I can propagate
> in the events.c code, but I'm not too sure how to set that value from within
> the NL driver since we are given the wpa_s as a void* (which I assume means
> we should not be assuming what struct it really is).

It looks like you found the way I was hoping for with the new
get_radio_name() driver op.

> One other thing I was worried about:  My patch is going to send scan results
> to interfaces that have not successfully requested them (they may have not
> requested at all, or they may have tried and received EBUSY).  Will that be
> an issue?

If your assumption above is correct, yes. Instead of sharing the
scan-done event, this change should like share the scan_res from
wpa_supplicant_get_scan_results() for all interfaces sharing the radio.
It could also be nice to add a for-each-vif-in-my-radio wrapper to take
care of the calls since I would expect that to be needed for other
areas, too.. Like for restricting new scan requests if there is a
pending scan on another interface that happens to share the radio.
("Restricting" here could mean delaying or dropping the new request
completely.. For more optimized behavior, this could eventually end up
being able to merge multiple requests into one, too..)

> It only crashes with the wpa_supplicant patch I posted (and the kernel
> patch as well, it turns out).  It's almost certainly due to faster
> association attempts, but I haven't looked any farther.  I plan to
> test this on ath5k as well..that might shed some light.

Huh.. Well, anyway, as I said, that should not matter in the context of
what we want to do with wpa_supplicant.

-- 
Jouni Malinen                                            PGP id EFC895FA
