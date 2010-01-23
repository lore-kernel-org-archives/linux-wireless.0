Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f190.google.com ([209.85.222.190]:43358 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab0AWRUU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 12:20:20 -0500
Received: by pzk28 with SMTP id 28so795922pzk.4
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2010 09:20:19 -0800 (PST)
Message-ID: <4B5B2FCF.2000005@lwfinger.net>
Date: Sat, 23 Jan 2010 11:20:15 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: kecsa@kutfo.hit.bme.hu
CC: linux-wireless@vger.kernel.org
Subject: Re: hwtkip hangs on b43
References: <Pine.LNX.4.44.1001230942190.16120-100000@kutfo.hit.bme.hu>
In-Reply-To: <Pine.LNX.4.44.1001230942190.16120-100000@kutfo.hit.bme.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/23/2010 02:46 AM, kecsa@kutfo.hit.bme.hu wrote:
> Hi,
>
> when I load b43 with hwtkip=1 system hangs after
> ' b43-phy0 debug: Using hardware based encryption for keyidx: 0, mac:...'
> throwing the below BUG.
>
> This is a non-SMP non-preemtive kernel.  It looks like we are entering
> b43_op_update_tkip_key() already holding the wl->mutex. We lock mutex in
> b43_interrupt_thread_handler().
>
> This problem is present in stable and also in compat-wireless-2010-01-22
> shapshot if I haven't missed something. As a quick and dirty fix I have
> removed wl->mutex lock/unlock from b43_op_update_tkip_key(). Box survived
> one day (until now) and a ~3GB file transfer over WLAN using hwtkip in
> this way.

Your analysis seem to be correct. I tested with the following patch, which tests 
to see if the mutex is locked on entry. If not, it logs a message, locks the 
mutex and sets a flag to indicate that the mutex should be unlocked on exit. 
This patch is not SMP-safe, but is merely for testing. The printk statement has 
not triggered after about 1 hour of testing. I'll give it a bit more testing 
before a final patch is submitted.

Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c
+++ wireless-testing/drivers/net/wireless/b43/main.c
@@ -850,11 +850,16 @@ static void b43_op_update_tkip_key(struc
  	struct b43_wl *wl = hw_to_b43_wl(hw);
  	struct b43_wldev *dev;
  	int index = keyconf->hw_key_idx;
+	bool locked_here = 0;

  	if (B43_WARN_ON(!modparam_hwtkip))
  		return;

-	mutex_lock(&wl->mutex);
+	if (!mutex_is_locked(&wl->mutex)) {
+		printk(KERN_DEBUG "b43: mutex not locked in %s\n", __func__);
+		mutex_lock(&wl->mutex);
+		locked_here = 1;
+	}

  	dev = wl->current_dev;
  	if (!dev || b43_status(dev) < B43_STAT_INITIALIZED)
@@ -866,7 +871,8 @@ static void b43_op_update_tkip_key(struc
  	keymac_write(dev, index, addr);

  out_unlock:
-	mutex_unlock(&wl->mutex);
+	if (locked_here)
+		mutex_unlock(&wl->mutex);
  }

  static void do_key_write(struct b43_wldev *dev,

==================================================


Larry


