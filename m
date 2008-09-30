Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:38466 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446AbYI3Nz3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 09:55:29 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [RFC/T] b43: to few loop tries in do_dummy_tx
Date: Tue, 30 Sep 2008 15:54:55 +0200
Cc: gavron@wetwork.net, Peter Stuge <peter@stuge.se>,
	wireless <linux-wireless@vger.kernel.org>
References: <48E11F1E.50705@lwfinger.net> <200809301528.26304.mb@bu3sch.de> <48E22D9C.9090404@wetwork.net>
In-Reply-To: <48E22D9C.9090404@wetwork.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809301554.56361.mb@bu3sch.de> (sfid-20080930_155604_198723_436259AC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 30 September 2008 15:46:04 gavron@wetwork.net wrote:
> If I understand him correctly he's suggesting that there could be BETTER 
> values than those used by the reference driver.  In other words, yes, 
> B43/B43-Legacy are based on the RE of the Windows driver but perhaps 
> there are better values that improve behavior beyond that of the 
> original driver.

I doubt that very much. I think it's as simple as the udelay of the original
driver taking 1.2 microseconds and ours taking only 1.05 microseconds.
Both udelay implementations are valid, but ours uncovers the hidden bug.

-- 
Greetings Michael.
