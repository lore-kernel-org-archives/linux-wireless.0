Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35428 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751231AbdBYOlo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Feb 2017 09:41:44 -0500
Received: by mail-wm0-f47.google.com with SMTP id v186so33425964wmd.0
        for <linux-wireless@vger.kernel.org>; Sat, 25 Feb 2017 06:41:44 -0800 (PST)
Subject: Re: [PATCHv2 0/4] cfg80211: mac80211: BTCOEX feature support
To: c_traja@qti.qualcomm.com, linux-wireless@vger.kernel.org
References: <1488029873-14600-1-git-send-email-c_traja@qti.qualcomm.com>
Cc: johannes@sipsolutions.net, ath10k@lists.infradead.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <d8f813bb-fd25-9957-360e-7aa4cd117822@broadcom.com> (sfid-20170225_154148_677625_47D69936)
Date: Sat, 25 Feb 2017 15:41:39 +0100
MIME-Version: 1.0
In-Reply-To: <1488029873-14600-1-git-send-email-c_traja@qti.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25-2-2017 14:37, c_traja@qti.qualcomm.com wrote:
> From: Tamizh chelvam <c_traja@qti.qualcomm.com>
> 
> This patchset add support for BTCOEX feature to enable/disable and
> modifying btcoex priority value via nl80211
> 
> Tamizh chelvam (4):
>   ath10k: Add support to enable or disable btcoex via nl80211
>   ath10k: Add support to update btcoex priority value via nl80211
>   dt: bindings: add new dt entry for BTCOEX feature in qcom,ath10k.txt
>   ath10k: Add support to read btcoex related data from DT

This cover letter does not seem to reflect the other patches that were
sent to the wireless list as those are about cfg80211/mac80211; not ath10k?

Regards,
Arend

> v2 :
>   * Introduced NL80211_CMD_SET_BTCOEX to enable/disable btcoex and
>     to set/modify btcoex_priority.
>   * Added bool variable in wiphy structure to advertise btcoex_priority
>     feature and removed BITMAP calculation for btcoex_priority value.
>  
>  .../bindings/net/wireless/qcom,ath10k.txt          |    4 +
>  drivers/net/wireless/ath/ath10k/core.c             |   44 ++++++++-
>  drivers/net/wireless/ath/ath10k/core.h             |    9 ++
>  drivers/net/wireless/ath/ath10k/debug.c            |   40 ++-------
>  drivers/net/wireless/ath/ath10k/mac.c              |   94 +++++++++++++++++++-
>  drivers/net/wireless/ath/ath10k/mac.h              |    1 +
>  drivers/net/wireless/ath/ath10k/wmi-ops.h          |   19 ++++
>  drivers/net/wireless/ath/ath10k/wmi.c              |   20 +++++
>  drivers/net/wireless/ath/ath10k/wmi.h              |   20 +++++
>  9 files changed, 215 insertions(+), 36 deletions(-)
> 
