Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:42954 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbbCCJQ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 04:16:59 -0500
Message-ID: <54F57C07.6010507@gmail.com> (sfid-20150303_101710_933104_7CC491EA)
Date: Tue, 03 Mar 2015 10:16:55 +0100
From: Pontus Fuchs <pontus.fuchs@gmail.com>
MIME-Version: 1.0
To: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH RFC 05/14] drivers: wireless: ar5523: use container_of
References: <1425318028-26531-1-git-send-email-fw@strlen.de> <1425318028-26531-6-git-send-email-fw@strlen.de>
In-Reply-To: <1425318028-26531-6-git-send-email-fw@strlen.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-03-02 18:40, Florian Westphal wrote:
> Compile tested only due to lack of hw.
>
> If we want to shrink skb->cb then we'd have to see about
> reducing struct ieee80211_tx_info, which gets embedded inside
> skb->cb[].
>
> It provides a scratch space to be used by wireless drivers.
> ar5523 uses the maximum space available today (40 bytes), but it seems
> we don't need this -- data->skb pointer seems to always point back to the
> skb whose cb buffer the data structure resides, iow, given a pointer to the
> embedded control buffer we can infer the skb address.
>
> Cc: linux-wireless@vger.kernel.org
> Signed-off-by: Florian Westphal <fw@strlen.de>

Tested-by: Pontus Fuchs <pontus.fuchs@gmail.com>

