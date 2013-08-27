Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:51722 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab3H0Fml convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 01:42:41 -0400
Received: by mail-bk0-f51.google.com with SMTP id mx10so1408256bkb.24
        for <linux-wireless@vger.kernel.org>; Mon, 26 Aug 2013 22:42:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6X=P2hTnOC8xqFwb=-32-hBgx=ndq3KHoUG83KptKv0vA@mail.gmail.com>
References: <1377066854-13981-1-git-send-email-michal.kazior@tieto.com>
	<1377507205-5386-1-git-send-email-michal.kazior@tieto.com>
	<CAB=NE6X=P2hTnOC8xqFwb=-32-hBgx=ndq3KHoUG83KptKv0vA@mail.gmail.com>
Date: Tue, 27 Aug 2013 07:42:39 +0200
Message-ID: <CA+BoTQ=zVAab8KV2TwYJ=+wG0N7M4-oo-TgaE2qpxJO33d3oZQ@mail.gmail.com> (sfid-20130827_074244_470372_67AF0A21)
Subject: Re: [PATCH v2 0/4] ath10k: fixes
From: Michal Kazior <michal.kazior@tieto.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 August 2013 22:20, Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
> On Mon, Aug 26, 2013 at 1:53 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
>>   ath10k: fix issues on non-preemptible systems
>
> This patch looks like a stable candidate fix. Please annotate as such
> if you confirm. Also, I reviewed other ath10k "fixes" and I see no
> practice of propagating any patches to stable yet. Can you please
> start doing that? If there were patches which are already merged
> upstream that should be propagated to stable then they can be
> submitted as stable candidate patches.

Good point.

If this patch is to be propagated to stable the patch(set) needs some
adjustments to avoid conflicts. Right now the patch touches a place
that was introduced with "ath10k: move htt rx processing to worker" so
the offending patch hunk should be moved to that patch.

Actually the "ath10k: make the workqueue multithreaded" could also be
a candidate for stable as it fixes AP beaconing during heavy TX
traffic. I should've mentioned that in the commit log.

I'll resend an updated patchset later today.


Michał.
