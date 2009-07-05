Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost02.isp.att.net ([204.127.217.102]:59157 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbZGERtp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jul 2009 13:49:45 -0400
Message-ID: <4A50E7C5.4040309@lwfinger.net>
Date: Sun, 05 Jul 2009 12:49:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [WIP] p54: deal with allocation failures in rx path
References: <200907040053.05654.chunkeey@web.de> <4A4FB3F2.5050405@lwfinger.net> <4A4FC61A.30004@lwfinger.net> <200907051559.32958.chunkeey@web.de>
In-Reply-To: <200907051559.32958.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian,

I changed the section in p54_tx_qos_accounting_free() to be the following:

@@ -223,7 +235,10 @@ static void p54_tx_qos_accounting_free(s
                struct p54_hdr *hdr = (void *) skb->data;
                struct p54_tx_data *data = (void *) hdr->data;

-               priv->tx_stats[data->hw_queue].len--;
+               if (priv->tx_stats[data->hw_queue].len)
+                       priv->tx_stats[data->hw_queue].len--;
+               else
+                       dump_stack();
        }
        p54_wake_queues(priv);
 }

In a 1 hour period running a 'make ARCH=i386 -j6' with the kernel
sources on an NFS mounted volume, I got the following sequence of
"failures":

a. dump_stack() with call from p54_find_and_unlock_skb()
b. dump_stack() with call from p54_find_and_unlock_skb()
c. disassociation error
d. dump_stack() with call from p54_find_and_unlock_skb()
e. dump_stack() with call from p54_find_and_unlock_skb()
f. dump_stack() with call from p54_find_and_unlock_skb()
g. disassociation error
h. disassociation error
i. disassociation error
j. disassociation error
k. dump_stack() with call from p54_find_and_unlock_skb()
l. disassociation error
m. disassociation error

When the dump_stack() occurs, the interface keeps going as long as the
queue len never goes negative. With the disassociation error, the
device must be powered cycled by unplugging and replugging it. The
driver does not need to be reloaded.

If I run the kernel make with -j1 rather than -j6, the builds have
always completed. Neither of the errors show up.

A "paper over the problem" workaround for the queue len < 0 would be

-               priv->tx_stats[data->hw_queue].len--;
+               if (priv->tx_stats[data->hw_queue].len)
+                       priv->tx_stats[data->hw_queue].len--;

but it doesn't properly fix the problem.

How sure are you of the locking? It seems that the more threads that
I'm using, the more likely that it is to happen. Similarly, the
disassociation errors could be overloading the firmware by adding too
many entries. Of course, it could result from a firmware error when
the device is driven hard.

I've only given it one trial, but p54usb only survived for 24 minutes
running my other torture test with repeating tcpperf in one terminal
and a flood ping in  a second. This one got the disassociation error
and also a "failure to remove key" (error code -95) and two "failed to
uodate LEDs" (error code -12).
