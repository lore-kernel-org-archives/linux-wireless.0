Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:58920 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab2AQOBD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 09:01:03 -0500
Date: Tue, 17 Jan 2012 15:00:09 +0100
From: Antonio Quartulli <ordex@autistici.org>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCHv3 2/2] mac80211: in IBSS use the Auth frame to trigger
 STA reinsertion
Message-ID: <20120117140008.GA2272@ritirata.org> (sfid-20120117_150107_545488_1462B60A)
References: <1326737526-29750-1-git-send-email-ordex@autistici.org>
 <4F157505.3060306@lri.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4F157505.3060306@lri.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nicolas and thank you for testing my patch!

On Tue, Jan 17, 2012 at 02:17:57 +0100, Nicolas Cavallari wrote:
> I tested your patch, but quickly run into a race condition where i would
> get Auth frame multiplication.
> 
> The worst case apparently happen when A boots for the first time and the
> first message that B receives is an Auth frame.  In that case, there are
> several ieee80211_ibss_add_sta() calls running concurrently on B  (A and
> B are SMP systems)  but only one succeeds,  except that your patch sends
> Auth frames before the check, so B sends several Auth frames to A.
> 
> Then A proceed to reset B.  After A deletes B's sta_info,  but before
> it reinserts it, some other code (ieee80211_ibss_rx_no_sta?) may call
> ieee80211_ibss_add_sta()  concurrently,  sending more Auth frames...
> increasing the odds of another race condition...

Thank you for debugging and having found the problem. Weird that I haven't seen
it before.

> 
> By calling send_auth only when sta_info_insert_rcu() succeeds, i'm no
> longer able to reproduce the Auth flood.

Sounds like a good hint. Better to send the auth frame only if we have already added
the new station to the list.

I will fix it in the next version

Regards,

-- 
Antonio Quartulli

..each of us alone is worth nothing..
Ernesto "Che" Guevara
