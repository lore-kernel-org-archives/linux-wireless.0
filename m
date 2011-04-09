Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38723 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab1DIWYg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Apr 2011 18:24:36 -0400
Received: by bwz15 with SMTP id 15so3646134bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Apr 2011 15:24:35 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [RFT] p54: implement multicast + arp req PS filter
Date: Sun, 10 Apr 2011 00:24:29 +0200
Cc: linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
References: <201104020058.17232.chunkeey@googlemail.com> <201104081508.27822.chunkeey@googlemail.com> <201104100023.52526.jcmvbkbc@gmail.com>
In-Reply-To: <201104100023.52526.jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104100024.30155.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 09 April 2011 22:23:51 Max Filippov wrote:
>>> So, I associated with that AP and obtained an IP address.
>> Just a question, that popped into my head: "Have you enabled PS?
>> either with "iw dev wlanX set power_save on" or
>> ?iwconfig wlanX power on?, because the filters may be restricted
>> to PSM.
> 
> I hadn't. LMAC API doc doesn't say that they're related.
> This time I ran tests both with "iwconfig wlan0 power on"
> and without it. Looks like PSM only makes kernel print
> "wlan0: detected beacon loss from AP - sending probe request".
> I see no other effect.
Well, that settles that.

>>[..]
> In the ARP case, when there's no other traffic on p54spi, all ARP requests
> are dropped. But if there's some egress traffic from p54spi, filter seems
> to work correctly: only ARP requests that match filter pass through.
"no other traffic" sounds like a the psm filter at work, have you disabled
it before starting the experiment?

or apply:

http://www.spinics.net/lists/linux-wireless/msg65488.html
(this patch makes the psm less aggressive by only sleeping
for one beacon interval at most [instead of listen_interval = 5]).

> In the multicast case filter seems to work correctly, but it treats broadcast
> as subject to that filtering too. By default only 01:00:5e:00:00:01 gets into
> priv->mc_maclist, so we miss all broadcasts.
ok, so we have to reserve a spot of ff:ff:ff:ff:ff:ff.

> These two filters seem to interfere:
> - if we set ARP filter and multicast filter without broadcast, we miss all
> ARPs if there's no egress traffic;
> - if we set ARP filter and multicast filter with broadcast, or don't set
> multicast filter at all we get all ARPs.
> 
> This effect does not depend on filter setup order.
interesting, well a unnamed [but trustworthy] source told us that ST identified
a problem with the arp/multicast filter some time ago, unfortunately I haven't
seen any updated p54spi firmwares lately. Maybe this sagred stuff works?
 
Thanks,
	Christian
