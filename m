Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65020 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539Ab2BYUUH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Feb 2012 15:20:07 -0500
Received: by eekc41 with SMTP id c41so183965eek.19
        for <linux-wireless@vger.kernel.org>; Sat, 25 Feb 2012 12:20:05 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] carl9170: Fix memory accounting when sta is in power-save mode.
Date: Sat, 25 Feb 2012 21:20:01 +0100
Cc: Jouni Malinen <j@w1.fi>,
	Nicolas Cavallari <Nicolas.Cavallari@lri.fr>,
	linux-wireless@vger.kernel.org
References: <1330012414-26559-1-git-send-email-cavallar@lri.fr> <20120225093243.GA4066@w1.fi> <1330200772.3509.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1330200772.3509.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201202252120.01430.chunkeey@googlemail.com> (sfid-20120225_212012_790796_FCB44B4B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 25 February 2012 21:12:52 Johannes Berg wrote:
> On Sat, 2012-02-25 at 11:32 +0200, Jouni Malinen wrote:
> > On Fri, Feb 24, 2012 at 03:09:02PM +0100, Johannes Berg wrote:
> > > On Fri, 2012-02-24 at 15:01 +0100, Nicolas Cavallari wrote:
> > > > Hostapd already does that¹ ... after the association response is acked.
> > > 
> > > Ok maybe then we should send out assoc resp etc. frames and not subject
> > > them to PS queueing? Jouni?
> > 
> > We should try to follow the clarified description of management frame
> > buffering in P802.11-REVmb/D12.0 (i.e., soon to be published IEEE Std
> > 802.11-2012). (Re)Association Response frame is not a bufferable
> > management frame and as such, it needs to be sent out without being
> > subject to PS queuing.
> 
> Ah yes, you mentioned before that this was being clarified but I forgot
> about it again. I'll take a look.
> 
Actually, I think I found the problem in carl9170 [writing a patch atm].
[I forgot to check IEEE80211_TX_CTL_POLL_RESPONSE and
IEEE80211_TX_CTL_CLEAR_PS_FILT flags].

[A simple fix: we could set something like TX_CTL_IGNORE_PS  
(now known as TX_CTL_POLL_RESPONSE) on outgoing
auth & (re-)assoc frames] 

Regards,
	Chr
