Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39455 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191AbaHERNQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2014 13:13:16 -0400
From: Avinash Patil <patila@marvell.com>
To: Andrey Yurovsky <yurovsky@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 5 Aug 2014 10:11:32 -0700
Subject: RE: scanning only returns results on specified channels (Marvell
 mwifiex driver)
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC4781147BBC@SC-VEXCH2.marvell.com> (sfid-20140805_191319_592067_B203C25E)
References: <CAAkeqgVTqV5cga8=Xk=PEctNNYXUumxm3U3oV2TtsjtzjhSVPA@mail.gmail.com>
In-Reply-To: <CAAkeqgVTqV5cga8=Xk=PEctNNYXUumxm3U3oV2TtsjtzjhSVPA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andrey,

What is your kernel version? Also do you have extended scan enabled? You may check init.c for adapter->ext_scan.

Thanks,
Avinash.

________________________________________
From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] On Behalf Of Andrey Yurovsky [yurovsky@gmail.com]
Sent: Tuesday, August 05, 2014 12:41 AM
To: linux-wireless@vger.kernel.org
Subject: scanning only returns results on specified channels (Marvell mwifiex driver)

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
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
