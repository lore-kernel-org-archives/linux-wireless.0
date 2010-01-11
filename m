Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:36074 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab0AKWO2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2010 17:14:28 -0500
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [PATCH 3/6] b43: N-PHY: add RSSI calculation for PHY rev < 3
Date: Mon, 11 Jan 2010 23:13:25 +0100
Cc: bcm43xx-dev@lists.berlios.de,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
References: <op.u6b70wtk9lhzdc@linux-g0th.site> <201001102338.28721.mb@bu3sch.de> <b170af451001111313r6bc6905fg722fcd42d7f2681a@mail.gmail.com>
In-Reply-To: <b170af451001111313r6bc6905fg722fcd42d7f2681a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001112313.26197.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 11 January 2010 22:13:31 Rafał Miłecki wrote:
> 2010/1/10 Michael Buesch <mb@bu3sch.de>:
> > On Sunday 10 January 2010 23:13:34 Rafał Miłecki wrote:
> >> +     s32 results_min[4];
> >> +     u8 vcm_final[4];
> >> +     s32 results[4][4];
> >> +     s32 miniq[4][2];
> >> +     memset(results_min, 0, sizeof(s32) * 4);
> >> +     memset(vcm_final, 0, sizeof(u8) * 4);
> >> +     memset(results, 0, sizeof(s32) * 4 * 4);
> >> +     memset(miniq, 0, sizeof(s32) * 4 * 2);
> >
> > Just initialize the variables to zero instead of doing a memset:
> >
> > +       s32 results_min[4] = { 0, };
> > +       u8 vcm_final[4] = { 0, };
> > +       s32 results[4][4] = { 0, };
> > +       s32 miniq[4][2] = { 0, };
> 
> Nice trick, thanks :) Just for two-dimensional arrays I'll have to hack it to:
> s32 results[4][4] = { { 0, }, { 0, }, { 0, }, { 0, } };
> I believe.

No I don't think so.
It's C standard that uninitialized elements on automatic variables are initialized
to zero, _if_ at least one element is initialized to something.
So if you init one element to 0, all others will be 0, too.
I think that should also work for multidimensional arrays. So my example
s32 results[4][4] = { 0, };
should do the right thing. Am I wrong?

Here's a test-program:


mb@maggie:~$ cat t.c
#include <stdio.h>
#include <stdint.h>

int main(void)
{
        int i, j;
        int32_t results[4][4]
#ifdef INIT_IT
= { 0, };
#else
;
#endif

        for (i = 0; i < 4; i++)
                for (j = 0; j < 4; j++)
                        printf("%d\n", results[i][j]);

}
mb@maggie:~$ gcc -o t t.c
mb@maggie:~$ ./t
0
0
0
1
-1077483840
0
0
0
-1077483824
268436224
268536212
0
-1077483776
268436888
268353524
0
mb@maggie:~$ gcc -D INIT_IT -o t t.c
mb@maggie:~$ ./t
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

-- 
Greetings, Michael.
