Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toccata.ens-lyon.org ([140.77.166.68]:49053 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934092AbaHZJNI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2014 05:13:08 -0400
Date: Tue, 26 Aug 2014 11:13:01 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Hugh Dickins <hughd@google.com>, akpm@linux-foundation.org,
	Sabrina Dubroca <sd@queasysnail.net>, Valdis.Kletnieks@vt.edu,
	Vincent Donnefort <vdonnefort@gmail.com>,
	Bryan Wu <cooloney@gmail.com>, linux-leds@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH][input-led] Defer input led work to workqueue
Message-ID: <20140826091301.GE5235@type.youpi.perso.aquilenet.fr> (sfid-20140826_111326_832399_1639804C)
References: <20140826015453.GA5235@type.youpi.perso.aquilenet.fr>
 <1409040095.2489.3.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1409040095.2489.3.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg, le Tue 26 Aug 2014 10:01:35 +0200, a écrit :
> On Tue, 2014-08-26 at 03:54 +0200, Samuel Thibault wrote:
> 
> > +	vt_led_wq = alloc_workqueue("input_leds", WQ_UNBOUND, 0);
> > +	if (!vt_led_wq)
> > +		return -ENOMEM;
> 
> Does this really need a separate workqueue rather than just using
> schedule_work()? There doesn't seem to be much point in having its own
> workqueue really, to me.

Ah, yes, probably.  I'm not up to date with this kind of thing (last
time I used those, they were called tasklets and bottom halves, you
know... ;) ), so I just followed Documentation/workqueue.txt, which does
not talk about schedule_work.

Samuel
