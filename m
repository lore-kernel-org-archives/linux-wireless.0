Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:42192 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbXCaR7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Mar 2007 13:59:50 -0400
Date: Sat, 31 Mar 2007 10:59:05 -0700
From: Jouni Malinen <j@w1.fi>
To: Dan Williams <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	dragoran <drago01@gmail.com>, linux-wireless@vger.kernel.org,
	John Linville <linville@redhat.com>
Subject: Re: mac80211 does not support WPA when used with wext
Message-ID: <20070331175905.GK8435@jm.kir.nu>
References: <460E2B8C.4030002@gmail.com> <1175335211.23438.45.camel@johannes.berg> <1175363333.9349.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1175363333.9349.10.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 31, 2007 at 01:48:53PM -0400, Dan Williams wrote:

> Take a look at ieee80211_sta_scan_result() in mac80211/ieee80211_sta.c.
> Note that it returns custom events for the WPA & RSN IEs.  That's just
> wrong.  We should be using already-defined events.

I don't think the "already-defined events" were defined when that code
was written.. Sure, now it should be updated to use the WEXT-18 -based
events.

> I don't quite get why mac80211/d80211 was so behind in wireless
> extensions support.  Didn't Jouni and Devicescape basically _write_
> WE-18/19 WPA support?  Did d80211 just not get the love that
> wpa_supplicant and the other drivers got when they were updated to WE-18
> and later?

Well, I may have added WPA support to WE-18, but only after having
implemented support for WPA using custom events (the only real option
available prior to WE-18). Devicescape code needed to work with number
of Linux kernels that did not include WE-18, so it had to continue using
those custom events. Looks like no one has had enough time or interest
to update it to use the events defined in WE-18. wpa_supplicant supports
both mechanisms for receiving the IEs.

-- 
Jouni Malinen                                            PGP id EFC895FA
