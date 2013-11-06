Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42593 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab3KFIAB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 03:00:01 -0500
Message-ID: <1383724794.14307.2.camel@jlt4.sipsolutions.net> (sfid-20131106_090007_168391_1D6262F9)
Subject: Re: [Query] Decryption and Monitor Mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: radiotap@netbsd.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 06 Nov 2013 08:59:54 +0100
In-Reply-To: <CABPxzY++gCivs1u8nDtAeB5=p+ZkGHXmOnqud1hkh=TWB5Xprg@mail.gmail.com>
References: <CABPxzY++gCivs1u8nDtAeB5=p+ZkGHXmOnqud1hkh=TWB5Xprg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-06 at 01:22 +0530, Krishna Chaitanya wrote:

> With this wireshark is not able to decode the packets, even thought
> they are decrypted. I propose 2 solutions

Well, you can say "ignore protected bit (with IV)" in the settings of
wireshark. But I agree that this is cumbersome, and previously floated
the idea of addings bits to radiotap to make this auto-detected.

> Radiotap and Wireshark:
> 
> 1) Add 2 flags to the radiotap RX Flags (HW Decrypted the packet,
> Packet has security Header (for some chipsets which consume the
> security header as well..??).)
> 
> Based on these the wireshark dissector decodes the packet accordingly.
> 
> mac80211:
> 
> 2) Remove the security header information in the monitor path as well
> based on the existing RX_FLAGS.
> 
> 
> Solutions 2 looks more elegant and simple, any comments?

Solution 2 drops information and makes the kernel code more expensive,
so I don't think we want that.

I think the radiotap bits would be better.

johannes


