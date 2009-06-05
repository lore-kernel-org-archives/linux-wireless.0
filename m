Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:38685 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbZFEHre convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 03:47:34 -0400
Received: by gxk10 with SMTP id 10so2466560gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 05 Jun 2009 00:47:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090605063059.GF17632@vasanth-laptop>
References: <1244180502-4323-1-git-send-email-lrodriguez@atheros.com>
	<1244180502-4323-2-git-send-email-lrodriguez@atheros.com>
	<20090605063059.GF17632@vasanth-laptop>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 5 Jun 2009 00:47:16 -0700
Message-ID: <43e72e890906050047w71f8e691g479797a54f5fb9a0@mail.gmail.com>
Subject: Re: [PATCH 01/15] ath9k: fix oops by downgrading assert in rc.c
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 4, 2009 at 11:30 PM, Vasanthakumar
Thiagarajan<vasanth@atheros.com> wrote:
>
>> +
>> +       /*
>> +        * Fine tuning for when no decent rate was found, the
>> +        * lowest should *not* be used under normal circumstances.
>> +        */
>> +       if (rix == ath_rc_priv->valid_rate_index[0]) {
>> +               DPRINTF(sc, ATH_DBG_RATE, "lowest rate being used, "
>> +                       "disabling MRR\n");
>> +               rates[0].idx = rate_lowest_index(sband, sta);
>> +               /* Disable MRR when ath_rc_ratefind_ht() found rate 0 */
>> +               rates[1].idx = -1;
>> +       }
>
> I think we can still fill other rates (1..3) with the lowest rate
> index as we dont differentiate the situation where the lowest rate
> is chosen truely by the algorithm from this particular case.

I thought about that as well, but does it really make sense for us to
use MRR with the same lowest rate? That's why I just used one segment.
Thoughts?

  Luis
