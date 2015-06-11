Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:52898 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbbFKT3Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 15:29:25 -0400
Message-ID: <5579E191.6090205@candelatech.com> (sfid-20150611_212930_318672_3DDBB3C3)
Date: Thu, 11 Jun 2015 12:29:21 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Subject: Re: Anyone tried ath10k AP with 40Mhz operation?
References: <55789EBF.2060501@candelatech.com> <CA+BoTQmWmrkCjTkq9R9qXZBqq=ynNKdsgn4uLNAucetXy39GRQ@mail.gmail.com> <55798BC5.3030800@candelatech.com>
In-Reply-To: <55798BC5.3030800@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/11/2015 06:23 AM, Ben Greear wrote:
> 
> 
> On 06/10/2015 11:54 PM, Michal Kazior wrote:
>> On 10 June 2015 at 22:31, Ben Greear <greearb@candelatech.com> wrote:
>>> I'm trying this hostapd config file.  Beacons seem OK, and station
>>> associates.  Station puts DHCP Discover on the air (using 20Mhz according
>>> to wireshark).  AP reads this, and thinks it is sending a DHCP response back,
>>> but sniffer never shows DHCP response on the air.
>>
>> Is the MSDU carrying DHCP resp completed with "ok" status? Or is it
>> maybe no-ack or discarded?

Here is some better info.

First, I tried stock firmware and stock kvalle.ath, and I see same problem.

But, here is the catch:

I was just re-starting hostapd with new config file when changing from HT80 to
HT40, and doing it programatically, so it is very fast.

This appears to break things when ever I go from HT80 to HT40 (and vice versa
at least once, but I wasn't paying close attention to that transition).

But, If I do a more thorough reset of the entire radio, which means my tool will
stop hostapd, stop supplicant (though supplicant had no stations configured),
admin the interfaces on that radio down, and then bring everything back up, then it works.

In both cases it seems firmware is restarted, so I do not know what the difference
really is..but it is repeatable.  I verified that hostapd is restarted
(different PID).

If I just change the vap (restart hostapd), wait ~10 seconds, and reset it
again, then the stations also work.

If I stop hostapd and ifdown the interface, change to HT40,
wait ~10 seconds, and then bring it up again, then it also works.

Resetting stations (without a second AP reset) does not seem to help.

I also tested an ath9k station against the AP and it fails to get
DHCP discover response as well, so it does not appear to be anything
to do with the stations.

Here is log of first resetting just the AP (which does not work properly),
and farther down, is full reset which does work.  It could easily be that the
'full' reset just works because that is effectively the second VAP restart,
and it is a minute or so after the re-config to HT40 was made.

Confusing....think I'll just document need for double-reset unless
you have any ideas.

Jun 11 11:50:12 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ampdu vdev_id 0 sta 00:0e:8e:32:06:96 tid 0 action 1
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac monitor recalc started? 0 needed? 0 allowed? 1
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac monitor recalc started? 0 needed? 0 allowed? 1
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ampdu vdev_id 0 sta 04:f0:21:39:e9:35 tid 0 action 1
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac sta 04:f0:21:39:e9:35 disassociated
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 peer delete 04:f0:21:39:e9:35 (sta gone)
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac chanctx change freq 5180 width 3 ptr ffff8802143ba298 changed 10
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac sta 00:0e:8e:32:06:96 disassociated
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 peer delete 00:0e:8e:32:06:96 (sta gone)
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac chanctx unassign ptr ffff8802143ba298 vdev_id 0
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac chanctx remove freq 5180 width 3 ptr ffff8802143ba298
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac monitor recalc started? 0 needed? 0 allowed? 1
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 delete (remove interface)
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot suspend complete
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot hif stop
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot warm reset
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 0 entries 16 base_addr ffff8800d4788000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 1 entries 512 base_addr ffff880036f40000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 2 entries 128 base_addr ffff8800d3fbf000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 3 entries 32 base_addr ffff8800d3e48000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 4 entries 4096 base_addr ffff8800d4250000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 7 entries 2 base_addr ffff880037120000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 7 entries 2 base_addr ffff88003715a000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot waiting target to initialise
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target indicator 0
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target indicator 2
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target initialised
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 0 entries 16 base_addr ffff8800d4788000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 1 entries 512 base_addr ffff880036f40000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 2 entries 128 base_addr ffff8800d3fbf000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 3 entries 32 base_addr ffff8800d3e48000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 4 entries 4096 base_addr ffff8800d4250000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 7 entries 2 base_addr ffff880037120000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 7 entries 2 base_addr ffff88003715a000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot waiting target to initialise
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target indicator 0
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target indicator 2
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target initialised
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot warm reset complete
Jun 11 11:50:25 ben-ota-1 dhcpd[2846]: receive_packet failed on vap50: Network is down
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot hif power down
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot hif power up
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot 988x chip reset
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot warm reset
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 0 entries 16 base_addr ffff8800d4788000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 1 entries 512 base_addr ffff880036f40000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 2 entries 128 base_addr ffff8800d3fbf000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 3 entries 32 base_addr ffff8800d3e48000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 4 entries 4096 base_addr ffff8800d4250000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 7 entries 2 base_addr ffff880037120000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 7 entries 2 base_addr ffff88003715a000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot waiting target to initialise
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target indicator 0
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target indicator 2
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target initialised
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 0 entries 16 base_addr ffff8800d4788000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 1 entries 512 base_addr ffff880036f40000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 2 entries 128 base_addr ffff8800d3fbf000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 3 entries 32 base_addr ffff8800d3e48000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 4 entries 4096 base_addr ffff8800d4250000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 7 entries 2 base_addr ffff880037120000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 7 entries 2 base_addr ffff88003715a000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot waiting target to initialise
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target indicator 0
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target indicator 2
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target initialised
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot warm reset complete
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 0 entries 16 base_addr ffff8800d4788000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 1 entries 512 base_addr ffff880036f40000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 2 entries 128 base_addr ffff8800d3fbf000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 3 entries 32 base_addr ffff8800d3e48000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 4 entries 4096 base_addr ffff8800d4250000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 7 entries 2 base_addr ffff880037120000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 7 entries 2 base_addr ffff88003715a000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot chip reset complete (warm)
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 0 entries 16 base_addr ffff8800d4788000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 1 entries 512 base_addr ffff880036f40000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 2 entries 128 base_addr ffff8800d3fbf000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 3 entries 32 base_addr ffff8800d3e48000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 4 entries 4096 base_addr ffff8800d4250000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 7 entries 2 base_addr ffff880037120000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 7 entries 2 base_addr ffff88003715a000
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot did not find a calibration file, try DT next: -2
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot did not find DT entry, try OTP next: -2
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot push board extended data addr 0x0
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot upload otp to 0x1234 len 6917
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot otp execute result 0
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot using calibration mode otp
Jun 11 11:50:25 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot uploading firmware image ffffc9000549cb44 len 190250 mode normal
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: htt tx max num pending tx 1424
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: htt rx ring size 2048 fill_level 1023
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot hif start
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot htc service 'Control' ul pipe 0 dl pipe 1 eid 0 ready
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot htc ep 0 ul polled 0 dl polled 0
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot htc service 'Control' eid 0 TX flow control disabled
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot htc service HTT Data does not allocate target credits
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot htc service 'HTT Data' ul pipe 4 dl pipe 1 eid 1 ready
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot htc ep 1 ul polled 1 dl polled 0
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot htc service 'HTT Data' eid 1 TX flow control disabled
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot htc service 'WMI' ul pipe 3 dl pipe 2 eid 2 ready
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot htc ep 2 ul polled 0 dl polled 0
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: firmware 10.1.467.2-1 booted
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: htt target version 2.1
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac create vdev 0 map ffff
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev create 0 (add interface) type 1 subtype 0 bcnmode single-buf
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac txpower 17
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac monitor recalc started? 0 needed? 0 allowed? 1
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 cts_prot 0
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 slot_time 1
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 preamble 1n
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac monitor recalc started? 0 needed? 0 allowed? 1
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac monitor recalc started? 0 needed? 0 allowed? 1
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac monitor recalc started? 0 needed? 0 allowed? 1
Jun 11 11:50:26 ben-ota-1 kernel: IPv6: ADDRCONF(NETDEV_UP): vap50: link is not ready
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac monitor recalc started? 0 needed? 0 allowed? 1
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac monitor recalc started? 0 needed? 0 allowed? 1
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 delete (remove interface)
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot suspend complete
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot hif stop
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot warm reset
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 0 entries 16 base_addr ffff8800d4788000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 1 entries 512 base_addr ffff880036f40000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 2 entries 128 base_addr ffff8800d3fbf000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 3 entries 32 base_addr ffff8800d3e48000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 4 entries 4096 base_addr ffff8800d4250000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 7 entries 2 base_addr ffff880037120000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 7 entries 2 base_addr ffff88003715a000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot waiting target to initialise
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target indicator 0
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target indicator 2
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target initialised
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 0 entries 16 base_addr ffff8800d4788000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 1 entries 512 base_addr ffff880036f40000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 2 entries 128 base_addr ffff8800d3fbf000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 3 entries 32 base_addr ffff8800d3e48000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 4 entries 4096 base_addr ffff8800d4250000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 7 entries 2 base_addr ffff880037120000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 7 entries 2 base_addr ffff88003715a000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot waiting target to initialise
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target indicator 0
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target indicator 2
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target initialised
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot warm reset complete
Jun 11 11:50:26 ben-ota-1 dhcpd[2846]: receive_packet failed on vap50: Network is down
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot hif power down
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot hif power up
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot 988x chip reset
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot warm reset
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 0 entries 16 base_addr ffff8800d4788000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 1 entries 512 base_addr ffff880036f40000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 2 entries 128 base_addr ffff8800d3fbf000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 3 entries 32 base_addr ffff8800d3e48000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 4 entries 4096 base_addr ffff8800d4250000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 7 entries 2 base_addr ffff880037120000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 7 entries 2 base_addr ffff88003715a000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot waiting target to initialise
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target indicator 0
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target indicator 2
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target initialised
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 0 entries 16 base_addr ffff8800d4788000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 1 entries 512 base_addr ffff880036f40000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 2 entries 128 base_addr ffff8800d3fbf000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 3 entries 32 base_addr ffff8800d3e48000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 4 entries 4096 base_addr ffff8800d4250000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 7 entries 2 base_addr ffff880037120000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 7 entries 2 base_addr ffff88003715a000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot waiting target to initialise
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target indicator 0
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target indicator 2
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target initialised
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot warm reset complete
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 0 entries 16 base_addr ffff8800d4788000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 1 entries 512 base_addr ffff880036f40000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 2 entries 128 base_addr ffff8800d3fbf000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 3 entries 32 base_addr ffff8800d3e48000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 4 entries 4096 base_addr ffff8800d4250000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 7 entries 2 base_addr ffff880037120000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 7 entries 2 base_addr ffff88003715a000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot chip reset complete (warm)
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 0 entries 16 base_addr ffff8800d4788000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 1 entries 512 base_addr ffff880036f40000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 2 entries 128 base_addr ffff8800d3fbf000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 3 entries 32 base_addr ffff8800d3e48000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 4 entries 4096 base_addr ffff8800d4250000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 7 entries 2 base_addr ffff880037120000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 7 entries 2 base_addr ffff88003715a000
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot did not find a calibration file, try DT next: -2
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot did not find DT entry, try OTP next: -2
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot push board extended data addr 0x0
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot upload otp to 0x1234 len 6917
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot otp execute result 0
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot using calibration mode otp
Jun 11 11:50:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot uploading firmware image ffffc9000549cb44 len 190250 mode normal
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: htt tx max num pending tx 1424
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: htt rx ring size 2048 fill_level 1023
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot hif start
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot htc service 'Control' ul pipe 0 dl pipe 1 eid 0 ready
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot htc ep 0 ul polled 0 dl polled 0
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot htc service 'Control' eid 0 TX flow control disabled
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot htc service HTT Data does not allocate target credits
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot htc service 'HTT Data' ul pipe 4 dl pipe 1 eid 1 ready
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot htc ep 1 ul polled 1 dl polled 0
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot htc service 'HTT Data' eid 1 TX flow control disabled
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot htc service 'WMI' ul pipe 3 dl pipe 2 eid 2 ready
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot htc ep 2 ul polled 0 dl polled 0
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: firmware 10.1.467.2-1 booted
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: htt target version 2.1
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac create vdev 0 map ffff
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev create 0 (add interface) type 1 subtype 0 bcnmode single-buf
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac txpower 17
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac monitor recalc started? 0 needed? 0 allowed? 1
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 cts_prot 0
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 slot_time 1
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 preamble 1n
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac monitor recalc started? 0 needed? 0 allowed? 1
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac monitor recalc started? 0 needed? 0 allowed? 1
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac monitor recalc started? 0 needed? 0 allowed? 1
Jun 11 11:50:27 ben-ota-1 kernel: IPv6: ADDRCONF(NETDEV_UP): vap50: link is not ready
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 rts threshold -1
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac chanctx add freq 5180 width 2 ptr ffff880201b52658
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac monitor recalc started? 0 needed? 0 allowed? 1
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac chanctx assign ptr ffff880201b52658 vdev_id 0
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 start center_freq 5180 phymode 11na-ht40
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac chanctx change freq 5180 width 2 ptr ffff880201b52658 changed 2
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 beacon_interval 240
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: vdev 0 set beacon tx mode to staggered
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 dtim_period 2
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 up
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev_id 0 txpower 17
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac txpower 17
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 cts_prot 0
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 slot_time 2
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 preamble 1n
Jun 11 11:50:27 ben-ota-1 kernel: IPv6: ADDRCONF(NETDEV_CHANGE): vap50: link becomes ready
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac monitor recalc started? 0 needed? 0 allowed? 1
Jun 11 11:50:27 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac monitor recalc started? 0 needed? 0 allowed? 1
Jun 11 11:50:32 ben-ota-1 dhcpd[3039]: Not searching LDAP since ldap-server, ldap-port and ldap-base-dn were not specified in the config file
Jun 11 11:50:32 ben-ota-1 dhcpd[3039]: Wrote 9 leases to leases file.
Jun 11 11:50:32 ben-ota-1 dhcpd[3039]: Bound fallback interface sk: 9 to device: vap50
Jun 11 11:50:38 ben-ota-1 hostapd[2957]: vap50: STA 00:0e:8e:32:06:96 IEEE 802.11: authenticated
Jun 11 11:50:38 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: vdev 0 set beacon tx mode to staggered
Jun 11 11:50:38 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 dtim_period 2
Jun 11 11:50:38 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 cts_prot 0
Jun 11 11:50:38 ben-ota-1 hostapd[2957]: vap50: STA 00:0e:8e:32:06:96 IEEE 802.11: associated (aid 1)
Jun 11 11:50:38 ben-ota-1 hostapd[2957]: vap50: STA 00:0e:8e:32:06:96 RADIUS: starting accounting session 5579D873-00000000
Jun 11 11:50:38 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 preamble 1n
Jun 11 11:50:38 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 peer create 00:0e:8e:32:06:96 (new sta) sta 1 / 128 peer 2 / 144
Jun 11 11:50:38 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac sta 00:0e:8e:32:06:96 associated
Jun 11 11:50:38 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ht peer 00:0e:8e:32:06:96 mcs cnt 24 nss 3
Jun 11 11:50:38 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac peer 00:0e:8e:32:06:96 qos 1
Jun 11 11:50:38 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac peer 00:0e:8e:32:06:96 phymode 11na-ht40
Jun 11 11:50:38 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac chanctx change freq 5180 width 2 ptr ffff880201b52658 changed 10
Jun 11 11:50:38 ben-ota-1 dhcpd[3040]: DHCPRELEASE of 63.1.1.18 from 00:0e:8e:32:06:96 via vap50 (found)
Jun 11 11:50:38 ben-ota-1 dhcpd[3040]: DHCPRELEASE of 63.1.1.18 from 00:0e:8e:32:06:96 via vap50 (found)
Jun 11 11:50:38 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ampdu vdev_id 0 sta 00:0e:8e:32:06:96 tid 0 action 0
Jun 11 11:50:38 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 00:0e:8e:32:06:96 via vap50
Jun 11 11:50:38 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.18 to 00:0e:8e:32:06:96 via vap50
Jun 11 11:50:38 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 00:0e:8e:32:06:96 via vap50
Jun 11 11:50:38 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.18 to 00:0e:8e:32:06:96 via vap50
Jun 11 11:50:42 ben-ota-1 hostapd[2957]: vap50: STA 04:f0:21:39:e9:35 IEEE 802.11: authenticated
Jun 11 11:50:42 ben-ota-1 hostapd[2957]: vap50: STA 04:f0:21:39:e9:35 IEEE 802.11: associated (aid 2)
Jun 11 11:50:42 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 peer create 04:f0:21:39:e9:35 (new sta) sta 2 / 128 peer 3 / 144
Jun 11 11:50:42 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac sta 04:f0:21:39:e9:35 associated
Jun 11 11:50:42 ben-ota-1 hostapd[2957]: vap50: STA 04:f0:21:39:e9:35 RADIUS: starting accounting session 5579D873-00000001
Jun 11 11:50:42 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ht peer 04:f0:21:39:e9:35 mcs cnt 24 nss 3
Jun 11 11:50:42 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vht peer 04:f0:21:39:e9:35 max_mpdu 1048575 flags 0x2003001
Jun 11 11:50:42 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac peer 04:f0:21:39:e9:35 qos 1
Jun 11 11:50:42 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac peer 04:f0:21:39:e9:35 phymode 11ac-vht40
Jun 11 11:50:42 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ampdu vdev_id 0 sta 04:f0:21:39:e9:35 tid 0 action 0
Jun 11 11:50:42 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 00:0e:8e:32:06:96 via vap50
Jun 11 11:50:42 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.18 to 00:0e:8e:32:06:96 via vap50
Jun 11 11:50:42 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 00:0e:8e:32:06:96 via vap50
Jun 11 11:50:42 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.18 to 00:0e:8e:32:06:96 via vap50
Jun 11 11:50:42 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 04:f0:21:39:e9:35 via vap50
Jun 11 11:50:42 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.17 to 04:f0:21:39:e9:35 via vap50
Jun 11 11:50:42 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 04:f0:21:39:e9:35 via vap50
Jun 11 11:50:42 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.17 to 04:f0:21:39:e9:35 via vap50
Jun 11 11:50:47 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ampdu vdev_id 0 sta 00:0e:8e:32:06:96 tid 0 action 1
Jun 11 11:50:49 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 00:0e:8e:32:06:96 via vap50
Jun 11 11:50:49 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.18 to 00:0e:8e:32:06:96 via vap50
Jun 11 11:50:49 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 00:0e:8e:32:06:96 via vap50
Jun 11 11:50:49 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.18 to 00:0e:8e:32:06:96 via vap50
Jun 11 11:50:49 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ampdu vdev_id 0 sta 00:0e:8e:32:06:96 tid 0 action 0
Jun 11 11:50:49 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 04:f0:21:39:e9:35 via vap50
Jun 11 11:50:49 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.17 to 04:f0:21:39:e9:35 via vap50
Jun 11 11:50:49 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 04:f0:21:39:e9:35 via vap50
Jun 11 11:50:49 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.17 to 04:f0:21:39:e9:35 via vap50
Jun 11 11:50:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ampdu vdev_id 0 sta 00:0e:8e:32:06:96 tid 0 action 1
Jun 11 11:50:59 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 04:f0:21:39:e9:35 via vap50
Jun 11 11:50:59 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.17 to 04:f0:21:39:e9:35 via vap50
Jun 11 11:50:59 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 04:f0:21:39:e9:35 via vap50
Jun 11 11:50:59 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.17 to 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:01 ben-ota-1 chronyd[778]: Selected source 149.20.68.17
Jun 11 11:51:02 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 00:0e:8e:32:06:96 via vap50
Jun 11 11:51:02 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.18 to 00:0e:8e:32:06:96 via vap50
Jun 11 11:51:02 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 00:0e:8e:32:06:96 via vap50
Jun 11 11:51:02 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.18 to 00:0e:8e:32:06:96 via vap50
Jun 11 11:51:02 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ampdu vdev_id 0 sta 00:0e:8e:32:06:96 tid 0 action 0
Jun 11 11:51:07 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ampdu vdev_id 0 sta 00:0e:8e:32:06:96 tid 0 action 1
Jun 11 11:51:08 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:08 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.17 to 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:08 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:08 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.17 to 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:22 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ampdu vdev_id 0 sta 04:f0:21:39:e9:35 tid 0 action 1
Jun 11 11:51:22 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac sta 04:f0:21:39:e9:35 disassociated
Jun 11 11:51:22 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 peer delete 04:f0:21:39:e9:35 (sta gone)
Jun 11 11:51:22 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 00:0e:8e:32:06:96 via vap50
Jun 11 11:51:22 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.18 to 00:0e:8e:32:06:96 via vap50
Jun 11 11:51:22 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 00:0e:8e:32:06:96 via vap50
Jun 11 11:51:22 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.18 to 00:0e:8e:32:06:96 via vap50
Jun 11 11:51:22 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ampdu vdev_id 0 sta 00:0e:8e:32:06:96 tid 0 action 0
Jun 11 11:51:23 ben-ota-1 hostapd[2957]: vap50: STA 04:f0:21:39:e9:35 IEEE 802.11: authenticated
Jun 11 11:51:23 ben-ota-1 hostapd[2957]: vap50: STA 04:f0:21:39:e9:35 IEEE 802.11: associated (aid 2)
Jun 11 11:51:23 ben-ota-1 hostapd[2957]: vap50: STA 04:f0:21:39:e9:35 RADIUS: starting accounting session 5579D873-00000002
Jun 11 11:51:23 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 peer create 04:f0:21:39:e9:35 (new sta) sta 2 / 128 peer 3 / 144
Jun 11 11:51:23 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac sta 04:f0:21:39:e9:35 associated
Jun 11 11:51:23 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ht peer 04:f0:21:39:e9:35 mcs cnt 24 nss 3
Jun 11 11:51:23 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vht peer 04:f0:21:39:e9:35 max_mpdu 1048575 flags 0x2003001
Jun 11 11:51:23 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac peer 04:f0:21:39:e9:35 qos 1
Jun 11 11:51:23 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac peer 04:f0:21:39:e9:35 phymode 11ac-vht40
Jun 11 11:51:23 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ampdu vdev_id 0 sta 04:f0:21:39:e9:35 tid 0 action 0
Jun 11 11:51:24 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ampdu vdev_id 0 sta 00:0e:8e:32:06:96 tid 0 action 1
Jun 11 11:51:24 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac sta 00:0e:8e:32:06:96 disassociated
Jun 11 11:51:24 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 peer delete 00:0e:8e:32:06:96 (sta gone)
Jun 11 11:51:24 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:24 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.17 to 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:24 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:24 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.17 to 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ampdu vdev_id 0 sta 04:f0:21:39:e9:35 tid 0 action 1
Jun 11 11:51:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac sta 04:f0:21:39:e9:35 disassociated
Jun 11 11:51:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 peer delete 04:f0:21:39:e9:35 (sta gone)
Jun 11 11:51:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac chanctx change freq 5180 width 2 ptr ffff880201b52658 changed 10
Jun 11 11:51:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: vdev 0 set beacon tx mode to staggered
Jun 11 11:51:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 dtim_period 2
Jun 11 11:51:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 cts_prot 0
Jun 11 11:51:26 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 preamble 1n
Jun 11 11:51:27 ben-ota-1 kernel: cfg80211: Verifying active interfaces after reg change
Jun 11 11:51:29 ben-ota-1 hostapd[2957]: vap50: STA 04:f0:21:39:e9:35 IEEE 802.11: authenticated
Jun 11 11:51:29 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: vdev 0 set beacon tx mode to staggered
Jun 11 11:51:29 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 dtim_period 2
Jun 11 11:51:29 ben-ota-1 hostapd[2957]: vap50: STA 04:f0:21:39:e9:35 IEEE 802.11: associated (aid 1)
Jun 11 11:51:29 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 cts_prot 0
Jun 11 11:51:29 ben-ota-1 hostapd[2957]: vap50: STA 04:f0:21:39:e9:35 RADIUS: starting accounting session 5579D873-00000003
Jun 11 11:51:29 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 preamble 1n
Jun 11 11:51:29 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 peer create 04:f0:21:39:e9:35 (new sta) sta 1 / 128 peer 2 / 144
Jun 11 11:51:29 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac sta 04:f0:21:39:e9:35 associated
Jun 11 11:51:29 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ht peer 04:f0:21:39:e9:35 mcs cnt 24 nss 3
Jun 11 11:51:29 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vht peer 04:f0:21:39:e9:35 max_mpdu 1048575 flags 0x2003001
Jun 11 11:51:29 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac peer 04:f0:21:39:e9:35 qos 1
Jun 11 11:51:29 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac peer 04:f0:21:39:e9:35 phymode 11ac-vht40
Jun 11 11:51:29 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac chanctx change freq 5180 width 2 ptr ffff880201b52658 changed 10
Jun 11 11:51:29 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ampdu vdev_id 0 sta 04:f0:21:39:e9:35 tid 0 action 0
Jun 11 11:51:30 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:30 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.17 to 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:30 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:30 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.17 to 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:31 ben-ota-1 hostapd[2957]: vap50: STA 00:0e:8e:32:06:96 IEEE 802.11: authenticated
Jun 11 11:51:31 ben-ota-1 hostapd[2957]: vap50: STA 00:0e:8e:32:06:96 IEEE 802.11: associated (aid 2)
Jun 11 11:51:31 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 peer create 00:0e:8e:32:06:96 (new sta) sta 2 / 128 peer 3 / 144
Jun 11 11:51:31 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac sta 00:0e:8e:32:06:96 associated
Jun 11 11:51:31 ben-ota-1 hostapd[2957]: vap50: STA 00:0e:8e:32:06:96 RADIUS: starting accounting session 5579D873-00000004
Jun 11 11:51:31 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ht peer 00:0e:8e:32:06:96 mcs cnt 24 nss 3
Jun 11 11:51:31 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac peer 00:0e:8e:32:06:96 qos 1
Jun 11 11:51:31 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac peer 00:0e:8e:32:06:96 phymode 11na-ht40
Jun 11 11:51:31 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ampdu vdev_id 0 sta 00:0e:8e:32:06:96 tid 0 action 0
Jun 11 11:51:31 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 00:0e:8e:32:06:96 via vap50
Jun 11 11:51:31 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.18 to 00:0e:8e:32:06:96 via vap50
Jun 11 11:51:31 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 00:0e:8e:32:06:96 via vap50
Jun 11 11:51:31 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.18 to 00:0e:8e:32:06:96 via vap50
Jun 11 11:51:34 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 00:0e:8e:32:06:96 via vap50
Jun 11 11:51:34 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.18 to 00:0e:8e:32:06:96 via vap50
Jun 11 11:51:34 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 00:0e:8e:32:06:96 via vap50
Jun 11 11:51:34 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.18 to 00:0e:8e:32:06:96 via vap50
Jun 11 11:51:36 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:36 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.17 to 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:36 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:36 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.17 to 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:40 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 00:0e:8e:32:06:96 via vap50
Jun 11 11:51:40 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.18 to 00:0e:8e:32:06:96 via vap50
Jun 11 11:51:40 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 00:0e:8e:32:06:96 via vap50
Jun 11 11:51:40 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.18 to 00:0e:8e:32:06:96 via vap50
Jun 11 11:51:43 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:43 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.17 to 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:43 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:43 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.17 to 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:47 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 00:0e:8e:32:06:96 via vap50
Jun 11 11:51:47 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.18 to 00:0e:8e:32:06:96 via vap50
Jun 11 11:51:47 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 00:0e:8e:32:06:96 via vap50
Jun 11 11:51:47 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.18 to 00:0e:8e:32:06:96 via vap50


And here starts the 'radio' reset.


Jun 11 11:51:52 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ampdu vdev_id 0 sta 00:0e:8e:32:06:96 tid 0 action 1
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac monitor recalc started? 0 needed? 0 allowed? 1
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac monitor recalc started? 0 needed? 0 allowed? 1
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ampdu vdev_id 0 sta 04:f0:21:39:e9:35 tid 0 action 1
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac sta 00:0e:8e:32:06:96 disassociated
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 peer delete 00:0e:8e:32:06:96 (sta gone)
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac chanctx change freq 5180 width 2 ptr ffff880201b52658 changed 10
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac sta 04:f0:21:39:e9:35 disassociated
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 peer delete 04:f0:21:39:e9:35 (sta gone)
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac chanctx unassign ptr ffff880201b52658 vdev_id 0
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac chanctx remove freq 5180 width 2 ptr ffff880201b52658
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac monitor recalc started? 0 needed? 0 allowed? 1
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 delete (remove interface)
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot suspend complete
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot hif stop
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot warm reset
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 0 entries 16 base_addr ffff8800d4788000
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 1 entries 512 base_addr ffff880036f40000
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 2 entries 128 base_addr ffff8800d3fbf000
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 3 entries 32 base_addr ffff8800d3e48000
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 4 entries 4096 base_addr ffff8800d4250000
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 7 entries 2 base_addr ffff880037120000
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 7 entries 2 base_addr ffff88003715a000
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot waiting target to initialise
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target indicator 0
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target indicator 2
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target initialised
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 0 entries 16 base_addr ffff8800d4788000
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 1 entries 512 base_addr ffff880036f40000
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 2 entries 128 base_addr ffff8800d3fbf000
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 3 entries 32 base_addr ffff8800d3e48000
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 4 entries 4096 base_addr ffff8800d4250000
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 7 entries 2 base_addr ffff880037120000
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 7 entries 2 base_addr ffff88003715a000
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot waiting target to initialise
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target indicator 0
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target indicator 2
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target initialised
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot warm reset complete
Jun 11 11:51:54 ben-ota-1 dhcpd[3040]: receive_packet failed on vap50: Network is down
Jun 11 11:51:54 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot hif power down
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot hif power up
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot 988x chip reset
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot warm reset
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 0 entries 16 base_addr ffff8800d4788000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 1 entries 512 base_addr ffff880036f40000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 2 entries 128 base_addr ffff8800d3fbf000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 3 entries 32 base_addr ffff8800d3e48000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 4 entries 4096 base_addr ffff8800d4250000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 7 entries 2 base_addr ffff880037120000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 7 entries 2 base_addr ffff88003715a000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot waiting target to initialise
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target indicator 0
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target indicator 2
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target initialised
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 0 entries 16 base_addr ffff8800d4788000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 1 entries 512 base_addr ffff880036f40000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 2 entries 128 base_addr ffff8800d3fbf000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 3 entries 32 base_addr ffff8800d3e48000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 4 entries 4096 base_addr ffff8800d4250000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 7 entries 2 base_addr ffff880037120000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 7 entries 2 base_addr ffff88003715a000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot waiting target to initialise
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target indicator 0
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target indicator 2
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot target initialised
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot warm reset complete
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 0 entries 16 base_addr ffff8800d4788000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 1 entries 512 base_addr ffff880036f40000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 2 entries 128 base_addr ffff8800d3fbf000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 3 entries 32 base_addr ffff8800d3e48000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 4 entries 4096 base_addr ffff8800d4250000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 7 entries 2 base_addr ffff880037120000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 7 entries 2 base_addr ffff88003715a000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot chip reset complete (warm)
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 0 entries 16 base_addr ffff8800d4788000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 1 entries 512 base_addr ffff880036f40000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 2 entries 128 base_addr ffff8800d3fbf000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 3 entries 32 base_addr ffff8800d3e48000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 4 entries 4096 base_addr ffff8800d4250000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot init ce src ring id 7 entries 2 base_addr ffff880037120000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot ce dest ring id 7 entries 2 base_addr ffff88003715a000
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot did not find a calibration file, try DT next: -2
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot did not find DT entry, try OTP next: -2
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot push board extended data addr 0x0
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot upload otp to 0x1234 len 6917
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot otp execute result 0
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot using calibration mode otp
Jun 11 11:51:55 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot uploading firmware image ffffc9000549cb44 len 190250 mode normal
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: htt tx max num pending tx 1424
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: htt rx ring size 2048 fill_level 1023
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot hif start
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot htc service 'Control' ul pipe 0 dl pipe 1 eid 0 ready
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot htc ep 0 ul polled 0 dl polled 0
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot htc service 'Control' eid 0 TX flow control disabled
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot htc service HTT Data does not allocate target credits
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot htc service 'HTT Data' ul pipe 4 dl pipe 1 eid 1 ready
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot htc ep 1 ul polled 1 dl polled 0
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot htc service 'HTT Data' eid 1 TX flow control disabled
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot htc service 'WMI' ul pipe 3 dl pipe 2 eid 2 ready
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: boot htc ep 2 ul polled 0 dl polled 0
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: firmware 10.1.467.2-1 booted
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: htt target version 2.1
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac create vdev 0 map ffff
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev create 0 (add interface) type 1 subtype 0 bcnmode single-buf
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac txpower 17
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac monitor recalc started? 0 needed? 0 allowed? 1
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 cts_prot 0
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 slot_time 1
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 preamble 1n
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac monitor recalc started? 0 needed? 0 allowed? 1
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac monitor recalc started? 0 needed? 0 allowed? 1
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac monitor recalc started? 0 needed? 0 allowed? 1
Jun 11 11:51:56 ben-ota-1 kernel: IPv6: ADDRCONF(NETDEV_UP): vap50: link is not ready
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 rts threshold -1
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac chanctx add freq 5180 width 2 ptr ffff880201a63d18
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac monitor recalc started? 0 needed? 0 allowed? 1
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac chanctx assign ptr ffff880201a63d18 vdev_id 0
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 start center_freq 5180 phymode 11na-ht40
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac chanctx change freq 5180 width 2 ptr ffff880201a63d18 changed 2
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 beacon_interval 240
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: vdev 0 set beacon tx mode to staggered
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 dtim_period 2
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 up
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev_id 0 txpower 17
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac txpower 17
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 cts_prot 0
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 slot_time 2
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 preamble 1n
Jun 11 11:51:56 ben-ota-1 kernel: IPv6: ADDRCONF(NETDEV_CHANGE): vap50: link becomes ready
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac monitor recalc started? 0 needed? 0 allowed? 1
Jun 11 11:51:56 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac monitor recalc started? 0 needed? 0 allowed? 1
Jun 11 11:51:58 ben-ota-1 hostapd[3329]: vap50: STA 04:f0:21:39:e9:35 IEEE 802.11: authenticated
Jun 11 11:51:58 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: vdev 0 set beacon tx mode to staggered
Jun 11 11:51:58 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 dtim_period 2
Jun 11 11:51:58 ben-ota-1 hostapd[3329]: vap50: STA 04:f0:21:39:e9:35 IEEE 802.11: associated (aid 1)
Jun 11 11:51:58 ben-ota-1 hostapd[3329]: vap50: STA 04:f0:21:39:e9:35 RADIUS: starting accounting session 5579D8CC-00000000
Jun 11 11:51:58 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 cts_prot 0
Jun 11 11:51:58 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 preamble 1n
Jun 11 11:51:58 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 peer create 04:f0:21:39:e9:35 (new sta) sta 1 / 128 peer 2 / 144
Jun 11 11:51:58 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac sta 04:f0:21:39:e9:35 associated
Jun 11 11:51:58 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ht peer 04:f0:21:39:e9:35 mcs cnt 24 nss 3
Jun 11 11:51:58 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vht peer 04:f0:21:39:e9:35 max_mpdu 1048575 flags 0x2003001
Jun 11 11:51:58 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac peer 04:f0:21:39:e9:35 qos 1
Jun 11 11:51:58 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac peer 04:f0:21:39:e9:35 phymode 11ac-vht40
Jun 11 11:51:58 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac chanctx change freq 5180 width 2 ptr ffff880201a63d18 changed 10
Jun 11 11:51:58 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:58 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.17 to 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:58 ben-ota-1 dhcpd[3040]: DHCPDISCOVER from 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:58 ben-ota-1 dhcpd[3040]: DHCPOFFER on 63.1.1.17 to 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:58 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ampdu vdev_id 0 sta 04:f0:21:39:e9:35 tid 0 action 0
Jun 11 11:51:58 ben-ota-1 dhcpd[3040]: DHCPREQUEST for 63.1.1.17 (63.1.1.1) from 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:58 ben-ota-1 dhcpd[3040]: DHCPACK on 63.1.1.17 to 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:58 ben-ota-1 dhcpd[3040]: DHCPREQUEST for 63.1.1.17 (63.1.1.1) from 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:58 ben-ota-1 dhcpd[3040]: DHCPACK on 63.1.1.17 to 04:f0:21:39:e9:35 via vap50
Jun 11 11:51:59 ben-ota-1 wpa_supplicant[3384]: Successfully initialized wpa_supplicant
Jun 11 11:51:59 ben-ota-1 dhcpd[3389]: Not searching LDAP since ldap-server, ldap-port and ldap-base-dn were not specified in the config file
Jun 11 11:51:59 ben-ota-1 dhcpd[3389]: Wrote 9 leases to leases file.
Jun 11 11:51:59 ben-ota-1 dhcpd[3389]: Bound fallback interface sk: 9 to device: vap50
Jun 11 11:52:01 ben-ota-1 hostapd[3329]: vap50: STA 00:0e:8e:32:06:96 IEEE 802.11: authenticated
Jun 11 11:52:01 ben-ota-1 hostapd[3329]: vap50: STA 00:0e:8e:32:06:96 IEEE 802.11: associated (aid 2)
Jun 11 11:52:01 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac vdev 0 peer create 00:0e:8e:32:06:96 (new sta) sta 2 / 128 peer 3 / 144
Jun 11 11:52:01 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac sta 00:0e:8e:32:06:96 associated
Jun 11 11:52:01 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ht peer 00:0e:8e:32:06:96 mcs cnt 24 nss 3
Jun 11 11:52:01 ben-ota-1 hostapd[3329]: vap50: STA 00:0e:8e:32:06:96 RADIUS: starting accounting session 5579D8CC-00000001
Jun 11 11:52:01 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac peer 00:0e:8e:32:06:96 qos 1
Jun 11 11:52:01 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac peer 00:0e:8e:32:06:96 phymode 11na-ht40
Jun 11 11:52:01 ben-ota-1 dhcpd[3390]: DHCPDISCOVER from 00:0e:8e:32:06:96 via vap50
Jun 11 11:52:01 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ampdu vdev_id 0 sta 00:0e:8e:32:06:96 tid 0 action 0
Jun 11 11:52:02 ben-ota-1 dhcpd[3390]: DHCPOFFER on 63.1.1.18 to 00:0e:8e:32:06:96 via vap50
Jun 11 11:52:02 ben-ota-1 dhcpd[3390]: DHCPREQUEST for 63.1.1.18 (63.1.1.1) from 00:0e:8e:32:06:96 via vap50
Jun 11 11:52:02 ben-ota-1 dhcpd[3390]: DHCPACK on 63.1.1.18 to 00:0e:8e:32:06:96 via vap50
Jun 11 11:52:02 ben-ota-1 dhcpd[3390]: DHCPREQUEST for 63.1.1.18 (63.1.1.1) from 00:0e:8e:32:06:96 via vap50
Jun 11 11:52:02 ben-ota-1 dhcpd[3390]: DHCPACK on 63.1.1.18 to 00:0e:8e:32:06:96 via vap50
Jun 11 11:52:14 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ampdu vdev_id 0 sta 00:0e:8e:32:06:96 tid 0 action 1
Jun 11 11:52:56 ben-ota-1 kernel: cfg80211: Verifying active interfaces after reg change
Jun 11 11:55:20 ben-ota-1 chronyd[778]: Selected source 171.66.97.126
Jun 11 11:56:41 ben-ota-1 hostapd[2782]: eth0#0: STA e8:99:c4:8e:83:4d RADIUS: starting accounting session 5579D84D-00000000
Jun 11 11:57:00 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ampdu vdev_id 0 sta 00:0e:8e:32:06:96 tid 0 action 0
Jun 11 11:57:05 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ampdu vdev_id 0 sta 00:0e:8e:32:06:96 tid 0 action 1
Jun 11 11:59:17 ben-ota-1 systemd[1]: Starting dnf makecache...
Jun 11 11:59:17 ben-ota-1 dnf[4779]: cachedir: /var/cache/dnf/x86_64/20
Jun 11 11:59:17 ben-ota-1 dnf[4779]: DNF version: 0.5.4
Jun 11 11:59:17 ben-ota-1 dnf[4779]: Making cache files for all metadata files.
Jun 11 11:59:17 ben-ota-1 dnf[4779]: Metadata cache refreshed recently.
Jun 11 11:59:17 ben-ota-1 systemd[1]: Started dnf makecache.
Jun 11 12:00:01 ben-ota-1 systemd[1]: Starting Session 3 of user root.
Jun 11 12:00:01 ben-ota-1 systemd[1]: Started Session 3 of user root.
Jun 11 12:00:01 ben-ota-1 CROND[4923]: (root) CMD (/usr/lib64/sa/sa1 1 1)
Jun 11 12:01:01 ben-ota-1 systemd[1]: Starting Session 4 of user root.
Jun 11 12:01:01 ben-ota-1 systemd[1]: Started Session 4 of user root.
Jun 11 12:01:01 ben-ota-1 CROND[5135]: (root) CMD (run-parts /etc/cron.hourly)
Jun 11 12:01:01 ben-ota-1 run-parts[5138]: (/etc/cron.hourly) starting 0anacron
Jun 11 12:01:01 ben-ota-1 run-parts[5144]: (/etc/cron.hourly) finished 0anacron
Jun 11 12:01:01 ben-ota-1 run-parts[5146]: (/etc/cron.hourly) starting mcelog.cron
Jun 11 12:01:01 ben-ota-1 run-parts[5150]: (/etc/cron.hourly) finished mcelog.cron
Jun 11 12:01:42 ben-ota-1 hostapd[2782]: eth0#0: STA e8:99:c4:8e:83:4d IEEE 802.11: disassociated due to inactivity
Jun 11 12:01:43 ben-ota-1 hostapd[2782]: eth0#0: STA e8:99:c4:8e:83:4d IEEE 802.11: deauthenticated due to inactivity (timer DEAUTH/REMOVE)
Jun 11 12:01:59 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ampdu vdev_id 0 sta 00:0e:8e:32:06:96 tid 0 action 0
Jun 11 12:02:04 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ampdu vdev_id 0 sta 00:0e:8e:32:06:96 tid 0 action 1
Jun 11 12:04:17 ben-ota-1 systemd[1]: Starting Cleanup of Temporary Directories...
Jun 11 12:04:17 ben-ota-1 systemd[1]: Started Cleanup of Temporary Directories.
Jun 11 12:06:58 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ampdu vdev_id 0 sta 00:0e:8e:32:06:96 tid 0 action 0
Jun 11 12:07:03 ben-ota-1 kernel: ath10k_pci 0000:07:00.0: mac ampdu vdev_id 0 sta 00:0e:8e:32:06:96 tid 0 action 1
[root@ben-ota-1 ~]#


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

