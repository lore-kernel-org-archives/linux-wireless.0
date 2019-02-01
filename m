Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B15C169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 02:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73BFD20855
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 02:40:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="QyESdqte"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbfBACkr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 21:40:47 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35308 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727313AbfBACkr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 21:40:47 -0500
Received: by mail-pl1-f193.google.com with SMTP id p8so2428070plo.2
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jan 2019 18:40:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FhL5Nmvexx8gB53709TUjJGMdq01V16r0C22itMv2Fg=;
        b=QyESdqteIl8+DtcbYJbJrILCvCl8mMQIWB3IpcVIRXGtkEGDalzyHI7KHus4qWpvZ4
         g2ssHZkd8CkbVFUrzGf04gULZEw2X9yaardrIxaNwUgoSKZl/SuijO2sIKgB2fo6dilR
         omUPPnblKZMIqRjizyu/FdADwLmLFzkDjXojc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FhL5Nmvexx8gB53709TUjJGMdq01V16r0C22itMv2Fg=;
        b=ssvXSJY/4gFuPhQz/lEsHSWvJGq6dGnr+vJzaC+Ij7tb9OYxgPasgXznJG3SK8DdZ3
         EKc3sl14Q3dJ01Lxf4Lh5OJDiqiFGN1Swt0YgjPxZROWaohHVkFnEG2CcKKH13WcEsi2
         4Iy/YWvx0pRZRwu91+Hc6yVuzIBSrf5BN0z/TamgMPkEOBRcpaRSVlqi4rYcPJo9xRHX
         JDchK8xa2c1zNH+nLsMSQ+d47LW/Vb8ha+2m5khCRbfT0oewQUUCGZZpJyEgRRK1klMN
         IY/f7g0xQC4OveJ/jY9sU5L7e7WOATKdv7xA+BX/n2j5I7Ce9rRsh6KMqBDsBnRAMmYy
         +FAw==
X-Gm-Message-State: AJcUukelXDT3N/k81fO6kghtm58gXZ/gY13KGZ7vq4ALVk/eK1Rqz5kB
        voyA7gYXQ+L7Dct/1WpVoKkQ/w==
X-Google-Smtp-Source: ALg8bN4xDR7dnMwCdE1SiORz4/JUxjNbLm47SMZ4ZwIQUIX4NW0hlGf03bgwW69m4Io7YB/j3aPMwA==
X-Received: by 2002:a17:902:5601:: with SMTP id h1mr38334231pli.160.1548988846565;
        Thu, 31 Jan 2019 18:40:46 -0800 (PST)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id j6sm12885528pfg.126.2019.01.31.18.40.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 31 Jan 2019 18:40:45 -0800 (PST)
Date:   Thu, 31 Jan 2019 18:40:43 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        tehuang@realtek.com, sgruszka@redhat.com,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/24] rtw88: major fixes for 8822c to have stable
 functionalities
Message-ID: <20190201024042.GB125494@google.com>
References: <1548937297-14660-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548937297-14660-1-git-send-email-yhchuang@realtek.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Jan 31, 2019 at 08:21:13PM +0800, yhchuang@realtek.com wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> Note this patch set is based on the original patch set "rtw88: mac80211
> driver for Realtek 802.11ac wireless network chips".

The latest would be here, for reference:

https://patchwork.kernel.org/cover/10787651/
http://lkml.kernel.org/linux-wireless/1548820940-15237-1-git-send-email-yhchuang@realtek.com

> These patches are mean to make sure 8822c chip to operate normal for most
> of the basic functionalities, such as power on, switch channel, scan,
> connection establish and connection monitor.
> 
> As the original patch set was sent 3 months ago, progress has been made
> by Realtek during the past months. Now we have tested on more chips and
> released tables and parameters for them. Also the chips are all
> programed with efuse map released for 8822c.
> 
> Most of the changes are about BB and RF, both control the tx/rx path.
> PHY parameters/seq and efuse info make sure the hardware is powered on
> correctly. And channel setting updates help driver to switch to target
> channel accurately. Then trx mode setting and DACK will make hardware to
> have stable performance to tx/rx to connect to AP.
> 
> Here tx power control is also required to transmit with a precise power.
> Otherwise if the power is too high or too low, the peer might not be able
> to receive the signal.
> 
> Finally, we need to report correct tx status for mac80211's connection
> monitor system, this requires firmware's C2H of tx status report. After
> this, users can use 8822c chips for more stable wireless communication.

Besides the comments I added (and needing to fix the out-of-bounds
reads), this series helpfully adds RFE 1 support, so the 8822C chip I
have works for some basic functions -- it's not too snappy, and I feel
like there's still plenty of room for improvement but:

Tested-by: Brian Norris <briannorris@chromium.org>

And except for a handful of patches (should look at patch 1 closer),
these all look pretty sane and helpful.

Reviewed-by: Brian Norris <briannorris@chromium.org>

I still need to pass back over the original patchset and try a few more
things out.

Regards,
Brian
