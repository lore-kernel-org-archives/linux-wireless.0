Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45893 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758837Ab1DNO0p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 10:26:45 -0400
Received: by bwz15 with SMTP id 15so1419756bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 07:26:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=mK2r_ZSStDhMSeHcFrx-jx=pN3A@mail.gmail.com>
References: <BANLkTimreffpSdBUogakk=E6Hn1Lf6KJ_w@mail.gmail.com>
 <BANLkTi=BgKRJXqM+8idBr-txCDPGFQSFhw@mail.gmail.com> <BANLkTi=Dtbhz=kGUSdH57JRG1DoRFP7kLw@mail.gmail.com>
 <201104131843.57676.chunkeey@googlemail.com> <BANLkTi=xyrWoYMeYCJjGhHgi=2W-CCBF7w@mail.gmail.com>
 <BANLkTi=mK2r_ZSStDhMSeHcFrx-jx=pN3A@mail.gmail.com>
From: Damian Lesiuk <lesiuk@gmail.com>
Date: Thu, 14 Apr 2011 16:26:04 +0200
Message-ID: <BANLkTi=HkWv--fUiJA_5nOB=Wj5zGcyHmQ@mail.gmail.com>
Subject: Re: carl9170: TP-LINK TL-WN822N slow connection speeds (16 mbps)
 MASTER MODE
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I changed it yesterday because of that problem. I thought It will help
and I forgot about that.
I have now:
ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'

And It's still the same.

Do you have other idea?
I am open to suggestions.

2011/4/14 Christian Lamparter <chunkeey@googlemail.com>:
> On Thu, Apr 14, 2011 at 1:53 PM, Damian Lesiuk <lesiuk@gmail.com> wrote:
>
>> ieee80211 phy0: Selected rate control algorithm 'minstrel'
>
> That's the ticket!
>
> you see minstrel does not know about ht frames at all! You need to
> have minstrel_ht for it
> to work properly. The weird thing is that minstrel_ht should be the
> default rate control
> [e.g. config.mk in compat-wireless should have:
> CONFIG_MAC80211_RC_DEFAULT=minstrel_ht ]
> algorithm, so the question is: who or what changed the default?
>
> do you have a module option for mac80211 to overwrite ieee80211_default_rc_algo?
> (check /sys/module/mac80211/parameters/ieee80211_default_rc_algo it should say
> minstrel_ht)
>
> Regards,
>    Chr
>
