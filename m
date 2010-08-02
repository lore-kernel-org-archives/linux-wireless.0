Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55829 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab0HBFBA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 01:01:00 -0400
Message-ID: <4C565100.4040305@candelatech.com>
Date: Sun, 01 Aug 2010 22:00:48 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Ryszard <ryszard99@gmail.com>
CC: Florian Fainelli <florian@openwrt.org>,
	Patrick McHardy <kaber@trash.net>,
	linux-wireless@vger.kernel.org
Subject: Re: virtual access poitns (ath5k/mac80211)
References: <AANLkTi=W=vkgb0gM7ZWsBeE79Fe3iabtKFgu2S7N5uLe@mail.gmail.com>	<201008011137.49528.florian@openwrt.org>	<AANLkTik=t=jeCG7=bgkq3LBwJP9vq7KmFpgDeHngPoq-@mail.gmail.com>	<4C55F377.6040404@candelatech.com> <AANLkTi=FEFrKdXUHN-h-BZruvNzSmwXdPcq9-OgZcFAM@mail.gmail.com>
In-Reply-To: <AANLkTi=FEFrKdXUHN-h-BZruvNzSmwXdPcq9-OgZcFAM@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/01/2010 06:51 PM, Ryszard wrote:
> Hey ben,
>
> thanks for the reply on this.
>
> perhaps i'm missing something fundamental along the way.  here is what
> i've done:
>
> iw dev phy0 interface add sta0 type station
> iw dev wlan0 interface add sta0 type station
> iw dev wlan0 interface add sta1 type station
>
> iw dev wlan0 interface add vap0 type __ap
> iw dev wlan0 interface add vap1 type __a
> p
>
> vap1, vap0, sta0 and sta1_rename
>
> output from iwconfig:
> wlan0     IEEE 802.11abg  ESSID:off/any
>           Mode:Managed  Access Point: Not-Associated   Tx-Power=20 dBm
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Encryption key:off
>           Power Management:off
> sta0      IEEE 802.11abg  ESSID:off/any
>           Mode:Managed  Access Point: Not-Associated   Tx-Power=20 dBm
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Encryption key:off
>           Power Management:off
> sta1_rename  IEEE 802.11abg  ESSID:off/any
>           Mode:Managed  Access Point: Not-Associated   Tx-Power=20 dBm
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Encryption key:off
>           Power Management:off
> vap0      IEEE 802.11abg  ESSID:off/any
>           Mode:Managed  Access Point: Not-Associated   Tx-Power=20 dBm
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Encryption key:off
>           Power Management:off
> vap1      IEEE 802.11abg  Mode:Master  Frequency:2.457 GHz  Tx-Power=20 dBm
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Power Management:off
> to get the interface up i've used macchanger on one of the vap
> interfaces.  I've also got (isc) DHCP set and listening on the vapn and
> when i run hostapd on the vapn interface i get mon.vapn .  using a
> wireless client, i can get an ip address assigned from one interface
> (vap0), but not the other.  I also get a call trace in syslog which i
> guess could be the very problem.
>
> I realise i've not listed a specific course of events/driver versions
> i've followed here, but i am willing to lay it all down in a blow by
> blow repeatable sequence if thats what it takes.  in fact aside from
> coding (i'm not a coder except for perl) i'm willing to do whatever to
> get it working, and provide any doco for the community...

Well, please show the trace.  Also, are you loading the driver with
hwcrypt disabled?

Here are my notes (ath9k doesn't work yet, btw).

# Make udev get out of the way

vi /etc/udev/rules.d/75-persistent-net-generator.rules
or, for F11:
vi /lib/udev/rules.d/75-persistent-net-generator.rules

# device name whitelist
#KERNEL!="eth*|ath*|wlan*[0-9]|ra*|sta*|ctc*|lcs*|hsi*", GOTO="persistent_net_generator_end"
KERNEL!="eth*|ath*|ra*|ctc*|lcs*|hsi*", GOTO="persistent_net_generator_end"

# Skip virtual interfaces of all types.
SUBSYSTEM=="net", ACTION=="add", ATTR(iflink)!="0", GOTO="persistent_net_generator_end"


# delete lines similar to this in /etc/udev/rules.d/70-persistent-net.rules, if it exists.
# PCI device 0x168c:0x0013 (ath5k)
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:0b:6b:83:5f:a6", ATTR{type}=="1", NAME="wlan0"



# Fix up modprobe.conf to turn off hwaccel for ath5k:
echo options ath5k nohwcrypt=1 >> /etc/modprobe.d/ath5k.conf
echo options ath9k nohwcrypt=1 >> /etc/modprobe.d/ath9k.conf

# Mount debug-fs
echo debugfs                 /debug                  debugfs    defaults        0 0 >> /etc/fstab
mkdir /debug


>
> regs R
>
> On 2 August 2010 08:21, Ben Greear <greearb@candelatech.com
> <mailto:greearb@candelatech.com>> wrote:
>
>     On 08/01/2010 01:56 PM, Ryszard wrote:
>
>         Hey Florian,
>
>         thanks for the help on this! Ben/Patrick, if you rebase the patches
>         for this functionality, i'm more than happy and willing to do
>         userland
>         testing on this to move it along.
>
>         regs
>
>         On 1 August 2010 19:37, Florian Fainelli<florian@openwrt.org
>         <mailto:florian@openwrt.org>>  wrote:
>
>             Hi,
>
>             Le Sunday 1 August 2010 03:53:13, Ryszard a écrit :
>
>                 Hi all,
>
>                 i'm working on a project that requires i can create
>                 multiple access
>                 points on the one bit of hardware.  After an insane
>                 amount of googling
>                 and reading the lists the closest i've been able to come
>                 up with is
>                 something along the lines of:
>                 iw dev wlan0 interface add vap0 type __ap
>                 iw dev wlan0 interface add vap1 type __ap
>
>                 then using macchanger to assign unique mac addresses.
>
>                 I've also seen something from March 2009
>                 (http://lwn.net/Articles/321690/) that hints at the
>                 functionality
>                 available with the ath9k which gave me a bit of hope!
>
>                 My question is, is it possible to create multiple
>                 virtual access
>                 points with my hardware ( Atheros Communications Inc.
>                 AR5413 802.11abg
>                 ) and the ath5k/mac80211 drivers (or is there some other
>                 method to
>                 achieve what i'm after) ?  i'm not too fussed about
>                 different
>                 channels, but different SSID's and WPA keys are a
>                 requirement for the
>                 project.
>
>
>             There is support for creating virtual interfaces using iw
>             and ath5k here:
>             http://www.candelatech.com/oss/vsta.html
>
>             I really wish someone could submit this mainline,
>             unfortunately it is pretty
>             hard to isolate the commits in this tree which are
>             implementing virtual
>             interfaces support.
>
>             Ben, Patrick, could you rebase your patches on top of
>             wireless-testing and
>             send them for review/testing?
>
>
>     You would not believe how hard it is to keep up with the wireless
>     tree.  Last time,
>     by the time we had something stable, upstream had changed too much
>     to merge.
>
>     The merge from .31 to .34 was basically not happening, so we are
>     trying to
>     re-do things from scratch.  I've been busy working on other .34 bugs
>     (and
>     updating our user-space stuff to work with .34), and haven't heard from
>     Patrick in a while.
>
>     We plan to get this done, but I don't know when.
>
>     For what it's worth, our .31 code works pretty well, supporting
>     virtual STA
>     and APs and deals with multiple STAs trying to all scan at once, etc.
>
>     Thanks,
>     Ben
>
>     --
>     Ben Greear <greearb@candelatech.com <mailto:greearb@candelatech.com>>
>     Candela Technologies Inc http://www.candelatech.com
>
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
