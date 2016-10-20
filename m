Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:35329 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755769AbcJTHiW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Oct 2016 03:38:22 -0400
Received: by mail-yb0-f195.google.com with SMTP id g68so605690ybi.2
        for <linux-wireless@vger.kernel.org>; Thu, 20 Oct 2016 00:38:22 -0700 (PDT)
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org
From: Xuebing Wang <xbing6@gmail.com>
Subject: linux-wireless: realtek rtl8192cu user-space driver for Monitor Mode:
 about debug mechanism
Message-ID: <79834d32-270f-3e4b-6b20-c38d6ba39cd7@gmail.com> (sfid-20161020_093827_663854_C408CD4F)
Date: Thu, 20 Oct 2016 15:38:13 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry, Chaoming and community,

I am trying to do user-space driver for Monitor Mode only for rtl8192cu.

My approach is:
1) Remove unnecessary functions from kernel driver, then verify kernel 
driver works with Monitor Mode.
    -- Purpose is to keep the code minimum.
2) Re-do the code at user-space by modelling kernel driver, e.g. 
rtl92cu_hw_init()

My current status is that I can download rtl8192cu firmware 
(rtl8192cufw_TMSC.bin). But, I can not read any WiFi frames from Bulk In 
Endpoint (ep0). I guess there could be 2 possible issues:
a) I do not init rtl8192cu correctly.
b) Monitor Mode frames are ready in rtl8192cu adapter to be read out, 
but I incorrectly read Bulk In Endpoint (at user-space).

As I am lack of a debug mechanism, is there a register in rtl8192cu 
which shows there is data ready to be read out via Bulk In Endpoint and 
I can read this register back?

I noticed rtl8192cu has an Interrupt Endpoint, what is this for?

Thanks.

xuebing
