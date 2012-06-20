Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53837 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373Ab2FTM3z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 08:29:55 -0400
Message-ID: <1340195389.4655.61.camel@jlt3.sipsolutions.net> (sfid-20120620_143019_490657_F18BE753)
Subject: Re: [PATCH v2 1/7] nl80211/cfg80211: add radar detection
 command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Victor Goldenshtein <victorg@ti.com>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, adrian.chadd@gmail.com, j@w1.fi,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Date: Wed, 20 Jun 2012 14:29:49 +0200
In-Reply-To: <4FE1C06A.3060605@neratec.com>
References: <1340111463-4554-1-git-send-email-victorg@ti.com>
	 <1340181600.4655.34.camel@jlt3.sipsolutions.net>
	 <4FE1C06A.3060605@neratec.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 14:22 +0200, Zefir Kurtisi wrote:
> On 06/20/2012 10:40 AM, Johannes Berg wrote:
> > [...]
> > 
> > How do you intend to handle HT40?
> > 
> > johannes
> > 
> 
> Not to mention VHT ante portas...
> 
> We should start with HT20 support only to have something to start
> testing with and add HT40 gradually (assuming it will require a lot more
> locations to be patched to be available initially).

Ok, fin with me. However, then somewhere in this code there should be a
channel type check ... otherwise you can do the CAC on 20 MHz and then
use 40 anyway, no? I see no channel type handling anywhere. Or just add
the code to check if all affected channels had CAC to start with, that
will refuse HT40 then

johannes

