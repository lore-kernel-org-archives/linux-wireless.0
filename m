Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665AbaI2Sxq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 14:53:46 -0400
Message-ID: <1412016823.4540.4.camel@dcbw.local> (sfid-20140929_205357_242255_B7F9B9ED)
Subject: Re: how can we fast roaming between multi-aps
From: Dan Williams <dcbw@redhat.com>
To: jammy <benxuelan0402@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Date: Mon, 29 Sep 2014 13:53:43 -0500
In-Reply-To: <450E9BCC-651A-4ECF-8185-FCF5E7FD32A9@gmail.com>
References: <509C5E93-4D6C-4CCE-A4F6-BA1CEC80AB98@gmail.com>
	 <CAA2SeNKdOBTPnkz2y=WUFqa1sSUmxeMwDCHaT50TwL0O0uJfgQ@mail.gmail.com>
	 <00852C2A-209F-48A8-9F46-2F2520CEF7EE@gmail.com>
	 <1411742131.27290.1.camel@dcbw.local>
	 <450E9BCC-651A-4ECF-8185-FCF5E7FD32A9@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2014-09-27 at 16:18 +0800, jammy wrote:
> Hi DAN，
> 1，Are all the SSIDs the same?
> A：yes，SSIDs are same.
> 2，What kind of authentication?  WPA Enterprise/802.1x?  What EAP methods?
> A：there are no authentication，and no EAP methods
> 3，Is pre-authentication enabled on the network and in the client?
> A：how to enable pre-authentication？My linux kernel is build by OpenWRT.
> 4，Is background scanning enabled in wpa_supplicant, and if so what is the interval?
> A：How to enable the background scanning in wpa_supplicant？

Given your answers, I think the problem is that background scanning is
not enabled in the supplicant.  The reason it's necessary for better
roaming is that when the signal from your current AP becomes weak, the
supplicant needs to know what AP to roam *to*.  It cannot do that unless
it has an up-to-date picture of the network, and what other APs it can
see.

Background scanning will initiate a scan when the current signal drops
below a certain threshold, so that when the current AP becomes unusable,
the supplicant can immediately switch to a better AP without delay.

If background scanning is not enabled, when the current AP goes out of
range the supplicant has to run a scan *after* it has disconnected,
which can take a few seconds.  That is likely the source of your issue.

In the supplicant configuration file, in the network block for your
SSID, put something like:

bgscan="simple:30:-45:300"

Dan

