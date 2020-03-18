Return-Path: <SRS0=7roA=5D=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FABDC5ACD7
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Mar 2020 18:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 488E120780
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Mar 2020 18:36:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinux-us.20150623.gappssmtp.com header.i=@archlinux-us.20150623.gappssmtp.com header.b="Dgi2Uvv8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgCRSgF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 18 Mar 2020 14:36:05 -0400
Received: from mail-lf1-f42.google.com ([209.85.167.42]:42458 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbgCRSgF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Mar 2020 14:36:05 -0400
Received: by mail-lf1-f42.google.com with SMTP id t21so21266393lfe.9
        for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2020 11:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=archlinux-us.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=K8lhMQtpr7hEqb1aCJvPHP2EIozqp1mLwNCJEs9rhE8=;
        b=Dgi2Uvv8Kf18stpYA9I+2KOP3eHqdqZiJu1QZSjdofEB+S1mWtVwL6Ezmu1vTi7PeX
         yI0n5St9/jyUpT5M5ULkcFidraWFlU84bTLpN8dzJCw+eusEe1+GIyshKyVBcZCeWcFk
         oTUYa78i/LCTw6DT6rwJCcLOLQzFDrbqi9RG2oDkw5I649iz+SST84le/RhVuKcr357h
         HoLFromrr5VsEvtsaWPMq5WO6HS4xoLDzNOYUcnZXDsNlfHFrmpgYhvraqTFHu/LMbFY
         xtFPnxkYJCYeacHILrbjOQkiloP7B3+A1VI8fdhg05jqUKgs6ePXLX4DLhS17C3dk9pQ
         JbWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=K8lhMQtpr7hEqb1aCJvPHP2EIozqp1mLwNCJEs9rhE8=;
        b=cunxY0A0dW6i2VrcRlFEzIV/nqLETpshYa3kGNpwwy9PKXbKmTKSjuzqaU7COT589O
         HsFIb4L1DQoIEuUw9mNsVx0AY34uKLOzNTHi37NV/G5qr4dOiLpBn0QltkqH3bjaUAxV
         r528rZzsW/MTmjjTefvje5CyHvO4CEdQ0OV0fbEPzu+pYNM1i0kNzBCwiIaq0nSA3IKL
         uPqEIrk9QoHbmKbNKLIy/9zsLg0YLK04N/VKVxXlLwRK4kUkJ28sPXxa1hzGgt1gRAY4
         bQcUdNj+CoT2HagqT+BDZBgdIz5SzdHhUQCtJFgcNHyvpys4XfiDtHToWW3ZI+dRXwPp
         9LsQ==
X-Gm-Message-State: ANhLgQ3HEHvB5tVrymqfp1RqEMqF+jugzhpEMHo0FWq7uYu6hEglM87z
        FPiY2zK2Z/M1wnShYiEgBZzMRnrDy/zj368rFTfMwVwLm4ss4g==
X-Google-Smtp-Source: ADFU+vu/BsFhLB096eK6vEirXVDLyv3QcmX4xqgJvww+7RLmC0NSE6DLVjEFMR5kHd0RVFK4cuFeNnyJ6PE7zktEFXE=
X-Received: by 2002:a05:6512:3195:: with SMTP id i21mr3783916lfe.186.1584556562469;
 Wed, 18 Mar 2020 11:36:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAKzmTe0_fbse0Owau3rnLSfPWOeFbqC=eT5+p1FuaBXJDZYrUQ@mail.gmail.com>
In-Reply-To: <CAKzmTe0_fbse0Owau3rnLSfPWOeFbqC=eT5+p1FuaBXJDZYrUQ@mail.gmail.com>
From:   JM <fijam@archlinux.us>
Date:   Wed, 18 Mar 2020 19:35:51 +0100
Message-ID: <CAKzmTe0+Vz2FqK3X7b79xz_Er1635OZWMVeEbAC2f05h+an+Cg@mail.gmail.com>
Subject: Re: no 5GHz band with mwifiex (w8897)
To:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Mar 12, 2020 at 11:03 AM JM <fijam@archlinux.us> wrote:
>
> Hi,
>
> I am struggling trying to get 802.11ac working on Marvell (now NXP)
> W8897 (verext = w8897o-B0, RF87XX, FP68, 15.68.19.p17) using the
> mwifiex driver. This is supposed to be a 2x2 dual band 801.11ac chip.
>
> This is an ARMv7 embedded device where the wifi module in accessed via
> MMC. I am using kernel 5.4.24 with 15.68.19.p17 firmware and iw
> version 5.4.
>
> Despite that, iw list only detects the 2.4GHz band https://pastebin.com/5jEQmTTt
>
> Is this configuration not supported? I feel like I am missing something obvious.

I managed to figure this out, insofar as this is a firmware related
issue. Using firmware version 15.68.7.p18 the 5GHz band is available:

https://pastebin.com/aizmeNmn

I configured 802.11ac AP with hostapd and it worked correctly.

Any newer version of the firmware will report only the 2.4GHz band.
Hopefully this saves someone some time.
Jan
