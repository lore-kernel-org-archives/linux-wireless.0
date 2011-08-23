Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48380 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab1HWOsx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 10:48:53 -0400
Received: by ewy4 with SMTP id 4so80201ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 07:48:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E53B6B0.8010605@broadcom.com>
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
Date: Tue, 23 Aug 2011 16:48:51 +0200
Message-ID: <CAKprTDGKfiGGZ7uEhT+U-DJ13+NexqPZKGQez7yShC40Heph_A@mail.gmail.com> (sfid-20110823_164857_032840_7F5B33AC)
Subject: Re: brcmsmac driver only works when sitting next to the AP
From: =?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>
To: Roland Vossen <rvossen@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	"networkmanager-list@gnome.org" <networkmanager-list@gnome.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/8/23 Roland Vossen <rvossen@broadcom.com>:
>>> that is great. Ok, do you have the kernel sources on your system ? If so,
>>> cd
>>> to the root of the source tree and issue these commands to build the
>>> driver:
>>>
>>> make SUBDIRS=drivers/staging/brcm80211 clean
>>> make SUBDIRS=drivers/staging/brcm80211 modules
>>
>> Done!
>
> perfect !
>
>>> if that works, do a 'modprobe mac80211' followed by a 'insmod
>>> drivers/staging/brcm80211/brcmutil/brcmutil.ko'
>>
>> root@stt300:/usr/src/linux-source-3.0.0# insmod
>> drivers/staging/brcm80211/brcmutil/brcmutil.ko
>> insmod: can't read 'drivers/staging/brcm80211/brcmutil/brcmutil.ko':
>> No such file or directory
>>
>> Ah, okay...
>> root@stt300:/usr/src/linux-source-3.0.0# insmod
>> drivers/staging/brcm80211/util/brcmutil.ko
>
> Ah, the source tree had some renaming. It is named 'brcmutil' in my source
> but in the source you are using it is still named 'util'.

Yep... I'm using Debian kernel sources for their "testing" branch.

>> root@stt300:/usr/src/linux-source-3.0.0#
>>
>>> followed by a 'insmod drivers/staging/brcm80211/brcmsmac/brcmsmac.ko'.
>>
>> Mmm... this one returned an error:
>>
>> root@stt300:/usr/src/linux-source-3.0.0# insmod
>> drivers/staging/brcm80211/brcmsmac/brcmsmac.ko
>> insmod: error inserting
>> 'drivers/staging/brcm80211/brcmsmac/brcmsmac.ko': -1 Unknown symbol in
>> module
>>
>> And dmesg shows:
>>
>> [16235.934894] brcmsmac: Unknown symbol bcm_chspec_malformed (err 0)
>> [16235.934985] brcmsmac: Unknown symbol bcm_pktq_init (err 0)
>> [16235.935035] brcmsmac: Unknown symbol bcm_bitcount (err 0)
>> [16235.935092] brcmsmac: Unknown symbol bcm_pktq_peek_tail (err 0)
>> [16235.935130] brcmsmac: Unknown symbol bcm_pktq_mdeq (err 0)
>> [16235.935283] brcmsmac: Unknown symbol bcm_pktq_pdeq (err 0)
>> [16235.935329] brcmsmac: Unknown symbol bcm_chspec_ctlchan (err 0)
>> [16235.935375] brcmsmac: Unknown symbol bcm_pkt_buf_free_skb (err 0)
>> [16235.935414] brcmsmac: Unknown symbol bcm_iovar_lencheck (err 0)
>> [16235.935457] brcmsmac: Unknown symbol bcm_pkttotlen (err 0)
>> [16235.935519] brcmsmac: Unknown symbol bcm_ether_atoe (err 0)
>> [16235.935581] brcmsmac: Unknown symbol bcm_crc8 (err 0)
>> [16235.935636] brcmsmac: Unknown symbol bcm_pkt_buf_get_skb (err 0)
>> [16235.935677] brcmsmac: Unknown symbol bcm_pktq_penq_head (err 0)
>> [16235.935735] brcmsmac: Unknown symbol bcm_pktq_pdeq_tail (err 0)
>> [16235.935774] brcmsmac: Unknown symbol bcm_pktq_pflush (err 0)
>> [16235.935827] brcmsmac: Unknown symbol bcm_pktq_penq (err 0)
>> [16235.935882] brcmsmac: Unknown symbol bcm_pktq_flush (err 0)
>
> These symbols are contained in the 'brcmutil.ko' module. Can you check with
> lsmod that brcmutil is indeed loaded ?

Let me check it...

root@stt300:/usr/src/linux-source-3.0.0# lsmod|grep -e mac -e br
brcmutil               13187  0
mac80211              165768  0
cfg80211              112970  1 mac80211

Seems loaded :-?

root@stt300:/usr/src/linux-source-3.0.0# insmod
drivers/staging/brcm80211/brcmsmac/brcmsmac.ko
insmod: error inserting
'drivers/staging/brcm80211/brcmsmac/brcmsmac.ko': -1 Unknown symbol in
module

And dmesg:

[18412.454900] brcmutil: module is from the staging directory, the
quality is unknown, you have been warned.
[18462.257358] brcmsmac: module is from the staging directory, the
quality is unknown, you have been warned.
[18462.260105] brcmsmac: Unknown symbol crc_ccitt (err 0)

Greetings,

-- 
Camaleón
