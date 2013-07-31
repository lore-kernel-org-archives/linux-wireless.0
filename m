Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.ugent.be ([157.193.49.126]:48624 "EHLO smtp2.ugent.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758920Ab3GaJjb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 05:39:31 -0400
Received: from localhost (mcheck2.ugent.be [157.193.49.249])
	by smtp2.ugent.be (Postfix) with ESMTP id D36F312C3CE
	for <linux-wireless@vger.kernel.org>; Wed, 31 Jul 2013 11:39:29 +0200 (CEST)
Received: from smtp2.ugent.be ([157.193.49.126])
	by localhost (mcheck2.UGent.be [157.193.43.11]) (amavisd-new, port 10024)
	with ESMTP id AqIQVJ01lCkV for <linux-wireless@vger.kernel.org>;
	Wed, 31 Jul 2013 11:39:29 +0200 (CEST)
Received: from mail-la0-f54.google.com (mail-la0-f54.google.com [209.85.215.54])
	(Authenticated sender: mathieu.devos@ugent.be)
	by smtp2.ugent.be (Postfix) with ESMTPSA id 1CB2B12C3B0
	for <linux-wireless@vger.kernel.org>; Wed, 31 Jul 2013 11:39:29 +0200 (CEST)
Received: by mail-la0-f54.google.com with SMTP id ea20so338327lab.27
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jul 2013 02:39:28 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 31 Jul 2013 11:39:28 +0200
Message-ID: <CAE_+Soy5=MfUUahaP3Ka2onp+jP9aupbhGu_QHco=CP7Y9sqhQ@mail.gmail.com> (sfid-20130731_113940_055502_891C89F7)
Subject: Skb and ieee80211 headers
From: Mathieu Devos <mathieu.devos@ugent.be>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I hope this is the right place to ask for a little bit of help as I'm
currently beyond stuck on a challenge I'm trying to accomplish. I'm
trying to write a "simple" LKM that properly uses a ieee80211 header
to print information about the mac addresses (addr1->addr4) and later
down the road try to send my own data.

I only need to get L2 working, no need for TCP/IP, just a proper
ieee80211 based on input from skb would be huge for me.

So my issue: when placing the ieee80211 on my mac_header after I hook
my skb from my wireless device (wlan0 on android - I9100) I get a huge
amount of zero's and random(?) numbers when trying to print the
addresses. This leads me to the first conclusion that mac_header is
placed wrong when using 80211. After that I saw a lot of people just
using the skb->data pointer. Now this gives even weirder issues for me
and actually totally crashes my kernel.
So I went back to starting with printing as much info as possible.
This is a sample output after I hook my packet type:

Skb->dev->name: wlan0

Skb->head: 0xe1d37040

Skb->mac_header: 0xe1d372a9

Skb->data: 0x510                           (!!!)

Skb->tail: 0xe1d37460

Skb->len: 617

Skb->hdr_len: 0


When trying to just capture this and only print a certain message when
one of the addresses maches my dev->dev_addr I never get any data
while the phone is connected and actively browsing the internet.

I'm aware that before I throw my hook some data is being changed
around already in net/core/dev.c and in net/mac80211/rx.c The weird
part is that these seem to be putting on ethernet headers
(skb->protocol = eth_type_trans(skb, dev); AND kb_pull_inline(skb,
ETH_HLEN);
eth = eth_hdr(skb); ) on items that should be ieee80211 headers.

Any insights as to why my data header is in such a weird spot (nowhere
between my head and my tail) or where I should call the
ieee80211_header on? I have tried working my way back from tail with
len and adding another ETH_HLEN but while I get data, it never really
matches my own mac addr so I'm assuming the data is still pretty
wrong.

Added links:


https://github.com/mathieudevos/kernelmodules/blob/master/ethernet_test.c
(my own program)
https://github.com/mathieudevos/linux_kernel_3.2.48 (used to get all
the .c files from to acquire information)

If possible I'd like to write a small guide after these issues have
been fixes for people who like me would like to get started with a
basic LKM in the ieee80211 part of linux.

If this is not the place to ask these questions, please disregard me
(hopefully it is) but all help would be welcome.


Kind regards,
Mathieu Devos
