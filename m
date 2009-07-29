Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:53755 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbZG2UO1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 16:14:27 -0400
Received: by ewy10 with SMTP id 10so260022ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 13:14:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1248877744-7273-2-git-send-email-me@bobcopeland.com>
References: <1248877744-7273-1-git-send-email-me@bobcopeland.com>
	 <1248877744-7273-2-git-send-email-me@bobcopeland.com>
Date: Wed, 29 Jul 2009 23:06:47 +0300
Message-ID: <40f31dec0907291306q7e19c9fdib7e9a6dcab89ac21@mail.gmail.com>
Subject: Re: [PATCH 2/2] ath5k: fix CAB queue operation
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, jirislaby@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/7/29 Bob Copeland <me@bobcopeland.com>:
> We need to process tx descriptors for all queues (currently main tx
> queue and cabq) which may have triggered the TX completion interrupt.
> Otherwise, the queues can get stuck after sending a few frames.
>
> Also, the CAB queue does need to be DBA (DMA beacon alert) gated, as
> in ath9k and madwifi, instead of beacon sent gated or the CAB frames
> may not be sent at the right time.
>

I think we are doing the wrong thing, CAB queue is supposed to fire
after beacon queue. Ath9k fires up cab queue and beacon queue at the
same time and uses ready time to hold cab queue for a fixed interval.
Try to remove the readytime stuff from cab queue and i guess it'll
work fine (now we fire it after the beacon queue AND wait for a beacon
transmition period).

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
