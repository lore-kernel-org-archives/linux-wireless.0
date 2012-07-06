Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64325 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab2GFHrY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 03:47:24 -0400
Received: by yhmm54 with SMTP id m54so9097877yhm.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jul 2012 00:47:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341558944.4462.9.camel@jlt3.sipsolutions.net>
References: <CANugF35YQzs7gi4htrgCUKrTDp_ia0RUo9g_HNJ=CzfnOCkO2g@mail.gmail.com>
 <CANugF37dDx1mvNJ-Y3is6OaeVFD1KwH=yh8Xef2BrN=YQPsiZQ@mail.gmail.com> <1341558944.4462.9.camel@jlt3.sipsolutions.net>
From: Andrew Chant <andrew.chant@gmail.com>
Date: Fri, 6 Jul 2012 00:46:42 -0700
Message-ID: <CANugF35qjKLdhBprQviNJaAPfM910wFCSbyEvdcCRj_UoKLqPQ@mail.gmail.com> (sfid-20120706_094727_997866_A5F431DC)
Subject: Re: v3.4.4 ath9k: kernel NULL pointer dereference in skb_dequeue
 during heavy udp xmit
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was able to reproduce this on a boot shortly afterwards without
changing the frequencies.
Exact same stack trace w/ exception of slightly different values for
RBX & R15, and R10 had 0x7f instead of 0x80.  I have not been able to
reproduce since despite trying quite hard :)  I have a picture of the
second oops if that helps.
PCI ID is 168c:0030 (AR9300 Wireless LAN adaptor (rev 01))
-Andrew

On Fri, Jul 6, 2012 at 12:15 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> -John
> +QCA folks
>
> On Thu, 2012-07-05 at 21:36 -0700, Andrew Chant wrote:
>
>>  while performance testing ath9k -> ath9k performance in 3.4.4, I got
>> a nasty kernel panic.  My performance testing involved filling the air
>> with 1410-byte UDP packets between the machines, and switching the
>> frequencies of the two cards to see how frequency affected
>> performance.  I had switched between channels 36, 40, 44, and 48.
>> Oops was on the transmitting machine, which was acting as the AP.
>>
>> Very clear screen image of the oops is at
>> https://picasaweb.google.com/lh/photo/CjBdHLZH0up5PrnmCySJidMTjNZETYmyPJy0liipFm0?feat=directlink
>
> I briefly looked at this, but I don't see a bug in mac80211. It seems
> likely that ath9k hands back a corrupted SKB, or frees one it no longer
> owns, or such. The skb->next/prev pointers seem corrupted (rcx is NULL)
> in one of the SKBs on the list, but mac80211 can't do that afaict.
>
> johannes
>
