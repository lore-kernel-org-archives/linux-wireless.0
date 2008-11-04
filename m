Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45420 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128AbYKDSUA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 13:20:00 -0500
Date: Tue, 4 Nov 2008 13:19:58 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: No ProbeResp - assume out of range
Message-ID: <20081104181958.GA22897@infradead.org> (sfid-20081104_192019_488276_E3185B64)
References: <43e72e890811021305k19e9a314i6400cd1a759b3d00@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890811021305k19e9a314i6400cd1a759b3d00@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 02, 2008 at 01:05:56PM -0800, Luis R. Rodriguez wrote:
> I'm curious if others are getting this frequently as I am:
> 
> No ProbeResp from current AP 00:DE:AD:BE:EE:FF - assume out of range
> 
> I get this with ath5k and ath9k, can be triggered easily in ath5k by
> doing a lot of consecutive:
> 
> iwlist wlan0 scan
> 
> I have to check if I can trigger this with ath9k by scanning too. We
> were seeing this with ath9k but were thinking it was ath9k related as
> it can be triggered on it after doing a large TX. Wondering if this is
> more of a generic and mac80211 issue.

I'm seeing this all the time with ath9k.  For now I'm running with the
following local hack:

Index: linux-2.6/net/mac80211/mlme.c
===================================================================
--- linux-2.6.orig/net/mac80211/mlme.c	2008-11-04 18:10:41.000000000 +0100
+++ linux-2.6/net/mac80211/mlme.c	2008-11-04 18:10:56.000000000 +0100
@@ -972,7 +972,7 @@ static void ieee80211_associated(struct 
 				       "current AP %s - assume out of "
 				       "range\n",
 				       sdata->dev->name, print_mac(mac, ifsta->bssid));
-				disassoc = 1;
+//				disassoc = 1;
 			} else
 				ieee80211_send_probe_req(sdata, ifsta->bssid,
 							 ifsta->ssid,

which makes the problem of an actual disassociation after this message
go away which made wireless completely unuseable with -rc3 for.  Given
that the message never appears a second time just increasing the time
it appears that just increasing IEEE80211_MONITORING_INTERVAL should
fix the problem, too.
