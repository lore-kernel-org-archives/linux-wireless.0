Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f172.google.com ([209.85.212.172]:57840 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbZHLRVx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 13:21:53 -0400
Received: by vws2 with SMTP id 2so155652vws.4
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 10:21:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250096221-11000-1-git-send-email-lrodriguez@atheros.com>
References: <1250096221-11000-1-git-send-email-lrodriguez@atheros.com>
Date: Wed, 12 Aug 2009 13:21:53 -0400
Message-ID: <b6c5339f0908121021x3bc9fe26vb17532de6c464b7f@mail.gmail.com>
Subject: Re: [PATCH 0/3] ath: advance ath.ko with one more helper
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 12, 2009 at 12:56 PM, Luis R.
Rodriguez<lrodriguez@atheros.com> wrote:
> This adds a common structure where we can start stuffing shared items
> and introduces a helper for both ath5k and ath9k's use.
>
> Luis R. Rodriguez (3):
>  ath: add common ath_rxbuf_alloc() and make ath9k use it
>  ath5k: use common ath.ko ath_rxbuf_alloc()
>  ath5k: use bit shift operators for cache line size

Series looks OK to me but I think we can add a 4/4 that would:

- include ath/reg.h [don't remember if that's the name right now]
  in ath.h
- move reg structs into ath_common (although, this could be a
  bad call for ar9170, haven't really checked).

Then we only have to deal with one header and one composite struct
(for now) as the interface between the modules.

-- 
Bob Copeland %% www.bobcopeland.com
