Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:56580 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757644AbZEBO3o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 May 2009 10:29:44 -0400
Received: by bwz7 with SMTP id 7so2755231bwz.37
        for <linux-wireless@vger.kernel.org>; Sat, 02 May 2009 07:29:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1241217890-11650-1-git-send-email-lrodriguez@atheros.com>
References: <1241217890-11650-1-git-send-email-lrodriguez@atheros.com>
Date: Sat, 2 May 2009 15:29:43 +0100
Message-ID: <9b2b86520905020729v331a9581q5d7916b5d36c02fb@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: fix race condition with wiphy_apply_custom_regulatory()
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/1/09, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:
> We forgot to lock using the cfg80211_mutex in
> wiphy_apply_custom_regulatory(). Without the lock
> there is possible race between processing a reply from CRDA
> and a driver calling wiphy_apply_custom_regulatory(). During
> the processing of the reply from CRDA we free last_request and
> wiphy_apply_custom_regulatory() eventually accesses an
> element from last_request in the through freq_reg_info_regd().
>
> This is very difficult to reproduce (I haven't), it takes us
> 3 hours and you need to be banging hard, but the race is obvious
> by looking at the code.
>
> This should only affect those who use this caller, which currently
> is ath5k, ath9k, and ar9170.
>
> EIP: 0060:[<f8ebec50>] EFLAGS: 00210282 CPU: 1
> EIP is at freq_reg_info_regd+0x24/0x121 [cfg80211]

This looks like the same bug I reported seeing on bootup (100% of the
time).  I'll test wireless-testing again for V9 of the rfkill rewrite,
so at that point I'll try to confirm that this patch fixes my problem.

Thanks!
Alan
