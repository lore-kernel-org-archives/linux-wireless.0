Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41389 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539Ab2BYUM5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Feb 2012 15:12:57 -0500
Subject: Re: [RFC] carl9170: Fix memory accounting when sta is in
 power-save mode.
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20120225093243.GA4066@w1.fi>
References: <1330012414-26559-1-git-send-email-cavallar@lri.fr>
	 <201202231752.44125.chunkeey@googlemail.com> <4F46771F.9000200@lri.fr>
	 <201202231908.16364.chunkeey@googlemail.com> <4F468AC1.1050100@lri.fr>
	 <4F4791FC.9080707@lri.fr> <1330090741.3426.16.camel@jlt3.sipsolutions.net>
	 <4F479847.10906@lri.fr> <1330092542.3426.17.camel@jlt3.sipsolutions.net>
	 <20120225093243.GA4066@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 25 Feb 2012 21:12:52 +0100
Message-ID: <1330200772.3509.0.camel@jlt3.sipsolutions.net> (sfid-20120225_211331_415280_132CAF9F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-02-25 at 11:32 +0200, Jouni Malinen wrote:
> On Fri, Feb 24, 2012 at 03:09:02PM +0100, Johannes Berg wrote:
> > On Fri, 2012-02-24 at 15:01 +0100, Nicolas Cavallari wrote:
> > > Hostapd already does that¹ ... after the association response is acked.
> > 
> > Ok maybe then we should send out assoc resp etc. frames and not subject
> > them to PS queueing? Jouni?
> 
> We should try to follow the clarified description of management frame
> buffering in P802.11-REVmb/D12.0 (i.e., soon to be published IEEE Std
> 802.11-2012). (Re)Association Response frame is not a bufferable
> management frame and as such, it needs to be sent out without being
> subject to PS queuing.

Ah yes, you mentioned before that this was being clarified but I forgot
about it again. I'll take a look.

johannes


