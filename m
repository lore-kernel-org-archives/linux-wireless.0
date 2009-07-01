Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from will39.synserver.de ([212.40.172.10]:39705 "EHLO willies.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbZGANmy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 09:42:54 -0400
Received: from nat-extern.rrze.uni-erlangen.de ([192.44.85.23] helo=jan.bude)
	by willies.info with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <jan@willies.info>)
	id 1MLzU0-0001ST-5I
	for linux-wireless@vger.kernel.org; Wed, 01 Jul 2009 15:04:16 +0200
Message-ID: <4A4B5EC8.8060804@willies.info>
Date: Wed, 01 Jul 2009 15:04:08 +0200
From: Jan Willies <jan@willies.info>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: 4965AGN loses connection on Custom wireless event
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello list,

I have a strange problem with an EAP-Network here. I can associate just 
fine, but approx 1 min after the _initial_ connection completed the 
network hangs. Though all the tools say I'm still connected (nm-applet, 
iwconfig) I can't ping anything. I have to re-new the connection with 
nm-applet and after that it works again (and longer!).

1. boot notebook and associate with wifi
2. wait 1 min -> hang
3. re-establish connection with nm-applet
4. after that it never hangs again (mostly)

You can find the log here: http://jan.willies.info/wpa_supplicant.log

Dan Williams says the interesting line is 1242720593.722277: "the driver 
sends an association event *after* it's completed association, which the 
supplicant interprets as a restart of the authentication process".

This is a Thinkpad X300 with Fedora 11 (iwlagn-1.3.27kds and 
wpa_supplicant-0.6.8)


regards,

   - jan

