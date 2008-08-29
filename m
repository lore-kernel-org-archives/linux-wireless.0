Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:6391 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbYH2Leo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 07:34:44 -0400
Received: by ey-out-2122.google.com with SMTP id 6so255103eyi.37
        for <linux-wireless@vger.kernel.org>; Fri, 29 Aug 2008 04:34:43 -0700 (PDT)
From: Jose Ignacio Naranjo =?iso-8859-1?q?Hern=E1ndez?=
	<joseignacio.naranjo@gmail.com>
To: Jouni Malinen <j@w1.fi>
Subject: Re: VLAN testing (and mac80211_hwsim test cases in general)
Date: Fri, 29 Aug 2008 13:34:31 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <20080617154008.883383150@localhost> <1219995211.25321.24.camel@johannes.berg> <20080829083740.GA6083@jm.kir.nu>
In-Reply-To: <20080829083740.GA6083@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808291334.32148.joseignacio.naranjo@gmail.com> (sfid-20080829_133450_926516_CF8A3EA8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 29 August 2008 10:37:41 Jouni Malinen wrote:
>
> debugfs provides some help for things like VLAN (or well, would provide,
> if we actually showed that information there ;-), but that can be easily
> added). As far as data packets are concerned, we could implement a
> simple "ping" program that uses packet sockets to send some data (and
> reply to specific messages). This can then by-pass the issues with IP
> and local interface.
>

Hello all, I saw the test driver project in kernelnewbies.org, posted by 
Johannes, so I was working a little bit on the subject.

I am an absolute newbie, but I would like to share my thoughts while I was 
working on this and seeing mac80211_hwsim. Again, probably most of them are 
useless, but give me a try :). This is gonna be a little bit off-topic... 
sorry.

First of all, I built a fool bus, just for plugging and unplugging the devices 
on it (using debugfs for this task). I think it was the better way for 
simulate a real device structure, but in fact is totally useless :$. 

> It would be useful to have a tool that processes hwsim0 dump, though,
> and provides a language for writing "expect scripts" for 802.11
> (+radiotap) frames.. For example, something like "EXPECT ProbeReq CHAN=1
> SRC=<mac> DST=<bcast>; EXPECT ProbeResp CHAN=1 SRC=<bssid> DST=<mac>"
> and so on.. That tool would then write a report on what happened and
> provided pass/fail result based on requirements in the script.

Then, every device has debugfs I/O files (well, writing isn't working properly 
yet). I tought it was the best way to allow an user tool to handle 
configurations and communication with devices. I mean, the 'air' would be these 
debugfs files next to an user tool to simulate what you want using them.

Well, the next two weeks are my exams period, so i will be out of service, but 
I would like to help with this. Therefore, I'll pay attention to the list just 
in case I could help with this stuff.

Regards,
Jose Ignacio.
