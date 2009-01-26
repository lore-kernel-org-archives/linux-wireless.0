Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:15971 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbZAZHqz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 02:46:55 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: fix CF firmware loading for some cards
Date: Mon, 26 Jan 2009 08:46:05 +0100
Cc: Dan Williams <dcbw@redhat.com>, Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>, stable@kernel.org,
	ryan@bluewatersys.com, Cyril HAENEL <chaenel@free.fr>
References: <1232729733.2577.13.camel@localhost.localdomain> <200901231801.19570.mb@bu3sch.de> <1232733214.2577.24.camel@localhost.localdomain>
In-Reply-To: <1232733214.2577.24.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200901260846.05912.hs4233@mail.mn-solutions.de> (sfid-20090126_084706_903156_FDB0D62D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Could be, Holger did the initial patch and I'm not sure if the
> udelay was intentional.  Note that this happens at PCMCIA/CF
> hardware probe time (if that has any constraints that might
> apply here).

I'm used the card on an ARM architecture, and there long mdelay 
won't work as on i386, so I used udelay.

In practice, the "expensive loop" isn't that expensive, because 
the real number of iterations is quite low (contrary to what the 
manual states).
