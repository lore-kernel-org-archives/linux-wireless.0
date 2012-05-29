Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:50930 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab2E2VhG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 17:37:06 -0400
Received: by wgbds11 with SMTP id ds11so2680464wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 May 2012 14:37:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FC53C3A.1080001@candelatech.com>
References: <4FC53C3A.1080001@candelatech.com>
Date: Tue, 29 May 2012 14:37:04 -0700
Message-ID: <CAA93jw7TiJLtL8tHNN28bpM4b_btqh4MkuqR6gL2=t2bracb+A@mail.gmail.com> (sfid-20120529_233711_186618_0B662E39)
Subject: Re: Is there no upper limit on mac80211 pending xmit queue size?
From: Dave Taht <dave.taht@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 29, 2012 at 2:14 PM, Ben Greear <greearb@candelatech.com> wrote:
> The tx pending queues doesn't seem to be limitted, allowing
> run-away memory usage when something like pktgen is
> sending packets faster than the system can actually
> send them.
>
> [root@ct520-2011 ~]# cat /debug/ieee80211/wiphy0/queues
> 00: 0x00000000/0
> 01: 0x00000000/0
> 02: 0x00000001/40076
> 03: 0x00000000/0
> [root@ct520-2011 ~]# cat /debug/ieee80211/wiphy0/queues
> 00: 0x00000000/0
> 01: 0x00000000/0
> 02: 0x00000001/52649
> 03: 0x00000000/0
> [root@ct520-2011 ~]# cat /debug/ieee80211/wiphy0/queues
> 00: 0x00000000/0
> 01: 0x00000000/0
> 02: 0x00000001/107939
> 03: 0x00000000/0
>
> I think this is what is causing my OOM issues when sending
> with (my hacked version of) pktgen.
>
> Shouldn't there be an upper limit on the number of pending frames
> that mac80211 will queue?

something bql-like would help a lot.

>
> Thanks,
> Ben
>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Dave Täht
SKYPE: davetaht
US Tel: 1-239-829-5608
http://www.bufferbloat.net
