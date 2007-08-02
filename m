Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:53806
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbXHBLLs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 07:11:48 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC V2] bcm43xx-mac80211: Provide information to allow  transmission rate decreases
Date: Thu, 2 Aug 2007 13:11:24 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de
References: <46b0f367.p35iGhSXwM+v4QLG%Larry.Finger@lwfinger.net> <200708020014.15072.mb@bu3sch.de> <1186045787.24230.7.camel@johannes.berg>
In-Reply-To: <1186045787.24230.7.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708021311.25033.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 02 August 2007 11:09:47 Johannes Berg wrote:
> On Thu, 2007-08-02 at 00:14 +0200, Michael Buesch wrote:
> 
> > Though, I have no idea how we can easily track the information for each
> > packet if it was sent with LONGFRAME bit or without.
> > It needs to be a per-frame-attribute.
> > I think the txstatus doesn't tell us (but I'm not sure).
> 
> Why do you need to know when you get a tx status? Oh I see. Hm. Well,
> mac80211 tells you how much to retry now (Daniel made a patch); you can
> select long/short based on that and on tx status simply compare with
> that number from the tx control struct.

We don't get a "I failed to transmit this" bit from the firmware,
so we must work around this my comparing the retries count to
the maximum possible retry count.
Of course, that's not an ideal solution. Especially because I think
When it succeed on the exact last retry, we take it as failure.
Though, that's very unlikely it fails 7 times give or take and then
suddenly succeeds.

-- 
Greetings Michael.
