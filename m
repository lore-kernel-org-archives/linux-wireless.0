Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55552 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229Ab2F0MWJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 08:22:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1SjrG2-0005WZ-67
	for linux-wireless@vger.kernel.org; Wed, 27 Jun 2012 14:22:06 +0200
Received: from 64.125.71.178 ([64.125.71.178])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 14:22:06 +0200
Received: from viscous.liquid by 64.125.71.178 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 14:22:06 +0200
To: linux-wireless@vger.kernel.org
From: Daniel Smith <viscous.liquid@gmail.com>
Subject: Re: carl9170 - single packet injection causes 3 packets to be sent.
Date: Wed, 27 Jun 2012 08:21:46 -0400
Message-ID: <jsetsp$6q2$1@dough.gmane.org> (sfid-20120627_142213_696213_6FF4FAD4)
References: <20120626222652.GA11880@192.168.1.10>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
In-Reply-To: <20120626222652.GA11880@192.168.1.10>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/26/2012 6:26 PM, marco wrote:
> Hello,
>
> I noticed a problem with packet injection on the carl9170.  When I inject a
> packet, I see 3 packets go out.  I see them with a secondary sniffer on a
> different PC.  One interesting thing is, if the packet has a broadcast DA mac,
> only one packet is injected (as I would expect).  I poked around in the
> carl9170 driver a little, and it *appears* that it is only sending the single
> packet across the usb stick, so I'm guessing the issue is with the
> firmware/hardware (?).  The only other thing I can think of is perhaps a
> radiotap header misconfiguration.  Is this a known problem or am I the only one
> seeing such a thing?  I've seen it across a few driver/firmware revisions.
>
> I'm running:
> [    8.310000] usb 1-1: driver   API: 1.9.4 2011-08-15 [1-1]
> [    8.310000] usb 1-1: firmware API: 1.9.4 2011-06-30
>
> I'm currently running compat-wireless-2011-11-22 on a 2.6.37 kernel.
>
> Thanks for any insight you can provide,
>
> Marco Fonseca
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
  Hi Marco,

I have dealt with a similar issue with the ath9k chipset. On those chips 
there is a retries parameter in the TX descriptor. By default the ath9k 
driver would set this to three as well. I forget where all I had to make 
changes (probably some in mac80211 as well as ath9k) so that I could 
pass the retries field in the radiotap header and have it honored by 
ath9k. Hopefully this help point you in the right direction.

V/r,
Daniel


