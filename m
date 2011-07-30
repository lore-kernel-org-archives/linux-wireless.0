Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60920 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab1G3LO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jul 2011 07:14:29 -0400
Received: by fxh19 with SMTP id 19so3024243fxh.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jul 2011 04:14:27 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: problem on ACS
Date: Sat, 30 Jul 2011 13:17:14 +0200
Cc: MingAnn Ng <devil_eddie01@hotmail.com>, nbd@openwrt.org,
	wireless testing <linux-wireless@vger.kernel.org>
References: <COL114-W9CEFD4E7F3803005186F98A4F0@phx.gbl> <COL114-W54CACDD9B23D044E0916368A370@phx.gbl> <CAB=NE6Xc_9DcCz2KfFwR8x2wK5uUt61cH-rP5rNA+-B8XK2gYQ@mail.gmail.com>
In-Reply-To: <CAB=NE6Xc_9DcCz2KfFwR8x2wK5uUt61cH-rP5rNA+-B8XK2gYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201107301317.14486.chunkeey@googlemail.com> (sfid-20110730_131434_412634_EF94E05C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 29 July 2011 22:50:54 Luis R. Rodriguez wrote:
> On Fri, Jul 29, 2011 at 12:39 AM, MingAnn Ng <devil_eddie01@hotmail.com> wrote:
> > Survey 2 from wlan0:
> >  noise:    -84 dBm
> >  channel active time:  12 ms
> >  channel busy time:  0 ms
> >  channel receive time:  0 ms
> >  channel transmit time:  0 ms
> >  interference factor:  9223372036854775815.000000
> 
> This is caused by log2(0), this if fixed as follows:

> diff --git a/src/ap/acs.c b/src/ap/acs.c
> index aa5498e..04b1e31 100644
> --- a/src/ap/acs.c
> +++ b/src/ap/acs.c
> @@ -125,7 +125,7 @@ static u64 min(u64 a, u64 b)
>   */
>  static u64 log2_sane(u64 val)
>  {
> -	return log2(min(1073741824, val));
> +	return return (!val) ? 0 : log2(min(1073741824, val));
>  }
> 
> 
> I'll send a new version of the last patch with this fix, thanks for
> reporting this.
Wait a sec... I guess you misunderstood my post about the cut-off.
I meant that you can cut of at the bottom by using log2(max(1, val)).
This ensures that the log2 will always be >= 0 anyway. In fact log2(1) = 0.

Regards,
	Chr
