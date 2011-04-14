Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51865 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757975Ab1DNOLh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 10:11:37 -0400
Received: by iyb14 with SMTP id 14so1464160iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 07:11:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=xyrWoYMeYCJjGhHgi=2W-CCBF7w@mail.gmail.com>
References: <BANLkTimreffpSdBUogakk=E6Hn1Lf6KJ_w@mail.gmail.com>
	<BANLkTi=BgKRJXqM+8idBr-txCDPGFQSFhw@mail.gmail.com>
	<BANLkTi=Dtbhz=kGUSdH57JRG1DoRFP7kLw@mail.gmail.com>
	<201104131843.57676.chunkeey@googlemail.com>
	<BANLkTi=xyrWoYMeYCJjGhHgi=2W-CCBF7w@mail.gmail.com>
Date: Thu, 14 Apr 2011 16:11:36 +0200
Message-ID: <BANLkTi=mK2r_ZSStDhMSeHcFrx-jx=pN3A@mail.gmail.com>
Subject: Re: carl9170: TP-LINK TL-WN822N slow connection speeds (16 mbps)
 MASTER MODE
From: Christian Lamparter <chunkeey@googlemail.com>
To: Damian Lesiuk <lesiuk@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 14, 2011 at 1:53 PM, Damian Lesiuk <lesiuk@gmail.com> wrote:

> ieee80211 phy0: Selected rate control algorithm 'minstrel'

That's the ticket!

you see minstrel does not know about ht frames at all! You need to
have minstrel_ht for it
to work properly. The weird thing is that minstrel_ht should be the
default rate control
[e.g. config.mk in compat-wireless should have:
CONFIG_MAC80211_RC_DEFAULT=minstrel_ht ]
algorithm, so the question is: who or what changed the default?

do you have a module option for mac80211 to overwrite ieee80211_default_rc_algo?
(check /sys/module/mac80211/parameters/ieee80211_default_rc_algo it should say
minstrel_ht)

Regards,
    Chr
