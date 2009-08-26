Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:38586 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbZHZCni (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 22:43:38 -0400
Received: by ewy2 with SMTP id 2so1023030ewy.17
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2009 19:43:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1251192477.10667.3.camel@johannes.local>
References: <950315.98615.qm@web23105.mail.ird.yahoo.com>
	 <1251192477.10667.3.camel@johannes.local>
Date: Wed, 26 Aug 2009 03:43:38 +0100
Message-ID: <3ace41890908251943n4affc955n61768e2ce98d0c94@mail.gmail.com>
Subject: Re: [RFC/RFT] rtl8187: Implement rfkill support
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: htl10@users.sourceforge.net,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 25, 2009 at 10:27 AM, Johannes
Berg<johannes@sipsolutions.net> wrote:
> On Tue, 2009-08-25 at 06:51 +0000, Hin-Tak Leung wrote:
>
>> dmesg and rfkill/state corresponds exactly to what the sliding switch
>> does (in the on position, dmesg says it is on, states says 2, in the
>> off position, dmesg says it is off, state says 1). NM basically
>> ignores rfkill/state, and just if'up the device whenever it notices
>> the device has gone down.
>
> NM can't ignore the state since cfg80211 enforces it.
>
> Can you please use rfkill (http://git.sipsolutions.net/rfkill.git) to
> see what's going on? Like print out events while you slide the button
> and use NM etc.
>
> One thing that would be possible -- does your poll callback work while
> the interface is down? Try to tell NM to turn off the wireless network,
> and see whether the state ever changes with your slider.

--------------------
[root@localhost rfkill]#  ./rfkill list
0: (null): Wireless LAN
	Soft blocked: no
	Hard blocked: no
[root@localhost rfkill]#  ./rfkill event
RFKILL event: idx 0 type 1 op 0 soft 0 hard 0
RFKILL event: idx 0 type 1 op 2 soft 0 hard 1
RFKILL event: idx 0 type 1 op 2 soft 0 hard 0
RFKILL event: idx 0 type 1 op 2 soft 0 hard 1
RFKILL event: idx 0 type 1 op 2 soft 0 hard 0
RFKILL event: idx 0 type 1 op 2 soft 0 hard 1
RFKILL event: idx 0 type 1 op 2 soft 0 hard 0
RFKILL event: idx 0 type 1 op 2 soft 0 hard 1
RFKILL event: idx 0 type 1 op 2 soft 0 hard 0
RFKILL event: idx 0 type 1 op 2 soft 0 hard 1
RFKILL event: idx 0 type 1 op 2 soft 0 hard 0
RFKILL event: idx 0 type 1 op 2 soft 0 hard 1
RFKILL event: idx 0 type 1 op 2 soft 0 hard 0
RFKILL event: idx 0 type 1 op 2 soft 0 hard 1
RFKILL event: idx 0 type 1 op 2 soft 0 hard 0
RFKILL event: idx 0 type 1 op 2 soft 0 hard 1
RFKILL event: idx 0 type 1 op 2 soft 0 hard 0
RFKILL event: idx 0 type 1 op 2 soft 0 hard 1
^C
[root@localhost rfkill]#  ./rfkill list
0: (null): Wireless LAN
	Soft blocked: no
	Hard blocked: yes
[root@localhost rfkill]#  ./rfkill list
0: (null): Wireless LAN
	Soft blocked: no
	Hard blocked: no
--------------
The rfkill event hard just goes 1 and 0 whenever I slide the switch,
regardless of what NM does . e.g. NM set to disable networking has no
effect on the 1/0 switch (it happens just depending on the slide
switch and nothing else), and nothing changes when NM noticed
rfkill'ed if down & decided to if'up and reassociate.

Basically the rfkill event state just depends on the slide switch,
regardless of NM (if it is set to enable wireless networking, it just
if up the device again; if it is set to disable, it just stayed
disable & the device stay down, but the event state continues to
respond to the slide switch).
