Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:10407 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbYLCCOX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 21:14:23 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1560444wah.21
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 18:14:23 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18741.60148.86455.854634@localhost.localdomain> (sfid-20081203_031427_176611_B79936DC)
Date: Wed, 3 Dec 2008 07:42:04 +0530
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@atheros.com, Luis.Rodriguez@atheros.com,
	Senthilkumar.Balasubramanian@atheros.com
Subject: Re: [PATCH] ath9k: Use GFP_ATOMIC when allocating private area
In-Reply-To: <43e72e890812021809h3bc371d0t23e1c14d79a36617@mail.gmail.com>
References: <18741.12999.753996.233483@gargle.gargle.HOWL>
	<43e72e890812021614i103235few3a19721c6ca1d0cc@mail.gmail.com>
	<18741.59362.77483.600612@localhost.localdomain>
	<43e72e890812021809h3bc371d0t23e1c14d79a36617@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> Interesting, I hadn't thought about stopping the queues, when would
> they be resumed then though, or rather who? I'll a rework of this
> ontop of more DMA fun, let me know what you think. I just tested this.
> 

In TX completion, when we see that a queue is stopped, we wake up that queue
if the depth is less than a threshold.

Sujith
