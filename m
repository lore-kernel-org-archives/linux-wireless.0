Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f183.google.com ([209.85.221.183]:56473 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab0EJOrF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 10:47:05 -0400
Received: by qyk13 with SMTP id 13so6247098qyk.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 May 2010 07:47:04 -0700 (PDT)
Date: Mon, 10 May 2010 16:46:26 +0200
From: Dan Carpenter <error27@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [patch 3/9] ath9k: cleanup: u32 => bool
Message-ID: <20100510144625.GW27064@bicker>
References: <20100508162247.GO27064@bicker> <1273477106.3573.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1273477106.3573.0.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 10, 2010 at 09:38:26AM +0200, Johannes Berg wrote:
> On Sat, 2010-05-08 at 18:22 +0200, Dan Carpenter wrote:
> 
> > +		bool on = param ? 1 : 0;
> 
> umm, if you're going to use bool then use true/false too.
> 
> johannes

The 1 and 0 are used as array indexes so it looks funny to use true and
false.

Let's just drop this patch.  I wrote it to silence a smatch false 
positive but I should/will just fix smatch instead.

Smatch complains we negate a non-boolean type here:

                if (!on != aniState->ofdmWeakSigDetectOff) {

It's a quite common bug to forget that negation has higher precendence 
than compare operations.  In this case, it's clear from code that "on" is
either 1 or 0 so smatch should not complain.

regards,
dan carpenter
