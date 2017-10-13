Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38042 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751762AbdJMJje (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 05:39:34 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: double the size of chan_stats array in adapter
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1507118766-17713-1-git-send-email-gbhat@marvell.com>
References: <1507118766-17713-1-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Rohit Fule <rohitf@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20171013093934.11BBD6095E@smtp.codeaurora.org> (sfid-20171013_113937_804459_360C12CD)
Date: Fri, 13 Oct 2017 09:39:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:

> From: Rohit Fule <rohitf@marvell.com>
> 
> When a user requests scan, driver sends multiple scan requests
> to firmware, which might be active or passive. Firmware will
> send channel statistics for each channel in the request. This will
> be stored in chan_stats array.
> 
> Few channels might report hidden SSIDs in passive scan results.
> So, once the original scan request is finished, driver issues an
> active scan request for all channels which reported hidden SSIDs.
> This will cause duplicates in the chan_stats array. At worst,
> every channel will have a hidden SSID, in which case the driver
> can issue active scan requests for each channel. So the complete
> scan statistics size will be twice of existing limit.
> 
> At present maximum number of channels returned in scan statistics
> is 31(BG) + 14(A) = 45. Clearly there will be an overflow of the
> chan_stats array in the above mentioned scenario. To fix this
> double the size of chan_stats array.
> 
> Signed-off-by: Rohit Fule <rohitf@marvell.com>
> Signed-off-by: Mangesh Malusare <mmangesh@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

2d5cc60949e0 mwifiex: double the size of chan_stats array in adapter

-- 
https://patchwork.kernel.org/patch/9984471/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
