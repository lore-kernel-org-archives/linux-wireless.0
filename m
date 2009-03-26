Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f118.google.com ([209.85.221.118]:46192 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbZCZNnW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 09:43:22 -0400
Received: by qyk16 with SMTP id 16so960761qyk.33
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2009 06:43:20 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 26 Mar 2009 09:43:19 -0400
Message-ID: <d0ad1e930903260643x63f84c59we63b0d47d4eaacb8@mail.gmail.com> (sfid-20090326_144326_479216_CC6409DE)
Subject: rate control algorithms in kernel 2.6.29
From: Bo Han <hanbo00@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have the following questions about the rate control algorithms in
2.6.29 kernel.

1.  It seems that PID has been removed from the 2.6.29 kernel
configuration.   I manually got it back but its performance is worse
than minstrel (always uses very low bit rates).  Is it true that PID
will not be supported and minstrel is the only active rate control
algorithm in mac80211?

2.  How to get the four bit rates in minstrel's retry chain?  I am
using ieee80211_get_tx_rate for the first bit rate and
ieee80211_get_alt_retry_rate for the three retry rates, with index 0,
1 and 2, respectively.  But the results are the last two retry rates
(index 1 and 2) are the same as the first one and the first retry rate
(index 0) is always the lowest bit rate, 1 Mbps.  Based on minstrel's
document, the lowest bit rate should be the last one.

Comments?

Thanks,
-Bo
