Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45556 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758827Ab2IEQdg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 12:33:36 -0400
Message-ID: <1346862851.4364.33.camel@jlt4.sipsolutions.net> (sfid-20120905_183341_124053_682C0E17)
Subject: Re: mac80211 flush callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Wed, 05 Sep 2012 18:34:11 +0200
In-Reply-To: <50477D5E.2040003@broadcom.com>
References: <503DFDE4.5030102@broadcom.com>
	 <1346853217.4364.15.camel@jlt4.sipsolutions.net>
	 <50477D5E.2040003@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-09-05 at 18:27 +0200, Arend van Spriel wrote:
> On 09/05/2012 03:53 PM, Johannes Berg wrote:
> > Hi Arend,
> >
> >> I ma currently looking into a long standing issue with flush callback in
> >> brcmsmac. After some debugging I found out that mac80211 keeps pushing
> >> packets to brcmsmac during the flush. Is that correct? Should brcmsmac
> >> (or any other driver) stop the mac80211 queues during the flush? My
> >> assumption was that mac80211 would not do transmits during the flush,
> >> but it probably comes from another worker thread.
> >
> > Hmm, good question, this area isn't quite fully worked out yet I
> > think ... probably better to stop queues yourself for now, although I
> > guess mac80211 should really take care to do it ...
> >
> 
> Thanks, Johannes
> 
> I did look at some other driver and it seems they grab a mutex in the 
> flush that is (probably?) also grabbed in the tx path thus blocking it. 
> For brcmsmac I submitted a patch to explicitly stop the queues in the flush.

I don't think any driver could possibly grab a mutex in the TX path
since it needs to be atomic? :)

johannes

