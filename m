Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:20784 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbZAHSlE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 13:41:04 -0500
Received: by wf-out-1314.google.com with SMTP id 27so9395260wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2009 10:41:03 -0800 (PST)
Message-ID: <b6c5339f0901081041p3c9669f8ycd461b155da60f94@mail.gmail.com> (sfid-20090108_194121_518259_6A9DBCE4)
Date: Thu, 8 Jan 2009 13:41:03 -0500
From: "Bob Copeland" <bcopeland@gmail.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: [ath5k-devel] ath5k_tasklet_rx BUG_ON(bf->skb == NULL)
Cc: "Maxim Levitsky" <maximlevitsky@gmail.com>,
	linux-wireless@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>,
	ath5k-devel@venema.h4ckr.net
In-Reply-To: <Pine.LNX.4.64.0901081740350.19523@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <Pine.LNX.4.64.0901081318190.22793@blonde.anvils>
	 <1231426017.922.2.camel@maxim-laptop>
	 <Pine.LNX.4.64.0901081603410.8411@blonde.anvils>
	 <b6c5339f0901080910x3d3b5758mae4e81411dcf1405@mail.gmail.com>
	 <Pine.LNX.4.64.0901081740350.19523@blonde.anvils>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 8, 2009 at 12:55 PM, Hugh Dickins <hugh@veritas.com> wrote:
> Let me see if I can reproduce the ath5k BUG with a straightforward
> memhog, repeatedly dirtying more anon memory than RAM can provide.
> Is there something suitable I could run to exercise that wireless
> path concurrently?  It was just idling when I hit the BUGs before.

Receiving any packets will do it, in your case it was probably
beacons from nearby APs if you weren't using the wifi.  So iperf
or similar will work.

-- 
Bob Copeland %% www.bobcopeland.com
