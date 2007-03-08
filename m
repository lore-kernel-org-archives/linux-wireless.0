Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.225]:6079 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbXCHSIz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 13:08:55 -0500
Received: by wx-out-0506.google.com with SMTP id h31so597912wxd
        for <linux-wireless@vger.kernel.org>; Thu, 08 Mar 2007 10:08:55 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: sparse using insane amounts of memory
Date: Thu, 8 Mar 2007 19:08:40 +0100
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	linux-sparse@vger.kernel.org
References: <1173319356.3546.54.camel@johannes.berg> <1173375270.15842.24.camel@dv> <1173375791.3248.37.camel@johannes.berg>
In-Reply-To: <1173375791.3248.37.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703081908.40997.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 08 March 2007 18:43, Johannes Berg wrote:
> On Thu, 2007-03-08 at 12:34 -0500, Pavel Roskin wrote:
> 
> > FIELDS32 expands to some monstrosities.  Look for rt2x00_bbp_write in
> > the dump.  Also behold the amount of parentheses in LOWEST_BIT32.
> > That's almost certainly the culprit.
> 
> And I even had CONFIG_RT2X00_DEBUG enabled so it's worse that the
> regular case.

Those checks are intended to doublecheck the register FIELD{16,32}
defines. Since all register definitions were rewritten from the legacy driver,
(legacy driver used unions and structs for all registers) some of those
defines weren't done correctly (A bitmask could for example be in binary 000110111
which is very wrong).

To check those the register checks were added to ensure the register defines
were at least correct. I am however open to suggestions on how this should be improved
and cleaned up, since it is not my favorite piece of code. ;)

Ivo
