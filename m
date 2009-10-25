Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:46591 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbZJYUTf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2009 16:19:35 -0400
MIME-Version: 1.0
In-Reply-To: <4AE3431C.2000201@wpkg.org>
References: <4AD21AB4.6010208@wpkg.org> <4AE1AC69.7010904@wpkg.org>
	 <69e28c910910230621j2176813dpe7f77b7dff5b1b44@mail.gmail.com>
	 <4AE1AE74.4020600@wpkg.org> <4AE2EC3E.3000503@wpkg.org>
	 <20091024125217.GA31897@hash.localnet> <4AE31CFC.1080803@wpkg.org>
	 <20091024160938.GC31897@hash.localnet> <4AE3431C.2000201@wpkg.org>
Date: Sun, 25 Oct 2009 16:19:39 -0400
Message-ID: <b6c5339f0910251319u2fc0180cjba1df3006ede92f5@mail.gmail.com>
Subject: Re: ath5k AP kernel panic when client uses SCP
From: Bob Copeland <me@bobcopeland.com>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org, linux-net@vger.kernel.org,
	linux-mips@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 24, 2009 at 2:10 PM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> Bob Copeland wrote:

> Here is everything the system said after being powered on, including all
> page allocation failures and the final oops:
>
> http://www1.wpkg.org/skb_gso_segment/minicom.txt
>
> (and it looks slightly different than the last time).

In this case an order-0 allocation failed inside ieee80211_skb_resize,
which then called dev_release_skb() on the original skb.  Off the top
of my head, it's unclear why the subsequent put_page would cause a fault.

This is a little out of my area so take it with a grain of salt :) but
in general order-0 allocation failures are bad news -- it couldn't get
a single free page, and that happened in under 3 minutes.  Maybe poke
around in /proc/slabinfo to see where the memory went?

-- 
Bob Copeland %% www.bobcopeland.com
