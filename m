Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37704 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab1KXNDv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 08:03:51 -0500
Subject: Re: mac80211: AP mode - question about Tx buffered unicast frames
 drop timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAFED-j=5-s7V9HZvYJDJ14KbVm+ioa=KnoBh1fj2ueT05QusTQ@mail.gmail.com> (sfid-20111123_193713_190763_C0FC3E1C)
References: <CAFED-j=5-s7V9HZvYJDJ14KbVm+ioa=KnoBh1fj2ueT05QusTQ@mail.gmail.com>
	 (sfid-20111123_193713_190763_C0FC3E1C)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Nov 2011 14:03:46 +0100
Message-ID: <1322139826.5366.2.camel@jlt3.sipsolutions.net> (sfid-20111124_140355_395612_F9278CAC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-23 at 19:36 +0100, Janusz Dziedzic wrote:
> Hello,
> 
> in sta_info.c I see function we call to remove expired unicast buffered frames.
> 
> sta_info_buffer_expired()
> {
> ...
> 	timeout = (sta->listen_interval *
> 		   sta->sdata->vif.bss_conf.beacon_int *
> 		   32 / 15625) * HZ;
> 	if (timeout < STA_TX_BUFFER_EXPIRE)
> 		timeout = STA_TX_BUFFER_EXPIRE;
> ...
> }
> 
> STA_TX_BUFFER_EXPIRE is define as 10 seconds.
> Do you remember why we set this as 10 seconds in case we calculate lower value?
> This "listen_interval" calculation seems to be correct.
> I found this during UAPSD debuging in AP mode.

I have no idea. It's probably just really old code. Now -- why would you
sleep for longer than 10 seconds? That's pretty bad user experience :)
But really, I don't know, and I wouldn't mind changing it either I
think.

johannes

