Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35693 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbaA0WWY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 17:22:24 -0500
Message-ID: <1390861337.4251.12.camel@jlt4.sipsolutions.net> (sfid-20140127_232228_083811_DA696A74)
Subject: Re: [ath9k-devel] [BUG] Atheros AR7010+AR9287: Scheduling while
 atomic: ksoftirqd/0/3/0x00000302
From: Johannes Berg <johannes@sipsolutions.net>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: mail@fuerstflorian.de, ath9k-devel@lists.ath9k.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 27 Jan 2014 23:22:17 +0100
In-Reply-To: <52E6AD5C.3020005@rempel-privat.de> (sfid-20140127_200308_000982_3276CE71)
References: <trinity-b8018ef9-8037-4688-a363-2deb3aed68fc-1390501815918@3capp-1and1-bs02>
	 <52E1712B.70202@rempel-privat.de>, <52E191B3.2070601@meshcoding.com>
	, <trinity-14f555a0-3945-448b-a908-b12f1cb532e3-1390546291559@3capp-1and1-bs03>
	 <trinity-c1a620e7-f7e8-4bb0-b583-b36b6fa6bfd8-1390546555391@3capp-1and1-bs03>
	 <52E6AD5C.3020005@rempel-privat.de> (sfid-20140127_200308_000982_3276CE71)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-27 at 20:02 +0100, Oleksij Rempel wrote:
> Hi Johannes,
> 
> i found this bug report with your response:
> https://bugzilla.redhat.com/show_bug.cgi?id=990955
> "I don't think adding a workqueue is a good idea because that would
> significantly delay the calls in many situations."
> 
> The problem on ath9k_htc

I don't care about ath9k_htc much, maybe it should just have a work item
for that. I don't like it in mac80211 though, since chips that want to
react quickly should be able to.

johannes

