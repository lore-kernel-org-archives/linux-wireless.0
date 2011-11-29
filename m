Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40073 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab1K2RkP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 12:40:15 -0500
Received: by vcbfk14 with SMTP id fk14so4869869vcb.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Nov 2011 09:40:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111126.152955.1479814929356999712.davem@davemloft.net>
References: <20111126.152955.1479814929356999712.davem@davemloft.net>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 29 Nov 2011 12:39:53 -0500
Message-ID: <CAB=NE6U411A0w-VUYum7U_0r4CPc1Vaxv2jNEGdpbTv1EHFbZg@mail.gmail.com> (sfid-20111129_184029_476054_4B8EDCEA)
Subject: Re: prism54 bug...
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/11/26 David Miller <davem@davemloft.net>:
>
> Someone please look into this.
>
> In prism2_ioctl_scan_req() gcc generates a warning:
>
> drivers/net/wireless/prism54/isl_ioctl.c: In function ‘prism2_ioctl_scan_req’:
> drivers/net/wireless/prism54/isl_ioctl.c:2733:14: warning: array subscript is above array bounds [-Warray-bounds]
>
> it's a pretty serious issue, it's about the call to:
>
>                current_ev = prism54_translate_bss(ndev, &info, current_ev,
>                                                   extra + IW_SCAN_MAX_DATA,
>                                                   &(bsslist->bsslist[i]),
>                                                   noise);
>
> it's not the bsslist->bsslist[i] thing, that's fine.
>
> It's "extra + IW_SCAN_MAX_DATA".
>
>        char *extra = "";
>        char *current_ev = "foo";
>
> and IW_SCAN_MAX_DATA is 4096.  Effectively these calls crap IW entries
> into random pieces of memory as far as I can tell.
>
> We either need to figure out where this ioctl interface expects the
> response to go, or remove the ioctl and this code entirely since it's
> obviously not being used.

I'm going to kill all this shit. Thanks for the report.

  Luis
