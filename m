Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:42196 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786AbZF2PrP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2009 11:47:15 -0400
Received: by fxm18 with SMTP id 18so1052075fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 29 Jun 2009 08:47:16 -0700 (PDT)
MIME-Version: 1.0
Reply-To: javier.galvez@entel.upc.edu
In-Reply-To: <145d4e1a0906290705k178e5bfalc3cb0842eabad8c5@mail.gmail.com>
References: <145d4e1a0906290158y4710d68ej270907f297335d42@mail.gmail.com>
	 <145d4e1a0906290200v4a45d83esf8eab021f6d094f9@mail.gmail.com>
	 <1246277392.21239.6.camel@mj>
	 <145d4e1a0906290705k178e5bfalc3cb0842eabad8c5@mail.gmail.com>
Date: Mon, 29 Jun 2009 17:47:15 +0200
Message-ID: <145d4e1a0906290847n2e86ff50k492b02f807236c44@mail.gmail.com>
Subject: Re: Using a Debian box as an AP with wireless testing and hostapd
From: =?ISO-8859-1?Q?Javier_G=E1lvez_Guerrero?=
	<javier.galvez@entel.upc.edu>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First, sorry for messing up my previous mail with copy-pasting dejavus.

I solved the commented issue after configuring the AP wireless
interface's IP address:

# ifconfig wlan0 192.168.3.1

Then all worked fine.


Thanks for your help and patience,
Javi

El 29 de junio de 2009 16:05, Javier Gálvez
Guerrero<javier.galvez@entel.upc.edu> escribió:
> Hi Pavel,
>
> Thanks a lot for your answer. I successfully uninstalled the
> compat-wireless package and no it is running properly. Anyway, I'm
> experiencing a problem while configuring the box as a DHCP server. I
> will tell you my problem, but if you consider this is not the place to
> discuss such issue I will understand.
>
> I configured dhcpd like this:
>
> --> /etc/dhcp3/dhcpd.conf:Jun 29 16:01:12 faye dhcpd: Wrote 0 leases
> to leases file.
> Jun 29 16:01:12 faye dhcpd:
> Jun 29 16:01:12 faye dhcpd: No subnet declaration for wlan0 (0.0.0.0).
> Jun 29 16:01:12 faye dhcpd: ** Ignoring requests on wlan0.  If this is not what
> Jun 29 16:01:12 faye dhcpd:    you want, please write a subnet declaration
> Jun 29 16:01:12 faye dhcpd:    in your dhcpd.conf file for the network segment
> Jun 29 16:01:12 faye dhcpd:    to which interface wlan0 is attached. **
> Jun 29 16:01:12 faye dhcpd:
> Jun 29 16:01:12 faye dhcpd:
> Jun 29 16:01:12 faye dhcpd: Not configured to listen on any interfaces!
>
> ddns-update-style none;
>
> option domain-name-servers 147.83.2.3, 147.83.2.10;
>
> default-lease-time 86400;
> max-lease-time 604800;
>
> authoritative;
>
> subnet 192.168.3.0 netmask 255.255.255.0 {
>  range 192.168.3.2 192.168.3.254;
>  option domain-name-servers 147.83.2.3,147.83.2.10;
>  option routers 192.168.3.1;
>  option broadcast-address 192.168.3.255;
>  default-lease-time 100000;
>  max-lease-time 100000;
> }
>
>
> --> /etc/default/dhcp3-server:
>
> # Defaults for dhcp initscript
> # sourced by /etc/init.d/dhcp
> # installed at /etc/default/dhcp3-server by the maintainer scripts
>
> #
> # This is a POSIX shell fragment
> #
>
> # On what interfaces should the DHCP server (dhcpd) serve DHCP requests?
> #       Separate multiple interfaces with spaces, e.g. "eth0 eth1".
> INTERFACES="wlan0"
>
>
> AFAIK, I just need this to configure the DHCP server in my box. Next,
> I should configure some NATting with iptables. However, when issuing
> /etc/init.d/dhcp3-server start I get this message:
>
> faye:/home/dulceangustia# /etc/init.d/dhcp3-server start
> Starting DHCP server: dhcpd3check syslog for diagnostics. failed!
>  failed!
>
> And in /var/log/syslog I see:
>
> Jun 29 16:01:12 faye dhcpd: Wrote 0 leases to leases file.
> Jun 29 16:01:12 faye dhcpd:
> Jun 29 16:01:12 faye dhcpd: No subnet declaration for wlan0 (0.0.0.0).
> Jun 29 16:01:12 faye dhcpd: ** Ignoring requests on wlan0.  If this is not what
> Jun 29 16:01:12 faye dhcpd:    you want, please write a subnet declaration
> Jun 29 16:01:12 faye dhcpd:    in your dhcpd.conf file for the network segment
> Jun 29 16:01:12 faye dhcpd:    to which interface wlan0 is attached. **
> Jun 29 16:01:12 faye dhcpd:
> Jun 29 16:01:12 faye dhcpd:
> Jun 29 16:01:12 faye dhcpd: Not configured to listen on any interfaces!
>
> BTW, the leases file do exist as I 'touch'ed it.
>
> I can't understand why it says that the dhcp server is not configured
> to listen on any interfaces. Seems I'm missing some easy configuration
> but after some time googling it seems that I should already have it
> running.
>
> Any idea on how to carry on configuring my AP?
>
>
> Thanks for your time and sorry for the inconvenience,
> Javi
>
> 2009/6/29 Pavel Roskin <proski@gnu.org>:
>> On Mon, 2009-06-29 at 11:00 +0200, Javier Gálvez Guerrero wrote:
>>> Hi all,
>>>
>>> I'm trying to use my Debian box as an AP using the latest wireless
>>> testing kernel (2.6.30-wl) and a WiFi card Asus WL-138G v2 PCI but I'm
>>> experiencing a weird problem, hope you can guide me through it.
>>>
>>> First, I'll tell what and how I setup it. I downloaded the wireless
>>> testing kernel and installed it (make && make modules && make
>>> modules_install && make install), prepared the boot images and updated
>>> the grub; fine. Next I installed compat-wireless, wireless regdb,
>>> crda, libnl, hostapd and iw following this tutorial
>>> (http://acx100.erley.org/git.html), with slight modifications: install
>>> some missing packages (m2crypto, libgcrypt-dev and libssl-dev) and,
>>> after installing compat-wireless, 'make unload' as suggested by the
>>> 'make install' output.
>>
>> You don't need compat-wireless with 2.6.30-wl.  The whole point of
>> compat-wireless is to backport the latest drivers from the "-wl" kernel
>> to older kernels.
>>
>> Please remove /lib/modules/2.6.30-wl and reinstall the kernel by running
>> "make modules_install install".
>>
>> --
>> Regards,
>> Pavel Roskin
>>
>
