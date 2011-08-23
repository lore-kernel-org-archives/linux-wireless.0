Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2779 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754745Ab1HWO7B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 10:59:01 -0400
Message-ID: <4E53C027.7060704@broadcom.com> (sfid-20110823_165910_770071_2A7453B2)
Date: Tue, 23 Aug 2011 16:58:47 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"networkmanager-list@gnome.org" <networkmanager-list@gnome.org>
Subject: Re: brcmsmac driver only works when sitting next to the AP
References: <20110822112737.GA5936@stt008.linux.site>
 <4E525235.7060501@broadcom.com>
 <CAKprTDHO+Hh4g3WjGijDhPtzY5PiqR0GQ_zg8Uw46-qOVXpCRQ@mail.gmail.com>
 <4E525FC7.4070802@broadcom.com>
 <CAKprTDF0iFSAkYZiLQFLX+KumyLbzNUvHocKJyzK37Kv_79EFA@mail.gmail.com>
 <4E5367AA.8040406@broadcom.com>
 <CAKprTDFret5n-AH_B_Hu6E0+B4FEGJQ=jjYbGNy8ZD5R8ReFCg@mail.gmail.com>
 <4E53728B.3030803@broadcom.com>
 <20110823095348.GA5383@stt008.linux.site>
 <4E538309.1040203@broadcom.com>
 <20110823105341.GA5604@stt008.linux.site>
 <4E538DC3.7060906@broadcom.com>
 <CAKprTDHVcEgZvNE6Ububoaf1WH+LAcHD35YriNaj47JnsVL=Xg@mail.gmail.com>
 <4E53B6B0.8010605@broadcom.com>
 <CAKprTDGKfiGGZ7uEhT+U-DJ13+NexqPZKGQez7yShC40Heph_A@mail.gmail.com>
In-Reply-To: <CAKprTDGKfiGGZ7uEhT+U-DJ13+NexqPZKGQez7yShC40Heph_A@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> These symbols are contained in the 'brcmutil.ko' module. Can you check with
>> lsmod that brcmutil is indeed loaded ?
>
> Let me check it...
>
> root@stt300:/usr/src/linux-source-3.0.0# lsmod|grep -e mac -e br
> brcmutil               13187  0
> mac80211              165768  0
> cfg80211              112970  1 mac80211
>
> Seems loaded :-?

Agree.

> root@stt300:/usr/src/linux-source-3.0.0# insmod
> drivers/staging/brcm80211/brcmsmac/brcmsmac.ko
> insmod: error inserting
> 'drivers/staging/brcm80211/brcmsmac/brcmsmac.ko': -1 Unknown symbol in
> module
>
> And dmesg:
>
> [18412.454900] brcmutil: module is from the staging directory, the
> quality is unknown, you have been warned.
> [18462.257358] brcmsmac: module is from the staging directory, the
> quality is unknown, you have been warned.
> [18462.260105] brcmsmac: Unknown symbol crc_ccitt (err 0)

The crc_ccitt warning can be resolved with a: 'sudo modprobe crc-ccitt' 
before loading the two brcm drivers.

Can you see the missing symbols with a 'cat /proc/kallsyms | grep bcm' ?

Thanks, Roland.







