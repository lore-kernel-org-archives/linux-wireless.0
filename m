Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36983 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3KRNBJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 08:01:09 -0500
Message-ID: <1384779666.17916.11.camel@jlt4.sipsolutions.net> (sfid-20131118_140113_784186_0A1BB6C6)
Subject: Re: [Query] Update mac80211 BSS info from cfg8011_bss_inform_frame
 when hw_scan is enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 18 Nov 2013 14:01:06 +0100
In-Reply-To: <CABPxzY+XHXCFpKxU1NPZzb4eXP7x8i0-89eE+7uxWqGKnNsePw@mail.gmail.com> (sfid-20131117_141416_294368_7F94FDA4)
References: <CABPxzYJAct6KtwqZY-DOgjf1wueSmeOU=iLku+gGeZ6ZVE6n9Q@mail.gmail.com>
	 <1384679792.14795.9.camel@jlt4.sipsolutions.net>
	 <CABPxzY+XHXCFpKxU1NPZzb4eXP7x8i0-89eE+7uxWqGKnNsePw@mail.gmail.com>
	 (sfid-20131117_141416_294368_7F94FDA4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-11-17 at 18:43 +0530, Krishna Chaitanya wrote:

> > You're not supposed to even call cfg80211_bss_inform_frame() from a
> > mac80211-based driver. Just report the RX frame properly.

> Ours is a partial Full MAC driver which still uses mac80211 but mostly with
> offloads to HW.
> 
> With mac80211 + hw_scan if we just report the RX frames, then we are just
> eliminating the SCAN SM from mac80211, is this just to reduce the host
> cycles? (apart from speeding up the channel switch)

When you post the driver for upstream we can talk about it. I have no
interest in it otherwise - but

 (a) you can't call cfg80211 from the driver and then have cfg80211 call
mac80211
     - that's a gross layering violation
 (b) if you're offloading much, you're probably not using a lot of
mac80211 and
     should come with a proposal to refactor the code

johannes

