Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:45552
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbXF2INu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2007 04:13:50 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] mac80211: Export short-preamble bit to drivers
Date: Fri, 29 Jun 2007 10:13:07 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Jiri Benc <jbenc@suse.cz>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200706251628.00838.mb@bu3sch.de> <1183024620.4769.80.camel@johannes.berg> <200706282301.16474.flamingice@sourmilk.net>
In-Reply-To: <200706282301.16474.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200706291013.07660.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 29 June 2007 08:01:11 Michael Wu wrote:
> On Thursday 28 June 2007 02:57, Johannes Berg wrote:
> > I don't think we ever care about configuring it per-frame and currently
> > can't afaik, so I don't think we can rightfully say "short preamble
> > allowed" unless we want to confuse driver authors about who is
> > responsible for then determining whether to use it or not for each
> > frame.
> >
> mac80211 does this per-frame. It does matter. Short preamble should not be 
> configured by a global bit. What does the bcm43xx firmware do with this bit?

Configure it for management/ctl frames that are sent in hw. We send them
with long preamble atm.

-- 
Greetings Michael.
