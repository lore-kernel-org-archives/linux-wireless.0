Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43641 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965602AbXBOO7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 09:59:50 -0500
Message-Id: <20070215144258.399503000@sipsolutions.net>
References: <20070215144241.847938000@sipsolutions.net>
Date: Thu, 15 Feb 2007 15:42:46 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>
Subject: [PATCH 05/10] wext: clean up
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This cleans up wext.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/wireless/wext-old.c |  302 ++----------------------------------------------
 1 file changed, 17 insertions(+), 285 deletions(-)

--- wireless-dev.orig/net/wireless/wext-old.c	2007-02-15 12:28:35.657940064 +0100
+++ wireless-dev/net/wireless/wext-old.c	2007-02-15 12:28:38.227940064 +0100
@@ -7,79 +7,6 @@
  * (As all part of the Linux kernel, this file is GPL)
  */
 
-/************************** DOCUMENTATION **************************/
-/*
- * API definition :
- * --------------
- * See <linux/wireless.h> for details of the APIs and the rest.
- *
- * History :
- * -------
- *
- * v1 - 5.12.01 - Jean II
- *	o Created this file.
- *
- * v2 - 13.12.01 - Jean II
- *	o Move /proc/net/wireless stuff from net/core/dev.c to here
- *	o Make Wireless Extension IOCTLs go through here
- *	o Added iw_handler handling ;-)
- *	o Added standard ioctl description
- *	o Initial dumb commit strategy based on orinoco.c
- *
- * v3 - 19.12.01 - Jean II
- *	o Make sure we don't go out of standard_ioctl[] in ioctl_standard_call
- *	o Add event dispatcher function
- *	o Add event description
- *	o Propagate events as rtnetlink IFLA_WIRELESS option
- *	o Generate event on selected SET requests
- *
- * v4 - 18.04.02 - Jean II
- *	o Fix stupid off by one in iw_ioctl_description : IW_ESSID_MAX_SIZE + 1
- *
- * v5 - 21.06.02 - Jean II
- *	o Add IW_PRIV_TYPE_ADDR in priv_type_size (+cleanup)
- *	o Reshuffle IW_HEADER_TYPE_XXX to map IW_PRIV_TYPE_XXX changes
- *	o Add IWEVCUSTOM for driver specific event/scanning token
- *	o Turn on WE_STRICT_WRITE by default + kernel warning
- *	o Fix WE_STRICT_WRITE in ioctl_export_private() (32 => iw_num)
- *	o Fix off-by-one in test (extra_size <= IFNAMSIZ)
- *
- * v6 - 9.01.03 - Jean II
- *	o Add common spy support : iw_handler_set_spy(), wireless_spy_update()
- *	o Add enhanced spy support : iw_handler_set_thrspy() and event.
- *	o Add WIRELESS_EXT version display in /proc/net/wireless
- *
- * v6 - 18.06.04 - Jean II
- *	o Change get_spydata() method for added safety
- *	o Remove spy #ifdef, they are always on -> cleaner code
- *	o Allow any size GET request if user specifies length > max
- *		and if request has IW_DESCR_FLAG_NOMAX flag or is SIOCGIWPRIV
- *	o Start migrating get_wireless_stats to struct iw_handler_def
- *	o Add wmb() in iw_handler_set_spy() for non-coherent archs/cpus
- * Based on patch from Pavel Roskin <proski@gnu.org> :
- *	o Fix kernel data leak to user space in private handler handling
- *
- * v7 - 18.3.05 - Jean II
- *	o Remove (struct iw_point *)->pointer from events and streams
- *	o Remove spy_offset from struct iw_handler_def
- *	o Start deprecating dev->get_wireless_stats, output a warning
- *	o If IW_QUAL_DBM is set, show dBm values in /proc/net/wireless
- *	o Don't loose INVALID/DBM flags when clearing UPDATED flags (iwstats)
- *
- * v8 - 17.02.06 - Jean II
- *	o RtNetlink requests support (SET/GET)
- *
- * v8b - 03.08.06 - Herbert Xu
- *	o Fix Wireless Event locking issues.
- *
- * v9 - 14.3.06 - Jean II
- *	o Change length in ESSID and NICK to strlen() instead of strlen()+1
- *	o Make standard_ioctl_num and standard_event_num unsigned
- *	o Remove (struct net_device *)->get_wireless_stats()
- */
-
-/***************************** INCLUDES *****************************/
-
 #include <linux/module.h>
 #include <linux/types.h>		/* off_t */
 #include <linux/netdevice.h>		/* struct ifreq, dev_get_by_name() */
@@ -97,19 +24,6 @@
 
 #include "wext.h"
 
-/**************************** CONSTANTS ****************************/
-
-/* Debugging stuff */
-#undef WE_IOCTL_DEBUG		/* Debug IOCTL API */
-#undef WE_RTNETLINK_DEBUG	/* Debug RtNetlink API */
-#undef WE_EVENT_DEBUG		/* Debug Event dispatcher */
-#undef WE_SPY_DEBUG		/* Debug enhanced spy support */
-
-/* Options */
-//CONFIG_NET_WIRELESS_RTNETLINK	/* Wireless requests over RtNetlink */
-#define WE_EVENT_RTNETLINK	/* Propagate events using RtNetlink */
-#define WE_SET_EVENT		/* Generate an event on some set commands */
-
 /************************* GLOBAL VARIABLES *************************/
 
 /* Size (in bytes) of the various private data types */
@@ -312,12 +226,6 @@ static int ioctl_standard_call(struct ne
 		return -EOPNOTSUPP;
 	descr = &(wext_standard_ioctl[cmd - SIOCIWFIRST]);
 
-#ifdef WE_IOCTL_DEBUG
-	printk(KERN_DEBUG "%s (WE) : Found standard handler for 0x%04X\n",
-	       ifr->ifr_name, cmd);
-	printk(KERN_DEBUG "%s (WE) : Header type : %d, Token type : %d, size : %d, token : %d\n", dev->name, descr->header_type, descr->token_type, descr->token_size, descr->max_tokens);
-#endif	/* WE_IOCTL_DEBUG */
-
 	/* Prepare the call */
 	info.cmd = cmd;
 	info.flags = 0;
@@ -328,12 +236,10 @@ static int ioctl_standard_call(struct ne
 		/* No extra arguments. Trivial to handle */
 		ret = handler(dev, &info, &(iwr->u), NULL);
 
-#ifdef WE_SET_EVENT
 		/* Generate an event to notify listeners of the change */
 		if((descr->flags & IW_DESCR_FLAG_EVENT) &&
 		   ((ret == 0) || (ret == -EIWCOMMIT)))
 			wireless_send_event(dev, cmd, &(iwr->u), NULL);
-#endif	/* WE_SET_EVENT */
 	} else {
 		char *	extra;
 		int	extra_size;
@@ -408,11 +314,6 @@ static int ioctl_standard_call(struct ne
 			}
 		}
 
-#ifdef WE_IOCTL_DEBUG
-		printk(KERN_DEBUG "%s (WE) : Malloc %d bytes\n",
-		       dev->name, extra_size);
-#endif	/* WE_IOCTL_DEBUG */
-
 		/* Create the kernel buffer */
 		/*    kzalloc ensures NULL-termination for essid_compat */
 		extra = kzalloc(extra_size, GFP_KERNEL);
@@ -429,11 +330,6 @@ static int ioctl_standard_call(struct ne
 				kfree(extra);
 				return -EFAULT;
 			}
-#ifdef WE_IOCTL_DEBUG
-			printk(KERN_DEBUG "%s (WE) : Got %d bytes\n",
-			       dev->name,
-			       iwr->u.data.length * descr->token_size);
-#endif	/* WE_IOCTL_DEBUG */
 		}
 
 		/* Call the handler */
@@ -453,15 +349,9 @@ static int ioctl_standard_call(struct ne
 					   iwr->u.data.length *
 					   descr->token_size);
 			if (err)
-				ret =  -EFAULT;				   
-#ifdef WE_IOCTL_DEBUG
-			printk(KERN_DEBUG "%s (WE) : Wrote %d bytes\n",
-			       dev->name,
-			       iwr->u.data.length * descr->token_size);
-#endif	/* WE_IOCTL_DEBUG */
+				ret =  -EFAULT;
 		}
 
-#ifdef WE_SET_EVENT
 		/* Generate an event to notify listeners of the change */
 		if((descr->flags & IW_DESCR_FLAG_EVENT) &&
 		   ((ret == 0) || (ret == -EIWCOMMIT))) {
@@ -473,7 +363,6 @@ static int ioctl_standard_call(struct ne
 				wireless_send_event(dev, cmd, &(iwr->u),
 						    extra);
 		}
-#endif	/* WE_SET_EVENT */
 
 		/* Cleanup - I told you it wasn't that long ;-) */
 		kfree(extra);
@@ -523,16 +412,6 @@ static inline int ioctl_private_call(str
 			break;
 		}
 
-#ifdef WE_IOCTL_DEBUG
-	printk(KERN_DEBUG "%s (WE) : Found private handler for 0x%04X\n",
-	       ifr->ifr_name, cmd);
-	if(descr) {
-		printk(KERN_DEBUG "%s (WE) : Name %s, set %X, get %X\n",
-		       dev->name, descr->name,
-		       descr->set_args, descr->get_args);
-	}
-#endif	/* WE_IOCTL_DEBUG */
-
 	/* Compute the size of the set/get arguments */
 	if(descr != NULL) {
 		if(IW_IS_SET(cmd)) {
@@ -589,11 +468,6 @@ static inline int ioctl_private_call(str
 				return -EFAULT;
 		}
 
-#ifdef WE_IOCTL_DEBUG
-		printk(KERN_DEBUG "%s (WE) : Malloc %d bytes\n",
-		       dev->name, extra_size);
-#endif	/* WE_IOCTL_DEBUG */
-
 		/* Always allocate for max space. Easier, and won't last
 		 * long... */
 		extra = kmalloc(extra_size, GFP_KERNEL);
@@ -609,10 +483,6 @@ static inline int ioctl_private_call(str
 				kfree(extra);
 				return -EFAULT;
 			}
-#ifdef WE_IOCTL_DEBUG
-			printk(KERN_DEBUG "%s (WE) : Got %d elem\n",
-			       dev->name, iwr->u.data.length);
-#endif	/* WE_IOCTL_DEBUG */
 		}
 
 		/* Call the handler */
@@ -631,11 +501,7 @@ static inline int ioctl_private_call(str
 			err = copy_to_user(iwr->u.data.pointer, extra,
 					   extra_size);
 			if (err)
-				ret =  -EFAULT;				   
-#ifdef WE_IOCTL_DEBUG
-			printk(KERN_DEBUG "%s (WE) : Wrote %d elem\n",
-			       dev->name, iwr->u.data.length);
-#endif	/* WE_IOCTL_DEBUG */
+				ret =  -EFAULT;
 		}
 
 		/* Cleanup - I told you it wasn't that long ;-) */
@@ -671,8 +537,7 @@ int wireless_process_ioctl(struct ifreq 
 	/* A bunch of special cases, then the generic case...
 	 * Note that 'cmd' is already filtered in dev_ioctl() with
 	 * (cmd >= SIOCIWFIRST && cmd <= SIOCIWLAST) */
-	switch(cmd) 
-	{
+	switch(cmd) {
 		case SIOCGIWSTATS:
 			/* Get Wireless Stats */
 			return ioctl_standard_call(dev,
@@ -773,22 +638,10 @@ static int rtnetlink_standard_get(struct
 		return -EOPNOTSUPP;
 	descr = &(wext_standard_ioctl[cmd - SIOCIWFIRST]);
 
-#ifdef WE_RTNETLINK_DEBUG
-	printk(KERN_DEBUG "%s (WE.r) : Found standard handler for 0x%04X\n",
-	       dev->name, cmd);
-	printk(KERN_DEBUG "%s (WE.r) : Header type : %d, Token type : %d, size : %d, token : %d\n", dev->name, descr->header_type, descr->token_type, descr->token_size, descr->max_tokens);
-#endif	/* WE_RTNETLINK_DEBUG */
-
 	/* Check if wrqu is complete */
 	hdr_len = event_type_size[descr->header_type];
-	if(request_len < hdr_len) {
-#ifdef WE_RTNETLINK_DEBUG
-		printk(KERN_DEBUG
-		       "%s (WE.r) : Wireless request too short (%d)\n",
-		       dev->name, request_len);
-#endif	/* WE_RTNETLINK_DEBUG */
+	if(request_len < hdr_len)
 		return -EINVAL;
-	}
 
 	/* Prepare the call */
 	info.cmd = cmd;
@@ -832,10 +685,6 @@ static int rtnetlink_standard_get(struct
 			extra_size = (wrqu_point.data.length
 				      * descr->token_size);
 		buffer_size = extra_size + IW_EV_POINT_LEN + IW_EV_POINT_OFF;
-#ifdef WE_RTNETLINK_DEBUG
-		printk(KERN_DEBUG "%s (WE.r) : Malloc %d bytes (%d bytes)\n",
-		       dev->name, extra_size, buffer_size);
-#endif	/* WE_RTNETLINK_DEBUG */
 
 		/* Create the kernel buffer that we will return */
 		buffer = kmalloc(buffer_size, GFP_KERNEL);
@@ -867,10 +716,6 @@ static int rtnetlink_standard_get(struct
 		 * dummy pointer. */
 		memcpy(buffer + IW_EV_POINT_OFF, request, IW_EV_LCP_LEN);
 
-#ifdef WE_RTNETLINK_DEBUG
-		printk(KERN_DEBUG "%s (WE.r) : Reply 0x%04X, hdr_len %d, tokens %d, extra_size %d, buffer_size %d\n", dev->name, cmd, hdr_len, wrqu->data.length, extra_size, buffer_size);
-#endif	/* WE_RTNETLINK_DEBUG */
-
 		/* Check if there is enough buffer up there */
 		if(wrqu_point.data.length < wrqu->data.length)
 			ret = -E2BIG;
@@ -915,25 +760,13 @@ static inline int rtnetlink_standard_set
 		return -EOPNOTSUPP;
 	descr = &(wext_standard_ioctl[cmd - SIOCIWFIRST]);
 
-#ifdef WE_RTNETLINK_DEBUG
-	printk(KERN_DEBUG "%s (WE.r) : Found standard SET handler for 0x%04X\n",
-	       dev->name, cmd);
-	printk(KERN_DEBUG "%s (WE.r) : Header type : %d, Token type : %d, size : %d, token : %d\n", dev->name, descr->header_type, descr->token_type, descr->token_size, descr->max_tokens);
-#endif	/* WE_RTNETLINK_DEBUG */
-
 	/* Extract fixed header from request. This is properly aligned. */
 	wrqu = &request->u;
 
 	/* Check if wrqu is complete */
 	hdr_len = event_type_size[descr->header_type];
-	if(request_len < hdr_len) {
-#ifdef WE_RTNETLINK_DEBUG
-		printk(KERN_DEBUG
-		       "%s (WE.r) : Wireless request too short (%d)\n",
-		       dev->name, request_len);
-#endif	/* WE_RTNETLINK_DEBUG */
+	if(request_len < hdr_len)
 		return -EINVAL;
-	}
 
 	/* Prepare the call */
 	info.cmd = cmd;
@@ -964,18 +797,8 @@ static inline int rtnetlink_standard_set
 		extra_len = wrqu_point.data.length * descr->token_size;
 
 		/* Check if request is self consistent */
-		if((request_len - hdr_len) < extra_len) {
-#ifdef WE_RTNETLINK_DEBUG
-			printk(KERN_DEBUG "%s (WE.r) : Wireless request data too short (%d)\n",
-			       dev->name, extra_size);
-#endif	/* WE_RTNETLINK_DEBUG */
+		if((request_len - hdr_len) < extra_len)
 			return -EINVAL;
-		}
-
-#ifdef WE_RTNETLINK_DEBUG
-		printk(KERN_DEBUG "%s (WE.r) : Malloc %d bytes\n",
-		       dev->name, extra_size);
-#endif	/* WE_RTNETLINK_DEBUG */
 
 		/* Always allocate for max space. Easier, and won't last
 		 * long... */
@@ -991,7 +814,6 @@ static inline int rtnetlink_standard_set
 		ret = handler(dev, &info, &wrqu_point, extra);
 	}
 
-#ifdef WE_SET_EVENT
 	/* Generate an event to notify listeners of the change */
 	if((descr->flags & IW_DESCR_FLAG_EVENT) &&
 	   ((ret == 0) || (ret == -EIWCOMMIT))) {
@@ -1002,7 +824,6 @@ static inline int rtnetlink_standard_set
 		else
 			wireless_send_event(dev, cmd, wrqu, extra);
 	}
-#endif	/* WE_SET_EVENT */
 
 	/* Cleanup - I told you it wasn't that long ;-) */
 	if(extra)
@@ -1058,13 +879,6 @@ static inline int rtnetlink_private_get(
 	if(descr == NULL)
 		return -EOPNOTSUPP;
 
-#ifdef WE_RTNETLINK_DEBUG
-	printk(KERN_DEBUG "%s (WE.r) : Found private handler for 0x%04X\n",
-	       dev->name, cmd);
-	printk(KERN_DEBUG "%s (WE.r) : Name %s, set %X, get %X\n",
-	       dev->name, descr->name, descr->set_args, descr->get_args);
-#endif	/* WE_RTNETLINK_DEBUG */
-
 	/* Compute the max size of the get arguments */
 	extra_size = get_priv_size(descr->get_args);
 
@@ -1078,14 +892,8 @@ static inline int rtnetlink_private_get(
 	}
 
 	/* Check if wrqu is complete */
-	if(request_len < hdr_len) {
-#ifdef WE_RTNETLINK_DEBUG
-		printk(KERN_DEBUG
-		       "%s (WE.r) : Wireless request too short (%d)\n",
-		       dev->name, request_len);
-#endif	/* WE_RTNETLINK_DEBUG */
+	if(request_len < hdr_len)
 		return -EINVAL;
-	}
 
 	/* Prepare the call */
 	info.cmd = cmd;
@@ -1116,11 +924,6 @@ static inline int rtnetlink_private_get(
 		/* Buffer for full reply */
 		buffer_size = extra_size + IW_EV_POINT_LEN + IW_EV_POINT_OFF;
 
-#ifdef WE_RTNETLINK_DEBUG
-		printk(KERN_DEBUG "%s (WE.r) : Malloc %d bytes (%d bytes)\n",
-		       dev->name, extra_size, buffer_size);
-#endif	/* WE_RTNETLINK_DEBUG */
-
 		/* Create the kernel buffer that we will return */
 		buffer = kmalloc(buffer_size, GFP_KERNEL);
 		if (buffer == NULL) {
@@ -1152,10 +955,6 @@ static inline int rtnetlink_private_get(
 		/* Put the iwe header where it should, i.e. scrap the
 		 * dummy pointer. */
 		memcpy(buffer + IW_EV_POINT_OFF, request, IW_EV_LCP_LEN);
-
-#ifdef WE_RTNETLINK_DEBUG
-		printk(KERN_DEBUG "%s (WE.r) : Reply 0x%04X, hdr_len %d, tokens %d, extra_size %d, buffer_size %d\n", dev->name, cmd, hdr_len, wrqu->data.length, extra_size, buffer_size);
-#endif	/* WE_RTNETLINK_DEBUG */
 	}
 
 	/* Return the buffer to the caller */
@@ -1213,13 +1012,6 @@ static inline int rtnetlink_private_set(
 	if(descr == NULL)
 		return -EOPNOTSUPP;
 
-#ifdef WE_RTNETLINK_DEBUG
-	printk(KERN_DEBUG "%s (WE.r) : Found private handler for 0x%04X\n",
-	       ifr->ifr_name, cmd);
-	printk(KERN_DEBUG "%s (WE.r) : Name %s, set %X, get %X\n",
-	       dev->name, descr->name, descr->set_args, descr->get_args);
-#endif	/* WE_RTNETLINK_DEBUG */
-
 	/* Compute the size of the set arguments */
 	/* Check for sub-ioctl handler */
 	if(descr->name[0] == '\0')
@@ -1242,14 +1034,8 @@ static inline int rtnetlink_private_set(
 	wrqu = &request->u;
 
 	/* Check if wrqu is complete */
-	if(request_len < hdr_len) {
-#ifdef WE_RTNETLINK_DEBUG
-		printk(KERN_DEBUG
-		       "%s (WE.r) : Wireless request too short (%d)\n",
-		       dev->name, request_len);
-#endif	/* WE_RTNETLINK_DEBUG */
+	if(request_len < hdr_len)
 		return -EINVAL;
-	}
 
 	/* Prepare the call */
 	info.cmd = cmd;
@@ -1277,18 +1063,8 @@ static inline int rtnetlink_private_set(
 		extra_len = adjust_priv_size(descr->set_args, &wrqu_point);
 
 		/* Check if request is self consistent */
-		if((request_len - hdr_len) < extra_len) {
-#ifdef WE_RTNETLINK_DEBUG
-			printk(KERN_DEBUG "%s (WE.r) : Wireless request data too short (%d)\n",
-			       dev->name, extra_size);
-#endif	/* WE_RTNETLINK_DEBUG */
+		if((request_len - hdr_len) < extra_len)
 			return -EINVAL;
-		}
-
-#ifdef WE_RTNETLINK_DEBUG
-		printk(KERN_DEBUG "%s (WE.r) : Malloc %d bytes\n",
-		       dev->name, extra_size);
-#endif	/* WE_RTNETLINK_DEBUG */
 
 		/* Always allocate for max space. Easier, and won't last
 		 * long... */
@@ -1329,18 +1105,12 @@ int wireless_rtnetlink_get(struct net_de
 	iw_handler		handler;
 
 	/* Check length */
-	if(len < IW_EV_LCP_LEN) {
-		printk(KERN_DEBUG "%s (WE.r) : RtNetlink request too short (%d)\n",
-		       dev->name, len);
+	if(len < IW_EV_LCP_LEN)
 		return -EINVAL;
-	}
 
 	/* ReCheck length (len may have padding) */
-	if(request->len > len) {
-		printk(KERN_DEBUG "%s (WE.r) : RtNetlink request len invalid (%d-%d)\n",
-		       dev->name, request->len, len);
+	if(request->len > len)
 		return -EINVAL;
-	}
 
 	/* Only accept GET requests in here */
 	if(!IW_IS_GET(request->cmd))
@@ -1413,18 +1183,12 @@ int wireless_rtnetlink_set(struct net_de
 	iw_handler		handler;
 
 	/* Check length */
-	if(len < IW_EV_LCP_LEN) {
-		printk(KERN_DEBUG "%s (WE.r) : RtNetlink request too short (%d)\n",
-		       dev->name, len);
+	if(len < IW_EV_LCP_LEN)
 		return -EINVAL;
-	}
 
 	/* ReCheck length (len may have padding) */
-	if(request->len > len) {
-		printk(KERN_DEBUG "%s (WE.r) : RtNetlink request len invalid (%d-%d)\n",
-		       dev->name, request->len, len);
+	if(request->len > len)
 		return -EINVAL;
-	}
 
 	/* Only accept SET requests in here */
 	if(!IW_IS_SET(request->cmd))
@@ -1520,19 +1284,6 @@ int iw_handler_set_spy(struct net_device
 		/* Reset stats */
 		memset(spydata->spy_stat, 0,
 		       sizeof(struct iw_quality) * IW_MAX_SPY);
-
-#ifdef WE_SPY_DEBUG
-		printk(KERN_DEBUG "iw_handler_set_spy() :  wireless_data %p, spydata %p, num %d\n", dev->wireless_data, spydata, wrqu->data.length);
-		for (i = 0; i < wrqu->data.length; i++)
-			printk(KERN_DEBUG
-			       "%02X:%02X:%02X:%02X:%02X:%02X \n",
-			       spydata->spy_address[i][0],
-			       spydata->spy_address[i][1],
-			       spydata->spy_address[i][2],
-			       spydata->spy_address[i][3],
-			       spydata->spy_address[i][4],
-			       spydata->spy_address[i][5]);
-#endif	/* WE_SPY_DEBUG */
 	}
 
 	/* Make sure above is updated before re-enabling */
@@ -1543,6 +1294,7 @@ int iw_handler_set_spy(struct net_device
 
 	return 0;
 }
+EXPORT_SYMBOL(iw_handler_set_spy);
 
 /*------------------------------------------------------------------*/
 /*
@@ -1578,6 +1330,7 @@ int iw_handler_get_spy(struct net_device
 		spydata->spy_stat[i].updated &= ~IW_QUAL_ALL_UPDATED;
 	return 0;
 }
+EXPORT_SYMBOL(iw_handler_get_spy);
 
 /*------------------------------------------------------------------*/
 /*
@@ -1602,12 +1355,9 @@ int iw_handler_set_thrspy(struct net_dev
 	/* Clear flag */
 	memset(spydata->spy_thr_under, '\0', sizeof(spydata->spy_thr_under));
 
-#ifdef WE_SPY_DEBUG
-	printk(KERN_DEBUG "iw_handler_set_thrspy() :  low %d ; high %d\n", spydata->spy_thr_low.level, spydata->spy_thr_high.level);
-#endif	/* WE_SPY_DEBUG */
-
 	return 0;
 }
+EXPORT_SYMBOL(iw_handler_set_thrspy);
 
 /*------------------------------------------------------------------*/
 /*
@@ -1631,6 +1381,7 @@ int iw_handler_get_thrspy(struct net_dev
 
 	return 0;
 }
+EXPORT_SYMBOL(iw_handler_get_thrspy);
 
 /*------------------------------------------------------------------*/
 /*
@@ -1656,16 +1407,6 @@ static void iw_send_thrspy_event(struct 
 	memcpy(&(threshold.low), &(spydata->spy_thr_low),
 	       2 * sizeof(struct iw_quality));
 
-#ifdef WE_SPY_DEBUG
-	printk(KERN_DEBUG "iw_send_thrspy_event() : address %02X:%02X:%02X:%02X:%02X:%02X, level %d, up = %d\n",
-	       threshold.addr.sa_data[0],
-	       threshold.addr.sa_data[1],
-	       threshold.addr.sa_data[2],
-	       threshold.addr.sa_data[3],
-	       threshold.addr.sa_data[4],
-	       threshold.addr.sa_data[5], threshold.qual.level);
-#endif	/* WE_SPY_DEBUG */
-
 	/* Send event to user space */
 	wireless_send_event(dev, SIOCGIWTHRSPY, &wrqu, (char *) &threshold);
 }
@@ -1689,10 +1430,6 @@ void wireless_spy_update(struct net_devi
 	if(!spydata)
 		return;
 
-#ifdef WE_SPY_DEBUG
-	printk(KERN_DEBUG "wireless_spy_update() :  wireless_data %p, spydata %p, address %02X:%02X:%02X:%02X:%02X:%02X\n", dev->wireless_data, spydata, address[0], address[1], address[2], address[3], address[4], address[5]);
-#endif	/* WE_SPY_DEBUG */
-
 	/* Update all records that match */
 	for(i = 0; i < spydata->spy_number; i++)
 		if(!compare_ether_addr(address, spydata->spy_address[i])) {
@@ -1721,9 +1458,4 @@ void wireless_spy_update(struct net_devi
 		}
 	}
 }
-
-EXPORT_SYMBOL(iw_handler_get_spy);
-EXPORT_SYMBOL(iw_handler_get_thrspy);
-EXPORT_SYMBOL(iw_handler_set_spy);
-EXPORT_SYMBOL(iw_handler_set_thrspy);
 EXPORT_SYMBOL(wireless_spy_update);

--

