Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:46858 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702Ab0AJWc2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jan 2010 17:32:28 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 2/6] b43: N-PHY: add RSSI functions: poll and set 2055 vcm
Date: Sun, 10 Jan 2010 23:32:21 +0100
Cc: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
References: <op.u6b70ig59lhzdc@linux-g0th.site>
In-Reply-To: <op.u6b70ig59lhzdc@linux-g0th.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001102332.22954.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 10 January 2010 23:13:20 Rafał Miłecki wrote:
> +		buf[0] += (s8)(((s[0] & 0x3F) << 2) >> 2);
> +		buf[1] += (s8)((((s[0] >> 8) & 0x3F) << 2) >> 2);
> +		buf[2] += (s8)(((s[1] & 0x3F) << 2) >> 2);
> +		buf[3] += (s8)((((s[1] >> 8) & 0x3F) << 2) >> 2);

I suggest buf[3] += (s8)((((s[1] >> 8) & 0x3F) << 2) >> 2) << 2) >> 2) << 2) >> 2) << 2) >> 2) << 2) >> 2) << 2) >> 2) << 2) >> 2)
;)
No, seriously, why shift left and then shift right? Is this a translation error?
I _guess_ it's some mistranslation of the sign extension going on.
Or alternatively a compiler going insane on sign extension.

The question is: Do we want these integers to be signextended or not?

What we currently do is this:
buf[3] += (s8)((s[1] >> 8) & 0x3F);

which will always result in a positive 8bit integer, as far as I can see.
Which smells fishy.

-- 
Greetings, Michael.
