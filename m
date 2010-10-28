Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46040 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758691Ab0J1OWG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 10:22:06 -0400
Received: by qwf7 with SMTP id 7so1192806qwf.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Oct 2010 07:22:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CC8639A.9070409@27m.se>
References: <4CC8639A.9070409@27m.se>
Date: Thu, 28 Oct 2010 10:22:03 -0400
Message-ID: <AANLkTimsxHRG-1dQPZzGfCsxwmW=-ptBLOtTS6z5qrvP@mail.gmail.com>
Subject: Re: [PATCH] ath5k: Fix double free on hw attach error path
From: Bob Copeland <me@bobcopeland.com>
To: Jones Desougi <jones.desougi@27m.se>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 27, 2010 at 1:38 PM, Jones Desougi <jones.desougi@27m.se> wrote:
> If ath5k_hw_attach fails it will free sc->ah (local variable ah) before
> returning. However, when it reports failure the caller (ath5k_pci_probe)
> will also free sc->ah. Let the caller handle the deallocation, it does
> so on further errors as well.
>
> Signed-off-by: Jones Desougi <jones.desougi@27m.se>

Reviewed-by: Bob Copeland <me@bobcopeland.com>

Thanks, yes, looks like that was due to commit 9adca126d,
"ath5k: allocate ath5k_hw prior to initializing hw".

This should probably go to stable.

-- 
Bob Copeland %% www.bobcopeland.com
