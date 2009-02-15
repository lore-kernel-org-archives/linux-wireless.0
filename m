Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:54601 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753337AbZBORGN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 12:06:13 -0500
Message-ID: <49984B70.4080007@lwfinger.net> (sfid-20090215_180615_338994_8C3F8E71)
Date: Sun, 15 Feb 2009 11:05:52 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: stefano.brivio@polimi.it, linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] B43: misplaced parentheses?
References: <499844E7.1040307@gmail.com>
In-Reply-To: <499844E7.1040307@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Roel Kluin wrote:
> -			  | (rfatt->with_padmix) ? txctl_value : 0);
> +			  | (rfatt->with_padmix ? txctl_value : 0));

As I see it, the difference between the above two lines is the same as the
difference between c and d in this program:

int main(int argc, char **argv)
{
        int a = 1, b = 2, c, d;

        c = (a) ? b : 0;
        d = (a ? b : 0);
        fprintf (stderr, "a, b, c, d: %d %d %d %d\n", a, b, c, d);
        return 1;
}

When this program is executed, the output line is

a, b, c, d: 1 2 2 2

which is what I expected. Thus "(condition) ? result1 : result2" is the same as
"(condition ? result1 : result2)".

Larry
