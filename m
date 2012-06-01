Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758373Ab2FAJNa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2012 05:13:30 -0400
Date: Fri, 1 Jun 2012 11:12:51 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jean-Pierre TOSONI <jp.tosoni@acksys.fr>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: mac80211/scan.c: scanning ceases after a double rescheduling
Message-ID: <20120601091250.GA30893@redhat.com> (sfid-20120601_111348_165643_ED849459)
References: <773DB8A82AB6A046AE0195C68612A319012CA1B7@sbs2003.acksys.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <773DB8A82AB6A046AE0195C68612A319012CA1B7@sbs2003.acksys.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 31, 2012 at 06:39:51PM +0200, Jean-Pierre TOSONI wrote:
> Hello all,
> 
> I am using compat-wireless-2012-04-17 in a OpenWrt box, client mode,
> kernel 2.6.33.
> I arrange to run an active background scan every second under some load
> (iperf UDP 40 Mbps).
> 
> I observed that the probes can be delayed due to two events flagged as
> IEEE80211_STA_BEACON_POLL and IEEE80211_STA_CONNECTION_POLL. They make
> __ieee80211_start_scan() return early in mac80211/scan.c when it is
> called by ieee80211_request_scan().
> 
> When one of these events occurs, the function returns and
> __ieee80211_start_scan() is reentered later, called this time by
> ieee80211_scan_work(). Now if it finds the other event flagged, it
> returns early but will never be called again. As a result later scan
> requests result in a "EBUSY" error.
> 
> I made a workaround by always returning an error, but I am pretty sure
> this is a wrong solution. I wonder if scan_work should not be
> rescheduled in this case.

I posted fix here:

http://marc.info/?l=linux-wireless&m=133717501822158&w=2

It is needed for 3.5 and it is still not appied in wireless-testing ...

Stanislaw
