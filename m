Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:33731 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbZAMQpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 11:45:12 -0500
Received: by ewy10 with SMTP id 10so118418ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 08:45:10 -0800 (PST)
Message-ID: <496CC514.3030307@gmail.com> (sfid-20090113_174518_168636_74B06E18)
Date: Tue, 13 Jan 2009 17:45:08 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
References: <494698AF.4020204@gmail.com> <200812161510.09499.chunkeey@web.de> <496B795B.8090700@gmail.com> <200901131449.41189.chunkeey@web.de>
In-Reply-To: <200901131449.41189.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> On Monday 12 January 2009 18:09:47 Artur Skawina wrote:
>> kernel: phy0: p54 detected a LM86 firmware
>> kernel: p54: rx_mtu reduced from 3240 to 2392
>> kernel: phy0: FW rev 2.13.1.0 - Softmac protocol 5.5
> Well, I guess you got the latest wireless-testing tree, right?

Actually that was with the wireless testing tree from ~ mid-december,
plus the fix from this thread, as i wanted to get things working
before upgrading and running into new regressions. As that didn't
work that well, i've applied some p54 patches, hence the rx_mtu
line above; it didn't make any significant difference - the box
still dies within minutes.

> Then you can try if the "latest" firmware (the ones for => 2.6.29) improve the situation.

will do, after upgrading the kernel (could take a few days).

>> so to test the device further i set up hostapd, which mostly worked; after 
>> a few tweaks (eg patching out country code setting in hostapd)
> patching out country code?! why that?
> currently, hostapd is the only thing that works out-of-the-box :-D

hostapd was aborting no matter what country code i configured, so i
disabled that, leaving figuring this out for later.
[also hostapd is reporting some TX failures, didn't investigate yet]

> you should execute "iw reg set XY" where XY is a 2-(upper-case)-letter ID of your country, e.g US = USA, CZ, DE, FR, etc...
> (see http://wireless.kernel.org/en/users/Documentation/iw )
> and then you have to wait a bit (e.g sleep 1) before you can start hostapd.

will try.

>> i got an almost working AP. "Almost" because connecting a client works sometimes,
>> but not always, and there seems to be way too much packet loss going on.
>> "dtim_period=1" seemed to improve things enough to achieve basic ipv4
>> connectivity (w/o it dhcp seemed to work, but arp usually did not).
> well, do you have another wifi device which has sniffer/monitor mode?

Another identical p54usb device will do i guess.

> It sounds like your client or AP has a problem with power save management.

yes, the client in this case was a windows mobile device, hostap being the ap.

>> But then i ran into a more serious issue -- the machine locks up completely
>> when trying to use the device (just connecting and disconnecting a client is
>> often enough). Happens after ~ a minute, the computer freezes, isn't
>> responsible over network, nothing in logs. It's a headless box, tried
>> hooking up a kbd and monitor, but that didn't help - console was dead too.
>> After setting up netconsole i first got two skb truesize warnings [1], then
>> after a short while again a complete lock up, nothing on the console.
>> Then tried plugging in a keyboard and that provoked a stream of order 0 page
>> allocation failures, but the machine remained dead.
> "order 0 page allocation failures"? Your machine suffers from a serios memory starvation.
> Either something is leaking, or you have not very much memory do you in your "headless box", or both...

it certainly looks like a leak, at first i suspected memory fragmentation, but
Larrys patch didn't help; later the order-0 alloc failures appeared.
The machine has 512M, ~100M should be (usually is) free, is under constant light
load (typically <2k ints/s, 60% idle) and is running fine for weeks/months between
reboots, but locks up after only a few packets go over the hostap driven
p54usb device. I need the box to be up, that limits the number of tests i can
run, at least as long as the lockups w/o any diagnostics happen...

artur
