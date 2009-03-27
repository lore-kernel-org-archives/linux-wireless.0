Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35134 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759403AbZC0OgN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 10:36:13 -0400
Date: Fri, 27 Mar 2009 11:36:08 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill-input: remove unused code
Message-ID: <20090327143608.GB24288@khazad-dum.debian.net> (sfid-20090327_153635_512916_55398CA9)
References: <1238159804.4452.4.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1238159804.4452.4.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 27 Mar 2009, Johannes Berg wrote:
> There's a lot of rfkill-input code that cannot ever be
> compiled and is useless until somebody needs and tests
> it -- therefore remove it.

Just so that you guys know, that code *is* tested :-)

I'd suggest that the code removal be done leaving a comment in place, like this:

/* Currently, code to implement EV_SW SW_WLAN/WWAN/BLUETOOTH/etc is not
 * in place since it was unused and was therefore removed.  Please look
 * at past history to check how it was supposed to be done, if you need
 * to implement handling for EV_SW.
 */

Because that codepath is _not_ the most obvious thing in the world to
reimplement without hitting a pitfall, so people better look how it was done
once in time...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
