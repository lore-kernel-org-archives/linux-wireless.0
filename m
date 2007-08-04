Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50983 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815AbXHFIRI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 04:17:08 -0400
Subject: Re: [PATCH] mac80211: allow drivers to indicate failed FCS/PLCP   checksum
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <1186177475.13315.10.camel@johannes.berg>
References: <1186177475.13315.10.camel@johannes.berg>
Content-Type: text/plain
Date: Sat, 04 Aug 2007 09:53:23 +0200
Message-Id: <1186214003.21957.6.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-08-03 at 23:44 +0200, Johannes Berg wrote:

> --- mac80211.orig/net/mac80211/rx.c	2007-08-03 23:06:54.187869508 +0200
> +++ mac80211/net/mac80211/rx.c	2007-08-03 23:39:41.717869508 +0200
> @@ -155,6 +155,7 @@ ieee80211_rx_monitor(struct net_device *
>  		__le16 chan_freq;
>  		__le16 chan_flags;
>  		u8 antsignal;
> +		__le16 rx_flags;
>  	} __attribute__ ((packed)) *rthdr;

Oh. I overlooked the packed attribute there, this additional patch is
needed:

--- mac80211.orig/net/mac80211/rx.c     2007-08-03 23:06:54.187869508 +0200
+++ mac80211/net/mac80211/rx.c  2007-08-03 23:39:41.717869508 +0200
@@ -155,6 +155,7 @@ ieee80211_rx_monitor(struct net_device *
 		__le16 chan_freq;
 		__le16 chan_flags;
 		u8 antsignal;
+		u8 padding_for_rx_flags;
 		__le16 rx_flags;
 	} __attribute__ ((packed)) *rthdr;
 

(patch fabricated by hand so might not apply)

johannes

