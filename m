Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53345 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab1BDJ01 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 04:26:27 -0500
Received: by wyb28 with SMTP id 28so2046700wyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Feb 2011 01:26:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikqBvB6+bwKRPFb+oSstzbR9K=bdmjK-D76D23Q@mail.gmail.com>
References: <1296800640-6381-1-git-send-email-vnatarajan@atheros.com>
	<1296800640-6381-2-git-send-email-vnatarajan@atheros.com>
	<AANLkTikqBvB6+bwKRPFb+oSstzbR9K=bdmjK-D76D23Q@mail.gmail.com>
Date: Fri, 4 Feb 2011 14:56:26 +0530
Message-ID: <AANLkTinD4XS7XKeQfy-hW==KcVExh_ybGpT3UdoHKYP_@mail.gmail.com>
Subject: Re: [PATCH 2/2] mac80211: Fix a race on enabling power save.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 4, 2011 at 1:07 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Thu, Feb 3, 2011 at 10:24 PM, Vivek Natarajan <vnatarajan@atheros.com> wrote:
>> There is a race of queuing a data frame before the tx completion
>> of nullfunc frame for enabling power save. This has caused a power
>> save state mismatch between the station and the AP. This patch
>> addresses this issue.
>>
>> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
>
> Not stable fix? What't the effect of not having this patch? The
> description could use some love to explain better what is observed in
> terms of metrics or loss.

The issue is similar to the other patch I posted for ath9k. As there
is a power save state mismatch, AP continues to send the data traffic
whereas the station might be in sleep mode. I see a IxChariot
disconnect issue while testing continuous Rx UDP traffic. I will add
these details in the next version after the review of these two PS
related patches.

VIvek.
