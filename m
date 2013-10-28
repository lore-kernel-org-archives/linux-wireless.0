Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.61]:40223 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab3J1V2j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 17:28:39 -0400
Received: from [192.168.1.141] (c-67-186-7-229.hsd1.pa.comcast.net [67.186.7.229])
	(user=rpw mech=PLAIN (0 bits))
	by smtp.andrew.cmu.edu (8.14.4/8.14.4) with ESMTP id r9SLSagP019315
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 28 Oct 2013 17:28:37 -0400
Message-ID: <526ED703.6020901@andrew.cmu.edu> (sfid-20131028_222841_975175_6C4FB74D)
Date: Mon, 28 Oct 2013 17:28:35 -0400
From: Richard Wang <rpw@andrew.cmu.edu>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Linksys AE3000 iw tool issues
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I currently have a Linksys AE3000 Wifi USB dongle, which has the 
RalinkRT3573 chipset.

I am able currently able to connect to surrounding APs by installing 
Ralink proprietary drivers as outlined here 
(http://geekniggle.blogspot.com/2012/07/cisco-linksys-ae3000-wifi-usb-dongle.html). 
Ifconfig and iwconfig both recognize the device using the interface ra0. 
Unfortunately, the "iw" tool is having some issues. One machine running 
Lucid Ubuntu 10.04 with the following command "iw dev ra0 info" returns 
"command failed: No such device (-19)". Another machine machine with 
xubuntu on command "iw list" returns "nl80211 not found."

 From what I have read so far, it appears that the current driver may 
not support iw operations. As a result, I looked into installing 
rt2800usb driver that a few other threads appear to have working 
successfully. As stated on wikidevi 
(http://wikidevi.com/wiki/Linksys_AE3000), one of the more recent 
patches appears to support the RT3573 chipset. I tried to install the 
latest developmental release. After rebooting and loading the rt2800usb 
driver, "modprobe rt2800usb", I get dmesg errors like "rt2x00lib: 
disagrees about version of... ieee80211....".

Any suggestions to get the "iw" tool working would be much appreciated.

Thanks!
