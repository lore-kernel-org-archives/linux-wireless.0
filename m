Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:35473 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756026Ab2BYKez (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Feb 2012 05:34:55 -0500
Date: Sat, 25 Feb 2012 11:32:43 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] carl9170: Fix memory accounting when sta is in power-save
 mode.
Message-ID: <20120225093243.GA4066@w1.fi> (sfid-20120225_113526_737851_1EFE9C3D)
References: <1330012414-26559-1-git-send-email-cavallar@lri.fr>
 <201202231752.44125.chunkeey@googlemail.com>
 <4F46771F.9000200@lri.fr>
 <201202231908.16364.chunkeey@googlemail.com>
 <4F468AC1.1050100@lri.fr>
 <4F4791FC.9080707@lri.fr>
 <1330090741.3426.16.camel@jlt3.sipsolutions.net>
 <4F479847.10906@lri.fr>
 <1330092542.3426.17.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1330092542.3426.17.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 24, 2012 at 03:09:02PM +0100, Johannes Berg wrote:
> On Fri, 2012-02-24 at 15:01 +0100, Nicolas Cavallari wrote:
> > Hostapd already does that¹ ... after the association response is acked.
> 
> Ok maybe then we should send out assoc resp etc. frames and not subject
> them to PS queueing? Jouni?

We should try to follow the clarified description of management frame
buffering in P802.11-REVmb/D12.0 (i.e., soon to be published IEEE Std
802.11-2012). (Re)Association Response frame is not a bufferable
management frame and as such, it needs to be sent out without being
subject to PS queuing.

-- 
Jouni Malinen                                            PGP id EFC895FA
