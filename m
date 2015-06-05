Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:33221 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbbFETKh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2015 15:10:37 -0400
Received: by obcej4 with SMTP id ej4so10026183obc.0
        for <linux-wireless@vger.kernel.org>; Fri, 05 Jun 2015 12:10:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5571D903.7060203@candelatech.com>
References: <1430829048-22549-1-git-send-email-vthiagar@qti.qualcomm.com>
	<5571D903.7060203@candelatech.com>
Date: Fri, 5 Jun 2015 12:10:36 -0700
Message-ID: <CAFuUQkjP18E6fjvgZMayJYiEQtpjVUAKb+_zDmS3yBfi-QF8Cg@mail.gmail.com> (sfid-20150605_211041_093603_B1C796A7)
Subject: Re: [PATCH] ath10k: Fix survey information reporting
From: YanBo <dreamfly281@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>,
	ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 5, 2015 at 10:14 AM, Ben Greear <greearb@candelatech.com> wrote:
> I applied these and some other related patches to my hacked-upon 4.0.4, but
> I am seeing some inconsistencies between how ath10k and ath9k
> reports survey info.  I am using my CT firmware based on 10.1.
>
> ath9k reports ever-increasing counters for the channel time
> and busy time.
>
> With ath10k, it reports the same values until I do a scan
> again, and even then, it is not additive.
>
> First, should the value only update when we do a scan?
>
> And second, should ath10k report ever increasing totals
> to match ath9k behaviour?
>

It should be match with ath9k, but the ath10k doesn't accumulate the
survey count at currently code,
I drafted a patch to fix this issue, will send to public mailist soon.

BR /Yanbo
