Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:64838 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbYEHXQQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 19:16:16 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1409195waf.23
        for <linux-wireless@vger.kernel.org>; Thu, 08 May 2008 16:16:15 -0700 (PDT)
Message-ID: <1ba2fa240805081616l3f49d770pefd517076a06b3ef@mail.gmail.com> (sfid-20080509_011516_185126_A9AE0D54)
Date: Fri, 9 May 2008 02:16:14 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi and tx info in skb->cb
Cc: "Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1210285845.3547.81.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1210197711.3547.1.camel@johannes.berg>
	 <1ba2fa240805071629i6c7336f6y61a7c9690820ef5e@mail.gmail.com>
	 <1210203054.3547.12.camel@johannes.berg>
	 <1ba2fa240805071721i3d1e3258s1e8c024c4cae9239@mail.gmail.com>
	 <1210255522.3547.48.camel@johannes.berg>
	 <1ba2fa240805081507j7cf991ffo5bae443b0b77a39e@mail.gmail.com>
	 <1210284656.3547.76.camel@johannes.berg>
	 <1ba2fa240805081528t45d7810cjfd553bf99daff096@mail.gmail.com>
	 <1210285845.3547.81.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 9, 2008 at 1:30 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>  > I've just scanned the thread that was explaining why is this necessary
>  > I will read it more carefully... I have just feeling that all this
>  > wlan stuff just fits very awkwardly into current networking stack.
>
>  That's not really related to wireless at all, if you want to do
>  zero-copy IO then you need to checksum when the stuff hits the wire
>  which means out of hardware buffers, which some hardware (including
>  802.11) doesn't support so you need to copy, nothing wireless specific
>  here :)
>

The FCS/CRS checksum of the wireless packet is performed in the HW but
why should I care about IP layer?

>  Anyway, with the changes davem and I are making to actually save the
>  *extra* copy we should be doing well. That's where you want to look for
>  improvements.

This is just for the bridging case, isn't it?

Tomas
