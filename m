Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.danego.net ([195.246.116.61]:55293 "EHLO smtp.danego.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbbJ3Qo1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 12:44:27 -0400
Received: from POBOX.postoffice.danego.net ([195.246.116.58])
        by smtp.danego.net (IceWarp 10.4.0) with ESMTP (SSL) id RAK55910
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2015 17:32:10 +0100
From: =?iso-8859-1?Q?Robert_Deli=EBn?= <robert@delien.nl>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath6kl reverting to US region after starting AP mode
Date: Fri, 30 Oct 2015 16:32:21 +0000
Message-ID: <6EA3E0BCC03CC34B89B01BD57ECBC718B1785A9F@POBOX.postoffice.danego.net> (sfid-20151030_174431_044404_65DBE75A)
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Experts,

I am experiencing a problem with an ath6kl wireless NIC on a Digi connectcard wi-i.mx28. After the Kernel driver is loaded, cfg80211 is calling CRDA to update world regulatory domain. Immediately after that, it calls again for country US. I'm not sure why, but I can live with that.

A little later, my startup script sets the CRDA world regulatory domain to NL and this is accepted. Again a little later hostapd is started, properly configured for region NL, but while AP mode is enabled, the world regulatory domain reverts back the US again. After that I can put it back to NL again, but that doesn't seem appropriate because that's too late to use specific NL channels for my AP.

For some time I have though that it was following other APs in the building, broadcasting regulatory domain US, but that doesn't seem to be the case. I have tried a number of different ath6kl firmware versions, but the problem remains. So I have traced the source code a little and it seems like the firmware is sending a WMI_REGDOMAIN_EVENTID with US to the driver. Is that how it works?

Is there any way to avoid this switching?

Thanks a lot in advance for any information on this!

Robert.