Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f198.google.com ([209.85.216.198]:41419 "EHLO
	mail-px0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab0CLIrI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Mar 2010 03:47:08 -0500
Received: by pxi36 with SMTP id 36so428237pxi.21
        for <linux-wireless@vger.kernel.org>; Fri, 12 Mar 2010 00:47:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B99AED3.4000204@openwrt.org>
References: <4B99AED3.4000204@openwrt.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 12 Mar 2010 00:46:46 -0800
Message-ID: <43e72e891003120046u2fc55bd4h4e3969bed54a38d@mail.gmail.com>
Subject: Re: [PATCH] ath9k: fix BUG_ON triggered by PAE frames
To: Felix Fietkau <nbd@openwrt.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Sujith <Sujith.Manoharan@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 11, 2010 at 7:02 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> When I initially stumbled upon sequence number problems with PAE frames
> in ath9k, I submitted a patch to remove all special cases for PAE
> frames and let them go through the normal transmit path.
> Out of concern about crypto incompatibility issues, this change was
> merged instead:
>
> commit 6c8afef551fef87a3bf24f8a74c69a7f2f72fc82
> Author: Sujith <Sujith.Manoharan@atheros.com>
> Date:   Tue Feb 9 10:07:00 2010 +0530
>
>    ath9k: Fix sequence numbers for PAE frames
>
> After a lot of testing, I'm able to reliably trigger a driver crash on
> rekeying with current versions with this change in place.
> It seems that the driver does not support sending out regular MPDUs with
> the same TID while an A-MPDU session is active.
> This leads to duplicate entries in the TID Tx buffer, which hits the
> following BUG_ON in ath_tx_addto_baw():
>
>    index  = ATH_BA_INDEX(tid->seq_start, bf->bf_seqno);
>    cindex = (tid->baw_head + index) & (ATH_TID_MAX_BUFS - 1);
>
>    BUG_ON(tid->tx_buf[cindex] != NULL);
>
> I believe until we actually have a reproducible case of an
> incompatibility with another AP using no PAE special cases, we should
> simply get rid of this mess.

I believe that incompatibility does already exist, I think Sujith
knows the details. Not sure if Sujith is in today, I think he's on a
journey somewhere. Senthil, Vasanth, do you guys happen to recall?

  Luis
