Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:47993 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752475AbZI3RvT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 13:51:19 -0400
Date: Wed, 30 Sep 2009 20:51:19 +0300
From: Jouni Malinen <j@w1.fi>
To: =?utf-8?B?Qmxhxb4gQmHEjW5paw==?= <bacnik@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: VLAN traffic appearing on the wrong iface
Message-ID: <20090930175119.GA13376@jm.kir.nu>
References: <57b62e7d0909291754x352ae254sa33ee7efb430d497@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <57b62e7d0909291754x352ae254sa33ee7efb430d497@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 30, 2009 at 02:54:10AM +0200, Blaž Bačnik wrote:
> I use RADIUS-assigned vlans with my AP. Hostapd reports vlan change
> during authentication and the station appears on correct vlan
> according to "iw dev ... station dump". But actual packets keep coming
> in on the default interface (wlan0), not the vlan one (eg. wlan0.2).

You will need (at least) the following fix in hostapd to get this
working:
http://w1.fi/gitweb/gitweb.cgi?p=hostap.git;a=commitdiff;h=1c766b094a82a669a1d0bb7f8d132b322e56e81d

I have not tested whether this actually works, so no guarantees on that
being the only remaining issue.

> I also tried taking RADIUS out of the loop, so I used hostapd's
> "accept_mac_file" with specified vlan and I think I might have found
> another bug. After applying the patch below (for I believe a rather
> obvious typo), kernel started oopsing and I gave up. If needed, I can
> provide config files for either hostapd or freeradius server, though
> it looks like this is a driver problem.

Thanks for the hostapd patch (even better thanks would have been given
should it have been sent to the hostap mailing list or me ;-). It is now
in the current development (0.7.x) tree for hostapd (with the additional
fix I mentioned above). If you can test one, it would be interesting to
hear whether VLANs are actually working now.

As far as the kernel oops is concerned, that does not sound good..
hostapd should not have been able to trigger such a thing even with the
not-yey-fixed driver_nl80211.c.. Some more details on this could be
useful if I cannot easily reproduce the oops.

-- 
Jouni Malinen                                            PGP id EFC895FA
