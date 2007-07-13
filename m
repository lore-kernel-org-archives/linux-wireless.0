Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:41097 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755540AbXGMPX2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2007 11:23:28 -0400
Date: Fri, 13 Jul 2007 17:23:38 +0200
From: Jiri Benc <jbenc@suse.cz>
To: "Cahill, Ben M" <ben.m.cahill@intel.com>
Cc: <benmcahill@gmail.com>, <flamingice@sourmilk.net>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/1] mac80211: Replace overly "sticky" averaging filters  for rssi, signal, noise.
Message-ID: <20070713172338.71bc4216@griffin.suse.cz>
In-Reply-To: <4220499A1B034C4FA93B547BA01E1FF07FC284@orsmsx413.amr.corp.intel.com>
References: <20070711022508.36db6129@logostar.upir.cz>
	<4220499A1B034C4FA93B547BA01E1FF07FC284@orsmsx413.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 10 Jul 2007 21:59:13 -0700, Cahill, Ben M wrote:
> Postponing the division keeps the running average using more significant
> bits, so each new sample has a meaningful, surviving impact to the
> running average.  Sorry, "high-precision" is the best term that I can
> think of to describe more bits being used in the running average.  The
> "binary point" is between bits 3 and 4; think of bits 3:0 as
> "remainder". 

Thanks, that makes sense. Please include something like this
explanation in the description of the patch when you resend it.

> There is a subtle difference between:
> 
> 1)  last_rssi * 15 / 16
> 
> 2)  last_rssi - (last_rssi / 16)
> 
> The first one would get stuck at -801 if there were a series of -51s
> coming in.
> -801 * 15 / 16 would get quantized to -750 each time, so the output
> would be stuck at -801 (-50 dBm).
> 
> The second one favors the high precision memory, and would progress from
> -801 to -802, etc., as a series of -51s came in:
> -801 - (-801/16) = -751

So it's basically just a different rounding - in the current code, it's
like float division with the result rounded down, while your change
makes it to round up (speaking about absolute value). Nothing about
precision here :-)

> I saw 2 instances of sta->last_rssi being used in ieee80211_ioctl.c, and
> STA_FILE(last_rssi, last_rssi, D) in debugfs_sta.c, which I didn't
> understand (still don't) and was afraid to touch, so I thought the
> safest thing with least impact would be to add the 3 additional
> variables, and do the division in one place for each of the 3
> rssi/signal/noise.
> 
> If we do the division when passing to user space, how should STA_FILE be
> handled, if necessary?

Johannes was quicker than me (thanks) :-)

> Thanks for your comments.  I'll wait for your answer, and try again.

Thanks and sorry for the delayed answer,

 Jiri

-- 
Jiri Benc
SUSE Labs
