Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2230 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756299AbXGEODk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2007 10:03:40 -0400
Date: Thu, 5 Jul 2007 09:57:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Jon Smirl <jonsmirl@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: Multiple interfaces in mac80211
Message-ID: <20070705135748.GA7272@tuxdriver.com>
References: <9e4733910707041723g6f7a535ap1a62dd4473484d40@mail.gmail.com> <200707042305.40944.flamingice@sourmilk.net> <1ba2fa240707050530q2d165232raa73455397546c62@mail.gmail.com> <1183638845.3818.34.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1183638845.3818.34.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 05, 2007 at 02:34:05PM +0200, Johannes Berg wrote:
> On Thu, 2007-07-05 at 15:30 +0300, Tomas Winkler wrote:
> > Does anybody have/ think of a patch that removes the master interface
> > from the sub_if_list. It slows down the receive path.
> 
> Actually, we want to get rid of it completely. The missing piece to that
> is decoupling qdiscs from netdevs.

Actually, the new multiqueue stuff should enable us to get rid of the
master interface.  The queueing currently associated with the master
interface should look like hardware queueing to the networking core.
The fact that it is implemented in software is just an implementation
detail.

John
-- 
John W. Linville
linville@tuxdriver.com
