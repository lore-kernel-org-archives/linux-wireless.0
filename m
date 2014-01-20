Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:54966 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbaATPnA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 10:43:00 -0500
Received: by mail-bk0-f49.google.com with SMTP id v15so525577bkz.22
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 07:42:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390228033-19162-3-git-send-email-michal.kazior@tieto.com>
References: <1390228033-19162-1-git-send-email-michal.kazior@tieto.com>
	<1390228033-19162-3-git-send-email-michal.kazior@tieto.com>
Date: Mon, 20 Jan 2014 16:42:58 +0100
Message-ID: <CA+BoTQkNX_uxvcn=cUnsGesB8tzotmA7kLCtLApCceYOENxCyA@mail.gmail.com> (sfid-20140120_164303_116561_A93AF30B)
Subject: Re: [PATCH 2/2] mac80211: implement multi-interface CSA
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 January 2014 15:27, Michal Kazior <michal.kazior@tieto.com> wrote:
> This implements a fairly simple multi-interface
> CSA. It doesn't support multiple channel
> contexts so it doesn't support multi-channel.
>
> Once a CSA is started other CSA requests are
> denied until the first one is completed. A single
> CSA may affect multiple interfaces. CSA can happen
> only if all target CSA chandefs are compatible and
> all affected interfaces are sharing a single
> channel context exclusively.
>
> A new worker is introduced: csa_complete_work
> which is used to account per-interface countdowns
> and issue the actual channel switch after last
> interface completes its CSA.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>  net/mac80211/cfg.c         | 376 ++++++++++++++++++++++++++++++++++++++-------
>  net/mac80211/chan.c        | 117 ++++++++++----
>  net/mac80211/ibss.c        |   2 +-
>  net/mac80211/ieee80211_i.h |  23 ++-
>  net/mac80211/iface.c       |   5 +-
>  net/mac80211/main.c        |   6 +
>  net/mac80211/mesh.c        |   2 +-
>  net/mac80211/mlme.c        |   9 +-
>  net/mac80211/tx.c          |  15 +-
>  9 files changed, 453 insertions(+), 102 deletions(-)

This breaks STA CSA as I forgot to set sdata->csa_complete for the
mode. This makes ieee80211_chanctx_chswitch() eventually fail. I'll
fix that in v2.


Michał
