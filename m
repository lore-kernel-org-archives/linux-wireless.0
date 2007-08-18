Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:41275 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbXHRDmz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2007 23:42:55 -0400
Date: Fri, 17 Aug 2007 20:41:47 -0700
From: Jouni Malinen <j@w1.fi>
To: Volker Braun <vbraun@physics.upenn.edu>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/2] mac80211:  Remove ieee80211_privacy_mismatch
Message-ID: <20070818034146.GC1415@jm.kir.nu>
References: <1187406018.30247.17.camel@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1187406018.30247.17.camel@thinkpad>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 17, 2007 at 11:00:18PM -0400, Volker Braun wrote:
> Remove ieee80211_privacy_mismatch() and associated variable
> "privacy_enabled". It serves no purpose and breaks dynamic wep.

I don't know what has happened here, but ieee80211_privacy_mismatch()
and being able to disable/enable mixed-cell operations was here for
purpose (to prevent associating with APs that have mismatching
configuration by default, but allowing this to be enabled if the target
network is known to use some of the virtual AP designs that would
otherwise cause problems). However, someone seems to have broken this
completely by removing the mixed_cell configuration option..

-- 
Jouni Malinen                                            PGP id EFC895FA
