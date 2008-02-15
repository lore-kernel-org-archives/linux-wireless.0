Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:45295 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757697AbYBOWAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 17:00:37 -0500
Received: by an-out-0708.google.com with SMTP id d31so184421and.103
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2008 14:00:34 -0800 (PST)
Message-ID: <40f31dec0802151400r7423c8e9w2524cba76618e07e@mail.gmail.com> (sfid-20080215_220041_738070_01EC442A)
Date: Sat, 16 Feb 2008 00:00:34 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 1/3] WDEV: ath5k, fix lock imbalance
Cc: linville@tuxdriver.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1203109133-32217-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1203109133-32217-1-git-send-email-jirislaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/2/15, Jiri Slaby <jirislaby@gmail.com>:
> Omitted lock causes sparse warning
>  drivers/net/wireless/ath5k/base.c:1682:1: warning: context imbalance in 'ath5k_tasklet_rx' - different lock contexts for basic block
>
>  Add the lock to the guilty fail path.
>
>  Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>  Cc: Nick Kossifidis <mickflemm@gmail.com>
>  Cc: Luis R. Rodriguez <mcgrof@gmail.com>
>  ---
>   drivers/net/wireless/ath5k/base.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
>  diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
>  index ddc8714..49d38e8 100644
>  --- a/drivers/net/wireless/ath5k/base.c
>  +++ b/drivers/net/wireless/ath5k/base.c
>  @@ -1715,6 +1715,7 @@ ath5k_tasklet_rx(unsigned long data)
>                         break;
>                 else if (unlikely(ret)) {
>                         ATH5K_ERR(sc, "error in processing rx descriptor\n");
>  +                       spin_unlock(&sc->rxbuflock);
>                         return;
>                 }
>
>


Acked-by: Nick Kossifidis <mickflemm@gmail.com>


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
