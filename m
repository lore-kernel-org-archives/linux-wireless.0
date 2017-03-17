Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:34332 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750977AbdCQF5R (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Mar 2017 01:57:17 -0400
Received: by mail-pf0-f178.google.com with SMTP id p189so11774445pfp.1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Mar 2017 22:56:41 -0700 (PDT)
Subject: Re: [PATCH 2/2] mac80211: Drop new node with weak power
To: Johannes Berg <johannes@sipsolutions.net>
References: <1489629438-7087-1-git-send-email-masashi.honma@gmail.com>
 <1489629438-7087-2-git-send-email-masashi.honma@gmail.com>
 <1489658630.2370.4.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <d0eb6984-6ae7-d984-b61a-0c98603294ae@gmail.com> (sfid-20170317_065805_925960_AA88AB2A)
Date: Fri, 17 Mar 2017 14:56:38 +0900
MIME-Version: 1.0
In-Reply-To: <1489658630.2370.4.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017/03/16 19:03, Johannes Berg wrote:
> I'm not really sure this is the right solution?
>
> It seems to me that it should be a function of the path selection to
> take this into account, not prohibiting the longer path entirely?

Right. To calculate metric with RSSI level is better solution than
this solution.

> It seems that this is really what the meshcfg.rssi_threshold was
> intended for, and the plink code *does* take it into account. Can you
> explain where that's breaking down?

Indeed meshcfg.rssi_threshold is already referred by some codes. But
when booting mesh node with user_mpm=1, the codes is not called.
So we need to add another code.

I will update commit log because this patch just enables
meshcfg.rssi_threshold with user_mpm=1.

Masashi Honma.
