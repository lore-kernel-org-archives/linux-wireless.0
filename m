Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52804 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab2CLCy6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Mar 2012 22:54:58 -0400
Received: by iagz16 with SMTP id z16so6189190iag.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Mar 2012 19:54:57 -0700 (PDT)
Message-ID: <4F5D657E.8020204@lwfinger.net> (sfid-20120312_035502_195282_2ECD03CF)
Date: Sun, 11 Mar 2012 21:54:54 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: alupu@verizon.net
CC: linux-wireless@vger.kernel.org
Subject: Re: r8712u staging in kernel 3.2.9
References: <22781504.258629.1331516788574.JavaMail.root@vms170035>
In-Reply-To: <22781504.258629.1331516788574.JavaMail.root@vms170035>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/11/2012 08:46 PM, alupu@verizon.net wrote:
> That means that I _must_ have done and succeeded in all of your above
> instructions and descriptions.  But that's beside the point.

I did not understand that point. Sorry.

> The real point that somehow I haven't been able to convey since my OP
> is that I expect the commands,
> iwconfig wlan0 essid ...
>
> and
>
> iwconfig wlan0 key restricted ...
> (or these two combined)
>
> to work from the _command line_ (init 3) for an adapter/driver.
> (how one actually connects to an AP, is _another_ story completely
> and I can handle that by myself).

I have understood that. I'm not stupid! The problem is that they work for me, 
but not for you. Why?

> What you have to do to replicate what I (and all the other
> users who prefer to sit at the command line) do is to
> use Linux at command line (init 3) and test the two commands.

Why? I did that and it worked.

> As an aside, in the meantime I tested Knoppix wireless in graphics mode.
> Works smoothly as well (as I feared)!
> Fails, as I said, if you try to connect from the command line, like
> 'knoppix 2' on the boot (BIOS) prompt.
>
> I suppose openSUSE has a similar command to go directly to command line
> (to "simulate" the _real_ Linux - not the graphics thrown on top of it).
> A "workaround" I suppose is to start up openSUSE "normally" (to graphics
> mode) _without_ the Rosewill plugged in (so the driver module doesn't
> load automatically). Then go into a terminal, then plug in Rosewill
> then test these two commands.

Watch what you say. I think that openSUSE is a "real" Linux, and I have a number 
of systems that connect to networks, including wireless, without even having a 
GUI loaded - no X. Yes, they boot in the equivalent of init 3. What openSUSE has 
are scripts called ifup and ifdown that read a control file and do the settings. 
That control file is owned by root and can only be read by root. It is as secure 
as anything else on the box, AND they do the stuff in the right order.

> Reasons (pretty obvious):
> 1. Wired connections _can_ be made from the command line at any time
> simply, conveniently and securely.
> 2. I worked with wireless adapters (Lynksys - Atheros? comes to mind)
> which do indeed that (i.e. succeed on the above two commands).
> Whether I use the wpa_supplicant (again, from command line) is based on
> what the AP expects from me as level of security and that's my business.

Here are the commands that I used and the results from the Live CD:

linux@linux:~> su -                        # switch to root
linux:~ # ps ax | grep Network
  2007 ?        Ssl    0:00 /usr/sbin/NetworkManager --no-daemon
  3596 ?        S      0:00 /sbin/dhclient -d -4 -sf 
/usr/lib/NetworkManager/nm-dhcp-client.action -pf /var/run/dhclient-wlan0.pid 
-lf /var/lib/dhcp/dhclient-415c92e4-fabb-45ff-ae4e-350d9e4a607d-wlan0.lease -cf 
/var/run/nm-dhclient-wlan0.conf wlan0
  3828 pts/1    S+     0:00 grep --color=auto Network
linux:~ # kill -9 2007                     # kill NetworkManager
linux:~ # modprobe -rv r8712u              # unload the driver to clear the 
connection
rmmod /lib/modules/3.1.0-1.2-desktop/kernel/drivers/staging/rtl8712/r8712u.ko
linux:~ # modprobe -v r8712u               # reload driver
insmod /lib/modules/3.1.0-1.2-desktop/kernel/drivers/staging/rtl8712/r8712u.ko
linux:~ # iwconfig wlan0                   # connection clear
wlan0     unassociated  Nickname:"rtl_wifi"
           Mode:Auto  Access Point: Not-Associated   Sensitivity:0/0
           Retry:off   RTS thr:off   Fragment thr:off
           Encryption key:off
           Power Management:off
           Link Quality:0  Signal level:0  Noise level:0
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
 

linux:~ # ifconfig wlan0 up                 # get iface UP - did you do this?
linux:~ # iwconfig wlan0 essid radius
linux:~ # iwconfig wlan0
wlan0     IEEE 802.11bg  ESSID:"radius"  Nickname:"rtl_wifi"
           Mode:Managed  Frequency:2.412 GHz  Access Point: 00:14:BF:85:49:FA
           Bit Rate:54 Mb/s   Sensitivity:0/0
           Retry:off   RTS thr:off   Fragment thr:off
           Encryption key:off
           Power Management:off
           Link Quality=0/100  Signal level=96/100  Noise level=0/100
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:0   Missed beacon:0

linux:~ # iwconfig wlan0 key restricted 1234f0033edaebf3f7dab4ceca
linux:~ # iwconfig wlan0
wlan0     IEEE 802.11bg  ESSID:"radius"  Nickname:"rtl_wifi"
           Mode:Managed  Frequency:2.412 GHz  Access Point: 00:14:BF:85:49:FA
           Bit Rate:54 Mb/s   Sensitivity:0/0
           Retry:off   RTS thr:off   Fragment thr:off
           Encryption key:1234-F003-3EDA-EBF3-F7DA-B4CE-CA   Security 
mode:restricted
           Power Management:off
           Link Quality=0/100  Signal level=100/100  Noise level=0/100
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:0   Missed beacon:0

linux:~ # dhcpcd wlan0 -L
linux:~ # ifconfig wlan0
wlan0     Link encap:Ethernet  HWaddr 00:1A:EF:1A:C2:17
           inet addr:192.168.3.109  Bcast:192.168.3.255  Mask:255.255.255.0
           inet6 addr: fe80::21a:efff:fe1a:c217/64 Scope:Link
           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
           RX packets:4 errors:0 dropped:0 overruns:0 frame:0
           TX packets:28 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 txqueuelen:1000
           RX bytes:768 (768.0 b)  TX bytes:6570 (6.4 Kb)

The only thing that may be unusual about r8712u is that the interface MUST be up 
before it will accept the essid and key. Is that the step you have been missing?

Larry
