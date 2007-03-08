Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:36284 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbXCHRed (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 12:34:33 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HPMTv-0005am-4U
	for linux-wireless@vger.kernel.org; Thu, 08 Mar 2007 12:32:47 -0500
Subject: Re: sparse using insane amounts of memory
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-sparse@vger.kernel.org
In-Reply-To: <1173372315.3248.19.camel@johannes.berg>
References: <1173319356.3546.54.camel@johannes.berg>
	 <1173371608.21465.12.camel@dv>  <1173372315.3248.19.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 12:34:30 -0500
Message-Id: <1173375270.15842.24.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-03-08 at 17:45 +0100, Johannes Berg wrote:
> and aborted when I got lots of errors, rt2400pci.i was created and has
> about 26k lines. Running sparse on it (sparse rt2400pci.i) takes a lot
> of memory too. I put the file up at
> http://johannes.sipsolutions.net/files/rt2400pci.i

FIELDS32 expands to some monstrosities.  Look for rt2x00_bbp_write in
the dump.  Also behold the amount of parentheses in LOWEST_BIT32.
That's almost certainly the culprit.

I understand the idea is to make gcc calculate integer logarithms at the
compile time.  That's nice, but sparse has to do the same, and it's
probably not optimized for such misuse.

-- 
Regards,
Pavel Roskin

