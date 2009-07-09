Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost03.isp.att.net ([207.115.11.53]:34555 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbZGITbe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 15:31:34 -0400
Message-ID: <4A5645A3.9000906@lwfinger.net>
Date: Thu, 09 Jul 2009 14:31:47 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: p54usb - problems with "no probe,response from AP ..."
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian,

I have not gotten very far with the problem in the subject; however, I
have a few things to report:

I got a dump of the TX queues when the disassociation event came
through. All were normal.

I tested with 2.6.31-rc2 from Linus's tree. It does _NOT_ have the
problem, thus it is something that was introduced in the process of
splitting p54common.{ch} into the component parts.

In comparing the code, I see that the variable 'cached_beacon' was
eliminated and the code that handles beacons was changed. When I made
the following change, the "no probe response" message went away - the
interface just hangs:

Index: wireless-testing/drivers/net/wireless/p54/txrx.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/p54/txrx.c
+++ wireless-testing/drivers/net/wireless/p54/txrx.c
@@ -386,7 +386,8 @@ static void p54_rx_frame_sent(struct p54
                        priv->beacon_req_id = cpu_to_le32(0);

                dev_kfree_skb_any(entry);
-               return ;
+               p54_wake_queues(priv);
+               return;
        }

        /*


Any thoughts?

Larry
