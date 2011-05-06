Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42077 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab1EFRMv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 13:12:51 -0400
Received: by pzk9 with SMTP id 9so1511673pzk.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 May 2011 10:12:51 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19908.11423.898062.510184@gargle.gargle.HOWL> (sfid-20110506_191254_819214_6D1426D9)
Date: Fri, 6 May 2011 22:45:11 +0530
To: George Nychis <gnychis@gmail.com>
Cc: Mark Davis <marked86@gmail.com>, linux-wireless@vger.kernel.org,
	Steven <srumney@sbcglobal.net>
Subject: Re: error initializing AR7010+AR9280 Xbox 802.11n adapter
In-Reply-To: <BANLkTi=tZDXs=ja+YKXFVyP3FeuxmWLtuA@mail.gmail.com>
References: <BANLkTinoAmna3mtMWY2Ai82wbGu-T9FzMQ@mail.gmail.com>
	<BANLkTi=Z=i9_WoXX=YbQtF-8imKizRPM+w@mail.gmail.com>
	<BANLkTim_uY0Di13RDHZxOpVQZaDfG3hc8A@mail.gmail.com>
	<19903.49991.848934.183819@gargle.gargle.HOWL>
	<BANLkTi=1E-Ma=N0D-gP_baSjMOvmfM-2KQ@mail.gmail.com>
	<BANLkTi=wXtCNY7TUUpfYpHux8piL09+RuQ@mail.gmail.com>
	<BANLkTiknq4jDQY2-z53QXoyHUb4b4=Oojw@mail.gmail.com>
	<BANLkTi=tZDXs=ja+YKXFVyP3FeuxmWLtuA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

George Nychis wrote:
> I decided to get the Sony BR100 and try it out, given that the
> WikiDevi page for the device seems to suggest that it works with
> ath9k_htc:
> http://www.wikidevi.com/wiki/Sony_UWA-BR100
> 
> My confidence is also a little higher given that someone has it
> working in Windows, also.
> 
> But, using the most recent firmware and compat-wireless, I get the
> same exact error that I did with the Xbox adapter:
> [ 1277.228258] usb 2-2: ath9k_htc: Transferred FW: htc_7010.fw, size: 72996
> [ 1278.228930] ath9k_htc 2-2:1.0: ath9k_htc: Target is unresponsive
> [ 1278.229788] Failed to initialize the device
> [ 1279.029952] ath9k_htc: probe of 2-2:1.0 failed with error -22
> 
> The WikiDev page mentions that it worked as of Jan. 8, 2011.  So I
> rolled back compat-wireless to that date and grabbed the old firmware
> from the old tree.
> 
> Unfortunately, I still get the same error:
> [  386.398366] usb 1-1: USB disconnect, address 4
> [  388.412466] usb 1-1: new high speed USB device using ehci_hcd and address 5
> [  389.113687] usb 1-1: ath9k_htc: Transferred FW: ar7010_1_1.fw, size: 70624
> [  390.112282] usb 1-1: ath9k_htc: Target is unresponsive
> [  390.112308] Failed to initialize the device
> [  390.113658] ath9k_hif_usb: probe of 1-1:1.0 failed with error -22
> 
> So, either this person had some form of magic, or I am missing
> something... I'd be curious to try it in Windows.  BTW, it shows up in
> Mac OSX as "Buffalo" ...
> 
> (CEWL 1):
> 
>   Product ID:	0x017f
>   Vendor ID:	0x0411  (BUFFALO INC.)
>   Version:	 2.02
>   Serial Number:	12345
>   Speed:	Up to 480 Mb/sec
>   Manufacturer:	BUFFALO
>   Location ID:	0xfd100000
>   Current Available (mA):	500
>   Current Required (mA):	Unknown (Device has not been configured)

This is  UB94 based, so it should work with ath9k_htc.
Can you post the output of lsusb -v ?

Sujith
