Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:47347 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216AbXIXSvn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 14:51:43 -0400
Received: by py-out-1112.google.com with SMTP id u77so3074439pyb
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2007 11:51:42 -0700 (PDT)
Message-ID: <43e72e890709241151q100047d2r1ab6907ad78801f3@mail.gmail.com>
Date: Mon, 24 Sep 2007 14:51:42 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 1/2 try 2] Net: ath5k, split hw into hw, phy and initvals
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com, "Christoph Hellwig" <hch@infradead.org>
In-Reply-To: <46F8051C.8030301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <3175698652466923884@pripojeni.net>
	 <43e72e890709241024pd364c31k4a41c030f192cf0d@mail.gmail.com>
	 <46F8051C.8030301@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/24/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 09/24/2007 07:24 PM, Luis R. Rodriguez wrote:
> > * #if 0's need to go, lets just remove this code instead.
>
> Which code do you mean exactly,

These hunks:

+#if 0
 /*
 * Get power mode (sleep state)
 * TODO:Remove ?
@@ -1385,7 +1148,7 @@ ath5k_hw_get_power_mode(struct ath_hw *hal)
       AR5K_TRACE;
       return hal->ah_power_mode;
 }
-
+#endif

 /***********************\
  DMA Related Functions
@@ -1816,6 +1579,7 @@ enum ath5k_int ath5k_hw_set_intr(struct ath_hw
*hal, enum ath5k_int new_mask)
       return old_mask;
 }

+#if 0
 /*
 * Enable HW radar detection
 */
@@ -1858,7 +1622,7 @@ ath5k_hw_radar_alert(struct ath_hw *hal, bool enable)
       /*Re-enable interrupts*/
       ath5k_hw_reg_write(hal, AR5K_IER_ENABLE, AR5K_IER);
 }
-

> there are also parts that might be needed in the future?

Then we can add then in the future. We can also remove turbo for this
same reason, I don't see us introducing it for a while. I should have
just removed turbo with my 'internalizing turbo' as its useless code
right now. But can patch work can be sent in later though. Mind you
madwifi-old-openhal will still have all this code we're not using
right now. So we'll always be able to pull from there.

  Luis
