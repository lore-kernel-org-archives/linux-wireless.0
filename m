Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1917 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706Ab1HWLYB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 07:24:01 -0400
Message-ID: <4E538DC3.7060906@broadcom.com> (sfid-20110823_132406_592895_484BAFB0)
Date: Tue, 23 Aug 2011 13:23:47 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>
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
In-Reply-To: <20110823105341.GA5604@stt008.linux.site>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Camaleón,

 >> Would you be able/willing to make debug related changes to our driver
 >> and build it ? I can tell you what changes to make.
 >
 > I can try whataver you want me to try :-)
 >
 > Just provide some guidance on what are the required steps.
 >

that is great. Ok, do you have the kernel sources on your system ? If 
so, cd to the root of the source tree and issue these commands to build 
the driver:

make SUBDIRS=drivers/staging/brcm80211 clean
make SUBDIRS=drivers/staging/brcm80211 modules

if that works, do a 'modprobe mac80211' followed by a 'insmod 
drivers/staging/brcm80211/brcmutil/brcmutil.ko' followed by a 'insmod 
drivers/staging/brcm80211/brcmsmac/brcmsmac.ko'.

Btw, I will assume until further notice that you disable network-manager 
prior to loading the driver.

Let me know how this goes, then we can take it to the next level.

Thanks, Roland.

