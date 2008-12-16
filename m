Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:54526 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbYLPNbP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 08:31:15 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Memory errors from p54usb
Date: Tue, 16 Dec 2008 14:31:17 +0100
Cc: wireless <linux-wireless@vger.kernel.org>
References: <49466F56.6060805@lwfinger.net> <200812152051.48349.chunkeey@web.de> <49472BC9.7060406@lwfinger.net>
In-Reply-To: <49472BC9.7060406@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812161431.17790.chunkeey@web.de> (sfid-20081216_143118_855281_FB99EFCD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 16 December 2008 05:17:13 Larry Finger wrote:
> 
> No matter how hard I try, I cannot duplicate these results. They may have been a
> fluke, but I do have another problem fr you to ponder.
> 
> If I run the 'ping -f -i 0.2' to my file server in one window, and start a
> kernel compilation with the source on an NFS volume on that same server, p54usb
> will hang. I managed to capture the whole process with kismet running on a third
> computer and have analyzed it with wireshark. I can find the last transmission
> from the server, but no ACK. The next transmission from the p54 is more than 26
> sec later when it sends an 802.11 Probe request. The dmesg log just shows that
> there was a disconnection, and a reconnection attempt.
In which mode is p54? ad-hoc / station? is radio_enabled flag cleared?

do you see anything else than probe request?
(because probe requests are marked as "no cancel" and won't be 
delayed / cancelled).

Can you bring back the receiver if you change the mode?
(e.g station to ad-hoc and then back to station,
       or ibss to station and bak to ibss again...
and don't forget to do a ifconfig wlanX up all the time...)

do you see if statistic counters in /sys/kernel/debug/ieee80211/phyX/statistics/
increase (especially: FCSErros, RTSCount and RTSFailure), or is the
the noise-level in iwconfig still updated? 

> Any idea as to why the receiver would go off-line, but the transmitter is still
> working?
Not really. normally its the other way around and the transmitter is dead.
