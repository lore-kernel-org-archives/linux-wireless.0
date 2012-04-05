Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fep33.mx.upcmail.net ([62.179.121.51]:41302 "EHLO
	fep33.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab2DESlu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2012 14:41:50 -0400
Received: from edge03.upcmail.net ([192.168.13.238])
          by viefep14-int.chello.at
          (InterMail vM.8.01.05.04 201-2260-151-105-20111014) with ESMTP
          id <20120405182408.TBYX8105.viefep14-int.chello.at@edge03.upcmail.net>
          for <linux-wireless@vger.kernel.org>;
          Thu, 5 Apr 2012 20:24:08 +0200
Received: from [192.168.111.10] (mithril.odi.ch [192.168.111.10])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by gandalf.odi.ch (Postfix) with ESMTPSA id 63A4346002D
	for <linux-wireless@vger.kernel.org>; Thu,  5 Apr 2012 20:24:07 +0200 (CEST)
Message-ID: <4F7DE399.4000304@odi.ch> (sfid-20120405_204154_413597_E79227DD)
Date: Thu, 05 Apr 2012 20:25:29 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: 3.3.1 ath9k regression
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am seeing similar symptoms as Michael Leun, using NetworkManager and ath9k 
built-in (not as a module):

Apr  5 20:09:14 mithril NetworkManager[2575]: <info> (wlan0): supplicant 
connection state:
   scanning -> associating
Apr  5 20:09:15 mithril kernel: wlan0: authenticate with xxx (try 1)
Apr  5 20:09:15 mithril kernel: wlan0: authenticate with xxx (try 2)
Apr  5 20:09:15 mithril kernel: wlan0: authenticate with xxx (try 3)
Apr  5 20:09:15 mithril kernel: wlan0: authentication with xxx timed out
Apr  5 20:09:17 mithril NetworkManager[2575]: <warn> (wlan0): link timed out.
Apr  5 20:09:25 mithril NetworkManager[2575]: <info> (wlan0): supplicant 
connection state:
   associating -> disconnected
Apr  5 20:09:25 mithril NetworkManager[2575]: <info> (wlan0): supplicant 
connection state:
   disconnected -> scanning
Apr  5 20:09:25 mithril kernel: ath: Failed to stop TX DMA, queues=0x001!


Reproducible 100% of the time. Reverting 
db6a6a78d8602964c9dfb1d8ce18daefd92da0a7 fixes the problem.

Hope that helps,

Ortwin
