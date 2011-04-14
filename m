Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48077 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932481Ab1DNTHA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 15:07:00 -0400
Received: by bwz15 with SMTP id 15so1630204bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 12:06:59 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Damian Lesiuk <lesiuk@gmail.com>
Subject: Re: carl9170: TP-LINK TL-WN822N slow connection speeds (16 mbps) MASTER MODE
Date: Thu, 14 Apr 2011 21:06:48 +0200
Cc: linux-wireless@vger.kernel.org
References: <BANLkTimreffpSdBUogakk=E6Hn1Lf6KJ_w@mail.gmail.com> <BANLkTi=gTS5DvT+JMr35Q4puaqUaUy5Bww@mail.gmail.com> <BANLkTik2F_6w5jacYw+2-=7Jken6aF_RBQ@mail.gmail.com>
In-Reply-To: <BANLkTik2F_6w5jacYw+2-=7Jken6aF_RBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201104142106.48549.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 14 April 2011 16:50:31 Damian Lesiuk wrote:
> btw I have 40 mbps now WOW!! :)
nearly half-way.

> But my windows 7 laptop still shows it as 75 mbps connection.

yup, but that's because of hostapd. You should start it with -d (or -dd)
and check the logs for something like:

"20/40 MHz operation not permitted on channel pri=7 sec=3 based on overlapping BSSes"

this is expected [see 802.11n 11.14.12 ] and you'll have to deal with
this issue differently [e.g.: move to another channel]. 

Regards,
	Chr
