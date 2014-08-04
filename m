Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51577 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaHDTL3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2014 15:11:29 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so8007641wgh.15
        for <linux-wireless@vger.kernel.org>; Mon, 04 Aug 2014 12:11:26 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 4 Aug 2014 12:11:25 -0700
Message-ID: <CAAkeqgVTqV5cga8=Xk=PEctNNYXUumxm3U3oV2TtsjtzjhSVPA@mail.gmail.com> (sfid-20140804_211133_400761_66077CF8)
Subject: scanning only returns results on specified channels (Marvell mwifiex driver)
From: Andrey Yurovsky <yurovsky@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am not seeing scan results on my test setup with a Marvell 88W8787
(mwifiex driver) connected over SDIO to an ARM926.  I traced and found
that the card and driver do receive results, they do report them via
cfg80211, and those results are stored as expected (for instance, I
see every BSSID I expected to find in tmp->pub.bssid
cfg80211_bss_update()).  iw never gets them, it just acts like there
were no results.  However specifying a frequency does return results,
so this doesn't work:

iw dev mlan0 scan

but this does:

iw dev mlan0 scan 2412

I'm wondering if there's something marked incorrectly in the BSS
structure from the driver or if there is some other reason that
results aren't reported unless the frequency is specified.  When doing
the latter, I do see reasonable results when compared to another
system scanning in the same room.

Can someone else reproduce this?  Is there anything specific that I
could look at that would help resolve the problem?

Thanks,

  -Andrey
