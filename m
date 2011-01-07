Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42048 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab1AGWJk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 17:09:40 -0500
Received: by qwa26 with SMTP id 26so18270979qwa.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 14:09:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110107215549.4053.qmail@stuge.se>
References: <20110107215549.4053.qmail@stuge.se>
Date: Fri, 7 Jan 2011 17:09:39 -0500
Message-ID: <AANLkTikb2bAeB6EqVoRSVvQUWqY70F4fO5d1cWKHgbRO@mail.gmail.com>
Subject: Re: [ath9k-devel] ath9k tx lockup, ath: received PCI FATAL interrupt
From: Brian Prodoehl <bprodoehl@gmail.com>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 7, 2011 at 4:55 PM, Peter Stuge <peter@stuge.se> wrote:
> First of all, sorry for dropping linux-wireless from my previous
> message, it was mostly about my understanding of ath9k processes.
>
> Crossposting is a bit unnatural for me, I usually strictly use
> list-reply. Let's try with this one! :)
>
>
> Peter Stuge wrote:
>> So there was a problem while writing this message. Will follow up
>> in separate message. I can only describe the symptom, but as I wrote
>> after subscribing this list over a year ago I'm comfortable and more
>> than happy to help with debugging on register level, and below, but I
>> still know neither driver nor hardware and if possible I would like
>> to not have to learn all of the driver, so I would need to be told
>> fairly specifically what to instrument.
>>
>> I think someone with good knowledge of driver and hardware could give
>> guidance very quickly.
>
> I booted wireless-testing master-2011-01-05 with an AR9280 Mini PCI
> card in my ThinkPad X40 today.
>
> I normally never use wpa_supplicant. I don't accept that it would be
> required for a working connection and so far noone has really
> explained why that would be the case. Only ath9k (ie. neither ipw2200
> nor ath5k) has ever made a difference between wpa_supplicant running
> or not.
>
> I configure manually. Module is loaded by kernel on boot. After
> logging in, I run:
>
> ip l s dev eth1 up
> iw dev eth1 connect Stuge
> ip a a 192.168.5.4/24 dev eth1
> ip r a default via 192.168.5.1
>
> ..and that is my internet connection.
>
>
> I used the connection without issues for about an hour, working
> remotely and listening to a music stream, then I was disassociated,
> with the PCI FATAL interrupt in the kernel log.
>
> dmesg output is log1_ath_pci_fatal_interrupt.txt
>
>
> Trying to revive the connection it seemed like no packets were being
> transmitted because I could scan, but not associate again.
>
> I then tried to start wpa_supplicant, which made four attempts at
> authenticating with the (unencrypted) AP, without success.
>
> dmesg output is log2_after_wpa_supplicant_4x_trying_to_auth.txt
>
>
> I tried to rmmod and modprobe the driver, followed by
>
> iw dev eth1 connect Stuge
>
> but that also did not work.
>
> dmesg output is log3_after_rmmod_modprobe.txt
>
>
> I power cycled and did the above ip l s + iw connect, which made the
> card sort-of associate, but not function correctly.
>
> dmesg output is log4_after_power_cycle_and_iw_connect.txt
>
> Running iw dev eth1 link at this time showed me *not* being
> successfully connected.
>
> I started wpa_supplicant 0.7.2 without debug messages.
> Output is in log5_wpa_supplicant.txt
>
> I ran iw dev eth1 connect Stuge
>
> wpa_supplicant output is log6_wpa_supplicant_after_iw_connect.txt
>
> dmesg output is log7_after_wpa_supplicant_and_iw_connect.txt
>
>
> This is the connection I am currently using.
>
>
> The above identifies at least two issues:
>
> 1. ath: received PCI FATAL interrupt
>
> How can I find out more about the reason for this?
>
>
> 2. Unworking association without wpa_supplicant after power cycle
>
> How can I find out more about the reason for this?
>
>
> The log files are attached and available at http://stuge.se/ath9k/wl0105/
> All dmesg output is incremental. boot1.txt and boot2.txt are initial
> messages for each boot, but not included as attachments.
>
> boot2.txt (after power cycle) had different timing, keyboard detected
> earlier, no tty60 hash and different btrfs transaction id. I added
> the Time: stamp in log4_after_power_cycle_and_iw_connect.txt.
>
> Please help me provide further neccessary information to debug this.
> Thank you!
>
>
> //Peter


Out of curiosity, what's your AP?  I've never seen those "detected
beacon loss from AP" messages.  If you bring up a monitor-mode
interface, do you see beacons at a sane, regular interval?

-Brian
