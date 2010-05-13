Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:27241 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751294Ab0EMArS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 20:47:18 -0400
Received: from vs3017.wh2.ocn.ne.jp (125.206.180.250)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-033791634
	for <linux-wireless@vger.kernel.org>; Thu, 13 May 2010 09:47:16 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Benoit Papillault <benoit.papillault@free.fr>
Subject: Re: [PATCH v2] mac80211: Add HT IE to IBSS beacons and probe responses.
Date: Thu, 13 May 2010 09:47:07 +0900
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1273098986-19330-1-git-send-email-benoit.papillault@free.fr> <1273574892.3669.54.camel@jlt3.sipsolutions.net> <4BEB175F.7000001@free.fr>
In-Reply-To: <4BEB175F.7000001@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201005130947.07577.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 13 May 2010 06:02:23 Benoit Papillault wrote:
> > Also I just noticed that there's a TODO item in rx.c when we receive an
> > HT frame from a peer we don't know about yet. Not sure what to do there,
> > but you'll need to look at it.
> 
> I did some patch in this area in my tree. Basically, the peer STA is
> created only on beacon/probe response since only those frames contains
> peer capabilities. Any frames received before is simply ignored.

i think the same applies to non-HT. when we receive a frame from a STA we 
haven't seen a beacon from yet, we just mark the rate at which we received the 
frame and can use that for a reply. later, when we receive a beacon, the rate-
set is updated. i guess the same can be done for HT and i'd argue that it 
should be done like this in order to be able to communicate even though we 
have not received a beacon from that particular STA yet - there are some 
reasons why the beacon might not have reached us: 

 * the STA might have deferred beacon sending for a few intervals as part of 
the normal beacon backoff

 * the beacon might have been lost due to interference

 * or the other STA might be a buggy implementation which doesn't send IBSS 
beacons for a while, like some madwifi versions.

in any case the ability to communicate is more important than a complete rate-
set...

bruno
