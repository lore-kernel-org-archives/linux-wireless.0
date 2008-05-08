Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:55493 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760814AbYEHWHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 18:07:30 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1377303waf.23
        for <linux-wireless@vger.kernel.org>; Thu, 08 May 2008 15:07:28 -0700 (PDT)
Message-ID: <1ba2fa240805081507j7cf991ffo5bae443b0b77a39e@mail.gmail.com> (sfid-20080509_000628_633481_A6C0410C)
Date: Fri, 9 May 2008 01:07:28 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi and tx info in skb->cb
Cc: "Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1210255522.3547.48.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1210197711.3547.1.camel@johannes.berg>
	 <1ba2fa240805071629i6c7336f6y61a7c9690820ef5e@mail.gmail.com>
	 <1210203054.3547.12.camel@johannes.berg>
	 <1ba2fa240805071721i3d1e3258s1e8c024c4cae9239@mail.gmail.com>
	 <1210255522.3547.48.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 8, 2008 at 5:05 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>  > >  > This is for scatter gather. Nothing to do with aggregation. If you get
>  > >  > fragmented frame you can send it out without linearizing in CPU. in
>  > >  > numer of TB - TX buffers (which is limitted bu MAX_NUM_OF_TBS)  But
>  > >  > I'm just over ever explaining :)
>  > >
>  > >  We don't support that in mac80211 right now, why do you have that there?
>  >
>  > Currently we actively use 2 of them. First for TX command second for
>  > actual frame.  It would be even worth if we need to expand
>  > each packet also for TX command.
>
>  We will no longer do that after davem and I figure out those allocation
>  patches.

Not sure these things are connected. TX command is allocated fixed for each TFD.

>  You should implement TCP checksumming in the hardware. *that* would help
>  a lot.

There is already pretty much deal of link layer in software to reduce
the cost and the complexity of the HW for these softmac NICs so
this would be kind of strange investment...but I didn't invest much
thoughts into yet.
There are probably other means to utilize scatter gather DMA then TCP
off loading. Are they any other source of scattered packets maybe
iovec?


Tomas
