Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53718 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163289AbeCBBKE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 20:10:04 -0500
Subject: Re: [Make-wifi-fast] [PATCH] mac80211: Adjust TSQ pacing shift
To: Jonathan Morton <chromatix99@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>
References: <20180202151105.30043-1-toke@toke.dk>
 <40f644f6-ecfa-c31b-ce98-3491c954d6b1@qti.qualcomm.com>
 <41B51538-B1F5-4611-AAB4-923C585FF3DA@toke.dk>
 <AF418EFD-681C-4845-A114-23F54F100A9D@gmail.com>
Cc: "make-wifi-fast@lists.bufferbloat.net"
        <make-wifi-fast@lists.bufferbloat.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ryan Hsu <ryanhsu@codeaurora.org>
Message-ID: <cf67c430-d1e7-ef40-5c43-5f9557876fd8@codeaurora.org> (sfid-20180302_021238_100892_2DCB73D0)
Date: Thu, 1 Mar 2018 17:09:47 -0800
MIME-Version: 1.0
In-Reply-To: <AF418EFD-681C-4845-A114-23F54F100A9D@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/14/2018 12:23 AM, Jonathan Morton wrote:

>> On 14 Feb, 2018, at 10:18 am, Toke Høiland-Jørgensen <toke@toke.dk> wrote:
>>
>> Why does the CPU usage go up >7?
> Just as a guess, it's generating extra packets which are then laboriously discarded and retransmitted.
>
>  - Jonathan Morton

I think for 11n, like ath9k, it might be good enough for 8, but for 11ac could
aggregate a little more.

Yes, and CPU usage goes up after 6 or 7, might due to it generates extra
packets but the physical bus is capping the throughput, so that we can't see
much throughput difference after (or maybe my setup is not optimal, assumed we
should be seeing around 550-600Mbps for TCP in 11ac), but only the CPU usage
increased.

-- 
Ryan Hsu
