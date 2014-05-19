Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:63239 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbaESQF5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 12:05:57 -0400
Received: by mail-wi0-f175.google.com with SMTP id f8so4434708wiw.2
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 09:05:56 -0700 (PDT)
MIME-Version: 1.0
Reply-To: andrea.merello@gmail.com
In-Reply-To: <1400515344.4273.19.camel@jlt4.sipsolutions.net>
References: <CAN8YU5Nh-FwrBWuCz-YArmHg9NSLqsS2aan_6edaVDg+i6018g@mail.gmail.com>
 <1400509775.4273.8.camel@jlt4.sipsolutions.net> <1400510950.4273.9.camel@jlt4.sipsolutions.net>
 <CAN8YU5OdpxQ0F7RMEFeQWC6PNzppHu6bDEt7Tv6dKntEUMy-9A@mail.gmail.com> <1400515344.4273.19.camel@jlt4.sipsolutions.net>
From: Andrea Merello <andrea.merello@gmail.com>
Date: Mon, 19 May 2014 18:05:36 +0200
Message-ID: <CAN8YU5P5rFjjF9kjLBi0qXwZ1-Zphfi-fbY048wbO9oBmKoULQ@mail.gmail.com> (sfid-20140519_180601_293940_C667F85C)
Subject: Re: [RFC] mac80211: at76x50x_usb driver broken by commit 3afc216..
 and RX path involved in scan
To: Johannes Berg <johannes@sipsolutions.net>
Cc: emmanuel.grumbach@intel.com,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	joerg.albert@gmx.de, Alex Stewart <alex@foogod.com>,
	n0_5p4m_p13453@hotmail.com, Pavel Roskin <proski@gnu.org>,
	agx@sigxcpu.org, Kalle Valo <kalle.valo@iki.fi>, sesmo@gmx.net,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes, I agree.. I thougth the same thing: parsing
beacons/probe-response in the driver was also my last resort :)

Andrea

On Mon, May 19, 2014 at 6:02 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2014-05-19 at 17:42 +0200, Andrea Merello wrote:
>
>> About Johannes patch.. Looks good :) But I already tried to do almost
>> the same thing in the at79 driver, but I failed, because despite
>> setting the single channel and performing a bunch of HW scan (one for
>> each ch), it happened that my HW did several full scans disregarding
>> the channel setting.
>
> Well, if it doesn't work we can go back to the mac80211 solution I
> suppose. Although the better solution even then might be to at least
> detect in the driver that we're in the scan, and then attempt to parse
> the DS information in the driver, so that it works regardless of whether
> mac80211 has both those long paths or not. That patch would also be
> simpler.
>
> johannes
>
