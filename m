Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost06.isp.att.net ([207.115.11.56]:41069 "EHLO
	fmailhost06.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbZFBX0w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 19:26:52 -0400
Message-ID: <4A25B53C.3040101@lwfinger.net>
Date: Tue, 02 Jun 2009 18:26:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: [RFT 3/3] b43/legacy: port to cfg80211 rfkill
References: <20090602111027.460530075@sipsolutions.net>	 <200906021641.11019.mb@bu3sch.de> <1243973079.6461.3.camel@johannes.local>	 <200906022208.46288.mb@bu3sch.de> <1243973487.7176.1.camel@johannes.local>	 <4A2592C5.10803@lwfinger.net> <1243976470.7176.12.camel@johannes.local>
In-Reply-To: <1243976470.7176.12.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> 
> Thanks for testing. This doesn't happen on a current wireless-testing
> tree I hope? I'll look more into it tomorrow, need some sleep now.

Unfortunately it does happen on the current w-t tree.

The oops is the statement BUG_ON(!list_empty(&work->entry)); at
kernel/workqueue.c:192.

The following hack lets the computer boot with the BCM43XX device
working, but obviously the radio kill switch does not work.

Larry

Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c
+++ wireless-testing/drivers/net/wireless/b43/main.c
@@ -4330,7 +4330,7 @@ static int b43_op_start(struct ieee80211
        }

        /* XXX: only do if device doesn't support rfkill irq */
-       wiphy_rfkill_start_polling(hw->wiphy);
+//     wiphy_rfkill_start_polling(hw->wiphy);

  out_mutex_unlock:
        mutex_unlock(&wl->mutex);


