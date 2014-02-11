Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:55962 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaBKGdp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Feb 2014 01:33:45 -0500
Received: from localhost (localhost [127.0.0.1])
	by zimbra.real-time.com (Postfix) with ESMTP id 044824E80B7
	for <linux-wireless@vger.kernel.org>; Tue, 11 Feb 2014 00:33:45 -0600 (CST)
Received: from zimbra.real-time.com ([127.0.0.1])
	by localhost (zimbra.real-time.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g3qOthRY68rU for <linux-wireless@vger.kernel.org>;
	Tue, 11 Feb 2014 00:33:44 -0600 (CST)
Received: from esk.lan (CPE-121-217-201-73.lnse3.cht.bigpond.net.au [121.217.201.73])
	by zimbra.real-time.com (Postfix) with ESMTPSA id 435B2452C28
	for <linux-wireless@vger.kernel.org>; Tue, 11 Feb 2014 00:33:43 -0600 (CST)
Date: Tue, 11 Feb 2014 17:33:29 +1100
From: James Cameron <quozl@laptop.org>
To: linux-wireless@vger.kernel.org
Subject: libertas: probe responses with zero length SSID cause scan result
 loss
Message-ID: <20140211063329.GO5487@us.netrek.org> (sfid-20140211_073348_895055_E1BA8EBF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

G'day,

I'd appreciate a sanity check, as I'm not sure what I am doing.

We saw for years that scan results for an OLPC XO-1 laptop would be
unreliable in large groups.  APs would not be easily found.  We
presumed other causes until recently.

Using monitor mode on another computer, and "iwlist eth0 scan" on the
XO-1, I found probe responses from an AP, and ACKs from the host to
the AP, but the output omitted the AP.

Further, the AP would be missing if there was a probe response from
another XO-1 running mesh, and an ACK from the host to that XO-1.

Enabling debugging, lbs_ret_scan was reporting "scan response: invalid
IE fmt" because the probe response had a zero length SSID IE.

Is a zero length SSID IE valid?  (We can't change the wireless firmware
at this stage.)

Background data and dmesg fragments:
http://dev.laptop.org/ticket/12757

Patch being tested (lacks signoff and any review):
http://dev.laptop.org/git/olpc-kernel/commit/?h=x86-3.3&id=e98f01abce522fb70a3852b23b62205244ef69b8

-- 
James Cameron
http://quozl.linux.org.au/
