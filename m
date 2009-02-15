Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:45058 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbZBORIY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 12:08:24 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] B43: misplaced parentheses?
Date: Sun, 15 Feb 2009 18:07:00 +0100
Cc: Roel Kluin <roel.kluin@gmail.com>, stefano.brivio@polimi.it,
	linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <499844E7.1040307@gmail.com> <49984B70.4080007@lwfinger.net>
In-Reply-To: <49984B70.4080007@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200902151807.00311.mb@bu3sch.de> (sfid-20090215_180826_542370_AED0812A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 15 February 2009 18:05:52 Larry Finger wrote:
> Roel Kluin wrote:
> > -			  | (rfatt->with_padmix) ? txctl_value : 0);
> > +			  | (rfatt->with_padmix ? txctl_value : 0));
> 
> As I see it, the difference between the above two lines is the same as the
> difference between c and d in this program:
> 
> int main(int argc, char **argv)
> {
>         int a = 1, b = 2, c, d;
> 
>         c = (a) ? b : 0;
>         d = (a ? b : 0);
>         fprintf (stderr, "a, b, c, d: %d %d %d %d\n", a, b, c, d);
>         return 1;
> }
> 
> When this program is executed, the output line is
> 
> a, b, c, d: 1 2 2 2
> 
> which is what I expected. Thus "(condition) ? result1 : result2" is the same as
> "(condition ? result1 : result2)".

The problem is the binary OR operator, which has precedence over the ?: operator.


-- 
Greetings, Michael.
