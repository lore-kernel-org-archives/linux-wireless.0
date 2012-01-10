Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53272 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508Ab2AJRfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jan 2012 12:35:13 -0500
Subject: Re: [PATCHv2 2/2] mac80211: add support for mcs masks
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
In-Reply-To: <20120110172832.GA19790@pandem0nium>
References: <1325793490-21501-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1325793490-21501-3-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1326114294.3451.25.camel@jlt3.sipsolutions.net>
	 <20120110172832.GA19790@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Jan 2012 18:35:11 +0100
Message-ID: <1326216911.3438.11.camel@jlt3.sipsolutions.net> (sfid-20120110_183517_354212_642B8E52)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-01-10 at 18:28 +0100, Simon Wunderlich wrote:
> Hello Johannes,

> > All this logic is pretty complex, maybe we could translate the bitmap to
> > an array of unsigned longs and use test_bit() instead of open-coding it
> > for 8-bit words?
> 
> Mhm, I would rather not add further copies into this fast path function, and
> simply casting will result in bad behaviour (alignment, endianess). 

Well you don't want to copy it, you want to maintain the data that way,
I think? Ok I think I see -- you're concerned about the masking etc.
Dunno. Maybe at least there's a way to abstract out all the
calculations?

> Generally
> changing the mcs_mask to u32 is possible,

No, u64 might work today but maybe somebody will want to use higher
MCSes in the future?

johannes

