Return-Path: <SRS0=bKPU=SE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19E15C4360F
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 12:59:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFE27206BA
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 12:59:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bobcopeland-com.20150623.gappssmtp.com header.i=@bobcopeland-com.20150623.gappssmtp.com header.b="tCo0n8Ln"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729802AbfDBM7K (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Apr 2019 08:59:10 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:53345 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbfDBM7K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Apr 2019 08:59:10 -0400
Received: by mail-it1-f195.google.com with SMTP id y204so4861355itf.3
        for <linux-wireless@vger.kernel.org>; Tue, 02 Apr 2019 05:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bobcopeland-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=neO4sSjPWYLO857+IqBYT24C/VRmjRupgGNPvG7xRjc=;
        b=tCo0n8LnKIA5k2vRUuAl7uy+rF9T/NnOcvJVbxVrMuEge0yxNjR30rS7bTOpMl5Qc1
         oQ5DqeUWWL78e5a8YvaweDKKwg/shTqQOCjtr9bVzpwBLNr2/SJNwt66EZhiBqMvMwbM
         i3Ci5RIBMKxSg9Omd8oweC5uYv6EjerE6FSfPMqdH11+fiadek9P1fnJkaDxrLJ34rO5
         ZTCsgyNpF0D+RboXUm0N1j1G7ygwGJiInVLv/lHEutxjBHCAGD/vBmKIfz0MnosM9YIe
         bTjCsm3HbMmrFZbmBL83bF+KckxZ8jK8kIl4w02ydVyZ3CMoxi5E7qd0i6w5L/5us5SF
         3FuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=neO4sSjPWYLO857+IqBYT24C/VRmjRupgGNPvG7xRjc=;
        b=oQodMYYMWk2YMFOub/I34cbaHQgHRov8fGI8mpsf5m+a8t+Ug706o5W8xht0CVA+zI
         5rRvkf83uvlONoBaDXJ6SmpFjqXLvQOdAzdiuaMbMVYKAs1vTfy5XNUaY+dJFDuje72A
         4gCBXYrz6v6OAdZynwUAqsNKy0E/8adYNBTewt/6XIdLEVKxFxuFufAxTpmr7J71xbdS
         nZHj9H70hM+x2UqqKu22o2tE395fpyhyfZ6r34+XJqqsoAVxtzj0vGytqXx2U4fTwHM9
         5RKg/ZyzZz2v68FipSoqpMpDSlPOApa0SOO5tbG544pm5T3Lt7Jqaa71ydL/+eM+B8Ag
         0uDA==
X-Gm-Message-State: APjAAAWv82dG9/smVfs5HQ1RLlvCgUB7I1xuW4z5tJv6R5PD4VRloj/o
        s4nT5a0WyfnwBFQIbh7Ut6eA0A==
X-Google-Smtp-Source: APXvYqwA0xPikE9z8wnvqCHkaU/nvrH8YhdRCuRxVR71LRDqh0mmbfMdRuhZrk9fPlL73M1/jJ8+Nw==
X-Received: by 2002:a02:bb81:: with SMTP id g1mr3517299jan.49.1554209949923;
        Tue, 02 Apr 2019 05:59:09 -0700 (PDT)
Received: from hash (CPE30b5c2fb365b-CM18593342f28f.cpe.net.cable.rogers.com. [99.232.51.173])
        by smtp.gmail.com with ESMTPSA id w5sm6230267itd.28.2019.04.02.05.59.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Apr 2019 05:59:09 -0700 (PDT)
Received: from bob by hash with local (Exim 4.92-RC6)
        (envelope-from <me@bobcopeland.com>)
        id 1hBJ0O-0007Pp-Aq; Tue, 02 Apr 2019 08:59:08 -0400
Date:   Tue, 2 Apr 2019 08:59:08 -0400
From:   Bob Copeland <me@bobcopeland.com>
To:     Balaji Pothunoori <bpothuno@codeaurora.org>
Cc:     johannes@sipsolutions.net, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Ashok Raj Nagarajan <arnagara@codeaurora.org>
Subject: Re: [PATCH v4 1/3] cfg80211: Add support to set tx power for a
 station associated
Message-ID: <20190402125908.GD32168@localhost>
References: <1553856501-21492-1-git-send-email-bpothuno@codeaurora.org>
 <20190401204611.GA8910@localhost>
 <cd497042d164c322bc06c4cfbf26435a@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd497042d164c322bc06c4cfbf26435a@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Apr 02, 2019 at 12:00:29PM +0530, Balaji Pothunoori wrote:
> > Should this really dBm?  It's a bit asymmetric for WIPHY_TX_POWER_LEVEL
> > to
> > use mBm and this to use dBm, and I might want to adjust in half-dB steps
> > if
> > supported by hardware.  Also allocating an s16 is a bit much for dBm.
> 
> if user will send mBm value then driver has to convert to dBm because
> firmware will expect the value in dBm.
> Please refer johannes comments on following patch " [EXT] Re: [PATCH] iw:
> Add support for controlling tx power for per station"
> for the reason why we opted dBm.

The quote was:

> I would prefer if this was *dBm*, rather than mBm, and be allowed to
> take float values, i.e. this would become "limit 20".

I read that as "iw should convert fractional dBm to mBm" not "kernel should
only support dBm".

ath10k might only support dBm, fine -- but even ath5k could support
per-packet transmit power in 0.5 dB steps, so this is already limiting
applicability to existing hardware.

-- 
Bob Copeland %% https://bobcopeland.com/
