Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:55519
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030594AbXBMAdY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Feb 2007 19:33:24 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: d80211: current TKIP hwcrypto implementation seems to be broken
Date: Tue, 13 Feb 2007 01:33:11 +0100
Cc: "Jouni Malinen" <jkm@devicescape.com>, "Jiri Benc" <jbenc@suse.cz>,
	linux-wireless@vger.kernel.org
References: <200702041344.19117.mb@bu3sch.de> <200702130110.02658.mb@bu3sch.de> <1ba2fa240702121619x259f546dga2bebefbe24bf1d3@mail.gmail.com>
In-Reply-To: <1ba2fa240702121619x259f546dga2bebefbe24bf1d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702130133.11690.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 13 February 2007 01:19, Tomas Winkler wrote:
> > HW doesn't scramble it. So when d80211 receives the packet it can
> > _then_ generate the key. There's no point in precomputing it.
> 
> For past packets you've already computed it so why do  it again? So
> you keep 2 phas1 keys one old and one current. When sequence numbers
> advance sufficiently you discard the old one and compute the new one
> in a spare time. Something like double buffer.

Ah, now I see. We are talking about two different things.
You are talking about the TX key and I am talking about
the RX key. We could probably cache the TX key to avoid the
key computation on every TX. That's right. But I don't even have
it working, yet, so optimization is not my worry, yet. :)
But yes, that could be an optimization to be done.

-- 
Greetings Michael.
