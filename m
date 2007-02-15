Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43649 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965721AbXBOO7x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 09:59:53 -0500
Message-Id: <20070215144256.381810000@sipsolutions.net>
References: <20070215144241.847938000@sipsolutions.net>
Date: Thu, 15 Feb 2007 15:42:42 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>
Subject: [PATCH 01/10] remove cfg80211/wext-nl compatibility
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wireless extensions over netlink can't reliably be used anyway (and probably
never will be used...) so remove the code that would allow cfg80211 to be
compatible with that.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/net/cfg80211.h     |    5 
 net/Kconfig                |   14 -
 net/core/rtnetlink.c       |   42 -----
 net/wireless/wext-compat.c |  333 ---------------------------------------------
 4 files changed, 1 insertion(+), 393 deletions(-)

--- wireless-dev.orig/net/Kconfig	2007-02-15 12:28:31.167940064 +0100
+++ wireless-dev/net/Kconfig	2007-02-15 12:28:34.637940064 +0100
@@ -244,20 +244,6 @@ config CFG80211_WEXT_COMPAT
 
 	If unsure, say Y.
 
-config CFG80211_WEXTNL_COMPAT
-	bool "cfg80211 WE-netlink compatibility"
-	depends CFG80211 && CFG80211_WEXT_COMPAT
-	---help---
-	This option allows using devices whose drivers have been
-	converted to use the new cfg80211 with wireless extensions
-	over rtnetlink, providing WE-20 compatibility. Note that
-	cfg80211's "native" interface is nl80211 using generic netlink.
-	The wireless extensions are being deprecated and the netlink
-	based API for WE was never configured by default, nor do any
-	userspace tools use this feature.
-
-	This option exists only to make Jean happy. Say N.
-
 endif   # if NET
 endmenu # Networking
 
--- wireless-dev.orig/net/wireless/wext-compat.c	2007-02-15 12:28:31.207940064 +0100
+++ wireless-dev/net/wireless/wext-compat.c	2007-02-15 12:28:34.647940064 +0100
@@ -1126,339 +1126,6 @@ static int iw_handler_get_iwstats(struct
 		return -EOPNOTSUPP;
 }
 
-#ifdef CONFIG_CFG80211_WEXTNL_COMPAT
-/*
- * Wrapper to call a standard Wireless Extension GET handler.
- * We do various checks and call the handler with the proper args.
- */
-static int rtnetlink_standard_get(struct net_device *	dev,
-				  struct iw_event *	request,
-				  int			request_len,
-				  iw_handler		handler,
-				  char **		p_buf,
-				  int *			p_len)
-{
-	const struct iw_ioctl_description *	descr = NULL;
-	unsigned int				cmd;
-	union iwreq_data *			wrqu;
-	int					hdr_len;
-	struct iw_request_info			info;
-	char *					buffer = NULL;
-	int					buffer_size = 0;
-	int					ret = -EINVAL;
-
-	/* Get the description of the Request */
-	cmd = request->cmd;
-	if((cmd - SIOCIWFIRST) >= standard_ioctl_num)
-		return -EOPNOTSUPP;
-	descr = &(standard_ioctl[cmd - SIOCIWFIRST]);
-
-	/* Check if wrqu is complete */
-	hdr_len = event_type_size[descr->header_type];
-	if(request_len < hdr_len)
-		return -EINVAL;
-
-	/* Prepare the call */
-	info.cmd = cmd;
-	info.flags = 0;
-
-	/* Check if we have extra data in the reply or not */
-	if(descr->header_type != IW_HEADER_TYPE_POINT) {
-
-		/* Create the kernel buffer that we will return.
-		 * It's at an offset to match the TYPE_POINT case... */
-		buffer_size = request_len + IW_EV_POINT_OFF;
-		buffer = kmalloc(buffer_size, GFP_KERNEL);
-		if (buffer == NULL) {
-			return -ENOMEM;
-		}
-		/* Copy event data */
-		memcpy(buffer + IW_EV_POINT_OFF, request, request_len);
-		/* Use our own copy of wrqu */
-		wrqu = (union iwreq_data *) (buffer + IW_EV_POINT_OFF
-					     + IW_EV_LCP_LEN);
-
-		/* No extra arguments. Trivial to handle */
-		ret = handler(dev, &info, wrqu, NULL);
-
-	} else {
-		union iwreq_data	wrqu_point;
-		char *			extra = NULL;
-		int			extra_size = 0;
-
-		/* Get a temp copy of wrqu (skip pointer) */
-		memcpy(((char *) &wrqu_point) + IW_EV_POINT_OFF,
-		       ((char *) request) + IW_EV_LCP_LEN,
-		       IW_EV_POINT_LEN - IW_EV_LCP_LEN);
-
-		/* Calculate space needed by arguments. Always allocate
-		 * for max space. Easier, and won't last long... */
-		extra_size = descr->max_tokens * descr->token_size;
-		/* Support for very large requests */
-		if((descr->flags & IW_DESCR_FLAG_NOMAX) &&
-		   (wrqu_point.data.length > descr->max_tokens))
-			extra_size = (wrqu_point.data.length
-				      * descr->token_size);
-		buffer_size = extra_size + IW_EV_POINT_LEN + IW_EV_POINT_OFF;
-
-		/* Create the kernel buffer that we will return */
-		buffer = kmalloc(buffer_size, GFP_KERNEL);
-		if (buffer == NULL) {
-			return -ENOMEM;
-		}
-
-		/* Put wrqu in the right place (just before extra).
-		 * Leave space for IWE header and dummy pointer...
-		 * Note that IW_EV_LCP_LEN==4 bytes, so it's still aligned...
-		 */
-		memcpy(buffer + IW_EV_LCP_LEN + IW_EV_POINT_OFF,
-		       ((char *) &wrqu_point) + IW_EV_POINT_OFF,
-		       IW_EV_POINT_LEN - IW_EV_LCP_LEN);
-		wrqu = (union iwreq_data *) (buffer + IW_EV_LCP_LEN);
-
-		/* Extra comes logically after that. Offset +12 bytes. */
-		extra = buffer + IW_EV_POINT_OFF + IW_EV_POINT_LEN;
-
-		/* Call the handler */
-		ret = handler(dev, &info, wrqu, extra);
-
-		/* Calculate real returned length */
-		extra_size = (wrqu->data.length * descr->token_size);
-		/* Re-adjust reply size */
-		request->len = extra_size + IW_EV_POINT_LEN;
-
-		/* Put the iwe header where it should, i.e. scrap the
-		 * dummy pointer. */
-		memcpy(buffer + IW_EV_POINT_OFF, request, IW_EV_LCP_LEN);
-
-		/* Check if there is enough buffer up there */
-		if(wrqu_point.data.length < wrqu->data.length)
-			ret = -E2BIG;
-	}
-
-	/* Return the buffer to the caller */
-	if (!ret) {
-		*p_buf = buffer;
-		*p_len = request->len;
-	} else {
-		/* Cleanup */
-		if(buffer)
-			kfree(buffer);
-	}
-
-	return ret;
-}
-
-/*
- * Wrapper to call a standard Wireless Extension SET handler.
- * We do various checks and call the handler with the proper args.
- */
-static inline int rtnetlink_standard_set(struct net_device *	dev,
-					 struct iw_event *	request,
-					 int			request_len,
-					 iw_handler		handler)
-{
-	const struct iw_ioctl_description *	descr = NULL;
-	unsigned int				cmd;
-	union iwreq_data *			wrqu;
-	union iwreq_data			wrqu_point;
-	int					hdr_len;
-	char *					extra = NULL;
-	int					extra_size = 0;
-	struct iw_request_info			info;
-	int					ret = -EINVAL;
-
-	/* Get the description of the Request */
-	cmd = request->cmd;
-	if((cmd - SIOCIWFIRST) >= standard_ioctl_num)
-		return -EOPNOTSUPP;
-	descr = &(standard_ioctl[cmd - SIOCIWFIRST]);
-
-	/* Extract fixed header from request. This is properly aligned. */
-	wrqu = &request->u;
-
-	/* Check if wrqu is complete */
-	hdr_len = event_type_size[descr->header_type];
-	if(request_len < hdr_len)
-		return -EINVAL;
-
-	/* Prepare the call */
-	info.cmd = cmd;
-	info.flags = 0;
-
-	/* Check if we have extra data in the request or not */
-	if(descr->header_type != IW_HEADER_TYPE_POINT) {
-
-		/* No extra arguments. Trivial to handle */
-		ret = handler(dev, &info, wrqu, NULL);
-
-	} else {
-		int	extra_len;
-
-		/* Put wrqu in the right place (skip pointer) */
-		memcpy(((char *) &wrqu_point) + IW_EV_POINT_OFF,
-		       wrqu, IW_EV_POINT_LEN - IW_EV_LCP_LEN);
-		/* Don't forget about the event code... */
-		wrqu = &wrqu_point;
-
-		/* Check if number of token fits within bounds */
-		if(wrqu_point.data.length > descr->max_tokens)
-			return -E2BIG;
-		if(wrqu_point.data.length < descr->min_tokens)
-			return -EINVAL;
-
-		/* Real length of payload */
-		extra_len = wrqu_point.data.length * descr->token_size;
-
-		/* Check if request is self consistent */
-		if((request_len - hdr_len) < extra_len)
-			return -EINVAL;
-
-		/* Always allocate for max space. Easier, and won't last
-		 * long... */
-		extra_size = descr->max_tokens * descr->token_size;
-		extra = kmalloc(extra_size, GFP_KERNEL);
-		if (extra == NULL)
-			return -ENOMEM;
-
-		/* Copy extra in aligned buffer */
-		memcpy(extra, ((char *) request) + hdr_len, extra_len);
-
-		/* Call the handler */
-		ret = handler(dev, &info, &wrqu_point, extra);
-	}
-
-        /* Generate an event to notify listeners of the change */
-	if ((descr->flags & IW_DESCR_FLAG_EVENT) &&
-	    ((ret == 0) || (ret == -EIWCOMMIT))) {
-		if(descr->flags & IW_DESCR_FLAG_RESTRICT)
-			/* If the event is restricted, don't
-			 * export the payload */
-			wireless_send_event(dev, cmd, wrqu, NULL);
-		else
-			wireless_send_event(dev, cmd, wrqu, extra);
-	}
-
-	/* Cleanup - I told you it wasn't that long ;-) */
-	if(extra)
-		kfree(extra);
-
-	return ret;
-}
-
-/*
- * Main RtNetlink dispatcher. Called from the main networking code
- * (do_getlink() in net/core/rtnetlink.c).
- * Check the type of Request and call the appropriate wrapper...
- */
-int cfg80211_wext_nl_get(struct net_device *	dev,
-			 char *			data,
-			 int			len,
-			 char **		p_buf,
-			 int *			p_len)
-{
-	struct iw_event *	request = (struct iw_event *) data;
-	iw_handler		handler;
-
-	/* Check length */
-	if(len < IW_EV_LCP_LEN) {
-		printk(KERN_DEBUG "%s (WE.r) : RtNetlink request too short (%d)\n",
-		       dev->name, len);
-		return -EINVAL;
-	}
-
-	/* ReCheck length (len may have padding) */
-	if(request->len > len) {
-		printk(KERN_DEBUG "%s (WE.r) : RtNetlink request len invalid (%d-%d)\n",
-		       dev->name, request->len, len);
-		return -EINVAL;
-	}
-
-	/* Only accept GET requests in here */
-	if(!IW_IS_GET(request->cmd))
-		return -EOPNOTSUPP;
-
-	/* If command is `get the encoding parameters', check if
-	 * the user has the right to do it */
-	if (request->cmd == SIOCGIWENCODE ||
-	    request->cmd == SIOCGIWENCODEEXT) {
-		if (!capable(CAP_NET_ADMIN))
-			return -EPERM;
-	}
-
-	/* Special cases */
-	if(request->cmd == SIOCGIWSTATS)
-		/* Get Wireless Stats */
-		return rtnetlink_standard_get(dev,
-					      request,
-					      request->len,
-					      &iw_handler_get_iwstats,
-					      p_buf, p_len);
-	if(request->cmd == SIOCGIWPRIV)
-		return -EOPNOTSUPP;
-
-	/* Basic check */
-	if (!netif_device_present(dev))
-		return -ENODEV;
-
-	/* Try to find the handler */
-	handler = get_handler(dev, request->cmd);
-	if (handler != NULL && request->cmd < SIOCIWFIRSTPRIV)
-		return rtnetlink_standard_get(dev,
-					      request,
-					      request->len,
-					      handler,
-					      p_buf, p_len);
-
-	return -EOPNOTSUPP;
-}
-
-/*
- * Main RtNetlink dispatcher. Called from the main networking code
- * (do_setlink() in net/core/rtnetlink.c).
- * Check the type of Request and call the appropriate wrapper...
- */
-int cfg80211_wext_nl_set(struct net_device *	dev,
-			 char *			data,
-			 int			len)
-{
-	struct iw_event *	request = (struct iw_event *) data;
-	iw_handler		handler;
-
-	/* Check length */
-	if(len < IW_EV_LCP_LEN) {
-		printk(KERN_DEBUG "%s (WE.r) : RtNetlink request too short (%d)\n",
-		       dev->name, len);
-		return -EINVAL;
-	}
-
-	/* ReCheck length (len may have padding) */
-	if(request->len > len) {
-		printk(KERN_DEBUG "%s (WE.r) : RtNetlink request len invalid (%d-%d)\n",
-		       dev->name, request->len, len);
-		return -EINVAL;
-	}
-
-	/* Only accept SET requests in here */
-	if(!IW_IS_SET(request->cmd))
-		return -EOPNOTSUPP;
-
-	/* Basic check */
-	if (!netif_device_present(dev))
-		return -ENODEV;
-
-	/* New driver API : try to find the handler */
-	handler = get_handler(dev, request->cmd);
-	if(handler != NULL && request->cmd < SIOCIWFIRSTPRIV)
-		return rtnetlink_standard_set(dev,
-					      request,
-					      request->len,
-					      handler);
-
-	return -EOPNOTSUPP;
-}
-#endif
-
 /*
  * Wrapper to call a standard Wireless Extension handler.
  * We do various checks and also take care of moving data between
--- wireless-dev.orig/include/net/cfg80211.h	2007-02-15 12:28:31.317940064 +0100
+++ wireless-dev/include/net/cfg80211.h	2007-02-15 12:28:34.647940064 +0100
@@ -195,11 +195,6 @@ extern void *nl80211msg_new(struct sk_bu
 
 #ifdef CONFIG_CFG80211_WEXT_COMPAT
 extern int cfg80211_wext_ioctl(struct ifreq *ifr, unsigned int cmd);
-#ifdef CONFIG_CFG80211_WEXTNL_COMPAT
-int cfg80211_wext_nl_set(struct net_device *dev, char *data, int len);
-int cfg80211_wext_nl_get(struct net_device *dev, char *data, int len,
-			 char **p_buf, int *p_len);
-#endif
 #endif
 
 #endif /* __NET_CFG80211_H */
--- wireless-dev.orig/net/core/rtnetlink.c	2007-02-15 12:28:31.257940064 +0100
+++ wireless-dev/net/core/rtnetlink.c	2007-02-15 12:28:34.647940064 +0100
@@ -56,9 +56,6 @@
 #include <linux/wireless.h>
 #include <net/iw_handler.h>
 #endif	/* CONFIG_NET_WIRELESS_RTNETLINK */
-#ifdef CONFIG_CFG80211_WEXTNL_COMPAT
-#include <net/cfg80211.h>
-#endif
 
 static DEFINE_MUTEX(rtnl_mutex);
 static struct sock *rtnl;
@@ -539,20 +536,6 @@ static int rtnl_setlink(struct sk_buff *
 		modified = 1;
 	}
 
-#ifdef CONFIG_CFG80211_WEXTNL_COMPAT
-	if (tb[IFLA_WIRELESS]) {
-		/* Call cfg80211 WE backward compat code.
-		 * Various stuff checked in there... */
-		err = cfg80211_wext_nl_set(dev, nla_data(tb[IFLA_WIRELESS]),
-					   nla_len(tb[IFLA_WIRELESS]));
-		if (err < 0 && err != -ENOSYS)
-			goto errout_dev;
-#ifdef CONFIG_NET_WIRELESS_RTNETLINK
-		if (err == 0)
-			goto skip_old_wext_nl;
-#endif
-	}
-#endif
 #ifdef CONFIG_NET_WIRELESS_RTNETLINK
 	if (tb[IFLA_WIRELESS]) {
 		/* Call Wireless Extensions.
@@ -562,10 +545,8 @@ static int rtnl_setlink(struct sk_buff *
 		if (err < 0)
 			goto errout_dev;
 	}
-#ifdef CONFIG_CFG80211_WEXTNL_COMPAT
- skip_old_wext_nl:
-#endif
 #endif	/* CONFIG_NET_WIRELESS_RTNETLINK */
+
 	if (tb[IFLA_BROADCAST]) {
 		nla_memcpy(dev->broadcast, tb[IFLA_BROADCAST], dev->addr_len);
 		send_addr_notify = 1;
@@ -630,24 +611,6 @@ static int rtnl_getlink(struct sk_buff *
 		return -EINVAL;
 
 
-#ifdef CONFIG_CFG80211_WEXTNL_COMPAT
-	if (tb[IFLA_WIRELESS]) {
-		/* Call Wireless Extensions. We need to know the size before
-		 * we can alloc. Various stuff checked in there... */
-		err = cfg80211_wext_nl_get(dev, nla_data(tb[IFLA_WIRELESS]),
-					   nla_len(tb[IFLA_WIRELESS]),
-					   &iw_buf, &iw_buf_len);
-		if (err < 0 && err != -ENOSYS)
-			goto errout;
-
-		iw += IW_EV_POINT_OFF;
-#ifdef CONFIG_NET_WIRELESS_RTNETLINK
-		if (err == 0)
-			goto skip_old_wext_nl;
-		iw -= IW_EV_POINT_OFF;
-#endif
-	}
-#endif
 #ifdef CONFIG_NET_WIRELESS_RTNETLINK
 	if (tb[IFLA_WIRELESS]) {
 		/* Call Wireless Extensions. We need to know the size before
@@ -660,9 +623,6 @@ static int rtnl_getlink(struct sk_buff *
 
 		iw += IW_EV_POINT_OFF;
 	}
-#ifdef CONFIG_CFG80211_WEXTNL_COMPAT
- skip_old_wext_nl:
-#endif
 #endif	/* CONFIG_NET_WIRELESS_RTNETLINK */
 
 	nskb = nlmsg_new(if_nlmsg_size(iw_buf_len), GFP_KERNEL);

--

