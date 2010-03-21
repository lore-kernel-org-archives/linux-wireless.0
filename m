Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43800 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659Ab0CUCBX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Mar 2010 22:01:23 -0400
Received: by gyg8 with SMTP id 8so2130338gyg.19
        for <linux-wireless@vger.kernel.org>; Sat, 20 Mar 2010 19:01:22 -0700 (PDT)
From: Bruno Randolf <randolf.bruno@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH V2] mac80211: Revise,pending queue depth in ieee80211_local data structure
Date: Sun, 21 Mar 2010 11:01:16 +0900
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	randolf.bruno@googlemail.com, linux-wireless@vger.kernel.org
References: <4BA24A12.4030208@gmail.com> <f74418681003201302g3ed2902bp230a1ce93d165831@mail.gmail.com> <1269117605.4611.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1269117605.4611.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201003211101.16481.randolf.bruno@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 21 March 2010 05:40:05 Johannes Berg wrote:
> On Sat, 2010-03-20 at 21:02 +0100, Lorenzo Bianconi wrote:
> > >> setup 2 wireless cards, talking to each other (i use IBSS) on
> > >> different
> > 
> > >> machines. then setup routing like this:
> > PC1<--ethernet cable-->Device1<--wireless link-->Device2<--ethernet
> > cable-->PC2
> 
> I'm not really sure how this scenario differs from injecting traffic
> locally, but I'll try to reproduce.

if you generate traffic locally it's enough to stop the queues, this will 
cause userspace to stop generating traffic. in the forwarding case (which we 
are talking about) stopping the queues will not stop the sender to send 
traffic, thus we have to start dropping packets at some point. 

bruno
