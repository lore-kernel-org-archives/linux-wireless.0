Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f45.google.com ([209.85.214.45]:59028 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab0LIGur (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 01:50:47 -0500
Received: by bwz16 with SMTP id 16so2285319bwz.4
        for <linux-wireless@vger.kernel.org>; Wed, 08 Dec 2010 22:50:46 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Wade Fitzpatrick <wade.fitzpatrick@gmail.com>
Subject: Re: carl9170 connect/disconnect loop
Date: Thu, 9 Dec 2010 07:50:26 +0100
Cc: linux-wireless@vger.kernel.org
References: <AANLkTingL2eooC2+jH6nQVADKZBFemE=6eTQ_Vhx_Swx@mail.gmail.com> <201012070032.23135.chunkeey@googlemail.com> <4D006D31.4000604@gmail.com>
In-Reply-To: <4D006D31.4000604@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201012090750.27563.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 09 December 2010 06:46:25 Wade Fitzpatrick wrote:
> 
> On 07/12/10 10:32, Christian Lamparter wrote:
> > mac80211 comes with some powerful debug tools.
> > Since you get the disconnects fairly quickly, you should
> > setup a wlan monitor.
> >
> > <http://linuxwireless.org/en/users/Documentation/iw#Adding_interfaces_with_iw>
> >   iw dev wlan1 interface add mon type monitor flags otherbss control
> >   ifconfig mon up
> >
> I'm getting a kernel panic just after bringing up the interface with 
> ifconfig. It mentions this info:
> 
> skb_under_panic ...
> kernel BUG at net/core/skbuff.c:146!
> Call Trace:
> <IRQ>
>    skb_defer_rx_timestamp
>    netif_receive_skb
never seen this one before, but maybe I was just lucky.
Because googling the BUG actually gave me this:

http://patchwork.ozlabs.org/patch/73998/ (scroll down to the bottom)

Best regards,
	Christian
