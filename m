Return-Path: <SRS0=bKPU=SE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED0BDC4360F
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 22:37:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC1E720700
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 22:37:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bobcopeland-com.20150623.gappssmtp.com header.i=@bobcopeland-com.20150623.gappssmtp.com header.b="UzTYJ5Oz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbfDBWhM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Apr 2019 18:37:12 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45125 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfDBWhL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Apr 2019 18:37:11 -0400
Received: by mail-io1-f67.google.com with SMTP id s7so12356945iom.12
        for <linux-wireless@vger.kernel.org>; Tue, 02 Apr 2019 15:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bobcopeland-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=C4Y3+FQE8LR/DItATdDJ7c2PykcdyvSuhWsbJ/T+O6E=;
        b=UzTYJ5OzJY9npNS7RHZu5SSKXdclpece2OVE4O5jmkFNPbMwiuPUefQwyfbEAbXVkS
         Kji30NM2zEOZklx9oqYPRYxdYkE2CJgcZ15m3ifDo5t87uQ/BddbO92E8E/FsR9my4ni
         pirdsriIhkWALIc47whZfDx9JWoxX0biuRaQOK/YXbH5QprXsZPilJo5X3XRC2w5gtAW
         Oh0QYyRqGklyQi6xYawquGodyywTrbcsTF3FqptP/7NOFrayFty4PZZZNFQTktJKBFp0
         jVYfGufEGxbcTozoZHGjXPt+/mZj48fBf3gZtoH4shl4An56jJppHhqH/REQlXodRbcn
         BTpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=C4Y3+FQE8LR/DItATdDJ7c2PykcdyvSuhWsbJ/T+O6E=;
        b=HrRixPBKWwvYo3RprcEo1qK2QB7PdGtjTOyXnlY/ThOOzXvWYC+hdX9dHHvB3LRL/p
         me8QalnhEoTWNqjeZqpO0tmtlyYccpcJBGMiVuPxYIMn9aapLuedRq9DXGoSnoqqd3SH
         msSzCZxALMW9Eee8iSsPJDXfFffQU0itjTD+b+NT/bWocQQPFKVvzB/IgBppWCtbpbol
         rvaL0dJWYIqZ0EwDWWobo5b1UbuEL01cN2g116n0/sESmRLlkrzZ2qZ+6NRuffOCGzVg
         +GUtsJLMd6V+/oaoKVIdwV95N7YqYHw3RNKWRc1zLODB81RGc0IUSDbyPwJSWm4VgYFn
         SGnw==
X-Gm-Message-State: APjAAAXlCI1D7Zote2OBGvrzgk+jKTDGZbSbRv5l78qr0B+lsz2Mq75m
        wlc90hqy9TLS4pw+NuYSNnTk7Q==
X-Google-Smtp-Source: APXvYqwuguNytTZte6kiBbzylm+RfdZ/s7vUz4nR4hWgqREYyhI3hRF6LgvP2/JnHhfNGaIuM+LjvA==
X-Received: by 2002:a6b:7b03:: with SMTP id l3mr33287381iop.250.1554244630897;
        Tue, 02 Apr 2019 15:37:10 -0700 (PDT)
Received: from hash (CPE30b5c2fb365b-CM18593342f28f.cpe.net.cable.rogers.com. [99.232.51.173])
        by smtp.gmail.com with ESMTPSA id w6sm5697875iom.22.2019.04.02.15.37.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Apr 2019 15:37:09 -0700 (PDT)
Received: from bob by hash with local (Exim 4.92-RC6)
        (envelope-from <me@bobcopeland.com>)
        id 1hBS1l-0002Du-4i; Tue, 02 Apr 2019 18:37:09 -0400
Date:   Tue, 2 Apr 2019 18:37:09 -0400
From:   Bob Copeland <me@bobcopeland.com>
To:     Balaji Pothunoori <bpothuno@codeaurora.org>
Cc:     johannes@sipsolutions.net, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Ashok Raj Nagarajan <arnagara@codeaurora.org>
Subject: Re: [PATCH v4 3/3] ath10k: add support for controlling tx power to a
 station
Message-ID: <20190402223709.GB8910@localhost>
References: <1553856587-21611-1-git-send-email-bpothuno@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1553856587-21611-1-git-send-email-bpothuno@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Mar 29, 2019 at 04:19:47PM +0530, Balaji Pothunoori wrote:
> From: Ashok Raj Nagarajan <arnagara@codeaurora.org>
> 
> This patch will add the support to control the transmit power for traffic
> to a station associated with the AP.
> 
> Underlying firmware will enforce that the maximum tx power will be based
> on the regulatory requirements. If the user given transmit power is greater
> than the allowed tx power in the given channel, then the firmware will use
> the maximum tx power in the same channel.
> 
> When 0 is sent to the firmware as tx power, it will revert to the default
> tx power for the station.
> 
> Tested Hardware : QCA9984
> Tested Firmware : 10.4-3.9.0.1-00013

I tried this on qca9984 with 10.4-3.9.0.2-00040, which claims to support
this feature, and it didn't seem to work:

- with global tx power limit set to 30 dBm, I started an iperf from station
  A -> B

- while iperf underway, I did tcpdump on a monitor on B and looked at signal
  level in radiotap, in this case around -75 dBm

- on A, changed the per-sta txpwr limit for B to something (tried as low as
  1 dBm).  verified via printk that it went through to the driver / firmware
  command and reported no error
  -> result: signal level unchanged

- on A, changed the global tx power limit to 1 dBm
  -> result: signal level dropped to ~ -95 dBm

Reading the description above, now I'm wondering if the txpower is
max(sta-power,global-power)?  If so, that seems a bit unintuitive to me,
or at least isn't what I hoped for.  I'd prefer to have per-sta power
setting override the global power.

-- 
Bob Copeland %% https://bobcopeland.com/
