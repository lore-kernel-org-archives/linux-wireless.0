Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45118 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab2IENxA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 09:53:00 -0400
Message-ID: <1346853217.4364.15.camel@jlt4.sipsolutions.net> (sfid-20120905_155305_326185_71449EDF)
Subject: Re: mac80211 flush callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Wed, 05 Sep 2012 15:53:37 +0200
In-Reply-To: <503DFDE4.5030102@broadcom.com>
References: <503DFDE4.5030102@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

> I ma currently looking into a long standing issue with flush callback in 
> brcmsmac. After some debugging I found out that mac80211 keeps pushing 
> packets to brcmsmac during the flush. Is that correct? Should brcmsmac 
> (or any other driver) stop the mac80211 queues during the flush? My 
> assumption was that mac80211 would not do transmits during the flush, 
> but it probably comes from another worker thread.

Hmm, good question, this area isn't quite fully worked out yet I
think ... probably better to stop queues yourself for now, although I
guess mac80211 should really take care to do it ...

johannes

