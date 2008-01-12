Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:55397 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbYALCpV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 21:45:21 -0500
Date: Fri, 11 Jan 2008 18:44:00 -0800
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: channel utilisation short/long hdr?
Message-ID: <20080112024400.GC12245@jm.kir.nu> (sfid-20080112_024528_430822_67790986)
References: <1199922658.3861.40.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1199922658.3861.40.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 10, 2008 at 12:50:58AM +0100, Johannes Berg wrote:
> What's the meaning of these defines?
> 
> #define CHAN_UTIL_HDR_LONG (202 * CHAN_UTIL_PER_USEC)
> #define CHAN_UTIL_HDR_SHORT (40 * CHAN_UTIL_PER_USEC)
> 
> I can't figure out what the values 202 and 40 are.

Hmm.. I thought I had filtered out the channel use estimation code from
the original release since I did not see much use for this and the
values were not exactly valid in many cases.. ;-). 

This code is almost five years old and maybe not so surprisingly, I
don't remember the exact details anymore.. Since these are use as
"hdrtime", I would assume they were derived using following calculation:

CHAN_UTIL_HDR_LONG: assume 802.11b with long preamble:
aSIFSTime (10 usec) + aPreambleLength (144 usec) + aPLCPHeaderLength (48
usec) = 202 usec

CHAN_UTIL_HDR_SHORT: assume OFDM:

aSIFSTime (+ signal ext in case of 802.11g; 16 usec) + preamble (16
usec) + signal (4 usec) = 36 usec; add one symbol time (4 usec) for
some reason (or a sign of someone not knowing how to add small
numbers together.. ;-), I don't remember anymore and cannot figure out
this without wasting way too much time..)

> And probably related, what does it mean for a bitrate to be an "ERP
> rate"? Does that just mean it's an OFDM bitrate?

That would be any rate using Extended Rate PHY (ERP; 802.11 Clause 19).
This is not necessarily OFDM (it could also be using PBCC modulation).
In practice, I would expect the kernel side implementation to use this
in anything PHY related as ERP-OFDM (i.e., it may not support optional
PBCC rates). The association and beacon/probe processing may be more
generic to any ERP rate. I don't think ERP-PBCC is very commonly used,
so this may be more on the theoretical side..

-- 
Jouni Malinen                                            PGP id EFC895FA
