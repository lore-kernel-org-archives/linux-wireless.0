Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:52695 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753785AbXDNVAa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Apr 2007 17:00:30 -0400
Message-ID: <46214155.20106@lwfinger.net>
Date: Sat, 14 Apr 2007 16:02:13 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@berlios.de,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/4] mac80211 and drivers: Improve wireless statistics
References: <46211955.4080006@lwfinger.net> <1ba2fa240704141300w2ec2beabm9cd1376c1b9ef2bb@mail.gmail.com>
In-Reply-To: <1ba2fa240704141300w2ec2beabm9cd1376c1b9ef2bb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler wrote:
> Those are really bad names.
> __signal__ is not meaning a value __signal level__ or __signal
> strength__ means value
> __level__ is too general to describes anything
> RSSI on other hand is well defined. Maybe it's too hw/vendor dependent
> to use in stack
> but at least its names says what it is.
> Quality should be a relative number depends on maxim
> I don't think this renaming make things clearer
> Tomas

Perhaps my names are bad; however, the existing system is broken. With it, passing the rssi value 
and the signal strength from bcm43xx-mac80211 results the following output from iwconfig: "Link 
Quality=216/146  Signal level=-197 dBm  Noise level=-63 dBm". In bcm43xx-softmac, the code in the 
driver is identical and results in "Link Quality=90/100  Signal level=-36 dBm  Noise level=-69 dBm".

When I proposed a patch to fix mac80211, Michael Wu NACKed it and requested the name changes I 
propose here. I don't care what names things get, but it needs to be fixed!

Larry
