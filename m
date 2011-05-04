Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61403 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1EDQQg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 12:16:36 -0400
Received: by gyd10 with SMTP id 10so448023gyd.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 May 2011 09:16:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DC042A5.9050806@candelatech.com>
References: <4DBF1967.9010604@candelatech.com>
	<BANLkTimYks_+QRUNURtbRy+S941fL04HRQ@mail.gmail.com>
	<4DC042A5.9050806@candelatech.com>
Date: Thu, 5 May 2011 00:16:35 +0800
Message-ID: <BANLkTikuw4uSOL5zoMa9QzOsajnSyhEsGQ@mail.gmail.com> (sfid-20110504_181640_163497_D57E678F)
Subject: Re: Looking for 3x3 Atheros NICs using ath9k driver.
From: Adrian Chadd <adrian@freebsd.org>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 May 2011 02:00, Ben Greear <greearb@candelatech.com> wrote:

> Here's the lspci for the SR71-A that doesn't work with ath9k:
>
> 03:00.0 Ethernet controller: Atheros Communications Inc. AR5008 Wireless
> Network Adapter (rev 01)
>        Subsystem: Atheros Communications Inc. Device ee1c

... ee1c? Err, that isn't right. Not by a very, very long shot.

What board are you putting this into?

>From FreeBSD on a RSPRO (ar71xx mips):

ath0@pci0:0:17:0:       class=0x028000 card=0x40820777 chip=0x0027168c
rev=0x01 hdr=0x00
    vendor     = 'Atheros Communications Inc.'
    class      = network

That definitely, positively is the same AC1A revision that you have.
It even does 11n(ag) too. Honest. I've seen it. :-)

This and the previous AR93xx "0xabcd" device id post is starting to
sound a lot like something's not waking up the PCI bus and/or chip
"right" in order to get the PCI vendor id init'ed from the EEPROM..



Adrian
