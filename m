Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:59621 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752710AbYLPQzY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 11:55:24 -0500
Message-ID: <4947DD7A.9060700@lwfinger.net> (sfid-20081216_175528_278950_170137C1)
Date: Tue, 16 Dec 2008 10:55:22 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Memory errors from p54usb
References: <49466F56.6060805@lwfinger.net> <200812152051.48349.chunkeey@web.de> <49472BC9.7060406@lwfinger.net> <200812161431.17790.chunkeey@web.de>
In-Reply-To: <200812161431.17790.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> In which mode is p54? ad-hoc / station? is radio_enabled flag cleared?

It is in station mode. I don't know how to get the radio_enabled flag.
> 
> do you see anything else than probe request?
> (because probe requests are marked as "no cancel" and won't be 
> delayed / cancelled).

No, just probes.
> 
> Can you bring back the receiver if you change the mode?
> (e.g station to ad-hoc and then back to station,
>        or ibss to station and bak to ibss again...
> and don't forget to do a ifconfig wlanX up all the time...)

It normally is under the control of NetworkManager, but when I killed NM and
KNM, I got ifup/ifdown control back. When I downed the interface, switched to
Ad-Hoc mode, then back to Managed and gave an ifup command, it came back.

It continued working under the load conditions for about another 2 minutes, then
froze again. Each cycle seem to last less and less time.
> 
> do you see if statistic counters in /sys/kernel/debug/ieee80211/phyX/statistics/
> increase (especially: FCSErros, RTSCount and RTSFailure), or is the
> the noise-level in iwconfig still updated? 

FCSerrorcount is being incremented, and the noise level is being updated as well
as quality and signal.

Larry


