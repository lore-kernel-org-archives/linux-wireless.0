Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:60643 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755843AbZJZMTB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 08:19:01 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix for incorrect sequence number on hostapd injected frames
Date: Mon, 26 Oct 2009 13:18:50 +0100
Cc: =?utf-8?q?Bj=C3=B6rn_Smedman?= <bjorn.smedman@venatech.se>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <j@w1.fi>, Joerg Pommnitz <pommnitz@yahoo.com>,
	Will Dyson <will.dyson@gmail.com>
References: <133e8d7e0910241155x4496b156p3c5d03450a71936a@mail.gmail.com> <1256497156.28230.0.camel@johannes.local>
In-Reply-To: <1256497156.28230.0.camel@johannes.local>
MIME-Version: 1.0
Message-Id: <200910261318.52570.mb@bu3sch.de>
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 25 October 2009 19:59:16 Johannes Berg wrote:
> On Sat, 2009-10-24 at 20:55 +0200, Björn Smedman wrote:
> > When hostapd injects a frame, e.g. an authentication or association
> > response, mac80211 looks for a suitable access point virtual interface
> > to associate the frame with based on its source address. This makes it
> > possible e.g. to correctly assign sequence numbers to the frames.
> > 
> > A small typo in the ethernet address comparison statement caused a
> > failure to find a suitable ap interface. Sequence numbers on such
> > frames where therefore left unassigned causing some clients
> > (especially windows-based 11b/g clients) to reject them and fail to
> > authenticate or associate with the access point. This patch fixes the
> > typo in the address comparison statement.
> > 
> > Signed-off-by: Björn Smedman <bjorn.smedman@venatech.se>
> 
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
> 
> and Cc: stable@kernel.org I think
> 
> > ---
> > diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> > index db4bda6..eaa4118 100644
> > --- a/net/mac80211/tx.c
> > +++ b/net/mac80211/tx.c
> > @@ -1445,7 +1445,7 @@ static void ieee80211_xmit(struct
> > ieee80211_sub_if_data *sdata,
> >                                 if (tmp_sdata->vif.type != NL80211_IFTYPE_AP)
> >                                         continue;
> >                                 if (compare_ether_addr(tmp_sdata->dev->dev_addr,
> > -                                                      hdr->addr2)) {
> > +                                                      hdr->addr2) == 0) {
> >                                         dev_hold(tmp_sdata->dev);
> >                                         dev_put(sdata->dev);
> >                                         sdata = tmp_sdata;
> > 
> 
> 

The following patch cleanly applies to 2.6.31.5-stable and is tested.

Index: linux-2.6.31/net/mac80211/tx.c
===================================================================
--- linux-2.6.31.orig/net/mac80211/tx.c	2009-10-26 09:15:20.000000000 +0100
+++ linux-2.6.31/net/mac80211/tx.c	2009-10-26 09:16:35.000000000 +0100
@@ -1478,7 +1478,7 @@
 				if (sdata->vif.type != NL80211_IFTYPE_AP)
 					continue;
 				if (compare_ether_addr(sdata->dev->dev_addr,
-						       hdr->addr2)) {
+						       hdr->addr2) == 0) {
 					dev_hold(sdata->dev);
 					dev_put(odev);
 					osdata = sdata;


-- 
Greetings, Michael.
