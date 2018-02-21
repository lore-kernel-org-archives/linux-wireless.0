Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:44352 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752720AbeBUI4k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Feb 2018 03:56:40 -0500
Received: by mail-qk0-f195.google.com with SMTP id v124so1011299qkh.11
        for <linux-wireless@vger.kernel.org>; Wed, 21 Feb 2018 00:56:40 -0800 (PST)
Subject: Re: [PATCH 0/3] Export TXQ parameters and statistics via nl80211
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
References: <20180219170224.14816-1-toke@toke.dk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A8D3445.3040300@broadcom.com> (sfid-20180221_095653_630631_05B6E2D5)
Date: Wed, 21 Feb 2018 09:56:37 +0100
MIME-Version: 1.0
In-Reply-To: <20180219170224.14816-1-toke@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/19/2018 6:02 PM, Toke Høiland-Jørgensen wrote:
> This series adds TXQ parameters and statistics that were previously only
> available through debugfs to the nl80211 userspace interface and the
> cfg80211 kernel interface. Patches for iw to print the statistics and
> change the settings are included.

So what is your motivation for having this exposed through nl80211. For 
the average end-user the stats and parameters are fairly fuzzy. So can 
we expect some manual in which is described what parameter should be 
tweaked based on the retrieved statistics.

Also do you intend to remove the debugfs method? Seems a bit redundant 
to have two mostly identical interfaces in place.

> Wasn't sure whether to include the updates to nl80211.h in the iw
> patchset, so I didn't :)

Updating the nl80211.h in iw should be done with a copy from the kernel 
so it has to wait for the kernel patch to be applied (which tree I am 
unsure).

Regards,
Arend

> -Toke
>
>
> Kernel patch:
>
> Toke Høiland-Jørgensen (1):
>    cfg80211: Expose TXQ stats and parameters to userspace
>
>   include/net/cfg80211.h       |  52 +++++++++++++++++++
>   include/uapi/linux/nl80211.h |  57 +++++++++++++++++++++
>   net/mac80211/cfg.c           |  95 +++++++++++++++++++++++++++++++++++
>   net/mac80211/ieee80211_i.h   |   3 ++
>   net/mac80211/main.c          |   3 ++
>   net/mac80211/sta_info.c      |  12 +++++
>   net/mac80211/tx.c            |  20 ++++++++
>   net/wireless/nl80211.c       | 115 +++++++++++++++++++++++++++++++++++++++++++
>   net/wireless/rdev-ops.h      |  12 +++++
>   net/wireless/trace.h         |  14 ++++++
>   10 files changed, 383 insertions(+)
>
>
> iw patches (updated nl80211.h not included):
>
> Toke Høiland-Jørgensen (2):
>    iw: Print TXQ statistics for stations and interfaces
>    iw: Add getting and setting of TXQ params for phy
>
>   info.c      |   3 ++
>   interface.c |   6 ++++
>   iw.h        |   2 ++
>   phy.c       | 116 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   station.c   |  91 ++++++++++++++++++++++++++++++++++++++++++++++-
>   5 files changed, 217 insertions(+), 1 deletion(-)
>
