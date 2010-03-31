Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:56519 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932259Ab0CaVjS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Mar 2010 17:39:18 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Subject: Re: [rt2x00-users] [PATCH RFC] rt2500usb: disable broken HW  encryption by default
Date: Wed, 31 Mar 2010 23:39:05 +0200
Cc: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org
References: <201003221601.36559.linux@rainbow-software.org> <201003241552.32184.linux@rainbow-software.org> <201003261205.51128.linux@rainbow-software.org>
In-Reply-To: <201003261205.51128.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201003312339.07606.linux@rainbow-software.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 26 March 2010 12:05:48 Ondrej Zary wrote:
> On Wednesday 24 March 2010, Ondrej Zary wrote:
> > On Wednesday 24 March 2010, Ivo Van Doorn wrote:
> > > On Wed, Mar 24, 2010 at 2:12 PM, Ondrej Zary
> > > <linux@rainbow-software.org>
> >
> > wrote:
> > > > On Tuesday 23 March 2010, Ivo Van Doorn wrote:
> > > >> On Tue, Mar 23, 2010 at 4:09 PM, Ondrej Zary
> > > >> <linux@rainbow-software.org>
> > > >
> > > > wrote:
> > > >> > On Tuesday 23 March 2010, Ivo Van Doorn wrote:
> > > >> >> On Tue, Mar 23, 2010 at 10:27 AM, Ondrej Zary
> > > >> >>
> > > >> >> <linux@rainbow-software.org> wrote:
> > > >> >> > On Monday 22 March 2010, Ivo Van Doorn wrote:
> > > >> >> >> >> But I though it was mentioned that disabling HW crypto
> > > >> >> >> >> didn't solve the issue due to a second bug in a later
> > > >> >> >> >> kernel?
> > > >> >> >> >
> > > >> >> >> > That was a false positive. Probably because the device was
> > > >> >> >> > not unplugged between the tests (and looks like the driver
> > > >> >> >> > does not initialize the chip completely). It's not reliable,
> > > >> >> >> > it sometimes stops working after reboot.
> > > >> >> >>
> > > >> >> >> Ah well that at least simplifies the problem. I'll have to
> > > >> >> >> retest rt2500usb soon to see why the HW crypto failed. I am
> > > >> >> >> sure I had it working for WEP, WPA and WPA2
> > > >> >> >> before I submitted the patch.
> > > >> >> >
> > > >> >> > So let's try to fix it instead of disabling.
> > > >> >> >
> > > >> >> > First, the unrealiability (keeping HW encryption disabled).
> > > >> >> > With the driver loaded but not doing anything more, the
> > > >> >> > register dumps are same for both working and non-working case
> > > >> >> > (dump-init.txt).
> > > >> >> >
> > > >> >> > dump-good-connected.txt is a dump after successful association
> > > >> >> > and DHCP dump-bad-attempt.txt is a dump after successful
> > > >> >> > association during non-working DHCP attempt
> > > >> >> > dump-bad-after.txt is a dump after DHCP timed out
> > > >> >>
> > > >> >> With association working, but DHCP failing it most likely means
> > > >> >> that somehow the frame was malformatted.
> > > >> >> The code for HW crypto alters the frame (alters IV/EIV/ICV data
> > > >> >> etc). And that is commonly the source of
> > > >> >> problems, because what has to be done depends heavily on the
> > > >> >> encryption type.
> > > >> >>
> > > >> >> So could you verify which of the encryption types (WEP,WPA,WPA2)
> > > >> >> is failing or working? That would give a starting
> > > >> >> position on which bytes might be corrupted.
> > > >> >
> > > >> > I was testing only with WPA2 before. I did some more testing
> > > >> > today. The results:
> > > >> >
> > > >> > No encryption - works always
> > > >> > WEP - sometimes works, sometimes not - same with and without HW
> > > >> > encryption WPA - sometimes works, sometimes not - same with and
> > > >> > without HW encryption WPA2 - never works with HW encryption
> > > >> >     - sometimes works, sometimes not without HW encryptionn
> > > >> >
> > > >> > So it seems that there are two problems:
> > > >> >  1. random problems with any encryption
> > > >> >  2. WPA2 is broken with HW encryption
> > > >> >
> > > >> > When the "random" problem appears, this appears in dmesg:
> > > >> > wlan1: authenticate with 00:13:d4:0f:f3:17 (try 1)
> > > >> > wlan1: authenticated
> > > >> > wlan1: associate with 00:13:d4:0f:f3:17 (try 1)
> > > >> > wlan1: RX AssocResp from 00:13:d4:0f:f3:17 (capab=0x411 status=0
> > > >> > aid=2) wlan1: associated
> > > >> > phy0 -> rt2500usb_set_device_state: Error - Device failed to enter
> > > >> > state 3 (-16). phy0 -> rt2500usb_set_device_state: Error - Device
> > > >> > failed to enter state 3 (-16). No probe response from AP
> > > >> > 00:13:d4:0f:f3:17 after 500ms, disconnecting.
> > > >> >
> > > >> > Disabling call to rt2500usb_set_state() in
> > > >> > rt2500usb_set_device_state() seems to fix problem 1. After this
> > > >> > change, WEP and WPA work always regardless of HW encryption (and
> > > >> > WPA2 works always without it).
> > > >>
> > > >> Ok, lets focus on the HW crypto for now.
> > > >>
> > > >> If WPA2 fails, then the WPA2 specific code for IV/EIV/ICV isn't
> > > >> working. Most likely
> > > >> the device either doesn't send all data back to the driver (while
> > > >> the driver does expect it)
> > > >> or it adds additional data which the driver doesn't expect. (See
> > > >> rt2x00crypto.c for the frame
> > > >> manipulation during HW crypto).
> > > >>
> > > >> Could you check the full packet data of a DHCP request with and
> > > >> without HW crypto?
> > > >> That might give a clue about what the hardware is sending for extra
> > > >> data.
> > > >
> > > > How do I access the full packets? I tried using another machine with
> > > > "iwconfig wlan0 mode monitor" and tcpdump. It captured many packets
> > > > and I'm unable to identify the interesting ones.
> > >
> > > You won't get the useful stuff from monitor mode.
> > > You have to enable rt2x00 debugfs support, to find a framedump file in
> > > the rt2x00 debugfs folder.
> > >
> > > You should use the framedump tool from:
> > > http://kernel.org/pub/linux/kernel/people/ivd/tools/
> > >
> > > To get the frame dumps in nicely formatted lines for analysis.
> >
> > Thanks, here are the dump files:
> > http://www.rainbow-software.org/linux_files/rt2500usb/dump-wpa2-bad.txt
> > http://www.rainbow-software.org/linux_files/rt2500usb/dump-wpa2-good.txt
> >
> > I don't know how wifi encryption works so I don't know what to look for.
>
> Some more news. Tested with another AP (Asus WL-300g with DD-WRT) with
> various WPA2 settings (TKIP, AES, TKIP+AES). TKIP works. AES works.
> TKIP+AES does not.

rt2800pci works with TKIP+AES (only for a couple of seconds, but that's 
another problem) so this seems to be specific for rt2500usb. Added some 
printk()s and it seems that wrong key is used for TX of broadcast packets.

A type 2 key (ALG_CCMP) is set up as pairwise key at index 0:
rt2x00crypto_key_to_cipher 2
pairwise
rt2500usb_config_key
rt2500usb_config_key: cmd == SET_KEY
TRXR_CSR0 = 192
hw_key_idx=0
TXRX_CSR0=192
TXRX_CSR0 set to 708

A type 1 key (ALG_TKIP) is set up as group key at index 1:
rt2x00crypto_key_to_cipher 1
group
rt2500usb_config_key
rt2500usb_config_key: cmd == SET_KEY
TRXR_CSR0 = 708
hw_key_idx=1
TXRX_CSR0=708
TXRX_CSR0 set to 1731

That looks good. But then a DHCPDISCOVER broadcast packets are sent with type 
2 (ALG_CCMP) key used, which looks wrong:
rt2x00crypto_create_tx_descriptor
rt2x00crypto_key_to_cipher 2
rt2x00crypto_tx_overhead=8
rt2x00crypto_tx_copy_iv
rt2x00crypto_tx_insert_iv

I might be wrong as this is first time I'm doing anything with wireless 
networks...

-- 
Ondrej Zary
