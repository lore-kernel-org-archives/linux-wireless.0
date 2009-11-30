Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 2.mail-out.ovh.net ([91.121.26.226]:56182 "HELO
	2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753239AbZK3XqZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 18:46:25 -0500
Message-ID: <4B14594E.2090307@free.fr>
Date: Tue, 01 Dec 2009 00:46:22 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: rt2x00 Users List <users@rt2x00.serialmonkey.com>
CC: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [rt2x00-users] [PATCH v3 0/4] Further L2 padding fixes.
References: <1259615298-2305-1-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1259615298-2305-1-git-send-email-gwingerde@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gertjan van Wingerde a écrit :
> The L2 padding fixes patch has grown a bit and now consists of 4 separate
> patches to clean the L2 padding code up and to fix a number of bugs at the
> same time.
> 
> 	1. rt2x00: Further L2 padding fixes.
> 	2. rt2x00: Remove SKBDESC_L2_PADDED flag.
> 	3. rt2x00: Reorganize L2 padding inserting function.
> 	4. rt2x00: Only remove L2 padding in received frames if there is payload.
> 
> ---
> Gertjan.

Thanks Gertjan for the patches, I know that padding is a bit of
nightware. I've testing your tree and here are the results:

1. On TX : It fails for control frames with hdrlen=10 since it will
produce l2pad = 2 in your case, where it should be 0. In all other
cases, it works!

Solution : padding is only needed for data frames for rt28x devices, so
I think it's better to something like rt2xqueue_padpos
[http://git.popipo.fr/?p=rt2x00.git;a=commitdiff;h=95ddf076c13062d1026025d97ba511f880a1792d]

2. On RX : It fails for data frames with hdrlen=26 or 30. So it looks
like it's not unpadding at all. I think your code is correct however,
but it still depends on RXDONE_L2PAD which is not properly set

Solution : applies the 2 patches I just posted
[http://git.popipo.fr/?p=rt2x00.git;a=commitdiff;h=8fee77832720708a09c50f9002edcc68dc5bd0a7]
and
[http://git.popipo.fr/?p=rt2x00.git;a=commitdiff;h=b8fce373e9de892113b32322a95ca5bc7da56389]

or get rid of RXDONE_L2PAD all together + padpos function :-)

Regards,
Benoit
