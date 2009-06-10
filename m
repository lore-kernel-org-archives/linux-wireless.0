Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f180.google.com ([209.85.221.180]:59705 "EHLO
	mail-qy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbZFJMxZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 08:53:25 -0400
Received: by qyk10 with SMTP id 10so529973qyk.33
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2009 05:53:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1244621975-1238-2-git-send-email-lrodriguez@atheros.com>
References: <1244621975-1238-1-git-send-email-lrodriguez@atheros.com>
	<1244621975-1238-2-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 10 Jun 2009 05:53:07 -0700
Message-ID: <43e72e890906100553l4270007ax9e67a92594967229@mail.gmail.com>
Subject: Re: [PATCH 01/18] mac80211: disable moving between PS modes during
	scan
To: linville@tuxdriver.com, johannes@sipsolutions.net, j@w1.fi
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 10, 2009 at 1:19 AM, Luis R.
Rodriguez<lrodriguez@atheros.com> wrote:
> We don't want to trigger moving between PS mode during
> scan. With this enabled we sometimes end up sending nullfunc
> frames during scan. We're supposed to only send one prior to
> scan and after scan.
>
> This fixes an oops which occured due to an assert in ath9k:
>
> http://marc.info/?l=linux-wireless&m=124277331319024
>
> The assert was happening because the rate control algorithm
> figures it should find at least one valid dual stream or
> single stream rate. Since we allow mac80211 to send nullfunc
> frames during scan and dynamic PS was enabled at times we ended
> up trying to send nullfunc frames for the target sta on the
> wrong band for which we have no valid rate to communicate with
> it. This brakes the assumptions in rate control. We'll handle
> this sanity check next, but this fix does prevent the
> spurious nullfunc frames from actually being sent.
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

John, please use v2, sorry but we noticed one missing issue with this patch.

  Luis
