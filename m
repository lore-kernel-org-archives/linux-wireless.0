Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:34997 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753604AbdDKMCk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 08:02:40 -0400
Received: by mail-wm0-f51.google.com with SMTP id w64so61664128wma.0
        for <linux-wireless@vger.kernel.org>; Tue, 11 Apr 2017 05:02:40 -0700 (PDT)
Subject: Re: [PATCHv4 0/2] cfg80211: mac80211: BTCOEX feature support
To: c_traja@qti.qualcomm.com, linux-wireless@vger.kernel.org
References: <1491905730-16392-1-git-send-email-c_traja@qti.qualcomm.com>
Cc: ath10k@lists.infradead.org, johannes@sipsolutions.net,
        tamizhchelvam@codeaurora.org, linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <50d867d1-740c-85b9-2bab-6ef49c4d87c1@broadcom.com> (sfid-20170411_140346_925495_9E4FC5E0)
Date: Tue, 11 Apr 2017 14:02:37 +0200
MIME-Version: 1.0
In-Reply-To: <1491905730-16392-1-git-send-email-c_traja@qti.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ linux-bluetooth, Marcel

On 11-4-2017 12:15, c_traja@qti.qualcomm.com wrote:
> From: Tamizh chelvam <c_traja@qti.qualcomm.com>
> 
> This patchset add support for BTCOEX feature to enable/disable and
> modifying btcoex priority value via nl80211

So you make a distinction between WMM ACs, but what about the different
types/profiles of BT traffic?

Regards,
Arend

> Tamizh chelvam (2):
>   cfg80211: Add support to enable or disable btcoex and set
>     btcoex_priority
>   mac80211: Add support to enable or disable btcoex and set btcoex
>     priority value
> 
> v4 :
>   * Moved btcoex_priority_support_flag enum to nl80211.h and renamed it.
>   * fixed typo.
> 
> v3 :
>   * Introduced NL80211_EXT_FEATURE_BTCOEX_PRIORITY to expose
>     btcoex priority support and removed bool variable.
> 
> v2 :
>   * Introduced NL80211_CMD_SET_BTCOEX to enable/disable btcoex and
>     to set/modify btcoex_priority.
>   * Added bool variable in wiphy structure to advertise btcoex_priority
>     feature and removed BITMAP calculation for btcoex_priority value.
> 
>  include/net/cfg80211.h       |    6 +++++
>  include/net/mac80211.h       |    5 +++++
>  include/uapi/linux/nl80211.h |   50 ++++++++++++++++++++++++++++++++++++++++++
>  net/mac80211/cfg.c           |    9 ++++++++
>  net/mac80211/driver-ops.h    |   15 +++++++++++++
>  net/mac80211/trace.h         |   20 +++++++++++++++++
>  net/wireless/nl80211.c       |   45 +++++++++++++++++++++++++++++++++++++
>  net/wireless/rdev-ops.h      |   13 +++++++++++
>  net/wireless/trace.h         |   17 ++++++++++++++
>  9 files changed, 180 insertions(+)
> 
