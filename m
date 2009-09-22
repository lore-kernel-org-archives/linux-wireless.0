Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbZIVX3t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2009 19:29:49 -0400
Subject: Re: [RFC] nl80211: introduce NL80211_ATTR_SCAN_EXPIRE
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>
In-Reply-To: <200909210946.19675.hs4233@mail.mn-solutions.de>
References: <200909181849.22302.hs4233@mail.mn-solutions.de>
	 <200909210842.59852.hs4233@mail.mn-solutions.de>
	 <1253517333.4458.7.camel@johannes.local>
	 <200909210946.19675.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 16:29:32 -0700
Message-Id: <1253662172.2510.60.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-09-21 at 09:46 +0200, Holger Schurig wrote:
> > It's not actually the same, and you didn't explain that well.
> > You care about the disappear case, but you made it sound like
> > you cared about the _reappear_ case.
> 
> Okay, sorry. I thought you read my other mails about 
> scan-life-time and that thus the context was/is clear.
> 
> 
> The base issue is: SCAN_TRIGGER does normally not a "clean scan", 
> it normally adds entries to the BSS list or updates existing 
> ones.
> 
> Entries in the BSS list are only deleted after 15 seconds.

So on the supplicant side, this weekend I was discussing with Jouni
about making the supplicant *not* trigger a completely new scan when
trying to associate if the scan list was current in the past 5 or 10
seconds.  The issue here is that NM requests a scan, figures out what AP
to start using, then tells the supplicant to associate with it.  Then
the supplicant throws away any scan results it has an does a full *new*
scan before associating.  That adds about 5 seconds to each NM
connection attempt that I'd like to get rid of.

Would that interfere with your forklift case?

BTW, 10 years ago I did a forklift deployment too with pre-802.11
Aironet equipment and Netware.  Wasn't that fun to get up and running.
This was at a paper company too, and guess what huge rolls of paper do?
They absorb radio waves quite well.  Suck.  And forklifts can go *fast*.

Dan

> 
> 
> However, in 15 seconds you can easily leave the range of AP_OLD 
> and be in the range of a completely AP_NEW. But it can also be 
> the case that the (now stale!) signal of AP_OLD is higher than 
> the (real) signal of AP_NEW. In this case wpa_supplicant tries 
> to associate to AP_OLD, which is out-of-sight. And that takes 
> unneeded time.
> 
> 
> I simple tried to mimick this scenario in the office, by 
> switching off an AP (just that I didn't really switch it off, 
> because the boot-times of Cisco-APs are soooooooo sloooooow).
> 
> About your "It's not actually the same": I think that my 
> laboratory experiment very well shows this behavior, e.g. see my 
> 2nd message with subject "Life-time of scan-results?":
> 
> 1253275108.958746: Trying to authenticate with 00:13:19:80:da:30 
> (SSID='MNHS' freq=2412 MHz)
> 
> Bit this is the "vanished" AP_OLD. With wireshark on a second 
> WLAN card I saw the attemps of mac80211 to associate to this 
> now-out-of-sight AP. This takes some tries from mac80211, then a 
> timeout on wpa_supplicant, than a new scan, then a new attempt. 
> All of those delays completely unnecessary if there would have 
> been a way to not get stale data via SCAN_DUMP.
> 
> 
> 
> So, clearly I have a visible problem and need to fix that.
> 
> I could fix that by making SCAN_TRIGGER always delete all stale 
> (cached) entries. Then I wouldn't need NL80211_ATTR_SCAN_EXPIRE.
> 
> However, a scan because "I want to look what is around" might be 
> different to a scan because "I need fresh data of APs around for 
> associating". And so I thought I make that configurable.
> 
> 
> I hope this now makes more sense.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

