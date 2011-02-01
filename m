Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:53162 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751923Ab1BAOvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 09:51:07 -0500
Date: Tue, 1 Feb 2011 16:51:00 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: pass up beacons from external BSS when
 operating as AP
Message-ID: <20110201145100.GA21686@jm.kir.nu>
References: <1296559385-5357-1-git-send-email-arik@wizery.com>
 <1296568614.3989.6.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1296568614.3989.6.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 01, 2011 at 02:56:54PM +0100, Johannes Berg wrote:
> On Tue, 2011-02-01 at 13:23 +0200, Arik Nemtsov wrote:
> > Beacons from external BSSes are required for updating overlapping BSS
> > info (i.e. ERP protection). Pass them up unconditionally.
> 
> Where will they be processed though?

In src/ap/ap_list.c (hostap.git) ;-)

This code has been there for a long time, but the functionality was
broken at some point (maybe already during d80211 -> mac80211 process)
due to the beacons not getting delivered there anymore.

-- 
Jouni Malinen                                            PGP id EFC895FA
