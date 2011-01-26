Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41678 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab1AZRGC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 12:06:02 -0500
Received: by pwj3 with SMTP id 3so293543pwj.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jan 2011 09:06:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110126015034.GA8600@hash.localnet>
References: <1295929904-11806-1-git-send-email-me@bobcopeland.com>
	<20110125135249.GA2610@redhat.com>
	<20110126015034.GA8600@hash.localnet>
Date: Wed, 26 Jan 2011 19:06:02 +0200
Message-ID: <AANLkTinx1Tpp10ToiVB-VuGt01iwDFhWrmw0Tf3o9BVu@mail.gmail.com>
Subject: Re: [PATCH 1/2] ath5k: fix error handling in ath5k_hw_dma_stop
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, Bruno Randolf <br1@einfach.org>,
	jirislaby@gmail.com, lrodriguez@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/1/26 Bob Copeland <me@bobcopeland.com>:
>
> As a side note, we still quit when the first error is encountered.
> Maybe we should try stopping all of the queues anyway if one fails?
> On the other hand we could spend a lot of time polling the registers
> if the card is truly hosed, so I think this is best for now.
>

It's better to continue with hw reset if a queue fails to stop, it
usually means the dma unit needs reset.



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
