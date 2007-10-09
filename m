Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38100 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbXJIJPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 05:15:07 -0400
Subject: Re: wext 64-bit: network manager and wpa_supplicant
From: Johannes Berg <johannes@sipsolutions.net>
To: jt@hpl.hp.com
Cc: Jouni Malinen <j@w1.fi>, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070926235135.GA16051@bougret.hpl.hp.com>
References: <1190292526.18521.52.camel@johannes.berg>
	 <20070920165545.GA29452@bougret.hpl.hp.com>
	 <1190307669.18521.94.camel@johannes.berg>
	 <20070920205602.GA15373@bougret.hpl.hp.com>
	 <1190385414.18521.148.camel@johannes.berg>
	 <20070926235135.GA16051@bougret.hpl.hp.com>
Content-Type: text/plain
Date: Tue, 09 Oct 2007 11:15:16 +0200
Message-Id: <1191921316.4013.5.camel@johannes.berg> (sfid-20071009_101511_275234_0CEF346F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-09-26 at 16:51 -0700, Jean Tourrilhes wrote:

> 	The patch I sent to Jouni was not a wpa_supplicant, but the
> Wireless Tools patch. The complete fix is across multiple Wireless
> Tools versions, and mixed with other stuff, this patch highlight
> clearly the changes.
> 	The patch probably does not have enough context to figure out
> everything, but at least point in the right direction. It's
> documentated, but feel free to ask questions. I also have tests
> vectors that you can use on i386.

I give up. I don't understand this structure packing at all nor do I
really want to. All the "cmd implies which event structure to use" and
"iw_point is defined as {pointer, length, flags} but used as {length,
flags}"... If there were at least proper structures defined :(

> 	I personally don't like much the parser used in
> wpa_supplicant, and it's somewhat different from my code. You will
> find it in those two functions :

If I were to venture a guess I'd say that Jouni would accept a (sane)
replacement if you were to license it under dual BSD/GPL as the rest of
wpa_supplicant/hostapd.

Could you try wpa_supplicant with kernel patch below on your 32-bit
machine? I think this should make the problem show up on 32-bit
machines. Not having a 64-bit machine needn't stop you from fixing the
alignment problems :) I can then verify that it works and didn't break
64/64 setups if you want.

johannes

---
 include/linux/wireless.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- linux-2.6-git.orig/include/linux/wireless.h	2007-10-08 14:21:47.119641377 +0200
+++ linux-2.6-git/include/linux/wireless.h	2007-10-08 14:23:17.136641377 +0200
@@ -664,7 +664,10 @@ struct	iw_param
  */
 struct	iw_point
 {
-  void __user	*pointer;	/* Pointer to the data  (in user space) */
+  union {
+	void __user	*pointer;	/* Pointer to the data  (in user space) */
+	u64 on_64_bit_machines_the_pointer_is_64bits;
+  };
   __u16		length;		/* number of fields or size in bytes */
   __u16		flags;		/* Optional params */
 };


