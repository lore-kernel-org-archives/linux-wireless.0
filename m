Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:61125 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213AbZJaIva (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 04:51:30 -0400
Received: by ewy28 with SMTP id 28so3638675ewy.18
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2009 01:51:33 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: ieee80211_tx_status: headroom too small
Date: Sat, 31 Oct 2009 09:51:29 +0100
Cc: Nikolai ZHUBR <zhubr@mail.ru>, linux-wireless@vger.kernel.org
References: <1094614475.20091030230028@mail.ru> <7111590175.20091031005644@mail.ru> <1256967967.3555.71.camel@johannes.local>
In-Reply-To: <1256967967.3555.71.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200910310951.30016.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 31 October 2009, Johannes Berg wrote:
> On Sat, 2009-10-31 at 00:56 +0300, Nikolai ZHUBR wrote:
> > Friday, October 30, 2009, 11:59:01 PM, Johannes Berg wrote:
> > >>
> > >> ieee80211_tx_status: headroom too small
> > 
> > > What driver are you using?
> > 
> > Ah, sorry, forgot to mention. It is rt61pci (RaLink mini-PCI card)
> 
> Ok. I looked at the problem and it's a very odd problem -- mac80211
> should always reserve enough headroom in buffers it passes to the
> driver. Does rt61pci somehow realloc frames?

It does use skb_push. but will/should always stay within the limits
of rt2x00dev->hw->extra_tx_headroom. Although I just realize there
might be a situation where it needs to align the frame to a 4-byte boundary,
it could exceed that amount. :(

Ivo
