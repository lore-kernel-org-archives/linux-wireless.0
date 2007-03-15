Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:57705 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422813AbXCOGcX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2007 02:32:23 -0400
Message-ID: <45F8E873.4050705@warmcat.com>
Date: Thu, 15 Mar 2007 06:32:19 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC][PATCH] Add radiotap-based packet injection capability to  monitor mode
References: <45F89DA5.8000206@warmcat.com> <200703150157.02876.flamingice@sourmilk.net>
In-Reply-To: <200703150157.02876.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Wednesday 14 March 2007 21:13, Andy Green wrote:

>> This patch adds the monitor mode packet injection stuff that was talked
>> about a week or so ago to mac80211.  Using a radiotap header prepended
>> to the injection payload was felt to be a reasonable way forward.
>>
> It seems rather odd to inject with radiotap headers when capturing with AVS 
> headers. I've attached a patch which switches mac80211 to using radiotap. 

Yes it seemed that radiotap on the capture part of Monitor was preferred 
and seen as the place to end up from the last discussion.  But the itch 
I needed to scratch was the injection, so your patch and mine go 
together really well in principle and migrate the whole stack to radiotap.

> It's pretty much the same patch I posted a while ago, except all support for 
> AVS on monitor interfaces was removed. Drivers need to implement radiotap for 
> best results, but if it isn't implemented, the stack fills in a minimal 
> radiotap header. The minimal radiotap header filling code is new in this 
> version of the patch and I haven't had a chance to test it yet. The rate 
> filling part might be wrong. Anyway, I recommend basing your patch on top of 
> this one. Aside from the new default radiotap filling code, the rest is 
> fairly solid AFAIK. I had a corresponding patch to hook up radiotap support 
> in zd1211rw-mac80211 but it seems like I've lost it. I'll put together a new 
> one tomorrow.

Okay I will apply your code when I can resume work on this later today. 
   They shouldn't conflict since yours is only on the receive path and 
mine only on the transmit path.  I need to learn about quilt it seems.

I am monitoring from an ipw2200 box that issues driver radiotap headers 
and tcpdump can do a lot more with them than the PRISM2 stuff.

> +	struct ieee80211_rtap_hdr {
> +		struct ieee80211_radiotap_header hdr;
> +		u8 flags;
> +		u8 pad0;
> +		u8 rate;
> +		u8 pad1;
> +		__le16 chan_freq;
> +		__le16 chan_flags;
> +		u8 antsignal;
> +	} __attribute__ ((packed)) *rthdr;

One thing though, what is the truth about endian-ness of radiotap args? 
  It seemed from the struct ieee80211_radiotap_header header version in 
Linville's latest FC7 #4 RPM anyway that they were native endian, ie, 
using u16 in there.  I took from that the args were likewise u16, which 
was possible since the radiotap part doesn't normally leave the machine. 
  But having fixed endianness makes more sense.

-Andy
