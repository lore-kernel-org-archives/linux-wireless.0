Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1164 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab1ANPHP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 10:07:15 -0500
From: "Arend Van Spriel" <arend@broadcom.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 14 Jan 2011 07:05:53 -0800
Subject: RE: cfg80211 rfkill interface
Message-ID: <400C43189542CE41BC0A5B252FC90136952F059531@SJEXCHCCR02.corp.ad.broadcom.com>
References: <400C43189542CE41BC0A5B252FC90136952F059529@SJEXCHCCR02.corp.ad.broadcom.com>
 <1294688709.3583.25.camel@jlt3.sipsolutions.net>
 <2EFC2EC4C7011444989031FE55348CDA9549080E26@SJEXCHCCR02.corp.ad.broadcom.com>,<1295017068.3853.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1295017068.3853.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for quick response. I will have to dig in deeper, than.

Gr. AvS
________________________________________
From: Johannes Berg [johannes@sipsolutions.net]
Sent: Friday, January 14, 2011 3:57 PM
To: Arend Van Spriel
Cc: linux-wireless@vger.kernel.org
Subject: RE: cfg80211 rfkill interface

On Fri, 2011-01-14 at 06:54 -0800, Arend Van Spriel wrote:

> Thanks for you thoughts on this. Especially the last remark was reason
> for me to verify several usage scenarios. I ran into a issue with
> unloading the driver module while it was in blocked rfkill state and
> polling was active. Turns out the call to ieee80211_unregister_hw
> takes a loooong time before it returns and dmesg shows message from
> unregister_netdevice which seems related about refcount not being
> zero. This is only observed in this scenario. Any suggestion on how to
> handle this?

No, I can see no reason for this to happen?? rfkill doesn't take a
netdev refcount.

johannes



