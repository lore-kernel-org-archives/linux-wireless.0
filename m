Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49350 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730876AbeISSmu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 14:42:50 -0400
Date: Wed, 19 Sep 2018 15:04:57 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/5] rt2x00: set registers based on current band
Message-ID: <20180919130456.GA26735@redhat.com> (sfid-20180919_150501_004093_CA9F57E5)
References: <20180919110540.GC22689@redhat.com>
 <1537359450-8843-1-git-send-email-pozega.tomislav@gmail.com>
 <20180919124717.GA26590@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180919124717.GA26590@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 19, 2018 at 02:47:18PM +0200, Stanislaw Gruszka wrote:
> > Can you show us how will the problem trigger on dual band devices?
> 
> When you switch from some 2.4GHz channel to 5GHz channel (or vice versa)
> ->curr_band will point to old band not the new one. To fix that you 
> have to move curr_band assignemt before ->config() in
> rt2x00lib_config() i.e:
> 
> rt2x00dev->curr_band = conf->chandef.chan->band; 
> rt2x00dev->ops->lib->config(rt2x00dev, &libconf, ieee80211_flags);
> 
> However I do not see the point of replacyng rf->channel check 
> to ->curr_band check. What you can do is oposite thing, replace
> wrong usage of ->curr_band in very few places in rt2800_config()
> subroutines to rf->channel check.

Actually ->curr_band is used in rt2800_config_ant() subroutines
not in rt2800_config() subroutines so things looks ok.

Stanislaw
