Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61167 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab0JDS51 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 14:57:27 -0400
Message-ID: <4CAA2397.9050400@gmail.com>
Date: Mon, 04 Oct 2010 11:57:27 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>, Pavel Machek <pavel@ucw.cz>,
	linux@brodo.de
Subject: Re: 2.6.36-rc6-git2: Reported regressions from 2.6.35
References: <-jYMINoCtaK.A.F5.8CPqMB@chimera> <AANLkTimUdaUkpXmNt5mPkCdWmHvBbXWA6smAP4U80yc4@mail.gmail.com>
In-Reply-To: <AANLkTimUdaUkpXmNt5mPkCdWmHvBbXWA6smAP4U80yc4@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/04/2010 11:35 AM, Luis R. Rodriguez wrote:
> Below are the 802.11 and Bluetooth ones:
>
> On Sun, Oct 3, 2010 at 2:15 PM, Rafael J. Wysocki<rjw@sisk.pl>  wrote:
>> Unresolved regressions
>> ----------------------
>
>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=19392
>> Subject         : WARNING: at drivers/net/wireless/ath/ath5k/base.c:3475 ath5k_bss_info_changed+0x44/0x168 [ath5k]()
>> Submitter       : Justin Mattock<justinmattock@gmail.com>
>> Date            : 2010-09-28 22:30 (6 days old)
>> Message-ID      :<AANLkTim5WCGKPvEkOkO_YnMF9pg8mvLfQoFBNUFpfa_k@mail.gmail.com>
>> References      : http://marc.info/?l=linux-kernel&m=128571307018635&w=2
>
> WTF -- this ended up in a bisect pointing to some PCMCIA patch! Justin:
>
>    * does this happen with wireless-testing.git ?

no this is the current Linus tree(have not tried any other tree).
as for the unresolved regression, this just was filed a few days ago..

>    * Did you do the bisect on the entire kernel? What git tree are you
> using to bisect?
>

the bisect had to be between 2.6.34 and 2.6.32 due to pcmcia breaking 
after 2.6.34(there is a bug report for that, but got resolved)

> Did you simply bring up the interface and then suspsend? Did you not
> add a new interface in between this? ath5k's add_interace has:
>
>          if (sc->vif) {
>                  ret = 0;
>                  goto end;
>          }
>
> But why does it just allow this to go through without complaining if
> multiple vifs are not supported?
>
>

the system is opensuse 11.2, I just simply start the machine boot up,
after nm connects I open a terminal then suspend in the terminal, upon 
wakeup this message appears.

>>
>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=17061
>> Subject         : 2.6.36-rc1 on zaurus: bluetooth regression
>> Submitter       : Pavel Machek<pavel@ucw.cz>
>> Date            : 2010-08-21 15:24 (44 days old)
>> Message-ID      :<20100821152445.GA1536@ucw.cz>
>> References      : http://marc.info/?l=linux-kernel&m=128240433828087&w=2
>
> I see no updates to this since August. There are boat load of PCMCIA
> changes recently, is bisect possible here?
>
>

yeah the first pcmcia bug I hit with this machine was back in may/june 
ended up doing a bisect for that(which was painful due to a slow 
machine)which ended up getting fixed.(never thought to check s2ram after 
that)

as for bluetooth the only issue I have with that is for my other 
machines which is hitting this: http://lkml.org/lkml/2010/9/1/61
(but have not had a chance to follow through due to doing the update 
broken web addresses in the kernel)

>> Regressions with patches
>> ------------------------
>
>
>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=17722
>> Subject         : 2.6.36-rc3: WARNING: at net/mac80211/scan.c:269 ieee80211_scan_completed
>> Submitter       : Thomas Meyer<thomas@m3y3r.de>
>> Date            : 2010-08-31 20:14 (34 days old)
>> Message-ID      :<201008312214.52473.thomas@m3y3r.de>
>> References      : http://marc.info/?l=linux-kernel&m=128328580504227&w=2
>>                   http://www.spinics.net/lists/netdev/msg140769.html
>> Handled-By      : Florian Mickler<florian@mickler.org>
>> Patch           : https://bugzilla.kernel.org/attachment.cgi?id=31671
>
> This seems fixed.
>
>    Luis
>

alright if this is with the latest wireless tree, then I can throw that 
in to verify that it is indeed fixed..

Justin P. Mattock
