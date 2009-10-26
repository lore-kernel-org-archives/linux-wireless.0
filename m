Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f216.google.com ([209.85.217.216]:40300 "EHLO
	mail-gx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbZJZFjN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 01:39:13 -0400
Received: by gxk8 with SMTP id 8so13130068gxk.1
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2009 22:39:17 -0700 (PDT)
Message-ID: <4AE53603.1040506@lwfinger.net>
Date: Mon, 26 Oct 2009 00:39:15 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Rate-setting problem with Broadcom 4315
References: <4AE49F0F.1060901@lwfinger.net> <4AE520F1.2070704@openwrt.org>
In-Reply-To: <4AE520F1.2070704@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Actually, the rate-setting mechanism is working. If I looked at the
iwconfig rate while a transmission was in progress, the rate toggled
between 48 and 54 Mb/s. When I checked between tests, it showed 1
Mb/s, which is what fooled me.

The rc_stats table is:

rate     throughput  ewma prob   this prob  this succ/attempt
success    attempts
  P  1         0.9       99.9      100.0          0(  0)        314
      314
     2         1.8       96.9      100.0          0(  0)         15
       16
     5.5       4.8       95.7      100.0          0(  0)         12
       12
    11         9.5       99.9      100.0          0(  0)        134
      138
     6         5.4       95.7      100.0          0(  0)         11
       11
     9         8.0       95.7      100.0          0(  0)         11
       11
    12        10.6       95.7      100.0          0(  0)         11
       11
    18        15.5       95.5      100.0          0(  0)         12
       13
    24        20.3       95.7      100.0          0(  0)         12
       12
    36        29.3       96.5       96.4          0(  0)       4118
     4249
T   48        37.6       96.3      100.0         23( 23)     376174
   414958
 t  54        36.8       84.8       81.5         62( 76)     356248
   427489

Total packet count::    ideal 6627      lookaround 348

The automatic throughput is about 13 Mb/s.

Larry

