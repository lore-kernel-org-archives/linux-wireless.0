Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49966 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbZGWSRR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 14:17:17 -0400
Date: Thu, 23 Jul 2009 14:17:16 -0400
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Fabio Rossi <rossi.f@inwind.it>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: WARNING: at net/mac80211/tx.c:561
Message-ID: <20090723181716.GA26729@bombadil.infradead.org>
References: <200907230051.57201.rossi.f@inwind.it> <200907231907.47751.rossi.f@inwind.it> <43e72e890907231021m46139567s3de4ed4cc2812938@mail.gmail.com> <200907231928.44337.rossi.f@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <200907231928.44337.rossi.f@inwind.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 23, 2009 at 07:28:44PM +0200, Fabio Rossi wrote:
> On Thursday 23 July 2009, Luis R. Rodriguez wrote:
> 
> > On Thu, Jul 23, 2009 at 10:07 AM, Fabio Rossi<rossi.f@inwind.it> wrote:
> > > On Thursday 23 July 2009, Luis R. Rodriguez wrote:
> > >> On Wed, Jul 22, 2009 at 3:51 PM, Fabio Rossi<rossi.f@inwind.it> wrote:
> > >> > I'm using the last wireless-testing.git and I have experienced the
> > >> > following WARNING:
> > >> >
> > >> >  WARNING: at net/mac80211/tx.c:561
> > >> > ieee80211_tx_h_rate_ctrl+0x3d1/0x470 [mac80211]()
> > >>
> > >> Please try a git pull
> > >
> > > I was already working with the latest release:
> > >  v2.6.31-rc3-28452-g5bfcdb0
> > > so I confirm that I get the warning quite often (every 15 seconds).
> >
> > What channel is your AP on?
> > Is your AP 00:0c:f6:xx:xx:xx ?
> 
> Yes, that is my AP configured on channel 8 (Frequency 2.447 GHz):
> 
>           Cell 05 - Address: 00:0C:F6:xx:xx:xx
>                     Channel:8
>                     Frequency:2.447 GHz (Channel 8)
>                     Quality=48/70  Signal level=-62 dBm
>                     Encryption key:on
>                     ESSID:""
>                     Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s
>                     Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s
>                               36 Mb/s; 48 Mb/s; 54 Mb/s
>                     Mode:Master
>                     Extra:tsf=000000007803aa0c
>                     Extra: Last beacon: 4352ms ago
>                     IE: Unknown: 0000
>                     IE: Unknown: 010482848B96
>                     IE: Unknown: 030108
>                     IE: Unknown: 050400010000
>                     IE: Unknown: 2A0104
>                     IE: Unknown: 32080C1218243048606C
>                     IE: Unknown: DD07000C4301000000

It is as I suspected, a real WARNING for a bug in mac80211, we should
not be sending frames on 5 GHz onyour 2.4 GHz AP.

Please try this patch:

From: Luis R. Rodriguez <lrodriguez@atheros.com>
Subject: [PATCH] mac80211: do not trigger beacon work if scanning

We were issues probe requests to the associated AP on the wrong
band. This leads to finding not bitrate. We should not be doing
this, so prevent the timer from stuffing beacon loss work on
the mac80211 workqueue.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/mlme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 523c0d9..e90992e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2187,7 +2187,7 @@ static void ieee80211_sta_bcn_mon_timer(unsigned long data)
 		(struct ieee80211_sub_if_data *) data;
 	struct ieee80211_local *local = sdata->local;
 
-	if (local->quiescing)
+	if (local->quiescing || local->sw_scanning || local->hw_scanning)
 		return;
 
 	queue_work(sdata->local->hw.workqueue,
-- 
1.6.3.3

