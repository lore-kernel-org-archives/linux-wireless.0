Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dozer.fsck.co.uk ([77.246.163.77]:48683 "EHLO dozer.fsck.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840Ab2HGWGS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2012 18:06:18 -0400
Received: from dozer.fsck.co.uk (localhost.localdomain [127.0.0.1])
	by dozer.fsck.co.uk (Postfix) with ESMTP id C1B5310016
	for <linux-wireless@vger.kernel.org>; Tue,  7 Aug 2012 22:58:13 +0100 (BST)
Received: from [192.168.1.107] (host217-44-86-65.range217-44.btcentralplus.com [217.44.86.65])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by dozer.fsck.co.uk (Postfix) with ESMTPSA id 834B110014
	for <linux-wireless@vger.kernel.org>; Tue,  7 Aug 2012 22:58:13 +0100 (BST)
Message-ID: <50218F74.5090907@fsck.co.uk> (sfid-20120808_000621_646101_A0AA14DB)
Date: Tue, 07 Aug 2012 22:58:12 +0100
From: "A. James Lewis" <james@fsck.co.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Driver support for WiFi VIF.
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello all,

I've spend most of the last couple of days investigating the process of
(trying to) work out which combination of hardware and software is
required to create multiple interfaces (ssids) with a single WiFi
harware device....  and I have reached the point where I need to ask
some questions.

I've looked at the Drivers page here:-

http://linuxwireless.org/en/users/Drivers

But it's not clear to me which column/if this table details if the
device is capable of running multiple VIF's... and I'm not quite sure if
the configuration I'm doing is correct.  I've tried 2 different types of
Ralink/Edimax dongle as well as the Centrino device in my laptop, and
the ultimate goal is to be able to run both "batman advanced" as well as
a standard WiFi client... or "batman advanced" as well as a WiFi AP.

I'm getting stumped right at the outset.... because I can configure both
interfaces, but if I try to bring 2 up at the same time with "ifconfig"
I get "Device or resource busy".

Here's what I'm trying to do, using kernel (Linux xwing 3.5.0-8-generic
#8-Ubuntu SMP)...

#iw phy phy0 interface add ah0 type ibss
#ifconfig ah0 mtu 1528
#iwconfig ah0 mode ad-hoc essid batman-adv ap any channel 3
#ifconfig ah0 up

This returns :- SIOCSIFFLAGS: Device or resource busy
when I try to bring the interface up.

If I first take the existing wlan0 interface down, I can bring ah0 up...
and visa versa... but not at the same time...

Is this a reasonable approach, I'm not sure if it's what I'm doing of if
the driver isn't able to do what I want... and I can't seem to work out
how to tell if multiple ssid's are supported by the driver or not.

I hope this question isn't too simple, or answered in the documentation
as I've spent a long time reading the documentation, and filtering out
the old information such as madwifi etc... and I think I've got to the
point where I have the correct process, but I'm left a bit stumped TBH.

-- 
A. James Lewis (james@fsck.co.uk)
Engineering does not require science. Science helps a lot but people
built perfectly good brick walls long before they knew why cement works.

