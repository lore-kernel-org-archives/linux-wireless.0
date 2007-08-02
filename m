Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41420
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbXHBNEJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 09:04:09 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [RFC V2] bcm43xx-mac80211: Provide information to allow  transmission rate decreases
Date: Thu, 2 Aug 2007 15:03:53 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <46b0f367.p35iGhSXwM+v4QLG%Larry.Finger@lwfinger.net> <200708021337.21285.mb@bu3sch.de> <1186055319.24230.32.camel@johannes.berg>
In-Reply-To: <1186055319.24230.32.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708021503.53982.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 02 August 2007 13:48:39 Johannes Berg wrote:
> On Thu, 2007-08-02 at 13:37 +0200, Michael Buesch wrote:
> 
> > If we just check the ack bit, rate control would throttle, just because
> > we sent unacked frames.
> 
> Ah but rate control shouldn't actually care about frames that we never
> expected an ACK for since there's no way to know for those anyway. So
> IMHO the rate control algorithm shouldn't even be called for those
> frames.
> 
> > So if we didn't get an ack, we need to check if we failed, or if...
> > Oh, acutally. Why not simply check the noack bit in the tx_control... :)
> 
> Works too, but it seems mac80211 should do that.

So, what's the point of this "excessive retries" field anyway?
We already have an "acked" bit. So if it's not set, but we expected an
ack, what's the point of setting excessive retries in the driver?
the rc algo sould know _anyway_, as it has the "acked" and the
"we wanted to have an ack" bits.

confused..

-- 
Greetings Michael.
