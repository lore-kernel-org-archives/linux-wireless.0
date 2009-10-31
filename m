Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:49285 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbZJaJCH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 05:02:07 -0400
Received: by ewy28 with SMTP id 28so3641521ewy.18
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2009 02:02:11 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: ieee80211_tx_status: headroom too small
Date: Sat, 31 Oct 2009 09:59:42 +0100
Cc: Nikolai ZHUBR <zhubr@mail.ru>, linux-wireless@vger.kernel.org
References: <1094614475.20091030230028@mail.ru> <200910310951.30016.IvDoorn@gmail.com> <1256979370.3555.91.camel@johannes.local>
In-Reply-To: <1256979370.3555.91.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200910310959.43260.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 31 October 2009, Johannes Berg wrote:
> On Sat, 2009-10-31 at 09:51 +0100, Ivo van Doorn wrote:
> 
> > > Ok. I looked at the problem and it's a very odd problem -- mac80211
> > > should always reserve enough headroom in buffers it passes to the
> > > driver. Does rt61pci somehow realloc frames?
> > 
> > It does use skb_push. but will/should always stay within the limits
> > of rt2x00dev->hw->extra_tx_headroom. Although I just realize there
> > might be a situation where it needs to align the frame to a 4-byte boundary,
> > it could exceed that amount. :(
> 
> extra_tx_headroom is set to max_t(driver, mac80211) so that there's
> always some headroom. This doesn't take into account alignment though.
> Should we simply add 2 to that value?

4 actually, wasn't there some cases where the header could have an odd
number of bytes and would require 3 bytes for alignment?

Ivo
