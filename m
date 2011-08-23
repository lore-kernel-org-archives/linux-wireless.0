Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37142 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab1HWP15 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 11:27:57 -0400
Received: by ewy4 with SMTP id 4so100458ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 08:27:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E53C027.7060704@broadcom.com>
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
	<4E53C027.7060704@broadcom.com>
Date: Tue, 23 Aug 2011 17:27:56 +0200
Message-ID: <CAKprTDHiYBR293bw2VzGo7QLsQNbKY6hNEiXBrn-JDYU8skqyQ@mail.gmail.com> (sfid-20110823_172801_633139_9FF71AC5)
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
>>> These symbols are contained in the 'brcmutil.ko' module. Can you check
>>> with
>>> lsmod that brcmutil is indeed loaded ?
>>
>> Let me check it...
>>
>> root@stt300:/usr/src/linux-source-3.0.0# lsmod|grep -e mac -e br
>> brcmutil               13187  0
>> mac80211              165768  0
>> cfg80211              112970  1 mac80211
>>
>> Seems loaded :-?
>
> Agree.
>
>> root@stt300:/usr/src/linux-source-3.0.0# insmod
>> drivers/staging/brcm80211/brcmsmac/brcmsmac.ko
>> insmod: error inserting
>> 'drivers/staging/brcm80211/brcmsmac/brcmsmac.ko': -1 Unknown symbol in
>> module
>>
>> And dmesg:
>>
>> [18412.454900] brcmutil: module is from the staging directory, the
>> quality is unknown, you have been warned.
>> [18462.257358] brcmsmac: module is from the staging directory, the
>> quality is unknown, you have been warned.
>> [18462.260105] brcmsmac: Unknown symbol crc_ccitt (err 0)
>
> The crc_ccitt warning can be resolved with a: 'sudo modprobe crc-ccitt'
> before loading the two brcm drivers.

Let's start over again... (and sorry for the long posts):

root@stt300:/usr/src/linux-source-3.0.0# make
SUBDIRS=drivers/staging/brcm80211 clean
  CLEAN   drivers/staging/brcm80211/.tmp_versions
  CLEAN   drivers/staging/brcm80211/Module.symvers
root@stt300:/usr/src/linux-source-3.0.0# make
SUBDIRS=drivers/staging/brcm80211 modules
  CC [M]  drivers/staging/brcm80211/brcmsmac/wl_mac80211.o
  CC [M]  drivers/staging/brcm80211/brcmsmac/wl_ucode_loader.o
  CC [M]  drivers/staging/brcm80211/brcmsmac/wlc_alloc.o
  CC [M]  drivers/staging/brcm80211/brcmsmac/wlc_ampdu.o
  CC [M]  drivers/staging/brcm80211/brcmsmac/wlc_antsel.o
  CC [M]  drivers/staging/brcm80211/brcmsmac/wlc_bmac.o
  CC [M]  drivers/staging/brcm80211/brcmsmac/wlc_channel.o
  CC [M]  drivers/staging/brcm80211/brcmsmac/wlc_main.o
  CC [M]  drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.o
  CC [M]  drivers/staging/brcm80211/brcmsmac/wlc_pmu.o
  CC [M]  drivers/staging/brcm80211/brcmsmac/wlc_rate.o
  CC [M]  drivers/staging/brcm80211/brcmsmac/wlc_stf.o
  CC [M]  drivers/staging/brcm80211/brcmsmac/aiutils.o
  CC [M]  drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.o
  CC [M]  drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.o
  CC [M]  drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.o
  CC [M]  drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_lcn.o
  CC [M]  drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_n.o
  CC [M]  drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.o
  CC [M]  drivers/staging/brcm80211/brcmsmac/bcmotp.o
  CC [M]  drivers/staging/brcm80211/brcmsmac/bcmsrom.o
  CC [M]  drivers/staging/brcm80211/brcmsmac/hnddma.o
  CC [M]  drivers/staging/brcm80211/brcmsmac/nicpci.o
  CC [M]  drivers/staging/brcm80211/brcmsmac/nvram.o
  LD [M]  drivers/staging/brcm80211/brcmsmac/brcmsmac.o
  CC [M]  drivers/staging/brcm80211/util/bcmutils.o
  CC [M]  drivers/staging/brcm80211/util/bcmwifi.o
  LD [M]  drivers/staging/brcm80211/util/brcmutil.o
  Building modules, stage 2.
  MODPOST 2 modules
  CC      drivers/staging/brcm80211/brcmsmac/brcmsmac.mod.o
  LD [M]  drivers/staging/brcm80211/brcmsmac/brcmsmac.ko
  CC      drivers/staging/brcm80211/util/brcmutil.mod.o
  LD [M]  drivers/staging/brcm80211/util/brcmutil.ko
root@stt300:/usr/src/linux-source-3.0.0# modprobe mac80211
root@stt300:/usr/src/linux-source-3.0.0# modprobe crc-ccitt
root@stt300:/usr/src/linux-source-3.0.0# insmod
drivers/staging/brcm80211/util/brcmutil.ko
root@stt300:/usr/src/linux-source-3.0.0# insmod
drivers/staging/brcm80211/brcmsmac/brcmsmac.ko
root@stt300:/usr/src/linux-source-3.0.0# lsmod|grep -e mac -e br -e cc
brcmsmac              489006  0
brcmutil               13187  1 brcmsmac
crc_ccitt              12331  1 brcmsmac
mac80211              165768  1 brcmsmac
cfg80211              112970  2 brcmsmac,mac80211

Hum... now looks better :-)

> Can you see the missing symbols with a 'cat /proc/kallsyms | grep bcm' ?

Now none:

root@stt300:~# cat /proc/kallsyms | grep bcm
f855a707 T bcm_chspec_malformed	[brcmutil]
f855a518 T bcm_pktq_init	[brcmutil]
f855a358 T bcm_bitcount	[brcmutil]
f855a192 T bcm_pktq_mdeq	[brcmutil]
f855a131 T bcm_pktq_peek_tail	[brcmutil]
f855a38e T bcm_bprintf	[brcmutil]
f855a382 T bcm_binit	[brcmutil]
f855a0b4 T bcm_pktq_pdeq	[brcmutil]
f855a650 T bcm_chspec_ctlchan	[brcmutil]
f855a548 T bcm_pkt_buf_free_skb	[brcmutil]
f855a21b T bcm_iovar_lencheck	[brcmutil]
f855a000 T bcm_pkttotlen	[brcmutil]
f855a4dd T bcm_ether_atoe	[brcmutil]
f855a288 T bcm_parse_tlvs	[brcmutil]
f855a26e T bcm_crc8	[brcmutil]
f855a41d T bcm_pktfrombuf	[brcmutil]
f855a62c T bcm_pkt_buf_get_skb	[brcmutil]
f855a063 T bcm_pktq_penq_head	[brcmutil]
f855a682 T bcm_mhz2channel	[brcmutil]
f855a0ea T bcm_pktq_pdeq_tail	[brcmutil]
f855a56d T bcm_pktq_pflush	[brcmutil]
f855a4a4 T bcm_iovar_lookup	[brcmutil]
f855a2b7 T bcm_qdbm_to_mw	[brcmutil]
f855a3c9 T bcm_mkiovar	[brcmutil]
f855a2ec T bcm_mw_to_qdbm	[brcmutil]
f855a010 T bcm_pktq_penq	[brcmutil]
f855a476 T bcm_chipname	[brcmutil]
f855a164 T bcm_pktq_mlen	[brcmutil]

Greetings,

-- 
Camaleón
