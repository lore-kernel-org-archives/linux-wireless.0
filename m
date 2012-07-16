Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58836 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab2GPVba convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jul 2012 17:31:30 -0400
Received: by yhmm54 with SMTP id m54so5825404yhm.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jul 2012 14:31:30 -0700 (PDT)
Date: Mon, 16 Jul 2012 16:31:22 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	=?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Roland Vossen <rvossen@broadcom.com>
Subject: Re: [3.2.y] Re: Brcmsmac driver woes, possible regression?
Message-ID: <20120716213122.GA3078@burratino> (sfid-20120716_233138_931012_08897DC9)
References: <CAKprTDGtvUFSBb_XK01bi6bJa3dynu73Lq-jTs=E78E3QwSqpA@mail.gmail.com>
 <20120601174237.GA31781@burratino>
 <CAKprTDHepfbCKquvnG8CQ2=-tSNbgOSkT6R0GQmEx9UyuiZyMQ@mail.gmail.com>
 <CAKprTDHQT8Oodh_YD5CWffSGJXAg-HgFMjR0STVgEZRxH4FaSQ@mail.gmail.com>
 <20120604084200.GA30645@tiikeri.vuoristo.local>
 <20120604173121.GA9238@stt008.linux.site>
 <20120605050620.GC3118@burratino>
 <CAKprTDHGqDpdZY4ErZmPEc7Ur81GeQoH8tiAL5hrfhAE0RtbvQ@mail.gmail.com>
 <20120611031544.GB3092@burratino>
 <4FE0CA49.3030909@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4FE0CA49.3030909@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi again,

Quick update.

Arend van Spriel wrote:
> On 06/11/2012 05:15 AM, Jonathan Nieder wrote:

>> Newer kernels seemed to work better than old, so I asked her to apply
>> the following patches agains the 3.2.y tree (the exact patches used
>> are at [2]):
>> 
>>   6b1a89afbf97 brcm80211: smac: drop "40MHz intolerant" flag from HT
>>                capability info
>>   c261bdf8acad brcm80211: smac: indicate severe problems to Mac80211
>>   0bf1f883fd0a brcm80211: smac: removed MPC related code
>>   4412953061de brcm80211: smac: removed MPC related variables
>>   28237002e726 brcm80211: smac: removed down-on-watchdog MPC functionality
>>   43ac09722f8e brcm80211: smac: removed down-on-rf-kill functionality
>>   a8bc4917ed6b brcm80211: smac: bugfix for tx mute in brcms_b_init()
>>   c6c44893c864 brcm80211: smac: fixed inconsistency in transmit mute
>>   2646c46d5679 brcm80211: smac: modified Mac80211 callback interface
>>   dc460127898c brcm80211: smac: mute transmit on ops_start
>>   1525662ac280 brcm80211: smac: changed check to confirm STA only support
>>   b7eec4233c34 brcm80211: smac: replace own access category definitions with
>>                mac80211 enum
>>   e9ca530a7b18 brcm80211: smac: don't modify sta parameters when adding sta
>>   8906c43cb160 brcm80211: smac: fix channel frequency
>>   02a588a2e3b9 brcm80211: smac: combine promiscuous mode functionality
>>   be667669ec01 brcm80211: smac: added support for mac80211 filter flags
>>  [d3f311349add brcm80211: fix usage of set tx power] --- unrelated, my mistake
>>   aa1f2f0a3218 brcm80211: smac: precendence bug in wlc_phy_attach()
>>   1570e53c14ff brcm80211: smac: fix unintended fallthru in
>>                wlc_phy_radio_init_2057()

With all the above patches applied on top of 3.2.21, Camaleón quickly
gets the reconnects and gnome-shell segfaults if she does not supply
the password to network-manager in time[1].  That means the patch that
prevents trouble is presumably one of the four listed below.

>>   137dabed34a1 brcm80211: smac: remove smatch warnings from brcmsmac code
>>   2b0a53d51b5f brcm80211: smac: only print block-ack timeout message at
>>                trace level
>>   6b8da423315b brcm80211: smac: do not use US as fallback regulatory hint
>>   94a2ca311cf4 brcm80211: smac: only provide valid regulatory hint

Thanks,
Jonathan

[1] http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=295;bug=664767
