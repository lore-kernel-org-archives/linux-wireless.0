Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:47923 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934380AbeEJNCU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 09:02:20 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RESEND PATCH] cfg80211: dynamically allocate per-tid stats for station info
In-Reply-To: <5AF431F4.9060408@broadcom.com>
References: <5AF430B2.2060903@broadcom.com> <5AF431F4.9060408@broadcom.com>
Date: Thu, 10 May 2018 15:02:14 +0200
Message-ID: <87a7t7y889.fsf@toke.dk> (sfid-20180510_150224_789102_AF4E542E)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> From: Arend van Spriel <aspriel@gmail.com>
>
> With the addition of TXQ stats in the per-tid statistics the struct
> station_info grew significantly. This resulted in stack limit warnings
> like below:
>
>    CC [M]  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.o
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:
> 	In function =E2=80=98brcmf_notify_connect_status_ap=E2=80=99:
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:5530:1:
> 	error: the frame size of 1592 bytes is larger than 1024 bytes
>
> This patch adds an allocation function that those who want to provide
> per-tid stats should use to allocate the tid array, ie.
> struct station_info::pertid.
>
> Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
> Fixes: 52539ca89f36 ("cfg80211: Expose TXQ stats and parameters to
> userspace")
> Signed-off-by: Arend van Spriel <aspriel@gmail.com>
> ---
> + linux-wireless list
>
> Johannes, Toke,
>
> Here an alternative approach. Currently the only cfg80211-based driver
> providing per-tid stats is mac80211. This patch only changes mac80211
> and the other driver can keep using stack allocation. Even mac80211 could
> if wanted, but I left that part as is.

Hmm, yeah, that would work too. Though I worry that mixing dynamically
and statically allocated fields is going to result in errors further
down the road? I guess it also depends on whether struct station_info is
likely to grow more for other reasons, in which case on-stack allocation
needs to be changed anyway.

I'm fine with either approach; I'm happy to let it be up to our friendly
maintainers to decide which approach they prefer :)

-Toke
