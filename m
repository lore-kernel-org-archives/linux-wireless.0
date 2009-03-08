Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.186]:54279 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbZCHNEv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Mar 2009 09:04:51 -0400
Received: by ti-out-0910.google.com with SMTP id d10so814867tib.23
        for <linux-wireless@vger.kernel.org>; Sun, 08 Mar 2009 06:04:47 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18867.49758.741918.767411@gargle.gargle.HOWL> (sfid-20090308_140500_965556_42092502)
Date: Sun, 8 Mar 2009 18:34:30 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@Atheros.com
Subject: Re: [PATCH] mac80211: Update IBSS beacon timestamp properly
In-Reply-To: <1236516770.4205.17.camel@johannes.local>
References: <18860.46550.551064.448896@gargle.gargle.HOWL>
	<1236516770.4205.17.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Tue, 2009-03-03 at 10:15 +0530, Sujith wrote:
> > In IBSS mode, the beacon timestamp has to be filled with the
> > BSS's timestamp when joining, and set to zero when creating
> > a new BSS.
> 
> I don't quite understand why, do we read it out again at any point?
> 

Drivers do, when they do a beacon_get(). And the timestamp in the
beacon is used to calculate TBTT.

Sujith
