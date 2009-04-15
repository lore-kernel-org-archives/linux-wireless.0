Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.186]:12811 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbZDOMNu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 08:13:50 -0400
Received: by fk-out-0910.google.com with SMTP id 18so1324099fkq.5
        for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2009 05:13:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1239796656-20646-6-git-send-email-me@bobcopeland.com>
References: <1239796656-20646-1-git-send-email-me@bobcopeland.com>
	 <1239796656-20646-6-git-send-email-me@bobcopeland.com>
Date: Wed, 15 Apr 2009 15:13:45 +0300
Message-ID: <40f31dec0904150513t3983d37ercaae985a6cd0fee@mail.gmail.com> (sfid-20090415_141355_132403_D69E170F)
Subject: Re: [PATCH 5/5] ath5k: manipulate rxlink and descriptor address under
	rxbuf lock
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, jirislaby@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/15 Bob Copeland <me@bobcopeland.com>:
> Grabbing an ath5k_buf then dropping the lock is racy because the
> referenced descriptor can be obtained in another thread and released
> before the buffer is handed to the hardware. =C2=A0Likewise, manipula=
ting
> sc->rxlink without the lock can lead to having multiple self-linked
> hardware descriptors.
>
> Changes-licensed-under: 3-Clause-BSD
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---

Acked-by: Nick Kossifidis <mickflemm@gmail.com>


--=20
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
