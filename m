Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:34078 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbYEHW2p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 18:28:45 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1387604waf.23
        for <linux-wireless@vger.kernel.org>; Thu, 08 May 2008 15:28:44 -0700 (PDT)
Message-ID: <1ba2fa240805081528t45d7810cjfd553bf99daff096@mail.gmail.com> (sfid-20080509_002742_123936_376DB97F)
Date: Fri, 9 May 2008 01:28:44 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi and tx info in skb->cb
Cc: "Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1210284656.3547.76.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1210197711.3547.1.camel@johannes.berg>
	 <1ba2fa240805071629i6c7336f6y61a7c9690820ef5e@mail.gmail.com>
	 <1210203054.3547.12.camel@johannes.berg>
	 <1ba2fa240805071721i3d1e3258s1e8c024c4cae9239@mail.gmail.com>
	 <1210255522.3547.48.camel@johannes.berg>
	 <1ba2fa240805081507j7cf991ffo5bae443b0b77a39e@mail.gmail.com>
	 <1210284656.3547.76.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  Ah, no, I misread that. Well, I think it might still help to say you
>  need N bytes headroom and use those since you wouldn't have to allocate
>  an extra skb.

There actually might be a benefit in doing this but it is quite a
change in design which means not now.

>
>  > >  You should implement TCP checksumming in the hardware. *that* would help
>  > >  a lot.
>  >
>  > There is already pretty much deal of link layer in software to reduce
>  > the cost and the complexity of the HW for these softmac NICs so
>  > this would be kind of strange investment...but I didn't invest much
>  > thoughts into yet.
>  > There are probably other means to utilize scatter gather DMA then TCP
>  > off loading. Are they any other source of scattered packets maybe
>  > iovec?
>
>  Well as far as I know those too would be zero-copy IO which only works
>  if you have TCP checksumming in hardware.

I've just scanned the thread that was explaining why is this necessary
I will read it more carefully... I have just feeling that all this
wlan stuff just fits very awkwardly into current networking stack.

Tomas
