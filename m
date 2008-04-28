Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:27593 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765572AbYD1IQi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Apr 2008 04:16:38 -0400
Received: by wa-out-1112.google.com with SMTP id m16so7841313waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 28 Apr 2008 01:16:35 -0700 (PDT)
Message-ID: <68676e00804280116j7b44c2adwdaa488d078cb94a1@mail.gmail.com> (sfid-20080428_101650_776296_5F62DDD2)
Date: Mon, 28 Apr 2008 10:16:35 +0200
From: "Luca Tettamanti" <kronos.it@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [PATCH] Fix compile error with wifi & leds
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
In-Reply-To: <20080428075452.GB16379@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080426203408.GA12074@dreamland.darkstar.lan>
	 <20080428074531.GA16379@cs181133002.pp.htv.fi>
	 <20080428075452.GB16379@cs181133002.pp.htv.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 28, 2008 at 9:54 AM, Adrian Bunk <bunk@kernel.org> wrote:
> On Mon, Apr 28, 2008 at 10:45:31AM +0300, Adrian Bunk wrote:
>  > Can you send the .config that gives this problem?

Just select IWL4965_LEDS without enabling LEDS_TRIGGERS.

>  Scrap that, I already got the problem (and your patch looks right).

It works, yes - but I don't like it... NEW_LEDS enables the core code
of the leds driver but also enables/disables the compilation of the
whole driver/leds directory; *every* user of the led driver has to
select whatever config option it wants (e.g. LEDS_TRIGGERS) _plus_
NEW_LEDS, otherwise led code won't be compiled.
>From a quick inspection RT2{4,5}00PCI_LEDS
(driver/net/wireless/rt2x00) have the same problem, they select
LEDS_CLASS without enabling NEW_LEDS -> unresolved symbols :|
Maybe LEDS_* should also select NEW_LEDS?

Luca
