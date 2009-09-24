Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:59011 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbZIXNnU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 09:43:20 -0400
Date: Thu, 24 Sep 2009 15:02:31 +0200
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: rfkill hard state after booting
Message-ID: <20090924130231.GU21590@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: Norbert Preining <preining@logic.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

(please cc)

I recently (on a flight) I found out that when I boot with the hard-switch
activated, so turning off all wireless activity on my laptop, the state
is not correctly announced in /dev/rfkill (reading it with rfkill command,
or my own gnome applet). All the devices seem to be in normal state but
one.

Here some outputs:
$ cd /sys/class/rfkill
$ ls
rfkill0@  rfkill1@  rfkill2@  rfkill3@	rfkill4@  rfkill5@
$ cat rfkill?/name
sony-wifi
sony-bluetooth
sony-wwan
hso-0
hci0
phy0
$

and the three sony-* are the ones for actually turning on/off the devices,
but they showed all soft 0 hard 0 at initial startup. Only phy0 (AFAIR)
had hard 1.

After turning off and on again the hard-switch the events were right.

That is all with 2.6.31.
driver iwlagn, Detected Intel Wireless WiFi Link 5100AGN REV=0x54

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
LIMERIGG (vb.)
To jar one's leg as the result of the disappearance of a stair which
isn't there in the darkness.
			--- Douglas Adams, The Meaning of Liff
