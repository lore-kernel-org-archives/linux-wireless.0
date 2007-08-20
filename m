Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.187]:59328 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbXHTRsd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2007 13:48:33 -0400
Received: by mu-out-0910.google.com with SMTP id i10so1934347mue
        for <linux-wireless@vger.kernel.org>; Mon, 20 Aug 2007 10:48:31 -0700 (PDT)
To: Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH V3] mac80211: Turn off meaningless TKIP message when software WEP encryption is used
Date: Mon, 20 Aug 2007 19:55:46 +0200
Cc: Larry Finger <larry.finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Mattias Nissler <mattias.nissler@gmx.de>
References: <46c0d788.GYQYqGfCBKyAWrg7%Larry.Finger@lwfinger.net> <46C0E5AD.2080407@lwfinger.net> <200708131658.27758.flamingice@sourmilk.net>
In-Reply-To: <200708131658.27758.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708201955.46232.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 14 August 2007, Michael Wu wrote:
> On Monday 13 August 2007 16:13, Larry Finger wrote:
> > Yes, this empirical behavior does not seem to match one's intuition on what
> > the flag should do.
> >
> The flag means the hardware does the rc4 but doesn't bother to deal with the 
> IV/ICV. If you're going do software encryption, there's no reason to bother 
> with that flag, as that says your hardware supports and does rc4 in hardware.

Has this behavior changed recently?
e.g. Has a patch been sent recently which will correctly enforce the rule mentioned
above, but has not yet appeared in wireless-dev?

I have removed the IEEE80211_HW_WEP_INCLUDE_IV flag from rt2x00 because hardware
encryption is not implemented and the result seems to be that WPA connections will
fail. I have already confirmation from 2 users who reported that with the flag set
WPA software encryption will work, while without the WPA the encryption will fail.
I have CC'ed Mattias, so if you need debugtraces he will be able to provide them.

Another thing that is odd in this case is that the name suggests that only WEP is affected
but apparently can break WPA. :S

Ivo
