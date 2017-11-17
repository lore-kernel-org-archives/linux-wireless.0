Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:43488 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759870AbdKQXJu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Nov 2017 18:09:50 -0500
Subject: Re: bug in commit: mac80211: Fix possible sband related NULL pointer
 de-reference
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <238cb9e7-c78f-66e4-01ed-5fead4f35820@candelatech.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <0825febb-ae2f-a054-dd06-ef8f9688e7a8@candelatech.com> (sfid-20171118_000953_647454_C4E30DE2)
Date: Fri, 17 Nov 2017 15:09:47 -0800
MIME-Version: 1.0
In-Reply-To: <238cb9e7-c78f-66e4-01ed-5fead4f35820@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/17/2017 02:30 PM, Ben Greear wrote:
> Author: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> Date:   Thu Apr 27 12:45:38 2017 +0530
>
>     mac80211: Fix possible sband related NULL pointer de-reference
>
>     Existing API 'ieee80211_get_sdata_band' returns default 2 GHz band even
>     if the channel context configuration is NULL. This crashes for chipsets
>     which support 5 Ghz alone when it tries to access members of 'sband'.
>     Channel context configuration can be NULL in multivif case and when
>     channel switch is in progress (or) when it fails. Fix this by replacing
>     the API 'ieee80211_get_sdata_band' with  'ieee80211_get_sband' which
>     returns a NULL pointer for sband when the channel configuration is NULL.
>
> ...
>
> This commit appears to break  sta_set_rate_info_tx on drivers that are not using chantx,
> because it calls ieee80211_get_sband, which does a WARN_ON when there is no chantx.
>
> Any idea how to make this work for chandef drivers?

Maybe there are other issues in my case.  I'll test out a patch to make it WARN_ON_ONCE
and submit once I get some other problems ironed out.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
