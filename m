Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:62389 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339AbZETTFL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 15:05:11 -0400
Received: by fxm2 with SMTP id 2so614476fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 20 May 2009 12:05:11 -0700 (PDT)
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [WIP PATCH] sdio support for wl12xx
References: <20090518180957.GD2580@hash.localnet>
	<20090519040239.GA12911@hash.localnet>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 20 May 2009 22:05:08 +0300
In-Reply-To: <20090519040239.GA12911@hash.localnet> (Bob Copeland's message of "Tue\, 19 May 2009 00\:02\:39 -0400")
Message-ID: <877i0begt7.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> On Mon, May 18, 2009 at 02:09:57PM -0400, Bob Copeland wrote:
>> yet for applying.  However, it does load (with the proper setup code)
>> on my Android dev phone, chip probe works, and probably the rest too,
>> though I didn't get that far.  
>
> So much for hubris!

Don't feel down about this, this is always difficult and you are making
good progress already.

> iwconfig shows:
>
> wlan0     IEEE 802.11bg  ESSID:""  
>           Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated   
>           Encryption key:off
>           Power Management:off
>           Link Quality:0  Signal level:0  Noise level:0
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>
> So at least mac80211 is up and running.

Very nice. I assume you can read the chip id and that's good, it means
that SDIO bus is working correctly.

> I'm missing the NVS tables so 'ifconfig wlan0 up' bails on fw load.

Current wl12xx code assumes that user space provides the NVS file. I'm
guessing that Android has NVS file stored in chip's EEPROM. Check the
!pWhalBus->pEEPROMBuf code path from TI's driver how to implement it.
Should be relatively easy:

http://android.git.kernel.org/?p=platform/system/wlan/ti.git;a=blob;f=sta_dk_4_0_4_32/common/src/BusAccess/Shm_Common/shmFwCtrl.c;h=946eb5ab3e82e44087c8387063369318ecfbaa34;hb=HEAD#l286

Please let me know if you have any questions. I try to get hold of
pandora, it has wl1251 using SDIO, so that I could help you with
testing.

http://www.openpandora.org/

-- 
Kalle Valo
