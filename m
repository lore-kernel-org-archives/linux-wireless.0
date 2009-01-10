Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-156-71.gdrpmi.dsl-w.verizon.net ([71.115.156.71]:48133
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbZAJTua (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2009 14:50:30 -0500
Message-ID: <4968FC02.6010708@erley.org> (sfid-20090110_205034_945997_F0B6680F)
Date: Sat, 10 Jan 2009 14:50:26 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: "W. van den Akker" <listsrv@wilsoft.nl>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Still problems to get ath9k in accessmode. Kernel hangs
References: <200901011444.20333.listsrv@wilsoft.nl> <200901062342.22935.listsrv@wilsoft.nl> <200901071642.04310.listsrv@wilsoft.nl> <200901101226.16007.listsrv@wilsoft.nl>
In-Reply-To: <200901101226.16007.listsrv@wilsoft.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W. van den Akker wrote:
> 
> Did some futher testing to exclude problems....
> The wlan0 and eth1 are both part of a bridge. I have removed the eth1 
> interface so the the eth1-driver cannot interfer with the ath9k driver.
> Also no result. The server still locks.
> 
> What is the right way to combine the eth1 and wlan0 into a bridge. Do I even 
> need  a bridge? The hostapd.config says I must define a bridge when I use the 
> nl80211driver interface.
> The bridge has an IP adress, wlan0 and eth1 are in the same subnet.
> 
> When hostapd is started I have some error-messages. Dont know if they can 
> hurt...
> Failed to set CTS protect in kernel driver
> Failed to set Short Slot Time option in kernel driver
> Could not set preamble for kernel driver
> 
> 

I use gentoo's init scripts, but my wlan0 and eth0 are both in a bridge
(br0) and it works fine.  I don't get the CTS, Short Slot Time, or
preamble kernel driver errors.  Perhaps you need to comment out a few
lines in hostapd.conf?

# preamble=1

and I have:

rts_threshold=2347

I'll send you a direct e-mail with my .config and hostapd-wep.conf files
to help with debugging.

Pat Erley
