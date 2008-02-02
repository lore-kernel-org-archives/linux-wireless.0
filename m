Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:50627 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbYBBViq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2008 16:38:46 -0500
Received: by an-out-0708.google.com with SMTP id d31so388029and.103
        for <linux-wireless@vger.kernel.org>; Sat, 02 Feb 2008 13:38:45 -0800 (PST)
Message-ID: <40f31dec0802021338x6075d134n5c1270a424d7ae5b@mail.gmail.com> (sfid-20080202_213850_150096_75490CB1)
Date: Sat, 2 Feb 2008 23:38:45 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [RFC: 2.6 patch] ath5k/phy.c: fix negative array index
Cc: "Jiri Slaby" <jirislaby@gmail.com>, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <20080202211617.GE9375@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080202211617.GE9375@cs181133002.pp.htv.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/2/2, Adrian Bunk <bunk@kernel.org>:
> This patch fixes a negative array index spotted by the Coverity checker.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
> ---
>
> I'm not 100% sure whether my patch is correct, but if not this patch is
> the easiest way to show the problem.
>
> --- linux-2.6/drivers/net/wireless/ath5k/phy.c.old      2008-02-02 21:44:58.000000000 +0200
> +++ linux-2.6/drivers/net/wireless/ath5k/phy.c  2008-02-02 21:48:28.000000000 +0200
> @@ -1176,10 +1176,13 @@ static int ath5k_hw_rf5112_rfregs(struct
>                 obdb = channel->freq >= 5725 ? 3 :
>                     (channel->freq >= 5500 ? 2 :
>                         (channel->freq >= 5260 ? 1 :
>                             (channel->freq > 4000 ? 0 : -1)));
>
> +               if (obdb == -1)
> +                       return -EINVAL;
> +
>                 if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
>                                 ee->ee_ob[ee_mode][obdb], 3, 279, 0, true))
>                         return -EINVAL;
>
>                 if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
>

Thanx ;-)

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
