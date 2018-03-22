Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:45234 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751455AbeCVUyr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Mar 2018 16:54:47 -0400
Received: by mail-ua0-f174.google.com with SMTP id x17so6470656uaj.12
        for <linux-wireless@vger.kernel.org>; Thu, 22 Mar 2018 13:54:47 -0700 (PDT)
MIME-Version: 1.0
From: Tyler Gray <graytfg@gmail.com>
Date: Thu, 22 Mar 2018 16:54:45 -0400
Message-ID: <CAEo4QHxp3w=PKJ0jgvLNHarw92Ynt=eZNmoWE8w7ZMf_HP9MGw@mail.gmail.com> (sfid-20180322_215451_336645_EB5D4B75)
Subject: iwlwifi intermittent beacon capture in monitor mode?
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm using an Intel 7265D card, stock ubuntu 16.04.4 (4.13.0-36),
iwlwifi firmware version 29.610311.0, and if I collect packets in
monitor mode I'm seeing beacons from a nearby AP drop in and out for
periods up to several minutes time.  I've got a laptop running hostapd
on a fairly quiet 2.4 GHz channel.  About 8 feet away in a normal
office I've got a second laptop with the intel 7265 card and specs
above on the same channel in monitor mode.  I'm running tcpdump,
usually with a bpf filter to just collect traffic to/from the hostapd
AP.

Nothing is connected to the AP, so when I collect I just see beacons
every tenth of a second plus a few probe responses.  After some period
of time, I'll stop seeing beacons.  Sometimes I'll get a short 1+
second gap and they'll resume, other times if I let it sit I'll see
nothing for minutes.  Example output from tcpdump is below:

11:41:47.166184 385217040us tsft 1.0 Mb/s 2457 MHz 11b -45dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:41:47.268591 385319440us tsft 1.0 Mb/s 2457 MHz 11b -45dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:41:47.370991 385421840us tsft 1.0 Mb/s 2457 MHz 11b -45dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:41:47.473371 385524240us tsft 1.0 Mb/s 2457 MHz 11b -45dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:41:47.575800 385626640us tsft 1.0 Mb/s 2457 MHz 11b -46dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:41:47.678186 385729041us tsft 1.0 Mb/s 2457 MHz 11b -45dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:41:47.780586 385831444us tsft 1.0 Mb/s 2457 MHz 11b -46dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:41:47.882996 385933845us tsft 1.0 Mb/s 2457 MHz 11b -46dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:41:47.985394 386036242us tsft 1.0 Mb/s 2457 MHz 11b -46dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:41:48.087995 386138843us tsft 1.0 Mb/s 2457 MHz 11b -45dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:41:48.190189 386241064us tsft 1.0 Mb/s 2457 MHz 11b -47dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:41:48.292594 386343445us tsft 1.0 Mb/s 2457 MHz 11b -46dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:41:48.394995 386445844us tsft 1.0 Mb/s 2457 MHz 11b -49dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10

<20+ seconds no beacons, ran command "iw wlan0 set channel 1;iw wlan0
set channel 10" in separate terminal window without stopping tcpdump>

11:42:12.459120 410509902us tsft 1.0 Mb/s 2457 MHz 11b -48dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:42:12.561527 410612302us tsft 1.0 Mb/s 2457 MHz 11b -48dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:42:12.663941 410714703us tsft 1.0 Mb/s 2457 MHz 11b -48dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:42:12.868745 410919503us tsft 1.0 Mb/s 2457 MHz 11b -47dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:42:12.971151 411021903us tsft 1.0 Mb/s 2457 MHz 11b -48dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:42:13.073538 411124304us tsft 1.0 Mb/s 2457 MHz 11b -48dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:42:13.175942 411226704us tsft 1.0 Mb/s 2457 MHz 11b -48dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:42:13.278313 411329104us tsft 1.0 Mb/s 2457 MHz 11b -47dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:42:13.380722 411431504us tsft 1.0 Mb/s 2457 MHz 11b -47dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:42:13.483122 411533905us tsft 1.0 Mb/s 2457 MHz 11b -48dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:42:13.585522 411636305us tsft 1.0 Mb/s 2457 MHz 11b -48dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:42:13.687941 411738705us tsft 1.0 Mb/s 2457 MHz 11b -48dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:42:13.790333 411841105us tsft 1.0 Mb/s 2457 MHz 11b -47dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:42:13.892751 411943506us tsft 1.0 Mb/s 2457 MHz 11b -48dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:42:13.995138 412045906us tsft 1.0 Mb/s 2457 MHz 11b -49dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:42:14.097550 412148306us tsft 1.0 Mb/s 2457 MHz 11b -47dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:42:14.199951 412250707us tsft 1.0 Mb/s 2457 MHz 11b -47dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:42:14.302345 412353107us tsft 1.0 Mb/s 2457 MHz 11b -48dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:42:14.404751 412455507us tsft 1.0 Mb/s 2457 MHz 11b -48dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:42:14.507148 412557907us tsft 1.0 Mb/s 2457 MHz 11b -48dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:42:14.609537 412660308us tsft 1.0 Mb/s 2457 MHz 11b -48dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:42:14.711954 412762708us tsft 1.0 Mb/s 2457 MHz 11b -48dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:42:14.814329 412865108us tsft 1.0 Mb/s 2457 MHz 11b -47dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:42:14.916749 412967511us tsft 1.0 Mb/s 2457 MHz 11b -46dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:42:15.019141 413069931us tsft 1.0 Mb/s 2457 MHz 11b -48dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:42:32.991973 431043234us tsft 1.0 Mb/s 2457 MHz 11b -27dBm signal
[bit 22] Acknowledgment RA:00:xx:xx:xx:xx:xx (oui Unknown)
11:42:33.008457 431059725us tsft 1.0 Mb/s 2457 MHz 11b -28dBm signal
[bit 22] Acknowledgment RA:00:xx:xx:xx:xx:xx (oui Unknown)

<20 second gap with no beacons, starting scanning for APs with my phone>

11:42:40.307010 438358276us tsft 1.0 Mb/s 2457 MHz 11b -34dBm signal
[bit 22] Acknowledgment RA:00:xx:xx:xx:xx:xx (oui Unknown)
11:42:40.387322 438438059us tsft 1.0 Mb/s 2457 MHz 11b -44dBm signal
[bit 22] Probe Response (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0
18.0 Mbit] CH: 10
11:42:50.331628 448382371us tsft 1.0 Mb/s 2457 MHz 11b -48dBm signal
[bit 22] Probe Response (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0
18.0 Mbit] CH: 10
11:42:50.331779 448383172us tsft 1.0 Mb/s 2457 MHz 11b -33dBm signal
[bit 22] Acknowledgment RA:00:xx:xx:xx:xx:xx (oui Unknown)
11:42:50.352506 448403255us tsft 1.0 Mb/s 2457 MHz 11b -44dBm signal
[bit 22] Probe Response (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0
18.0 Mbit] CH: 10
11:42:50.353411 448404167us tsft 1.0 Mb/s 2457 MHz 11b -43dBm signal
[bit 22] Probe Response (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0
18.0 Mbit] CH: 10
11:42:50.374548 448425779us tsft 1.0 Mb/s 2457 MHz 11b -30dBm signal
[bit 22] Acknowledgment RA:00:xx:xx:xx:xx:xx (oui Unknown)
11:42:50.399771 448450539us tsft 1.0 Mb/s 2457 MHz 11b -44dBm signal
[bit 22] Probe Response (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0
18.0 Mbit] CH: 10
11:42:57.105806 455156456us tsft 1.0 Mb/s 2457 MHz 11b -48dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:43:00.409262 458460432us tsft 1.0 Mb/s 2457 MHz 11b -35dBm signal
[bit 22] Acknowledgment RA:00:xx:xx:xx:xx:xx (oui Unknown)
11:43:01.816236 459866833us tsft 1.0 Mb/s 2457 MHz 11b -46dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:43:01.918648 459969241us tsft 1.0 Mb/s 2457 MHz 11b -45dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:43:07.002271 465053412us tsft 1.0 Mb/s 2457 MHz 11b -48dBm signal
[bit 22] Acknowledgment RA:00:xx:xx:xx:xx:xx (oui Unknown)
11:43:07.021455 465072680us tsft 1.0 Mb/s 2457 MHz 11b -47dBm signal
[bit 22] Acknowledgment RA:00:xx:xx:xx:xx:xx (oui Unknown)
11:43:10.277266 468327919us tsft 1.0 Mb/s 2457 MHz 11b -42dBm signal
[bit 22] Probe Response (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0
18.0 Mbit] CH: 10
11:43:10.351030 468402167us tsft 1.0 Mb/s 2457 MHz 11b -30dBm signal
[bit 22] Acknowledgment RA:00:xx:xx:xx:xx:xx (oui Unknown)
11:43:10.352881 468404028us tsft 1.0 Mb/s 2457 MHz 11b -32dBm signal
[bit 22] Acknowledgment RA:00:xx:xx:xx:xx:xx (oui Unknown)
11:43:10.354759 468405905us tsft 1.0 Mb/s 2457 MHz 11b -31dBm signal
[bit 22] Acknowledgment RA:00:xx:xx:xx:xx:xx (oui Unknown)
11:43:10.393865 468445004us tsft 1.0 Mb/s 2457 MHz 11b -28dBm signal
[bit 22] Acknowledgment RA:00:xx:xx:xx:xx:xx (oui Unknown)
11:43:10.415638 468466367us tsft 1.0 Mb/s 2457 MHz 11b -43dBm signal
[bit 22] Probe Response (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0
18.0 Mbit] CH: 10
11:43:10.416570 468467304us tsft 1.0 Mb/s 2457 MHz 11b -44dBm signal
[bit 22] Probe Response (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0
18.0 Mbit] CH: 10
11:43:10.418471 468469150us tsft 1.0 Mb/s 2457 MHz 11b -43dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:43:10.506117 468557261us tsft 1.0 Mb/s 2457 MHz 11b -32dBm signal
[bit 22] Acknowledgment RA:00:xx:xx:xx:xx:xx (oui Unknown)
11:43:18.712344 476762898us tsft 1.0 Mb/s 2457 MHz 11b -48dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:43:18.814739 476865271us tsft 1.0 Mb/s 2457 MHz 11b -47dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:43:18.917148 476967683us tsft 1.0 Mb/s 2457 MHz 11b -46dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:43:19.019543 477070075us tsft 1.0 Mb/s 2457 MHz 11b -47dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:43:19.121940 477172472us tsft 1.0 Mb/s 2457 MHz 11b -48dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:43:19.224343 477274899us tsft 1.0 Mb/s 2457 MHz 11b -48dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:43:19.326746 477377272us tsft 1.0 Mb/s 2457 MHz 11b -48dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10
11:43:19.429132 477479672us tsft 1.0 Mb/s 2457 MHz 11b -47dBm signal
[bit 22] Beacon (test2) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
ESS CH: 10


When I'm not seeing beacons:
I see them coming in on an atheros USB dongle I added to the same
laptop and collect on with the same filter.
I can change channels and change right back, like I did in the output
above, and I'll always get at least a few seconds of beacons before it
stops again.
I can still see probe responses from the same device, as shown above
after I started scanning with my phone.
I can stop hostapd, change the ssid and MAC address (ip link set addr
xx:xx:xx:xx:xx:xx dev wlan0) and restart it, and I still won't see any
beacons.
If I move the laptop to a new position I'll often start getting
beacons again, but then in the new spot after some period of time I
can usually get beacons to freeze again.

I've run the collection on several different devices that have the
same 7265 card and have seen the same results, and we've run the test
in several different locations.

For the hostapd laptop, I've used an intel 7265 card as well as a
realtek usb dongle, and I've seen these gaps in the beacons from both.
I can't say for sure, but I think the signal strength has to be in the
-40s or worse before this happens, so for the 7265 transmitting, I'm
more like 15 feet away.

During this capture, there are one or two other APs visible on channel
11 from my office, and if I run tcpdump with no filter, I can see
their beacons disappear over time as well, so it isn't just my AP
doing it.  Usually they don't all disappear at the same time, but one
will totally disappear, and then the next.


I've tried to disable power save, but there are a lot of places that
seem to refer to power:
/sys/module/iwlwifi/parameters:
power_save = N
d0i3_disable = Y

/sys/module/iwlmvm/parameters/power_scheme = 1

/sys/kernel/debug/iwlwifi/0000:02:00.0/iwlmvm:
ps_disabled = 1
disable_power_off:    disable_power_off_d0=0,    disable_power_off_d3=3


Today we pulled the latest version of iwlwifi and built it with
debugging enabled.  That gives me fw_rx_stats, and I'm looking just at
CCK rx stats because that's what all the beacons are.

7 good seconds:  (beacons coming in)
ina_cnt: +152
fina_cnt: +152
plcp_err: +44
crc32_err: +3

7 bad seconds:  (No beacons coming in, basically no traffic)
ina_cnt:  +56
fina_cnt: +56
plcp_err: +54
crc32_err: +0

Those time periods are pretty rough, but the firmware saw similar plcp
errors in both cases, but basically no other CCK data when I'm not
seeing beacons.  Given the proximity of the two devices and the signal
strengths I get when I do see packets, I can't come up with a valid
reason the 7265 really can't see the traffic, so something else has to
be going on.

Thanks to anyone who took the time to read to the end, and I'm hoping
one of the Intel guys who are active here will have some guess at what
might be happening, or a suggestion on what I can do to debug this
better.

Thanks,
Tyler
