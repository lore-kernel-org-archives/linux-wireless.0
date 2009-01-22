Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail37.messagelabs.com ([216.82.241.83]:47250 "EHLO
	mail37.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbZAVW05 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 17:26:57 -0500
From: "Gordon, Charles" <Charles.Gordon@digi.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 22 Jan 2009 16:26:53 -0600
Subject: RE: Question on tx field of struct ieee80211_ops
Message-ID: <8DCC153EAFE67A4B990A840E829F704B010A451E5DEF@mtk-sms-exch01.digi.com> (sfid-20090122_232702_425061_00BB0D85)
References: <8DCC153EAFE67A4B990A840E829F704B010A451E5DE9@mtk-sms-exch01.digi.com>
In-Reply-To: <8DCC153EAFE67A4B990A840E829F704B010A451E5DE9@mtk-sms-exch01.digi.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A follow up question on this is if my transmit routine does not have its own queue and the H/W can only transmit 1 packet at a time, should the transmit routine call ieee80211_stop_queue() when it starts the transmit procedure, and then call ieee80211_wake_queue() when the hardware indicates it has finished transmitting the packet.


-----Original Message-----
From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Gordon, Charles
Sent: Thursday, January 22, 2009 4:53 PM
To: linux-wireless@vger.kernel.org
Subject: Question on tx field of struct ieee80211_ops

I'm writing a wireless driver that will use the mac80211 API.  My hardware = allows me to send one packet at a time.  The driver is suppose to set the t= x field (among others) in the struct ieee80211_ops argument passed to ieee8= 0211_alloc_hw().  The tx field should be loaded with a pointer to a low lev= el transmit routine.  However, it's not clear from the documentation if thi= s routine should maintain a packet queue or not.  Is it okay for the low le= vel transmit routine to only allow one packet to be transmitted at a time, = or should it maintain a queue of tx packets?  It seems like the mac80211 AP= I is already maintaining a queue, so I'm not sure that the low level driver=  should maintain a second one.

Thanks for any information you can provide.

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
