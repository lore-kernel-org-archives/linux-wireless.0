Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54518 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758577Ab2BIXHK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 18:07:10 -0500
Received: by daed14 with SMTP id d14so1855253dae.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2012 15:07:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120207171538.3336af0c@mj>
References: <CAO=xpBHy9p4yzhxaWTfG+jjw7f_OzbACmxxPnDL8AmLBS-JdwQ@mail.gmail.com>
 <CAO=xpBGT7ovdSOV77AV6wpUcTDFYr0t8GEab474mVmZm0-BhVA@mail.gmail.com> <20120207171538.3336af0c@mj>
From: Alfonso Fiore <alfonso.fiore@gmail.com>
Date: Fri, 10 Feb 2012 00:06:39 +0100
Message-ID: <CAO=xpBGRs_kYtt_w6aG2dFjO4Pgd9MrjPwn7YfuLe7bw3mGiPg@mail.gmail.com> (sfid-20120210_000715_928936_15B79140)
Subject: Re: Setting up an AP @ 5 GHz 802.11a - hostapd refuses [Could not
 select hw_mode and channel. (-1)]
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 7, 2012 at 11:15 PM, Pavel Roskin <proski@gnu.org> wrote:
>
> On Tue, 7 Feb 2012 09:20:53 +0100
> Alfonso Fiore <alfonso.fiore@gmail.com> wrote:
>
> > I also found out about ath_info
> > http://madwifi-project.org/wiki/UserDocs/AthInfo and I rewrote my
> > regdomain:
> > ./ath_info -v -g 4:0 -w 0xeffd0000 regdomain 0x68
>
> That may be dangerous.  Not all cards work with ath_info, and some can
> be broken by it permanently.  It's much safer to adjust
> ath_regd_sanitize() in drivers/net/wireless/ath/regd.c.

Hi Pavel and thank you,

I tried for days and finally I realized that when I do "make install"
still my box does not run my new code.
The only way I managed to use 5 GHz channels was setting my regdomain
to 0x00 with ath_info.

I really would like to know why my debian based box does not run my
modified compat-wireless code after "make install".

Any idea?

Thank you,
alfonso
