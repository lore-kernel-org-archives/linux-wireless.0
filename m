Return-Path: <SRS0=9BuQ=PR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D876C43387
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 00:45:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C00120821
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 00:45:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="COKPMSZp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729101AbfAIApX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 19:45:23 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:38118 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbfAIApX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 19:45:23 -0500
Received: by mail-oi1-f195.google.com with SMTP id a77so4934590oii.5;
        Tue, 08 Jan 2019 16:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hpEhIkdCxrovNApXUNn2sYxFeYUbibi+cons5pYN6HY=;
        b=COKPMSZpYK1Ct4l2vRoC3lwEB302d542NZ4RYu7iVdnlx8BWrAJmq1Dz1XqYvvH2j5
         vrIuTXdDaojmQ+s6TAGxFusTkBxxcDeBX16QbxL5qOt9/e1aqBsUSOkWe/sCsrUpds7T
         PFzxJVL0haSEI1cRv9zmlkR6vm4H4xd7edzp1iDQ63L5Y62Vcl+6PS0FxKue3Ju4zRSA
         1MJVoLDo4iyFq5z6p+Tl8jh3Ngckihj5Rk9S2EI/Ex15+rhvvhBC3pqACSKSQHtdRa00
         y+rJFgQKN9UVkDp5TQeQDxHCxw0127WHWiIDknLylxZvqw0JVTRsD9gQFdI3dw9PuQfa
         gmwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hpEhIkdCxrovNApXUNn2sYxFeYUbibi+cons5pYN6HY=;
        b=UVoM1FChdLF9CPtuppf/qwiyE0bhCTQTk26f3HQ911JIzdZ9MSs3HHJSKOjFUJMRFc
         oMK9Ddc9w5r+BCluO6Qq4BJVoJ2k2DxO4DTcvVz5alLDTIuESVm4eli+TvX1HSBIpzYE
         ROeggGqF9My8tQf3PjRMWeHq+jYosAKrRgm+pKeNS3cw2N/N6PPh5bNwNZDKbV+qJPam
         e6roJraYERwVN9DY/HaWHs+anC07ZxVTtEQ7zQDKnCFP5XmoNXW85/gojqrX94rgGUyA
         Rf24bO87hazZ9xfXI6LCHSui1/6hcR0O4BO2pXoqYaeB8tvXc1pjYIBOFowAll8tKo+x
         nnkA==
X-Gm-Message-State: AJcUukflWbX0LAldnJbZmLr/iUrnnSMmoSUVNvFi7YfIppcDDpVF3/5q
        x5DGjyar4x045o6QRMzxie5lDv0E
X-Google-Smtp-Source: ALg8bN5OjjUJ5Gb9xpWnEoCv62mHA6ijStGvCQtozqeAL+oZzMGK7/eJba38oyIrpwangGLkk463Tw==
X-Received: by 2002:aca:490c:: with SMTP id w12mr2644937oia.8.1546994722786;
        Tue, 08 Jan 2019 16:45:22 -0800 (PST)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id q131sm32883814oih.1.2019.01.08.16.45.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 16:45:22 -0800 (PST)
Subject: Re: [PATCH v4 0/4] rtlwifi: Fix issues with rtl8723ae
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
References: <AM6PR07MB560811200F9507F8DB95488AE48A0@AM6PR07MB5608.eurprd07.prod.outlook.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <2353d9ae-0def-9a02-e6d0-25351e283128@lwfinger.net>
Date:   Tue, 8 Jan 2019 18:45:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <AM6PR07MB560811200F9507F8DB95488AE48A0@AM6PR07MB5608.eurprd07.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/8/19 4:49 PM, Bernd Edlinger wrote:
> Currently the rtl8723ae driver is broken (since v4.7).
> 
> Connection to AP is lost very often, especially when
> the signal level is not very good.
> 
> The main issue is the power save mode is basically
> not working, and seems to trigger a firmware bug.
> So I had to take out the FW LPS mode handling.
> 
> While debugging the driver I found a couple related issues,
> for instance that the signal level in dm.undec_sm_pwdb
> is no longer accurate (may be even much too high) when no more
> packets are received, and it increases the likelihood to receive
> something if the input gain is set to maximum.
> 
> The patch was tested with the rtl8723ae PCI card in my laptop
> against a FRITZ!Box 7590 AP -- the WiFi connection works now
> very reliable for me.
> 
> ChangeLog:
> 
> v2: Adjusts the defaults of swlps and fwlps module
> parameters to match the firmware capabilities instead of removing
> the whole code, so it can be easily re-activated once a firmware
> update is available.
> 
> v3: Make the title of each patch fit in one line.
> 
> v4: Try to fix the line endings the message body.
>      Which is an exchange server issue.
>      The patch does not change at all.
> 
> Bernd Edlinger (4):
>    rtl8723ae: Take the FW LPS mode handling out
>    rtl8723ae: Dont use old data for input gain control
>    rtl8723ae: Re-introduce the adaptive rate control
>    rtlwifi: Don't clear num_rx_inperiod too early
> 
>   drivers/net/wireless/realtek/rtlwifi/base.c        |  4 +-
>   drivers/net/wireless/realtek/rtlwifi/core.c        |  2 +
>   .../net/wireless/realtek/rtlwifi/rtl8723ae/dm.c    | 95 +++++++++++++++++++++-
>   .../net/wireless/realtek/rtlwifi/rtl8723ae/sw.c    |  8 +-
>   4 files changed, 101 insertions(+), 8 deletions(-)

This version applied OK.

Larry


