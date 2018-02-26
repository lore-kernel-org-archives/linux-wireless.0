Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:39336 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752312AbeBZP4t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 10:56:49 -0500
Subject: Re: [PATCH] Revert "ath10k: send (re)assoc peer command when NSS
 changed"
To: Karthikeyan Periyasamy <periyasa@codeaurora.org>,
        ath10k@lists.infradead.org
References: <1519625792-12010-1-git-send-email-periyasa@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <aedd8281-ee1b-e5ae-2521-fd3a7a221dd6@candelatech.com> (sfid-20180226_165654_076625_081EA40A)
Date: Mon, 26 Feb 2018 07:56:46 -0800
MIME-Version: 1.0
In-Reply-To: <1519625792-12010-1-git-send-email-periyasa@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/25/2018 10:16 PM, Karthikeyan Periyasamy wrote:
> This reverts commit 55884c045d31a29cf69db8332d1064a1b61dd159.
>
> When Ath10k is in AP mode and an unassociated STA sends a VHT action frame
> (Operating Mode Notification for the NSS change) periodically to AP this causes
> ath10k to call ath10k_station_assoc() which sends WMI_PEER_ASSOC_CMDID during
> NSS update. Over the time (with a certain client it can happen within 15 mins
> when there are over 500 of these VHT action frames) continuous calls of
> WMI_PEER_ASSOC_CMDID cause firmware to assert due to resource exhaust.

Can you share exactly which resource the firmware ran out of?  It would seem to
be a FW bug if it is leaking, so maybe it can be fixed as well...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
