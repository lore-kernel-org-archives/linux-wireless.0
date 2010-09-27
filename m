Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46243 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933430Ab0I0TVL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 15:21:11 -0400
Received: by qyk33 with SMTP id 33so8233920qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 12:21:10 -0700 (PDT)
Subject: Re: Question about starting up an AP
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Joshua Smith <jesmith@kaon.com>
In-Reply-To: <201009271956.41041.helmut.schaa@googlemail.com>
Date: Mon, 27 Sep 2010 15:21:04 -0400
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Message-Id: <D83E9C0C-C35C-4787-832E-1308213F325E@kaon.com>
References: <DA0C92FD-F6BF-4746-9BE1-A643A0D70F7A@kaon.com> <201009251034.24993.helmut.schaa@googlemail.com> <B17955D1-62BE-4A7E-8ECD-05FA62BD80B9@kaon.com> <201009271956.41041.helmut.schaa@googlemail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just to be specific, here is the problem I'm having:

Sometimes my Linksys/Cisco WMP600N adapter will not initialize in AP mode.  Prior to going into AP mode, I do 'iw wlan0 scan' and get a bunch of info, so the hardware is working up to that point.  When I try to start hostapd, I get this error in dmesg:

phy0 -> rt2800_wait_wpdma_ready: Error - WPDMA TX/RX busy, aborting.
phy0 -> rt2800pci_set_device_state: Error - Device failed to enter state 4 (-5).

(note that I also get this message:
phy0 -> rt2800pci_mcu_status: Error - MCU request failed, no response from hardware
but I get that when everything works, as well.)

After the WPMDA TX/RX error occurs I usually cannot use the hardware at all.  Even a simple 'ifconfig wlan0 up' will result in the same error.  On rare occasions, the hardware will work if I simply retry hostapd.  But usually I have to reboot to get the hardware working again.

Helmut provided me with a patch to change the timeout for DMA to become ready; this did not solve the problem.

Restarting the kernel modules like this:

rmmod rt2800pci rt2800lib rt2x00pci rt2x00lib compat_firmware_class mac80211 cfg80211 compat
modprobe rt2800pci

also has no effect.  I'm open to suggestions for other ways I might be able to kick the pci card without rebooting.

Note that this exact software/hardware sometimes works, and sometimes fails.  I have reproduced this problem on multiple WiFi adapters (same make/model), so I am confident it is not an isolated hardware failure.  lspci -vv shows this data about the adapter:

03:01.0 Network controller: RaLink RT2800 802.11n PCI
	Subsystem: Linksys Unknown device 0067
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (500ns min, 1000ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at f3000000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: rt2800pci
	Kernel modules: rt2800pci, rt2860sta

I am running compat-wireless 2010-09-20 with a 2.6.27.8 kernel (slax 6.0.9-based distro)

In the "probably not related, but just in case" category: I have another problem with these cards and hostapd where occasionally they will send a beacon but not respond to clients trying to join the network.  However, stopping hostapd and restarting it clears this condition.  (Now that I can successfully restart hostapd, thanks to a patch from Helmut!)  In one case, restarting hostapd resulted in the WPDMA TX/RX error, and then I had to reboot.

I'd be happy to try any wild ideas anyone has on this.

Please reply to me directly, as I am not subscribed to this list.

-Joshua

On Sep 27, 2010, at 1:56 PM, Helmut Schaa wrote:

> Hi,
> 
> Am Montag 27 September 2010 schrieb Joshua Smith:
>> The change to the REGISTER_BUSY_COUNT did not eliminate the issue. 
>> The device still sometimes exhibits this behavior.  (It may be exhibiting
>> it less often, but the occurrences are so random, that it's hard for me to
>> know for sure.)
> 
> Yeah, as I said, just a shot in the dark.
> 
>> However, the other fix DID indeed eliminate the kernel crash when I tried
>> to restart hostapd, and it also fixed a crash that I experienced when I
>> tried to rmmod the rt2800pci module.  So you should definitely mainline
>> that patch.
> 
> Sure.
> 
>> Now that I can retry hostapd and rmmod the modules, I have found that there
>> is apparently no software workaround for the case where the DMA busy
>> condition does not pass. 
> 
> Hmm, maybe there is but we have't found it yet ;)
> 
>> I have tried restarting hostapd, and I have tried rmmod'ding all the
>> associated modules and modprobing them back in.  Nothing clears the
>> condition except a reboot.
> 
> Too bad.
> 
>> Any other ideas of what I could do to reset the hardware?  I'd love to find
>> a "soft" fix for this, rather than having to reboot to clear the condition.
> 
> Nothing obviouis at least. So, no without further debugging I don't know what's
> going on in your case. Would be interesting if others experience the same
> problem.
> 
> Helmut

