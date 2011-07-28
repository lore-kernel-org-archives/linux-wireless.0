Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58499 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab1G1Tl1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 15:41:27 -0400
Received: by fxh19 with SMTP id 19so1554577fxh.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jul 2011 12:41:26 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Harshal Chhaya <harshal@gmail.com>
Subject: Re: carl9170: Beacons at lower Tx power than data frames?
Date: Thu, 28 Jul 2011 21:41:13 +0200
Cc: linux-wireless@vger.kernel.org
References: <CAJ8GFOiTwtS7Ddjo8GR3uJMFtkBY+cFuNo3d4mX_4EwOLN9PxQ@mail.gmail.com> <201107281849.29700.chunkeey@googlemail.com> <CAJ8GFOhQySNW+hL-NHR+TEgX+tzYOhP2G3NmfTv0bGt6fDVn4Q@mail.gmail.com>
In-Reply-To: <CAJ8GFOhQySNW+hL-NHR+TEgX+tzYOhP2G3NmfTv0bGt6fDVn4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201107282141.14040.chunkeey@googlemail.com> (sfid-20110728_214131_408497_E77B051C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, July 28, 2011 08:57:01 PM Harshal Chhaya wrote:
> On Thu, Jul 28, 2011 at 11:49 AM, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
> > On Thursday, July 28, 2011 06:18:09 PM Harshal Chhaya wrote:
> >> Sujith, Christian,
> >>
> >> On the wiki page for carl9170, the first item in the "not working yet" list is:
> >> * Power Save Mode, It's implemented but buggy
> >>
> >> Is this still the case?
> >>
> >> I am seeing clients disconnect after a few seconds when I enable power
> >> saving on the clients. I can send more details if needed.
> > Oh no, unless of course your failing clients are also running carl9170.
> > Take a look at 802.11-2007 11.2 for an explantation. APs usually don't
> > do any PSM.
> 
> But I am seeing a definite problem with network stability when I
> enable power saving on my clients. The clients work as expected with
> another off-the-shelf AP.
Well, there are several different ps schemes [legacy ps, aspd and u-aspd]
and each implementation might differ in this regard. So, this is always a
bit of a apple and orange comparision... unless of course your off-the-shelf
AP uses the same mac80211 stack and just a different driver
[e.g.: ath9k(_htc)/iwlagn/p54/b43]

> Could you tell me how to enable debug output in carl9170? I would like
> to better understand what's going on in the carl9170 driver/firmware
> when I see these disconnects.
There's no such switch in the driver or firmware. But because the driver
relies on mac80211 to do the actual management, you can enable a few
options there:

CONFIG_MAC80211_VERBOSE_PS_DEBUG [dmesg]
CONFIG_MAC80211_DEBUGFS [/sys/kernel/debug/ieee80211/phyX/]

http://linuxwireless.org/en/developers/Documentation/mac80211/tracing

> All of my clients use CCMP. Which file/function do I look at to see
> what it would take to use all 64 key entries for CCMP?
drivers/net/wireless/ath/carl9170/main.c / carl9170_op_set_key

Regards,
	Christian
