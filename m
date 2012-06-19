Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-forward2.uio.no ([129.240.10.71]:48936 "EHLO
	mail-forward2.uio.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab2FSIgQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 04:36:16 -0400
Received: from exim by mail-out2.uio.no with local-bsmtp (Exim 4.75)
	(envelope-from <Jon.Wikne@cern.ch>)
	id 1SgtQP-0002xL-HF
	for linux-wireless@vger.kernel.org; Tue, 19 Jun 2012 10:04:33 +0200
Received: from mail-mx3.uio.no ([129.240.10.44])
	by mail-out2.uio.no with esmtp (Exim 4.75)
	(envelope-from <Jon.Wikne@cern.ch>)
	id 1SgtQP-0002xI-GP
	for linux-wireless@vger.kernel.org; Tue, 19 Jun 2012 10:04:33 +0200
Received: from cheetah.uio.no ([129.240.84.23])
	by mail-mx3.uio.no with esmtp  (Exim 4.76)
	(envelope-from <Jon.Wikne@cern.ch>)
	id 1SgtQO-0005VF-WF
	for linux-wireless@vger.kernel.org; Tue, 19 Jun 2012 10:04:33 +0200
Message-ID: <4FE03291.5030202@cern.ch> (sfid-20120619_103623_225076_427B32F6)
Date: Tue, 19 Jun 2012 10:04:33 +0200
From: Jon Wikne <Jon.Wikne@cern.ch>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: wikne@cheetah.uio.no
Subject: Mysterious hangs - cfg80211 - ath9k
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi List,

I am experiencing a puzzling problem with WLAN on a Toshiba Qosmio
F750 laptop, running CERN SLC 5.8 (mostly identical to RHEL 5.8),
but with kernel 2.6.39.4. (The kernel that came with the distro did
not work properly with WLAN on this machine at all.)

What happens is that the WLAN comes up flawlessly, and works well
until it suddenly hangs. This happens when (or seconds after) I see
an entry like the following in the log:

Jun 18 19:04:42 redcat kernel: cfg80211: Calling CRDA to update world 
regulatory domain

I do not understand why cfg80211 does this long after the connection
has been established. If I understand correctly, this "regulatory
domain" business only makes sense when the WLAN interface is started.

Subsequent DHCP requests are issued, but never answered:

Jun 18 19:23:38 redcat dhclient: DHCPREQUEST on wlan0 to 137.138.16.6 
port 67 (xid=0x63998557)
Jun 18 19:24:16 redcat last message repeated 3 times
Jun 18 19:25:30 redcat last message repeated 6 times
.....
Jun 18 19:50:10 redcat dhclient: DHCPREQUEST on wlan0 to 255.255.255.255 
port 67 (xid=0x63998557)
Jun 18 19:50:55 redcat last message repeated 3 times
.....
Jun 18 19:58:41 redcat dhclient: No DHCPOFFERS received.

I interpret this as something has (effectively) been turned off,
but that the drivers do not realize this.

Restarting WLAN when the problem has occurred is simple:

root@redcat 97 # /sbin/ifdown wlan0
root@redcat 98 # /sbin/ifup wlan0

What puzzles me even more is that cfg80211 seems to be activated
and mess up things at highly irregular intervals, ranging from
a few minutes to many hours:

root@redcat 105 # tail -2000l /var/log/messages | grep cfg80211
Jun 17 20:28:51 redcat kernel: cfg80211: Calling CRDA to update world 
regulatory domain
Jun 17 23:09:37 redcat kernel: cfg80211: Calling CRDA to update world 
regulatory domain
Jun 17 23:36:01 redcat kernel: cfg80211: Calling CRDA to update world 
regulatory domain
Jun 18 09:27:59 redcat kernel: cfg80211: Calling CRDA to update world 
regulatory domain
Jun 18 11:57:48 redcat kernel: cfg80211: Calling CRDA to update world 
regulatory domain
Jun 18 18:42:00 redcat kernel: cfg80211: Calling CRDA to update world 
regulatory domain
Jun 18 18:46:49 redcat kernel: cfg80211: Calling CRDA to update world 
regulatory domain
Jun 18 19:04:42 redcat kernel: cfg80211: Calling CRDA to update world 
regulatory domain
Jun 18 22:40:42 redcat kernel: cfg80211: Calling CRDA to update world 
regulatory domain

At the time of writing this (Tue 19 Jun 2012 09:27:54 CEST) the WLAN
has not stopped since the last entry in the above. What on earth is
governing the timing in this?

Some relevant info on the laptop:

root@redcat 108 # lspci
.....
03:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless 
Network Adapter (PCI-Express) (rev 01)
.....

root@redcat 109 # lsmod
Module                  Size  Used by
.....
ath9k                  89934  0
mac80211              160999  1 ath9k
ath9k_common            3051  1 ath9k
.....
ath9k_hw              291258  2 ath9k,ath9k_common
ath                    15289  2 ath9k,ath9k_hw
.....
cfg80211              141299  3 ath9k,mac80211,ath

Any ideas will be greatly appreciated. I will be happy to test
patches. Please CC me at jon.wikne@cern.ch since I am not on
the list.


Regards,
-- Jon Wikne
