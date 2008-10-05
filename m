Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.230]:47945 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbYJECcU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2008 22:32:20 -0400
Received: by wr-out-0506.google.com with SMTP id 69so984852wri.5
        for <linux-wireless@vger.kernel.org>; Sat, 04 Oct 2008 19:32:19 -0700 (PDT)
Message-ID: <43e72e890810041932n4034f3c6gbd5c64100338f61e@mail.gmail.com> (sfid-20081005_043223_638198_94BDCDBC)
Date: Sat, 4 Oct 2008 19:32:19 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/3] ath9k: fix oops on trying to hold the wrong spinlock
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org,
	"Vasanthakumar Thiagarajan" <vasanth@atheros.com>,
	Sujith <Sujith.Manoharan@atheros.com>,
	"Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1223073927-16266-3-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1223073927-16266-1-git-send-email-lrodriguez@atheros.com>
	 <1223073927-16266-2-git-send-email-lrodriguez@atheros.com>
	 <1223073927-16266-3-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 3, 2008 at 3:45 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> We were trying to hold the wrong spinlock due to a typo
> on IEEE80211_BAR_CTL_TID_S's definition. We use this to
> compute the tid number and then hold this this tid number's
> spinlock.
>
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Just a head up John -- Ingo has already sucked this into his tree with
a proper Reported-by. We still need it in wireless-testing though, not
sure how that will be handled.

  Luis
