Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62283 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbaHEUvR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2014 16:51:17 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so1605165wgh.3
        for <linux-wireless@vger.kernel.org>; Tue, 05 Aug 2014 13:51:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CBACCFA0AEB13A41977475BCF3E896FC4781147BBC@SC-VEXCH2.marvell.com>
References: <CAAkeqgVTqV5cga8=Xk=PEctNNYXUumxm3U3oV2TtsjtzjhSVPA@mail.gmail.com>
	<CBACCFA0AEB13A41977475BCF3E896FC4781147BBC@SC-VEXCH2.marvell.com>
Date: Tue, 5 Aug 2014 13:51:16 -0700
Message-ID: <CAAkeqgWXvonrETQUMj-O8cs5ZHiHwMyx+ccyyFjW+atUCa+eYw@mail.gmail.com> (sfid-20140805_225123_059513_5B4F485C)
Subject: Re: scanning only returns results on specified channels (Marvell
 mwifiex driver)
From: Andrey Yurovsky <yurovsky@gmail.com>
To: Avinash Patil <patila@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 5, 2014 at 10:11 AM, Avinash Patil <patila@marvell.com> wrote:
> What is your kernel version? Also do you have extended scan enabled? You may check init.c for adapter->ext_scan.

I built 3.16 from Linus' tree and scanning is working properly, so
this appears to only be an issue with the version shipped in 3.15 (and
possibly some other earlier ones).  Thanks and sorry for the noise.

  -Andrey

> ________________________________________
> From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] On Behalf Of Andrey Yurovsky [yurovsky@gmail.com]
> Sent: Tuesday, August 05, 2014 12:41 AM
> To: linux-wireless@vger.kernel.org
> Subject: scanning only returns results on specified channels (Marvell mwifiex driver)
>
> I am not seeing scan results on my test setup with a Marvell 88W8787
> (mwifiex driver) connected over SDIO to an ARM926.  I traced and found
> that the card and driver do receive results, they do report them via
> cfg80211, and those results are stored as expected (for instance, I
> see every BSSID I expected to find in tmp->pub.bssid
> cfg80211_bss_update()).  iw never gets them, it just acts like there
> were no results.  However specifying a frequency does return results,
> so this doesn't work:
>
> iw dev mlan0 scan
>
> but this does:
>
> iw dev mlan0 scan 2412
>
> I'm wondering if there's something marked incorrectly in the BSS
> structure from the driver or if there is some other reason that
> results aren't reported unless the frequency is specified.  When doing
> the latter, I do see reasonable results when compared to another
> system scanning in the same room.
>
> Can someone else reproduce this?  Is there anything specific that I
> could look at that would help resolve the problem?
>
> Thanks,
>
>   -Andrey
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
