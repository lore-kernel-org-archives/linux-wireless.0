Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:41973 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760010AbYFXRKE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 13:10:04 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KBC1q-0001Yg-KR
	for linux-wireless@vger.kernel.org; Tue, 24 Jun 2008 17:10:02 +0000
Received: from alille-153-1-110-58.w90-1.abo.wanadoo.fr ([90.1.105.58])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2008 17:10:02 +0000
Received: from fabien by alille-153-1-110-58.w90-1.abo.wanadoo.fr with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2008 17:10:02 +0000
To: linux-wireless@vger.kernel.org
From: Fabien Crespel <fabien@crespel.net>
Subject: Re: [PATCH 04/13] rfkill: add parameter to disable radios by   default
Date: Tue, 24 Jun 2008 19:06:00 +0200
Message-ID: <g3r9hn$av5$1@ger.gmane.org> (sfid-20080624_191026_092891_5130FBAB)
References: <1214252588-30723-1-git-send-email-hmh@hmh.eng.br>	<1214252588-30723-5-git-send-email-hmh@hmh.eng.br> <g3quvb$8sa$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
In-Reply-To: <g3quvb$8sa$1@ger.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dmitry Baryshkov wrote:
> 
> Why not add the possibility for each rfkill-enabled radio to supply it's 
> default state?
> 

Indeed, I think it would be better to let the driver choose the default state 
(initialization) instead of forcing it when registering. This would allow drivers 
to restore the device state after a reboot or shutdown (provided the firmware 
stores it, which is the case at least on my ASUS F3JC laptop).

- Fabien.

