Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:37020 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751809AbeA0Tof (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Jan 2018 14:44:35 -0500
Received: by mail-oi0-f42.google.com with SMTP id t78so2462500oih.4
        for <linux-wireless@vger.kernel.org>; Sat, 27 Jan 2018 11:44:34 -0800 (PST)
Subject: Re: [PATCH 04/10] rtlwifi: Extend tx_power_by_rate_offset size for
 newer IC
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180126074645.27201-1-pkshih@realtek.com>
 <20180126074645.27201-5-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <57387d71-27cf-2448-dfe3-b4748930c36b@lwfinger.net> (sfid-20180127_204439_473783_03B255A3)
Date: Sat, 27 Jan 2018 13:44:33 -0600
MIME-Version: 1.0
In-Reply-To: <20180126074645.27201-5-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2018 01:46 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> In older design, the TX power is grouped into rate section (smaller array
> size), but new design groups them into rate (larger array size). Thus,
> we extend the size for both cases, and add compile time assertion.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---

I hate to see any arrays getting larger, but I can see that changes in rates 
make this inevitable. The BUILD_BUG_ON() is a good addition.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
