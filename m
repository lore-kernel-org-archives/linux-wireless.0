Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:53192 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757015Ab1CDRLp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 12:11:45 -0500
Received: by mail-wy0-f177.google.com with SMTP id 23so2419108wyf.36
        for <linux-wireless@vger.kernel.org>; Fri, 04 Mar 2011 09:11:42 -0800 (PST)
Subject: Re: Powersave broken on p54
From: Luciano Coelho <coelho@ti.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1299222198.7039.111.camel@cumari>
References: <1299003142.6461.12.camel@maggie>
	 <201103021813.52719.chunkeey@googlemail.com>
	 (sfid-20110302_181438_600050_FFFFFFFF80E6967A)  <1299086257.13604.17.camel@marge>
	 <1299222198.7039.111.camel@cumari>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 19:11:41 +0200
Message-ID: <1299258701.1824.4.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-03-04 at 09:03 +0200, Luciano Coelho wrote:
> On Wed, 2011-03-02 at 18:17 +0100, Michael Buesch wrote:
> > On Wed, 2011-03-02 at 18:13 +0100, Christian Lamparter wrote:
> > > sure there was the rssi->dbm update (I hope you've already updated
> > > your eeprom image.)
> > 
> > What change to the eeprom is needed? My eeprom doesn't
> > contain any rssi info (see recent NULL ptr fix).
> > 
> > > No idea, it looks like the ps-poll is broken, because
> > > "iwconfig wlanX power timeout 10" fixes the long delays
> > > almost immediately. [let's see if there's more]
> > 
> > So maybe it's a generic mac80211 bug? Are there other
> > devices with PS issues?
> 
> We have been having some problems with PSM on the wl12xx driver too.  It
> seems that it broke in the past couple of weeks as well.  So this is
> most likely a problem in mac80211.  I'll try to investigate this a bit
> more too.

I've been investigating this problem a bit more and it seems that the
symptom, at least, is that when we receive data with the
more-data-buffered flag set, we immediately send a PS-poll which enables
PS mode again.  My guess is that it shouldn't send PS-poll but a
null-frame with PS mode off.

I still need to refresh my PSM knowledge a bit more before I can
continue studying this. ;)


-- 
Cheers,
Luca.

