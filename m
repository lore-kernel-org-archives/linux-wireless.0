Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:40905 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbZDPBMM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 21:12:12 -0400
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <Kalle.Valo@nokia.com>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <1239842656.25334.20.camel@johannes.local>
References: <1239837672.11795.46.camel@violet>
	 (sfid-20090416_012123_293746_81110E23)  <1239841291.25334.18.camel@johannes.local>
	 (sfid-20090416_022212_435684_EEC24EF6)  <1239842656.25334.20.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 03:12:05 +0200
Message-Id: <1239844325.11795.50.camel@violet> (sfid-20090416_031214_117620_3A83FBE3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > > After a long debugging session with Reinette we finally tracked down
> > > what is going on here. A full scan with this card takes 7-9 seconds and
> > > that seems to be too long and trigger IEEE80211_MONITORING_INTERVAL
> > > which then deauthenticates us with the AP (reason=6). 
> > 
> > Yeah, this is a bug. We analysed this problem a couple of days ago and I
> > thought Kalle was going to fix it -- maybe he forgot. I forgot what
> > exactly it was and how to fix it, hmm. Right now I'm confused and can't
> > seem to reproduce my analysis. I thought it had something to do with
> > using a different timer but we do seem to use the regular mgd.timer, so
> > I'm not sure.
> 
> Hmm. Can't seem to find what's going on -- can you enable
> CONFIG_MAC80211_VERBOSE_DEBUG and check for the beacon loss messages?

I did that already and yes, I see the beacon loss message. Increasing
IEEE80211_MONITORING_INTERVAL to 10 seconds fixes this, but that can't
be the real solution for it.

Also even when it deauth, it should then be able to authenticate and
associate again. If I end up in this situation basically only a reboot
fixes it.

Regards

Marcel


