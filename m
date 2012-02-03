Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49727 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab2BCDuO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 22:50:14 -0500
Received: by pbdu11 with SMTP id u11so2576229pbd.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 19:50:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAO=xpBGLQazD30z3f+rs+MWuQgMSmhYzWyUFwunfcViRny9jnA@mail.gmail.com>
References: <CAO=xpBGPi7o+gi3bTb=9iML=bSqBog6okz-Z7X7tywqiwb=FaA@mail.gmail.com>
 <20120202192906.GA1592@minime.bse> <CAO=xpBGLQazD30z3f+rs+MWuQgMSmhYzWyUFwunfcViRny9jnA@mail.gmail.com>
From: Alfonso Fiore <alfonso.fiore@gmail.com>
Date: Fri, 3 Feb 2012 04:49:44 +0100
Message-ID: <CAO=xpBGnGGu5HtEBwbMWqxc14SJRN-2MVRyWkmLQSZSrjOmbRw@mail.gmail.com> (sfid-20120203_045028_401402_BD91540C)
Subject: Re: how to setup a wireless bridge (wds) without iwpriv?
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I found a mistake in my configuration:

>        post-up route add -net 192.168.100.0 netmask 255.255.255.0 dev eth0

should be

post-up route add -net 192.168.100.0 netmask 255.255.255.128 dev eth0

But that was not the reason for the problem. The reason was that I
have quite a big source of wireless noise that I didn't think of:
Mimi Qube 2.4 GHz WiFi Speaker

Now with the ALIX on top of the PC I get 12 MBit/sec.

But obviously now that I found the source of problem, my wireless
works just fine. It only gets to 6MBit/sec, so I will prob keep using
the ALIX...

Yes I know. Quite silly.

Is there a way to make these two wireless devices work together? which
two channels create less interference?

thanks again,
alfonso

On Fri, Feb 3, 2012 at 4:16 AM, Alfonso Fiore <alfonso.fiore@gmail.com> wrote:
> Hi Daniel,
>
> thanks a lot, it worked like a charm! (not true, please read till the end)
>
> A recap for my memory and for others looking to achieve the same thing
> (feel free to correct any mistakes).
>
> As far as I saw, the PC won't work with DHCP, so manually set an IP in
> the right range.
> This is my topology:
> (ISP wireless router - 192.168.100.254) <---wireless---> (ALIX setup
> as bridge) <---wired---> (PC - 192.168.100.100)
>
> remember to set both the IP and the DNS in the PC. The PC netmask is
> not affected by the setup, so keep 255.255.255.0.
>
> Then on the ALIX, use this /etc/network/interfaces:
>
> auto lo
> iface lo inet loopback
> auto eth0
> iface eth0 inet static
>        address 0.0.0.0
>        netmask 255.255.255.255
> auto wlan0
> iface wlan0 inet dhcp
>        wpa-driver wext
>        wpa-ssid <<Your_AP_SSID_Here>>
>        wpa-psk <<cleartext_password>>
>        wpa-key-mgmt WPA-PSK
>        wpa-pairwise TKIP
>        wpa-group CCMP TKIP
>        wpa-proto RSN
>        wireless-mode Managed
>        post-up route del -net 192.168.100.0 netmask 255.255.255.0
>        post-up route add -net 192.168.100.128 netmask 255.255.255.128 dev wlan0
>        post-up route add -net 192.168.100.0 netmask 255.255.255.0 dev eth0
>
> then add to your /etc/rc.local:
>
> echo 1 > /proc/sys/net/ipv4/conf/eth0/proxy_arp
> echo 1 > /proc/sys/net/ipv4/conf/wlan0/proxy_arp
> echo 1 > /proc/sys/net/ipv4/ip_forward
>
> and you are good to go!
>
> Ok this is just plain silly now. I did all the tests and the PC was
> running perfect. Way faster than I expected (12Mbit/sec with
> speedtest.net). I rebooted the ALIX to test the config files and it
> worked. Then I disconnected and moved the ALIX box close to the PC,
> disconnected "half" of the cables between ALIX and the PC (for the
> test I was using 2 cables connected with an RJ45 extender) and run the
> test again. It's super slow (speedtest.net can't measure it). I
> rebooted the PC, the DSL router and the ALIX several times. I moved
> again the ALIX near my laptop and I got 4Mbit/sec from the PC (but not
> 12Mbit). The router is less than 3 meters away, no walls in between.
> During the tests the ALIX was 1 meter from the DSL router.
> I also tried to switch off the TV (the only source of electromagnetic
> pollution I can think of) but it doesn't change results.
> I tried to put the ALIX on the PC case and on a wood table (thinking
> about some problem due to the metal PC case).
> I feel cursed.
>
> thanks again,
> alfonso
>
> On Thu, Feb 2, 2012 at 8:29 PM, Daniel Glöckner <daniel-gl@gmx.net> wrote:
>> Hi Alfonso,
>>
>> On Thu, Feb 02, 2012 at 07:22:30PM +0100, Alfonso Fiore wrote:
>>> Since wireless on my PC doesn't work properly, I'd like to create a
>>> wireless bridge to allow a PC to get an IP address from the wireless
>>> network without NAT.
>>>
>>> (ISP wireless router - 192.168.1.1) <---wireless---> (ALIX setup as
>>> bridge) <---wired---> (PC - 192.168.1.x)
>>
>> I use proxy ARP to achieve this with WPA:
>>
>> route add -net 192.168.1.0/25 dev wlan0
>> route add -net 192.168.1.128/25 dev eth0
>> echo 1 >/proc/sys/net/ipv4/conf/wlan0/proxy_arp
>> echo 1 >/proc/sys/net/ipv4/conf/eth0/proxy_arp
>> echo 1 >/proc/sys/net/ipv4/ip_forward
>>
>> But it only works if you know beforehand on which interface your ALIX
>> will see an IP address. You could run the DHCP server on your ALIX to
>> make it more deterministic.
>>
>>  Daniel
