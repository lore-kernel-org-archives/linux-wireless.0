Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37704 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932591AbcI1PTT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 11:19:19 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: johannes@sipsolutions.net, kvalo@codeaurora.org,
        akarwar@marvell.com, nishants@marvell.com,
        Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
        projekt-wlan@fem.tu-ilmenau.de
Subject: Re: [PATCHv3] wireless: check A-MSDU inner frame source address on AP interfaces
References: <1475075672-30549-1-git-send-email-michael-dev@fami-braun.de>
Date: Wed, 28 Sep 2016 11:19:16 -0400
In-Reply-To: <1475075672-30549-1-git-send-email-michael-dev@fami-braun.de>
        (Michael Braun's message of "Wed, 28 Sep 2016 17:14:32 +0200")
Message-ID: <wrfja8esdpcb.fsf@redhat.com> (sfid-20160928_171922_743718_CD94FC70)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Braun <michael-dev@fami-braun.de> writes:
> When using WPA security, the station and thus the required key is
> identified by its mac address when packets are received. So a
> station usually cannot spoof its source mac address.
>
> But when a station sends an A-MSDU frame, port control and crypto
> is done using the outer mac address, while the packets delivered
> and forwarded use the inner mac address.
>
> IEEE 802.11-2012 mandates that the outer source mac address should
> match the inner source address (section 8.3.2.2). For the
> destination mac address, matching is not required (section 10.23.15).
>
> Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
> ---
>  drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  3 ++-
>  .../net/wireless/marvell/mwifiex/11n_rxreorder.c   | 18 +++++++-------
>  drivers/staging/rtl8723au/core/rtw_recv.c          |  2 +-
>  include/net/cfg80211.h                             |  9 +++----
>  net/mac80211/rx.c                                  | 11 +++++++--
>  net/wireless/util.c                                | 28 +++++++++-------------
>  6 files changed, 38 insertions(+), 33 deletions(-)

I understand the intentions of this patch are all good, but you need to
not post patches that include both staging and mainline drivers at the
same time. In general make it a patchset and do one patch per driver.

Ideally split up changes to generic code into their own patches too.

Last drivers/staging/rtl8723au is gone - so your patch is going to fail
to apply anyway.

Jes
