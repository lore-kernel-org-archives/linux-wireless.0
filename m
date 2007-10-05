Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:60752
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615AbXJEOGt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2007 10:06:49 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211: What is get_sequence_counter?
Date: Fri, 5 Oct 2007 16:06:06 +0200
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
References: <200710051556.27401.mb@bu3sch.de> <1191593004.7367.32.camel@johannes.berg>
In-Reply-To: <1191593004.7367.32.camel@johannes.berg>
MIME-Version: 1.0
Message-Id: <200710051606.06382.mb@bu3sch.de> (sfid-20071005_150652_568327_6D83687B)
Content-Type: text/plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 05 October 2007 16:03:24 Johannes Berg wrote:
> On Fri, 2007-10-05 at 15:56 +0200, Michael Buesch wrote:
> > What is the get_sequence_counter callback for?
> > 
> > 	/* For devices that have internal sequence counters, allow 802.11
> > 	 * code to access the current value of a counter */
> > 	int (*get_sequence_counter)(struct ieee80211_hw *hw,
> > 				    u8* addr, u8 keyidx, u8 txrx,
> > 				    u32* iv32, u16* iv16);
> > 
> > It doesn't seem to be used in current mac80211 code.
> > It seems that this is to fetch the current initial values.
> > Is that correct?
> > Who is supposed to use this callback? If it's unused, let's remove
> > it please. The documentation for it sucks anyway. :)
> 
> No, it's actually used in a patch I'm about to post:
> http://johannes.sipsolutions.net/patches/kernel/all/2007-09-28-22%3a38/017-mac80211-key-seq-nl80211.patch
> 
> Mind you, it could be renamed and described better; it's used for
> getting the current sequence number of a hardware TKIP implementation.

Ah, ok. It sounded to me like it's supposed to fetch the
seq_ctrl counter (data header), if the device does frame sequence
counting in hw.
Can you please rename that to something like
get_tkip_ivs() or
get_tkip_counters()
or something like that?

-- 
Greetings Michael.
