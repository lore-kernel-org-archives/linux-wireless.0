Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:32970 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965310AbXDGEeF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Apr 2007 00:34:05 -0400
Date: Fri, 6 Apr 2007 21:33:11 -0700
From: Jouni Malinen <j@w1.fi>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: RFC: ieee80211: Spamming of log resulting from packets with ExtIV not set
Message-ID: <20070407043310.GH16197@jm.kir.nu>
References: <4616DD7E.6010606@lwfinger.net> <20070407013848.GG16197@jm.kir.nu> <46171B36.6090108@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46171B36.6090108@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 06, 2007 at 11:16:54PM -0500, Larry Finger wrote:

> As far as I can tell, FCS errors are not filtered. I looked at other 
> wireless drivers, and I can see where zd1211rw filters them, but I have not 
> yet figured out what routine sets the error bits. Once I have that and 
> filter them, I'll see if the log messages stop.

OK, that would certainly explain large number of TKIP/CCMP errors. It is
quite normal to get packet error rate of 5-10% and FCS error detection
should take care of most of the incorrect frames that get through
without causing some other format error to reject them.

I would expect most wlan designs to do FCS error filtering in hardware,
so this could be just lack of configuring something differently or
dropping frames based on one of the RX flags. If the exact mechanism for
this is not known, I would recommend validating FCS in software prior to
processing the its contents (or trying to decrypt it for that matter).

-- 
Jouni Malinen                                            PGP id EFC895FA
