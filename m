Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:58096 "EHLO
	p15091797.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbXEAWkq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2007 18:40:46 -0400
Date: Wed, 2 May 2007 00:40:45 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: Jiri Benc <jbenc@suse.cz>
Cc: Daniel Drake <dsd@gentoo.org>, linville@tuxdriver.com,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] zd1211rw-mac80211: limit URB buffering in tx path
Message-ID: <20070501224045.GA26845@p15091797.pureserver.info>
References: <20070501030100.BDE3D7B409F@zog.reactivated.net> <20070501123411.081c43c6@logostar.upir.cz> <20070501195008.GA14294@p15091797.pureserver.info> <20070501231028.4cfa4053@logostar.upir.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070501231028.4cfa4053@logostar.upir.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07-05-01 23:10 Jiri Benc wrote:

> Really? From what you wrote ("if too many URBs are ready for submit") it
> seems that the code is triggered when the queue is just full. That's not
> necessarily an error condition and the only thing needed to do is to stop
> the queue. Unless zd1211 is really special here (and then I'd like to know
> how is it special).

Jiri, even if ZD1211B supports multiple queues, there is only one
USB endpoint receiving packets for transmission. I suppose that
the queue for the packet can be set in the control data for the
packet. However if the device doesn't read USB blocks anymore, all
queues will be affected. At this point in time I have to stop all
queues. Sure I could care for the different priorities of the
queues by stopping low-priority queues earlier, but if the user is
overloading the device, I have to stop all queues.

> If you support one queue only, call ieee80211_stop_queue(hw, 0). Calling
> ieee80211_stop_queues if you have just a full queue is wrong.

Again I don't just have a full queue, I cannot send any packets to
the device anymore. Under this condition I simply stop all queues,
not caring whether there are 1 or 1024. Sure with the explicit
knowledge that I have only one queue, I could stop it explicitly,
but this would require a change of the code as soon as a second
queue comes into play.

-- 
Uli Kunitz
