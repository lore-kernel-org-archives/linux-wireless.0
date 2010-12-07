Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33270 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab0LGEci convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 23:32:38 -0500
Received: by qwa26 with SMTP id 26so85458qwa.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 20:32:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19709.46740.86437.390791@gargle.gargle.HOWL>
References: <19701.62091.644444.121284@gargle.gargle.HOWL> <20101202193024.GC2358@tuxdriver.com>
 <19704.23185.565826.890275@gargle.gargle.HOWL> <AANLkTinPLPoAHxauaXj8Sj=zjyHQPyxO0ku342ersZQ4@mail.gmail.com>
 <19709.45926.38551.25130@gargle.gargle.HOWL> <AANLkTinNF2dnacLof_knM3OAf6ADCCPsb8DO1VE6c31U@mail.gmail.com>
 <19709.46740.86437.390791@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 6 Dec 2010 20:32:16 -0800
Message-ID: <AANLkTinJLRMSSvLHgPP1Dw5BXsC3utAudJ=oSAsUUD8T@mail.gmail.com>
Subject: Re: [PATCH 2/2] ath9k_htc: Fix suspend/resume
To: Sujith <m.sujith@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 6, 2010 at 8:22 PM, Sujith <m.sujith@gmail.com> wrote:
> Luis R. Rodriguez wrote:
>> That's the thing, the device was powered up, lifted from idle, but we
>                    ^^^^^^^^^^^^^^^^^^^^^^^^^
> Not according to mac80211 - start() wasn't issued, config() with ~CONF_IDLE
> wasn't issued.
>
> This is the issue in ath9k_htc:
>
> * modprobe ath9k_htc
> * pm-suspend
> ---
> * resume
>
> In this case, as I said above, neither start() nor CONF_IDLE have been notified
> to the driver by mac80211, since the interface was never brought up.
>
> But ath9k_htc powers up the device while initialization, immediately when the driver
> is loaded, not waiting for start() or ~CONF_IDLE. And since the driver maintains
> internal state with respect to the radio's power status, I think it is up to the
> driver to clean it properly ...

Oh right, I see. Should we not wait to turn the radio until we get a
non-idle config() call?

  Luis
