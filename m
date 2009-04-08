Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost03.isp.att.net ([207.115.11.53]:33454 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761895AbZDHVHZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 17:07:25 -0400
Message-ID: <49DD11FC.6090506@lwfinger.net> (sfid-20090408_231852_359853_A4476559)
Date: Wed, 08 Apr 2009 16:07:08 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ivan Kuten <ivan.kuten@promwad.com>
CC: "eugene.sobol" <eugene.sobol@promwad.com>,
	linux-wireless@vger.kernel.org, hintak.leung@gmail.com
Subject: Re: rtl8187 diversity
References: <200904081530.51962.eugene.sobol@promwad.com> <49DCE741.7080406@lwfinger.net> <1e0576e9ab550ccec84402b8b0805633@promwad.com>
In-Reply-To: <1e0576e9ab550ccec84402b8b0805633@promwad.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivan Kuten wrote:
> 
> Hello Larry, thanks for comments! Surely Eugene will fix patch issues and 
> resubmit patch inline. Actually in its current stage this patch just show
> an 
> diversity idea and will be cleaned-up for submission with Signed-off-by.
> Currently the question was about correctness of calculation of signal
> quality
> and making decision when switching between antennas should be done. Anyway
> it will be easier to say about this when patch will be inline.
> 
> Btw, USB_DEVICE is already added: http://lkml.org/lkml/2008/11/17/39

I think there is a logic error in the following:

+void sw_antenna_diversity_timer_callback(struct rtl8187_priv *priv)
+{
+    static int tick_without_switch = 0;
+    static int old_value = 0;
+    int average = 0;
+    int i;
+    for ( i = 0; i < VAL_ARRAY_SIZE; ++i)
+    {
+        average += priv->ant_diversity.agc_array[i];
+    }
+    average /= VAL_ARRAY_SIZE;
+    average /= 10; // cut 1 chipher
+    printk("%d->%d\n", old_value, average);
+
+    int sub = average - old_value;
+    if (sub < 0)
+        sub *= -1;
+    if (average > old_value)
+    {
+        priv->ant_diversity.switch_to ^= 1;
+        queue_delayed_work(priv->hw->workqueue, &priv->antenna_work,
+                                    msecs_to_jiffies(ANTENNA_SWITCH_TIMER_PERIOD));
+    }
+    old_value = average;

The AGC value is inversely proportional to the signal strength. I think you need
to select the antenna with the smaller, not the larger, value for the average.

Larry

