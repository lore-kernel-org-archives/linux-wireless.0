Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59261 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab1ANO5v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 09:57:51 -0500
Subject: RE: cfg80211 rfkill interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <2EFC2EC4C7011444989031FE55348CDA9549080E26@SJEXCHCCR02.corp.ad.broadcom.com>
References: <400C43189542CE41BC0A5B252FC90136952F059529@SJEXCHCCR02.corp.ad.broadcom.com>
	 <1294688709.3583.25.camel@jlt3.sipsolutions.net>
	 <2EFC2EC4C7011444989031FE55348CDA9549080E26@SJEXCHCCR02.corp.ad.broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Jan 2011 15:57:48 +0100
Message-ID: <1295017068.3853.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

