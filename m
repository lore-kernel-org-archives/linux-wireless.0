Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:50531 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762259AbbA3Nr2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 08:47:28 -0500
Received: by mail-we0-f171.google.com with SMTP id k11so24841959wes.2
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 05:47:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1422624670.1919.21.camel@sipsolutions.net>
References: <1422607287-12289-1-git-send-email-michal.kazior@tieto.com>
	<1422621086-28970-1-git-send-email-michal.kazior@tieto.com>
	<1422621086-28970-3-git-send-email-michal.kazior@tieto.com>
	<1422621903.1919.7.camel@sipsolutions.net>
	<CA+BoTQkdszYWbNJcV+1dDFsaSJ3aoTuC=ORUMr_aJx7_aQmcqw@mail.gmail.com>
	<1422623054.1919.18.camel@sipsolutions.net>
	<CA+BoTQnkqzHNWTFSc9VB4_itCK_+jC6HC8GmdMKiyrhu-Sz9Cg@mail.gmail.com>
	<1422624670.1919.21.camel@sipsolutions.net>
Date: Fri, 30 Jan 2015 14:47:27 +0100
Message-ID: <CA+BoTQ=YnQhjLwUU9jj_SBS_mji-pG=cYbdGtYusKC3pwVAirA@mail.gmail.com> (sfid-20150130_145349_234208_577C773C)
Subject: Re: [PATCH v2 2/7] ath10k: implement chanctx API
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 January 2015 at 14:31, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2015-01-30 at 14:22 +0100, Michal Kazior wrote:
>
>> You'd probably have to add quite a few mutex_lock(iflist_mtx) around
>> drv_*() calls (not directly but somewhere at their call trees) to
>> guarantee driver can use lock-free iterate() version (which doesn't
>> exist yet). This could be tricky.
>
> Well, I was thinking you'd only use it in some places now - but it does
> seem a bit difficult to maintain.
>
> We've not typically had to worry about using the synchronous versions
> much since we mostly just need a single interface so we just pass it out
> and use it there, or so.

I'm not sure if you refer to iwlwifi or mac80211 now? If it's the
latter: even if you have an ops with, e.g. vif pointer, driver may
still need to iterate over interfaces in order to propagate some
side-effect changes or aggregate some values/recalculate.


Michał
