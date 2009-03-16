Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from col0-omc2-s14.col0.hotmail.com ([65.55.34.88]:14483 "EHLO
	col0-omc2-s14.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751512AbZCPUZw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 16:25:52 -0400
Message-ID: <COL113-W165EE515E90C5373519FE8CB9B0@phx.gbl> (sfid-20090316_212554_918747_803ECABE)
From: Adrian Bassett <adrian.bassett@hotmail.co.uk>
To: <linux-wireless@vger.kernel.org>
Subject: FW: rtl8180 Bit Rate regression in 2.6.29
Date: Mon, 16 Mar 2009 20:25:50 +0000
In-Reply-To: <20090316180832.GC3660@tuxdriver.com>
References: <COL113-W348B209977311F6BB460ADCB9B0@phx.gbl>
 <20090316180832.GC3660@tuxdriver.com>
Content-Type: text/plain; charset=Windows-1252
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



(Replied to John's note but forgot to Cc: the list so here is):

> FWIW, are you sure?  PID was still the default in 2.6.28 IIRC.
> The "run to the highest available rate" behavior was typical of PID.
=20
I have just gone through all of my preserved 2.6.28 configs (2.6.28 to =
2.6.28.7) and in every case:
=20
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=3Dy
=20
and

CONFIG_MAC80211_RC_DEFAULT=3D"minstrel"
=20
whilst
=20
CONFIG_MAC80211_RC_DEFAULT_PID is not set
=20
Same thing for 2.6.29-rc stuff.
=20
(All my 2.6.27 configs used PID for rate control, probably that's all t=
here was, can't remember).
=20
I'm currently bisecting - at 2.6.29-rc2 at the moment - but with no imp=
rovement so far in the Bit Rate reported by iwconfig.
=20
In all I'm pretty sure it's not a minstrel v. PID rate control issue so=
 much as something different in the underlying stuff between 2.6.28 and=
 2.6.29.
=20
Adrian
=20
=20

_________________________________________________________________
View your Twitter and Flickr updates from one place =96 Learn more!
http://clk.atdmt.com/UKM/go/137984870/direct/01/--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
