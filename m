Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43805 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab1CUS4l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 14:56:41 -0400
Subject: Re: Logs spammed by brcm80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <op.vspg80mq3ri7v4@arend-laptop>
References: <4D878FBC.5010204@lwfinger.net> <op.vspg80mq3ri7v4@arend-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Mar 2011 19:56:34 +0100
Message-ID: <1300733794.3804.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-21 at 19:51 +0100, Arend van Spriel wrote:
> On Mon, 21 Mar 2011 18:49:48 +0100, Larry Finger  
> <Larry.Finger@lwfinger.net> wrote:
> 
> > With both BCM4313 and BCM943224 cards, brcm80211 spams my logs with  
> > messages:
> >
> > wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen 159/256 dur  
> > 1778/1504
> > wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen 137/256 dur  
> > 1602/1504
> > wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen 382/256 dur  
> > 3562/1504
> 
> This actually means that mac80211 is giving us transmit packets which  
> violate the txop duration. I am not sure whether this is actually true or  
> we did not honour the conf_tx callback. I think we should put this one on  
> our todo list.

Are you saying you expect mac80211 to fragment packets that don't fit
into a txop? That's not done for sure.

johannes

