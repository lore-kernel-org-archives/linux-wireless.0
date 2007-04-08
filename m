Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:50820
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbXDHKT0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2007 06:19:26 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: RFC: ieee80211: Spamming of log resulting from packets with ExtIV  not set
Date: Sun, 8 Apr 2007 12:18:48 +0200
Cc: Larry Finger <larry.finger@lwfinger.net>, Jouni Malinen <j@w1.fi>,
	wireless <linux-wireless@vger.kernel.org>
References: <4616DD7E.6010606@lwfinger.net> <46171B36.6090108@lwfinger.net> <1176019813.8459.15.camel@johannes.berg>
In-Reply-To: <1176019813.8459.15.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200704081218.49055.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 April 2007 10:10, Johannes Berg wrote:
> On Fri, 2007-04-06 at 23:16 -0500, Larry Finger wrote:
> 
> > As far as I can tell, FCS errors are not filtered.
> 
> Actually, they are filtered by the firmware and never passed up to the
> driver unless you set the "rx invalid frames" bit in the mac control
> field. Since the driver never sets that except with some of the module
> parameters (or is that modparm bcm43xx-mac80211 only?) the FCS on all
> frames passed up should be fine.

FCS corrupted frames are always filtered in bcm43xx. There's a
hack module parameter to pass them up in monitor mode in bcm43xx-mac80211.

-- 
Greetings Michael.
