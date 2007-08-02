Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:57784
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbXHBLhh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 07:37:37 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [RFC V2] bcm43xx-mac80211: Provide information to allow  transmission rate decreases
Date: Thu, 2 Aug 2007 13:37:21 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <46b0f367.p35iGhSXwM+v4QLG%Larry.Finger@lwfinger.net> <200708021311.25033.mb@bu3sch.de> <1186053497.24230.27.camel@johannes.berg>
In-Reply-To: <1186053497.24230.27.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708021337.21285.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 02 August 2007 13:18:17 Johannes Berg wrote:
> On Thu, 2007-08-02 at 13:11 +0200, Michael Buesch wrote:
> 
> > We don't get a "I failed to transmit this" bit from the firmware,
> 
> Well, if you expect the frame to be acked then you do get a bit 'this
> frame was ever acked'

Yep, the problem is for frames that don't get acked.
If we just check the ack bit, rate control would throttle, just because
we sent unacked frames.
So if we didn't get an ack, we need to check if we failed, or if...
Oh, acutally. Why not simply check the noack bit in the tx_control... :)

-- 
Greetings Michael.
