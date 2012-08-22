Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52785 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab2HVFWF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2012 01:22:05 -0400
Received: by obbuo13 with SMTP id uo13so887501obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Aug 2012 22:22:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120819220436.GA9899@pandem0nium>
References: <20120813165340.GA10044@pandem0nium>
	<20120819220436.GA9899@pandem0nium>
Date: Wed, 22 Aug 2012 10:50:49 +0530
Message-ID: <CAD2nsn0O+dfJLnKroRUJF6TEVWUmgwvriF7M+Oy4YL2ug0gSNA@mail.gmail.com> (sfid-20120822_072210_473476_8C4909D0)
Subject: Re: AR9330 hornet board stops beaconing after a few days (0xdeadbeef)
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	openwrt-devel@lists.openwrt.org,
	Marek Lindner <lindner_marek@yahoo.de>, sven@narfation.org,
	Gabor Juhos <juhosg@openwrt.org>,
	Adrian Chadd <adrian.chadd@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Simon,

On Mon, Aug 20, 2012 at 3:34 AM, Simon Wunderlich
<simon.wunderlich@s2003.tu-chemnitz.de> wrote:
> Hello,
>
> just to bump again - isn't there anyone who can give us some hint or
> clue regarding these 0xdeadbeef entries in the registers? Couldn't find
> a connection to other reports deadbeef on the mailing list so far.

based on the suggestion from Felix Bitterli he says the deadbeef is
due to clocks
of MAC/baseband is off. Adrian says dumping RTC registers might
provide some clue

today evening i would just take a look at some h/w specific changes
that were still yet to be in ath9k.


>
> Thanks!
>         Simon
>
> On Mon, Aug 13, 2012 at 06:53:40PM +0200, Simon Wunderlich wrote:
>> Hello ath9k fellows,
>>
>> I'm using a pretty new AR9330 rev1/hornet based AP at home. After some
>> days (5 days this time), it suddenly stops beaconing. dmesg shows nothing,
>> hostapd is still running, but what I can see is:
>>
>> cat /sys/kernel/debug/ieee80211/phy0/ath9k/regdump
>> 0x000000 0xdeadbeef
>> 0x000004 0xdeadbeef
>> 0x000008 0xdeadbeef
>> 0x00000c 0xdeadbeef
>> 0x000010 0xdeadbeef
>> 0x000014 0xdeadbeef
>> [...]
>> 0x001ff4 0xdeadbeef
>> 0x001ff8 0xdeadbeef
>> 0x001ffc 0xdeadbeef
>> 0x002000 0xbadc0ffe
>> 0x002004 0xbadc0ffe
>> 0x002008 0xbadc0ffe
>> 0x00200c 0xbadc0ffe
>> 0x002010 0xbadc0ffe
>> [...]
>> 0x003ff0 0xbadc0ffe
>> 0x003ff4 0xbadc0ffe
>> 0x003ff8 0xbadc0ffe
>> 0x003ffc 0xbadc0ffe
>> 0x004000 0x00000000
>> 0x004004 0x0102420b
>> 0x004008 0x00000000
>> 0x00400c 0x00000000
>> [...] (some more sane looking registers here, and then zeros)
>> 0x004ef8 0x00000000
>> 0x004efc 0x00000000
>> 0x004f00 0xdeadbeef
>> 0x004f04 0xdeadbeef
>> 0x004f08 0xdeadbeef
>> [...] (and the rest is mostly deadbeef)
>>
>> Also /sys/kernel/debug/ieee80211/phy0/ath9k/dma shows a lot of deadbeef.
>>
>> I'm using OpenWRT r31729, a single AP bridged with Ethernet. It is normal
>> home usage, i.e. a few laptops and android phones doing not so much traffic.
>> The box stops working out of the blue after a few days without any outside
>> event (at least none I'm aware of). Sometimes this problem does not occur for
>> 2 weeks, sometimes after 12 hours, I couldn't find an easy way to reproduce it
>> yet. As said, the box is perfectly reachable via SSH, no errors in syslog or
>> anywhere else. Also an ifconfig wlan0 down and up seems to fix the problem.
>>
>> I'll try a new firmware with more debugging turned on, but have any of you
>> seen this problem? Any input would be very much appreciated. I have a complete
>> /sys/kernel/debug log from a working and a non-working system, along with
>> more info (brctl, ip config, etc) which I'd love to share with anyone interested
>> - it's too much to post on a public ml.
>>
>> Thank you very much
>> Cheers,
>>       Simon
>
>
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
>
> iEYEARECAAYFAlAxYvQACgkQrzg/fFk7axaPhACfaTuTkdyx9J/Q4z4EQBf/3sfi
> O/oAn0c8YFa8FPzayVApD2qX78OBz8AT
> =3WcZ
> -----END PGP SIGNATURE-----
>



-- 
thanks,
shafi
