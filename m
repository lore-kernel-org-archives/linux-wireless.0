Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:48084 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab0AKKJH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2010 05:09:07 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 2/6] b43: N-PHY: add RSSI functions: poll and set 2055 vcm
Date: Mon, 11 Jan 2010 11:08:19 +0100
Cc: bcm43xx-dev@lists.berlios.de,
	=?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
References: <op.u6b70ig59lhzdc@linux-g0th.site> <201001102332.22954.mb@bu3sch.de> <4B4A8F3D.6010200@lwfinger.net>
In-Reply-To: <4B4A8F3D.6010200@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001111108.21701.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 11 January 2010 03:38:53 Larry Finger wrote:
> Yes, my fault. The specs are now corrected so that these statements are
> 
> ((s8)((s[1] >> 8) & 0x3F) << 2) >> 2
> 
> I think that is right.

No it is not.

You need to do this:
(s8)(((s[1] >> 8) & 0x3F) << 2) >> 2

Alternatively add another pair of parenthesis to make it clearer:

((s8)(((s[1] >> 8) & 0x3F) << 2)) >> 2

This basically shifts left unsigned and then shifts right _arithmetically_.
In your example, the compiler will optimize both shifts away (it may actually
also optimize the shifts in my case, but the sign extension will persist.

Just try it and you'll see:

mb@homer:~$ cat t.c
#include <stdio.h>
#include <stdint.h>

int main()
{
        int8_t s0;
        int8_t s1;
        uint8_t u;

        u = 0x3D;

        s0 = ((int8_t)(u & 0x3F) << 2) >> 2;
        s1 = ((int8_t)((u & 0x3F) << 2)) >> 2;

        printf("%d %d\n", s0, s1);
}
mb@homer:~$ gcc -o t t.c
mb@homer:~$ ./t
61 -3


-- 
Greetings, Michael.
