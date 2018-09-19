Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52294 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731206AbeISRzQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 13:55:16 -0400
Received: by mail-wm1-f65.google.com with SMTP id y139-v6so5995394wmc.2
        for <linux-wireless@vger.kernel.org>; Wed, 19 Sep 2018 05:17:35 -0700 (PDT)
From: =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
To: sgruszka@redhat.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/5] rt2x00: set registers based on current band
Date: Wed, 19 Sep 2018 14:17:30 +0200
Message-Id: <1537359450-8843-1-git-send-email-pozega.tomislav@gmail.com> (sfid-20180919_141753_723050_4CF71019)
In-Reply-To: <20180919110540.GC22689@redhat.com>
References: <20180919110540.GC22689@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 19 Sep 2018 13:05:41 +0200, Stanislaw Gruszka wrote:

>Driver should provide on what channels are supported to mac80211, but
>user space decide what channel to use and that imply band 2.4GHz or
>5GHz. ->curr_band is just shortcut for band of current channel. Is set 
>in rt2x00lib_config() after we call rt2x00dev->ops->lib->config()
>[rt2800_config() for rt2800] . So patch is wrong. Either ->curr_band 
>should be set before ->config call or we need to consistently use
>rf->channel <= 14 for band check in any rt2800_config() function and
>all it's subroutines. I prefer the second solution (i.e. rf->channel)
>and now I can see few places when we use ->curr_band, what is a bug.

Works fine, no any kind of regression, especially not performance ones.
So I don't see a reason to claim it is wrong or bug just because you
prefer current solution.

>It's because ->curr_band initialize to 0 and NL80211_BAND_2GHZ
>happen to be 0. Also problem will not trigger on single band
>2.4GHz devices.

Can you show us how will the problem trigger on dual band devices?
