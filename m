Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173003pub.verizon.net ([206.46.173.3]:44318 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757699Ab2CLXDD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 19:03:03 -0400
Received: from vznit170128 ([unknown] [192.168.1.3]) by vms173003.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0M0S002V6O0IBGL2@vms173003.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Mon, 12 Mar 2012 18:02:42 -0500 (CDT)
Date: Mon, 12 Mar 2012 18:02:42 -0500 (CDT)
From: alupu@verizon.net
To: Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org
Message-id: <6340383.366730.1331593362221.JavaMail.root@vznit170128> (sfid-20120313_000320_934494_6D0F6E11)
Subject: Re: r8712u staging in kernel 3.2.9
MIME-version: 1.0
Content-type: multipart/mixed;
 boundary="----=_Part_366729_4546307.1331593362140"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_366729_4546307.1331593362140
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

> On 03/11/12 10:54 PM, Larry Finger wrote:
>> On 03/11/2012 08:46 PM, alupu@verizon.net wrote:

Hi Larry,

I tested the Rosewill wireless adapter as per your instructions.
Still FAILURE.
The gory details are in the attached file.

Just so you have a better idea of the "tool" I used:
 694157312 openSUSE-12.1-KDE-LiveCD-i686.iso
 md5sum: 29fa37038400b9894fc62b6aeaa7932c

When the LiveCD is up I get a screen "openSUSE installer",
The screen contains five choices,
 openSUSE Live KDE (the default - the one I've chosen anyway)
 Installation
 Check Installation Media
 Boot form Hard Disk
 Memory Test

and three defaults (all taken)
English (US), 1280x1024 and Default Kernel

Once fully up (in "openSUSE Live KDE") I select
 Kickoff Application Launcher > Terminal > su

-----------------------------------------------------------------
Loose ends (you can disregard - the important words are above)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> [ I excpect the iwconfig coomands ]
>> to work from the _command line_ (init 3) for an adapter/driver.
>> (how one actually connects to an AP, is _another_ story completely
>> and I can handle that by myself).

> I have understood that. I'm not stupid! The problem is that they work for me, 
> but not for you. Why?

>> What you have to do to replicate what I (and all the other
>> users who prefer to sit at the command line) do is to
>> use Linux at command line (init 3) and test the two commands.

> Why? I did that and it worked.

>> As an aside, in the meantime I tested Knoppix wireless in graphics mode.
>> Works smoothly as well (as I feared)!
>> Fails, as I said, if you try to connect from the command line, like
>> 'knoppix 2' on the boot (BIOS) prompt.
>>
>> I suppose openSUSE has a similar command to go directly to command line
>> (to "simulate" the _real_ Linux - not the graphics thrown on top of it).

> Watch what you say. I think that openSUSE is a "real" Linux, and I have a
> number of systems that connect to networks, including wireless, without even
> having a GUI loaded - no X.
>
> Here are the commands that I used and the results from the Live CD:
 ...

The commands in your log appear to have been run in a Terminal opened from the
graphics mode (i.e. "GUI loaded"). I assume that was so we compare our notes
directly (I only have the Live CD). That's perfectly OK.

> The only thing that may be unusual about r8712u is that the interface MUST
> be up before it will accept the essid and key.
> Is that the step you have been missing?

I never missed this step, now or on the previous tests.

Regards,
-- Alex

------=_Part_366729_4546307.1331593362140
Content-Type: text/plain; charset=us-ascii; name=temp2.txt
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=temp2.txt

linux:/home/linux # ps ax | grep Network
 1685 ?        Ssl    0:00 /usr/sbin/NetworkManager --no-daemon
 2657 pts/1    S+     0:00 grep --color=auto Network

linux:/home/linux # kill -9 1685

linux:/home/linux # lsmod | grep r8712u
r8712u                175536  0 
usbcore               190567  5 r8712u,usbhid,uhci_hcd,ehci_hcd

linux:/home/linux # modprobe -r r8712u

linux:/home/linux # lsmod | grep r8712u

linux:/home/linux # modprobe r8712u

linux:/home/linux # iwconfig wlan0
wlan0     unassociated  Nickname:"rtl_wifi"
          Mode:Auto  Access Point: Not-Associated   Sensitivity:0/0  
          Retry:off   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

linux:/home/linux # lsmod | grep r8712u
r8712u                175536  0 
usbcore               190567  5 r8712u,usbhid,uhci_hcd,ehci_hcd

linux:/home/linux # ifconfig wlan0 up

linux:/home/linux # ifconfig
eth0      Link encap:Ethernet  HWaddr 00:1E:8C:CE:83:C3  
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:136 errors:0 dropped:0 overruns:0 frame:0
          TX packets:136 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:8828 (8.6 Kb)  TX bytes:8828 (8.6 Kb)

wlan0     Link encap:Ethernet  HWaddr 00:1A:EF:25:2D:F9  
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

linux:/home/linux # iwconfig wlan0 essid radius

linux:/home/linux # iwconfig wlan0
wlan0     unassociated  Nickname:"rtl_wifi"
          Mode:Auto  Access Point: Not-Associated   Sensitivity:0/0  
          Retry:off   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

linux:/home/linux # iwconfig wlan0 key restricted 1234f0033edaebf3f7dab4ceca

linux:/home/linux # iwconfig wlan0
wlan0     unassociated  Nickname:"rtl_wifi"
          Mode:Auto  Access Point: Not-Associated   Sensitivity:0/0  
          Retry:off   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

linux:/home/linux # ifconfig
eth0      Link encap:Ethernet  HWaddr 00:1E:8C:CE:83:C3  
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:136 errors:0 dropped:0 overruns:0 frame:0
          TX packets:136 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:8828 (8.6 Kb)  TX bytes:8828 (8.6 Kb)

wlan0     Link encap:Ethernet  HWaddr 00:1A:EF:25:2D:F9  
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
--------------------------------------------------------------
Some of my LiveCD openSUSE parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
linux:/home/linux # uname -a
Linux linux.site 3.1.0-1.2-default #1 SMP Thu Nov 3 14:45:45 UTC 2011
 (187dde0) i686 i686 i386 GNU/Linux

linux:/home/linux # udevadm --version
173

linux:/home/linux # cat /proc/version
Linux version 3.1.0-1.2-default (geeko@buildhost) (gcc version 4.6.2
 (SUSE Linux) ) #1 SMP Thu Nov 3 14:45:45 UTC 2011 (187dde0)

linux:/home/linux # cat /proc/devices
Character devices:
  1 mem
  4 /dev/vc/0
  4 tty
  4 ttyS
  5 /dev/tty
  5 /dev/console
  5 /dev/ptmx
  7 vcs
  9 st
 10 misc
 13 input
 21 sg
 29 fb
116 alsa
128 ptm
136 pts
180 usb
189 usb_device
202 cpu/msr
226 drm
251 firewire
252 hidraw
253 bsg
254 rtc

Block devices:
  1 ramdisk
  2 fd
259 blkext
  7 loop
  8 sd
  9 md
 11 sr
 65 sd
 66 sd
 67 sd
 68 sd
 69 sd
 70 sd
 71 sd
128 sd
129 sd
130 sd
131 sd
132 sd
133 sd
134 sd
135 sd
252 virtblk
253 device-mapper
254 mdp

linux:/home/linux # cat /proc/meminfo
MemTotal:        3348532 kB
MemFree:         1392136 kB
Buffers:           26824 kB
Cached:          1379148 kB
SwapCached:            0 kB
Active:           615464 kB
Inactive:        1258964 kB
Active(anon):     470620 kB
Inactive(anon):   121068 kB
Active(file):     144844 kB
Inactive(file):  1137896 kB
Unevictable:           0 kB
Mlocked:               0 kB
HighTotal:       2489864 kB
HighFree:         622516 kB
LowTotal:         858668 kB
LowFree:          769620 kB
SwapTotal:        514076 kB
SwapFree:         514076 kB
Dirty:                16 kB
Writeback:             0 kB
AnonPages:        468492 kB
Mapped:            81800 kB
Shmem:            123236 kB
Slab:              49828 kB
SReclaimable:      33292 kB
SUnreclaim:        16536 kB
KernelStack:        2200 kB
PageTables:         3560 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     2188340 kB
Committed_AS:    1228800 kB
VmallocTotal:     122880 kB
VmallocUsed:       35284 kB
VmallocChunk:      28372 kB
HardwareCorrupted:     0 kB
AnonHugePages:    110592 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       4096 kB
DirectMap4k:       20472 kB
DirectMap4M:      888832 kB

linux:/home/linux # lsusb
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 008 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 002: ID 045e:0750 Microsoft Corp. Wired Keyboard 600
Bus 005 Device 002: ID 045e:00cb Microsoft Corp. Basic Optical Mouse v2.0
Bus 002 Device 002: ID 0bda:8172 Realtek Semiconductor Corp. RTL8191SU 802.11n
 WLAN Adapter


------=_Part_366729_4546307.1331593362140--
