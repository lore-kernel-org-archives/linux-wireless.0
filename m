Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:58017 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892Ab1LaUha (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Dec 2011 15:37:30 -0500
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
	by mout4.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1Rh5gH-0002ko-56
	for linux-wireless@vger.kernel.org; Sat, 31 Dec 2011 21:37:29 +0100
Received: from localhost ([::1]:35431 helo=mjail1.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1Rh5gH-0006jz-1K
	for linux-wireless@vger.kernel.org; Sat, 31 Dec 2011 21:37:29 +0100
Received: from [195.4.92.14] (port=35638 helo=4.mx.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1Rh5e3-0006W0-2k
	for linux-wireless@vger.kernel.org; Sat, 31 Dec 2011 21:35:11 +0100
Received: from p4fde0b4e.dip0.t-ipconnect.de ([79.222.11.78]:39994 helo=mail.maya.org)
	by 4.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1Rh5e2-0003qm-P5
	for linux-wireless@vger.kernel.org; Sat, 31 Dec 2011 21:35:11 +0100
Message-ID: <4EFF71F8.6070208@01019freenet.de> (sfid-20111231_213750_128750_E5922262)
Date: Sat, 31 Dec 2011 21:35:04 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Helmut Schaa <helmut.schaa@googlemail.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: Compat-wireless-3.2-rc6-3 is broken for rt2860 device
References: <4EFF12D9.3010602@01019freenet.de>
In-Reply-To: <4EFF12D9.3010602@01019freenet.de>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andreas Hartmann schrieb:
> Hello,
> 
> I tested compat-wireless-3.2-rc6-3 with kernel 3.1 and a rt2860 device
> running in AP mode (80211.n - 40 MHz). During
> 
> netperf -t TCP_STREAM -H ap
> 
> the data stream mostly stalls (-> the device receives data) after a few
> seconds and never comes up any more. The connection is completely death.
> I have to restart wpa_supplicant to get it working again.
> 
> 
> 
> I tried to isolate the problem the following way:
> 
> 1. Running compat-wireless-3.2-rc6-3 with the rt2x00 level from
> compat-wireless-3.1.1-1. The problem didn't gone.
> 
> 2. Running compat-wireless-3.1.1-1 with the rt2x00 based changes in
> compat-wireless-3.2-rc6-3. I can't see the problem any more.
> 
> 
> That's why I think, that the problem must be outside the rt2x00 changes.
> But there are many changes outside :-).


Removing this patch

mac80211: retry sending failed BAR frames later instead of tearing down
aggr (http://www.spinics.net/lists/linux-wireless/msg76379.html) makes
it working again.

Device is: RaLink RT2800 802.11n PCI


Kind regards,
Andreas Hartmann
