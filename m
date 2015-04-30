Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:35375 "EHLO
	mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbbD3LtY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2015 07:49:24 -0400
Received: by qkhg7 with SMTP id g7so31096062qkh.2
        for <linux-wireless@vger.kernel.org>; Thu, 30 Apr 2015 04:49:24 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 30 Apr 2015 14:49:24 +0300
Message-ID: <CAFSVvReVaiEW+vzk7T5Kzap1fBsqf-rtKr-qMx4dUA02ekOaQg@mail.gmail.com> (sfid-20150430_134928_264367_E8B65C3E)
Subject: DFS region is not set for Australia. Channel 52 and above is unusable.
From: Dmitrijs Ivanovs <dmitrijs.ivanovs@ubnt.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

In latest regdb, there are four countries which have DFS channels but
DFS region is not set:

00 (World regulatory domain)
AD (Andorra)
AU (Australia)
HK (Hong-Kong)

For example:

country AU:
    (2402 - 2482 @ 40), (20)
    (5170 - 5250 @ 80), (17), AUTO-BW
    (5250 - 5330 @ 80), (24), DFS, AUTO-BW
    (5490 - 5710 @ 160), (24), DFS
    (5735 - 5835 @ 80), (30)

However, cfg80211 has explicit check for this condition since revision
55f7435c18. Because of this, I cannot use channel 52 and above when
country code is set to AU. Hostapd receives error code -EINVAL from
the kernel after NL80211_CMD_RADAR_DETECT and aborts initialization
sequence.

I have a couple of questions regarding this issue:

1) Has anyone else noticed this too?
2) Which of these three components is wrong - regdb, cfg80211 or hostapd?
