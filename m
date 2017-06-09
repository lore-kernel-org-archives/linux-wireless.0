Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38538 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751679AbdFINuW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 09:50:22 -0400
Subject: Re: [PATCH v2 1/3] ath10k: Use complete VHT chan width for 160MHz
 workaround
To: Sven Eckelmann <sven.eckelmann@openmesh.com>,
        ath10k@lists.infradead.org
References: <20170609110750.14950-1-sven.eckelmann@openmesh.com>
Cc: linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <c91d2578-d491-c813-cbfb-f742d04f9417@candelatech.com> (sfid-20170609_155048_405725_76002213)
Date: Fri, 9 Jun 2017 06:50:11 -0700
MIME-Version: 1.0
In-Reply-To: <20170609110750.14950-1-sven.eckelmann@openmesh.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/09/2017 04:07 AM, Sven Eckelmann wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> The ath10k firmware doesn't announce its VHT channel width capabilities in
> the vht_cap information from the "service ready event" arguments. The
> driver must therefore check whether the 160MHz short GI bit is set and
> whether the driver still doesn't set the bits for the 160/80+80 MHz
> capabilities.
>
> The two bits for the channel width are a two bit integer and not two
> separate bits which cannot be parsed without the knowledge of the other
> bit. Using IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ (b10..) as a
> mask for this task doesn't make any sense. The correct mask for the VHT
> channel width should be used instead to make this check more readable.

I didn't test them, but a quick review looks good.  Thanks for picking this up!

--Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
