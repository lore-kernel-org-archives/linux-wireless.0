Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ip82-139-117-192.lijbrandt.net ([82.139.117.192]:46035 "EHLO
	salmon.dokterbob.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbZDSURH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 16:17:07 -0400
Received: from ip82-139-117-157.lijbrandt.net (ip82-139-117-157.lijbrandt.net [82.139.117.157])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by salmon.dokterbob.net (Postfix) with ESMTPSA id 40D4164BBE
	for <linux-wireless@vger.kernel.org>; Sun, 19 Apr 2009 22:08:23 +0200 (CEST)
Message-ID: <49EB84D6.5070601@dokterbob.net> (sfid-20090419_221712_902778_EBFF8886)
Date: Sun, 19 Apr 2009 22:08:54 +0200
From: Mathijs de Bruin <drbob@dokterbob.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Bug in wireless-compat due to patch 'cfg80211: do not replace BSS
 structs' usage of ksize
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

a couple of minutes I tried getting wireless-compat to work on my Gentoo 
2.6.28-hardened-r7 kernel. Apparently the cfg80211 module expects there 
to be a 'ksize' symbol which was not there. To be sure I checked that it 
was also unavailable in the 2.6.28.9 vanilla kernel.

After some more looking around it turns out that this is the result of a 
recent patch submitted to the wireless-test tree, in which in fact the 
'ksize' symbol IS exported in mm/sl*b.c.

Indeed, if I revert the file net/wireless/scan.c to before commit 
ad80a7a983e36c6d8f4ae57e4c472deb9cf1391c, I find the wireless-compat 
modules to work perfectly.

I hope I can help you with this information. Nevertheless, I am no 
kernel hacker. I am also not on the list, so please direct any further 
questions to my personal email address.

Kind regards,
Mathijs de Bruin
