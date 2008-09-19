Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40859 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbYISNRX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 09:17:23 -0400
Subject: Re: technology preview: scan with cfg80211 (v2)
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Dan Williams <dcbw@redhat.com>
In-Reply-To: <1221794329.10419.9.camel@johannes.berg> (sfid-20080919_052010_602864_D520EF40)
References: <1221794329.10419.9.camel@johannes.berg>
	 (sfid-20080919_052010_602864_D520EF40)
Content-Type: text/plain
Date: Fri, 19 Sep 2008 15:16:46 +0200
Message-Id: <1221830207.12059.10.camel@johannes.berg> (sfid-20080919_151730_930583_57949476)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>  * provide a way for the hw to limit the number of SSIDs in a scan

check

>  * provide a function to just pass in the whole beacon/probe response
>    frame and pick it apart itself

check

>  * provide a wext "set scan" hook that creates a request and passes it
>    off to ->scan(), provide wext "get scan" hook

check

>  * pass the scan request to the hardware offload

check

>  * handle multiple SSIDs in a scan

check

>  * handle active/passive properly

check

> grab the scan-test branch from iw

updated too.

New todo list:

cfg80211:
 * BSS aging
 * BSS hash table
 * supported rates bitmap (really needed?)
 * mesh handling
 * private area per BSS, driver access to BSS list

mac80211:
 * use BSS list stuff from cfg80211 when there

any fullmac driver:
 * port over to see if it works

---
 drivers/net/wireless/at76_usb.c             |   17 
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   12 
 drivers/net/wireless/iwlwifi/iwl-core.c     |    1 
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   17 
 include/linux/nl80211.h                     |   34 +
 include/net/cfg80211.h                      |   96 +++++
 include/net/mac80211.h                      |    3 
 include/net/wireless.h                      |    2 
 net/mac80211/cfg.c                          |   24 +
 net/mac80211/ieee80211_i.h                  |   16 
 net/mac80211/main.c                         |   32 +
 net/mac80211/mlme.c                         |   35 +-
 net/mac80211/scan.c                         |  333 ++-----------------
 net/mac80211/wext.c                         |   57 ---
 net/wireless/Makefile                       |    2 
 net/wireless/core.c                         |    8 
 net/wireless/core.h                         |    6 
 net/wireless/nl80211.c                      |  286 ++++++++++++++++
 net/wireless/nl80211.h                      |    6 
 net/wireless/scan.c                         |  480 ++++++++++++++++++++++++++++
 20 files changed, 1091 insertions(+), 376 deletions(-)

--- everything.orig/include/linux/nl80211.h	2008-09-19 05:09:30.000000000 +0200
+++ everything/include/linux/nl80211.h	2008-09-19 13:24:49.000000000 +0200
@@ -106,6 +106,11 @@
  * 	to the the specified ISO/IEC 3166-1 alpha2 country code. The core will
  * 	store this as a valid request and then query userspace for it.
  *
+ * @NL80211_CMD_GET_SCAN: get scan results
+ * @NL80211_CMD_TRIGGER_SCAN: trigger a new scan with the given parameters
+ * @NL80211_CMD_NEW_SCAN: scan notification (as a reply to NL80211_CMD_GET_SCAN
+ *	and on the "scan" multicast group)
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -148,6 +153,10 @@ enum nl80211_commands {
 	NL80211_CMD_SET_REG,
 	NL80211_CMD_REQ_SET_REG,
 
+	NL80211_CMD_GET_SCAN,
+	NL80211_CMD_TRIGGER_SCAN,
+	NL80211_CMD_NEW_SCAN,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -242,6 +251,10 @@ enum nl80211_commands {
  *	supported interface types, each a flag attribute with the number
  *	of the interface mode.
  *
+ * @NL80211_ATTR_SCAN_FREQUENCIES: nested attribute with frequencies
+ * @NL80211_ATTR_SCAN_SSIDS: nested attribute with SSIDs
+ * @NL80211_ATTR_BSS: scan result BSS
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -296,6 +309,13 @@ enum nl80211_attrs {
 	NL80211_ATTR_REG_ALPHA2,
 	NL80211_ATTR_REG_RULES,
 
+	NL80211_ATTR_INFORMATION_ELEMENT,
+
+	NL80211_ATTR_SCAN_FREQUENCIES,
+	NL80211_ATTR_SCAN_SSIDS,
+	NL80211_ATTR_SCAN_GENERATION,
+	NL80211_ATTR_BSS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -594,4 +614,18 @@ enum nl80211_mntr_flags {
 	NL80211_MNTR_FLAG_MAX = __NL80211_MNTR_FLAG_AFTER_LAST - 1
 };
 
+enum nl80211_bss {
+	__NL80211_BSS_INVALID,
+	NL80211_BSS_BSSID,
+	NL80211_BSS_FREQUENCY,
+	NL80211_BSS_TSF,
+	NL80211_BSS_BEACON_INTERVAL,
+	NL80211_BSS_CAPABILITY,
+	NL80211_BSS_INFORMATION_ELEMENTS,
+
+	/* keep last */
+	__NL80211_BSS_AFTER_LAST,
+	NL80211_BSS_MAX = __NL80211_BSS_AFTER_LAST - 1
+};
+
 #endif /* __LINUX_NL80211_H */
--- everything.orig/include/net/cfg80211.h	2008-09-19 05:09:30.000000000 +0200
+++ everything/include/net/cfg80211.h	2008-09-19 14:17:44.000000000 +0200
@@ -4,6 +4,10 @@
 #include <linux/netlink.h>
 #include <linux/skbuff.h>
 #include <linux/nl80211.h>
+#include <linux/if_ether.h>
+#include <linux/ieee80211.h>
+#include <linux/wireless.h>
+#include <net/iw_handler.h>
 #include <net/genetlink.h>
 
 /*
@@ -351,6 +355,58 @@ struct ieee80211_regdomain {
 struct wiphy;
 
 /**
+ * struct cfg80211_ssid - SSID description
+ * @ssid: the SSID
+ * @ssid_len: length of the ssid
+ */
+struct cfg80211_ssid {
+	u8 *ssid;
+	u8 ssid_len;
+};
+
+/**
+ * struct cfg80211_scan_request - scan request description
+ *
+ * @extra_elements: extra information elements to add to probe requests
+ * @len_extra_elements: length of the IEs
+ * @ssids: SSIDs to scan for (active scan only)
+ * @n_ssids: number of SSIDs
+ * @channels: channels to scan on.
+ * @n_channels: number of channels for each band
+ * @wiphy: the wiphy this was for
+ * @ifidx: the interface index
+ */
+struct cfg80211_scan_request {
+	u8 *extra_elements;
+	size_t len_extra_elements;
+	struct cfg80211_ssid *ssids;
+	int n_ssids;
+	struct ieee80211_channel **channels;
+	u32 n_channels;
+
+	/* internal */
+	struct wiphy *wiphy;
+	int ifidx;
+};
+
+struct cfg80211_scan_result {
+	struct ieee80211_channel *channel;
+
+	/* XXX: add flags which members are valid? */
+
+	u8 bssid[ETH_ALEN];
+	u64 tsf;
+	u16 beacon_interval;
+	u16 capability;
+	u8 *information_elements;
+	size_t len_information_elements;
+
+	/* internal */
+	struct list_head list;
+	unsigned long ts;
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -400,6 +456,10 @@ struct wiphy;
  * @set_mesh_cfg: set mesh parameters (by now, just mesh id)
  *
  * @change_bss: Modify parameters for a given BSS.
+ *
+ * @scan: Request to do a scan. If returning zero, the scan request is given
+ *	the driver, and will be valid until passed to cfg80211_scan_done().
+ *	For scan results, call cfg80211_scan_result().
  */
 struct cfg80211_ops {
 	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
@@ -455,6 +515,42 @@ struct cfg80211_ops {
 
 	int	(*change_bss)(struct wiphy *wiphy, struct net_device *dev,
 			      struct bss_parameters *params);
+
+	int	(*scan)(struct wiphy *wiphy, struct net_device *dev,
+			struct cfg80211_scan_request *request);
 };
 
+/**
+ * cfg80211_scan_done - notify that scan finished
+ *
+ * @request: the corresponding scan request
+ */
+void cfg80211_scan_done(struct cfg80211_scan_request *request);
+
+/**
+ * cfg80211_scan_result - pass scan result to cfg80211
+ *
+ * @request: the scan request
+ * @result: the result information
+ */
+void cfg80211_scan_result(struct cfg80211_scan_request *request,
+			  struct cfg80211_scan_result *result,
+			  gfp_t gfp);
+void cfg80211_scan_result_frame(struct cfg80211_scan_request *request,
+				struct ieee80211_channel *channel,
+				struct ieee80211_mgmt *mgmt, size_t len,
+				gfp_t gfp);
+
+#ifdef CONFIG_WIRELESS_EXT
+int cfg80211_wext_siwscan(struct net_device *dev,
+			  struct iw_request_info *info,
+			  union iwreq_data *wrqu, char *extra);
+int cfg80211_wext_giwscan(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_point *data, char *extra);
+#else
+#define ieee80211_ioctl_siwscan NULL
+#define ieee80211_ioctl_giwscan NULL
+#endif
+
 #endif /* __NET_CFG80211_H */
--- everything.orig/net/wireless/nl80211.c	2008-09-19 05:09:30.000000000 +0200
+++ everything/net/wireless/nl80211.c	2008-09-19 14:31:57.000000000 +0200
@@ -98,6 +98,10 @@ static struct nla_policy nl80211_policy[
 
 	[NL80211_ATTR_HT_CAPABILITY] = { .type = NLA_BINARY,
 					 .len = NL80211_HT_CAPABILITY_LEN },
+	[NL80211_ATTR_INFORMATION_ELEMENT] = { .type = NLA_BINARY,
+					       .len = IEEE80211_MAX_DATA_LEN },
+	[NL80211_ATTR_SCAN_FREQUENCIES] = { .type = NLA_NESTED },
+	[NL80211_ATTR_SCAN_SSIDS] = { .type = NLA_NESTED },
 };
 
 /* message building helper */
@@ -1753,6 +1757,228 @@ bad_reg:
 	return -EINVAL;
 }
 
+static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	struct net_device *dev;
+	struct cfg80211_scan_request *request;
+	struct cfg80211_ssid *ssid;
+	struct ieee80211_channel *channel;
+	struct nlattr *attr;
+	struct wiphy *wiphy;
+	int err, tmp, n_ssids = 0, n_channels = 0, i;
+	enum ieee80211_band band;
+
+	if (!info->attrs[NL80211_ATTR_SCAN_SSIDS])
+		return -EINVAL;
+
+	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	if (err)
+		return err;
+
+	wiphy = &drv->wiphy;
+
+	if (!drv->ops->scan) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (drv->scan_req) {
+		err = -EBUSY;
+		goto out;
+	}
+
+	if (info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
+		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_FREQUENCIES], tmp)
+			n_channels++;
+		if (!n_channels) {
+			err = -EINVAL;
+			goto out;
+		}
+	} else {
+		for (band = 0; band < IEEE80211_NUM_BANDS; band++)
+			if (wiphy->bands[band])
+				n_channels += wiphy->bands[band]->n_channels;
+	}
+
+	nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS], tmp)
+		n_ssids++;
+
+	if (n_ssids > wiphy->max_scan_ssids) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	request = kzalloc(sizeof(*request)
+			+ sizeof(*ssid) * n_ssids
+			+ sizeof(channel) * n_channels, GFP_KERNEL);
+	if (!request) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	request->channels = (void *)((char *)request + sizeof(*request));
+	request->n_channels = n_channels;
+	request->ssids = (void *)(request->channels + n_channels);
+	request->n_ssids = n_ssids;
+
+	if (info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
+		/* user specified, bail out if channel not found */
+		request->n_channels = n_channels;
+		i = 0;
+		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_FREQUENCIES], tmp) {
+			request->channels[i] = ieee80211_get_channel(wiphy, nla_get_u32(attr));
+			if (!request->channels[i]) {
+				err = -EINVAL;
+				goto out_free;
+			}
+			i++;
+		}
+	} else {
+		/* all channels */
+		i = 0;
+		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+			int j;
+			if (!wiphy->bands[band])
+				continue;
+			for (j = 0; j < wiphy->bands[band]->n_channels; j++) {
+				request->channels[i] = &wiphy->bands[band]->channels[j];
+				i++;
+			}
+		}
+	}
+
+	i = 0;
+	nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS], tmp) {
+		request->ssids[i].ssid = nla_data(attr);
+		request->ssids[i].ssid_len = nla_len(attr);
+		if (request->ssids[i].ssid_len > IEEE80211_MAX_SSID_LEN) {
+			err = -EINVAL;
+			goto out_free;
+		}
+		i++;
+	}
+
+	request->ifidx = dev->ifindex;
+	request->wiphy = &drv->wiphy;
+
+	rtnl_lock();
+	drv->scan_req = request;
+	err = drv->ops->scan(&drv->wiphy, dev, request);
+	rtnl_unlock();
+
+ out_free:
+	if (err) {
+		drv->scan_req = NULL;
+		kfree(request);
+	}
+ out:
+	cfg80211_put_dev(drv);
+	dev_put(dev);
+	return err;
+}
+
+static int nl80211_send_bss(struct sk_buff *msg, u32 pid, u32 seq, int flags,
+			    struct cfg80211_registered_device *rdev,
+			    struct net_device *dev,
+			    struct cfg80211_scan_result *res)
+{
+	void *hdr;
+	struct nlattr *bss;
+
+	hdr = nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_SCAN);
+	if (!hdr)
+		return -1;
+
+	NLA_PUT_U32(msg, NL80211_ATTR_SCAN_GENERATION,
+		    rdev->scan_generation);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
+
+	bss = nla_nest_start(msg, NL80211_ATTR_BSS);
+	if (!bss)
+		goto nla_put_failure;
+	if (res->bssid)
+		NLA_PUT(msg, NL80211_BSS_BSSID, ETH_ALEN, res->bssid);
+	if (res->information_elements && res->len_information_elements)
+		NLA_PUT(msg, NL80211_BSS_INFORMATION_ELEMENTS,
+			res->len_information_elements,
+			res->information_elements);
+	if (res->tsf)
+		NLA_PUT_U64(msg, NL80211_BSS_TSF, res->tsf);
+	NLA_PUT_U16(msg, NL80211_BSS_CAPABILITY, res->capability);
+	NLA_PUT_U16(msg, NL80211_BSS_BEACON_INTERVAL, res->beacon_interval);
+	NLA_PUT_U32(msg, NL80211_BSS_FREQUENCY, res->channel->center_freq);
+
+	nla_nest_end(msg, bss);
+
+	return genlmsg_end(msg, hdr);
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
+static int nl80211_dump_scan(struct sk_buff *skb,
+			     struct netlink_callback *cb)
+{
+	struct cfg80211_registered_device *dev;
+	struct net_device *netdev;
+	struct cfg80211_scan_result *scan;
+	int ifidx = cb->args[0];
+	int start = cb->args[1], idx = 0;
+	int err;
+
+	if (!ifidx) {
+		err = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl80211_fam.hdrsize,
+				  nl80211_fam.attrbuf, nl80211_fam.maxattr,
+				  nl80211_policy);
+		if (err)
+			return err;
+
+		if (!nl80211_fam.attrbuf[NL80211_ATTR_IFINDEX])
+			return -EINVAL;
+
+		ifidx = nla_get_u32(nl80211_fam.attrbuf[NL80211_ATTR_IFINDEX]);
+		if (!ifidx)
+			return -EINVAL;
+		cb->args[0] = ifidx;
+	}
+
+	netdev = dev_get_by_index(&init_net, ifidx);
+	if (!netdev)
+		return -ENODEV;
+
+	dev = cfg80211_get_dev_from_ifindex(ifidx);
+	if (IS_ERR(dev)) {
+		err = PTR_ERR(dev);
+		goto out_put_netdev;
+	}
+
+	spin_lock(&dev->scan_lock);
+	list_for_each_entry(scan, &dev->scan_list, list) {
+		if (++idx <= start)
+			continue;
+		if (nl80211_send_bss(skb,
+				NETLINK_CB(cb->skb).pid,
+				cb->nlh->nlmsg_seq, NLM_F_MULTI,
+				dev, netdev, scan) < 0) {
+			idx--;
+			goto out;
+		}
+	}
+
+ out:
+	spin_unlock(&dev->scan_lock);
+
+	cb->args[1] = idx;
+	err = skb->len;
+	cfg80211_put_dev(dev);
+ out_put_netdev:
+	dev_put(netdev);
+
+	return err;
+}
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -1902,12 +2128,26 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_TRIGGER_SCAN,
+		.doit = nl80211_trigger_scan,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_GET_SCAN,
+		.policy = nl80211_policy,
+		.dumpit = nl80211_dump_scan,
+	},
 };
 
 /* multicast groups */
 static struct genl_multicast_group nl80211_config_mcgrp = {
 	.name = "config",
 };
+static struct genl_multicast_group nl80211_scan_mcgrp = {
+	.name = "scan",
+};
 
 /* notification functions */
 
@@ -1927,6 +2167,48 @@ void nl80211_notify_dev_rename(struct cf
 	genlmsg_multicast(msg, 0, nl80211_config_mcgrp.id, GFP_KERNEL);
 }
 
+static int nl80211_send_scan_donemsg(struct sk_buff *msg,
+				    struct cfg80211_registered_device *rdev,
+				    struct net_device *netdev,
+				    u32 pid, u32 seq, int flags)
+{
+	void *hdr;
+
+	hdr = nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_SCAN);
+	if (!hdr)
+		return -1;
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+
+	/* XXX: I have no idea how to multicast large result sets */
+
+	/* XXX: we should probably just bounce back the request */
+
+	return genlmsg_end(msg, hdr);
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
+void nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
+			    struct net_device *netdev)
+{
+	struct sk_buff *msg;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	if (nl80211_send_scan_donemsg(msg, rdev, netdev, 0, 0, 0) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast(msg, 0, nl80211_scan_mcgrp.id, GFP_KERNEL);
+}
+
 /* initialisation/exit functions */
 
 int nl80211_init(void)
@@ -1947,6 +2229,10 @@ int nl80211_init(void)
 	if (err)
 		goto err_out;
 
+	err = genl_register_mc_group(&nl80211_fam, &nl80211_scan_mcgrp);
+	if (err)
+		goto err_out;
+
 	return 0;
  err_out:
 	genl_unregister_family(&nl80211_fam);
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ everything/net/wireless/scan.c	2008-09-19 15:14:16.000000000 +0200
@@ -0,0 +1,480 @@
+/*
+ * cfg80211 scan result handling
+ *
+ * Copyright 2008 Johannes Berg <johannes@sipsolutions.net>
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/wireless.h>
+#include <linux/nl80211.h>
+#include <net/arp.h>
+#include <net/cfg80211.h>
+#include <net/iw_handler.h>
+#include "core.h"
+#include "nl80211.h"
+
+#define IEEE80211_SCAN_RESULT_EXPIRE 10 * HZ
+
+void cfg80211_scan_done(struct cfg80211_scan_request *request)
+{
+	struct net_device *dev;
+#ifdef CONFIG_WIRELESS_EXT
+	union iwreq_data wrqu;
+#endif
+
+	dev = dev_get_by_index(&init_net, request->ifidx);
+	if (!dev)
+		goto out;
+
+	nl80211_send_scan_done(wiphy_to_dev(request->wiphy), dev);
+
+	WARN_ON(request != wiphy_to_dev(request->wiphy)->scan_req);
+	wiphy_to_dev(request->wiphy)->scan_req = NULL;
+
+#ifdef CONFIG_WIRELESS_EXT
+	memset(&wrqu, 0, sizeof(wrqu));
+
+	wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
+#endif
+
+	dev_put(dev);
+
+ out:
+	kfree(request);
+}
+EXPORT_SYMBOL(cfg80211_scan_done);
+
+static void cfg80211_scan_result_add(struct cfg80211_registered_device *dev,
+				     struct cfg80211_scan_result *res)
+{
+	if (WARN_ON(!res->channel)) {
+		kfree(res);
+		return;
+	}
+
+	res->ts = jiffies;
+
+	/* XXX This is horrible!! */
+
+	spin_lock(&dev->scan_lock);
+	list_add_tail(&res->list, &dev->scan_list);
+	dev->scan_generation++;
+	spin_unlock(&dev->scan_lock);
+}
+
+void cfg80211_scan_result(struct cfg80211_scan_request *request,
+			  struct cfg80211_scan_result *result,
+			  gfp_t gfp)
+{
+	struct cfg80211_scan_result *res;
+
+	res = kzalloc(sizeof(*res) + result->len_information_elements, gfp);
+	if (!res)
+		return;
+
+	memcpy(res, result, sizeof(*res));
+	res->information_elements = (char *)(res + 1);
+	memcpy(res->information_elements,
+	       result->information_elements,
+	       result->len_information_elements);
+
+	cfg80211_scan_result_add(wiphy_to_dev(request->wiphy), res);
+}
+EXPORT_SYMBOL(cfg80211_scan_result);
+
+void cfg80211_scan_result_frame(struct cfg80211_scan_request *request,
+				struct ieee80211_channel *channel,
+				struct ieee80211_mgmt *mgmt, size_t len,
+				gfp_t gfp)
+{
+	struct cfg80211_scan_result *res;
+	size_t ielen = len - offsetof(struct ieee80211_mgmt,
+				      u.probe_resp.variable);
+
+	if (WARN_ON(!mgmt || !request ||
+		    len < offsetof(struct ieee80211_mgmt, u.probe_resp.variable)))
+		return;
+
+	res = kzalloc(sizeof(*res) + ielen, gfp);
+	if (!res)
+		return;
+
+	memcpy(res->bssid, mgmt->bssid, ETH_ALEN);
+	res->channel = channel;
+	res->tsf = le64_to_cpu(mgmt->u.probe_resp.timestamp);
+	res->beacon_interval = le16_to_cpu(mgmt->u.probe_resp.beacon_int);
+	res->capability = le16_to_cpu(mgmt->u.probe_resp.capab_info);
+	res->information_elements = (char *)(res + 1);
+	memcpy(res->information_elements, mgmt->u.probe_resp.variable, ielen);
+	res->len_information_elements = ielen;
+
+	cfg80211_scan_result_add(wiphy_to_dev(request->wiphy), res);
+}
+EXPORT_SYMBOL(cfg80211_scan_result_frame);
+
+#ifdef CONFIG_WIRELESS_EXT
+int cfg80211_wext_siwscan(struct net_device *dev,
+			  struct iw_request_info *info,
+			  union iwreq_data *wrqu, char *extra)
+{
+	struct cfg80211_registered_device *rdev;
+	struct wiphy *wiphy;
+	struct iw_scan_req *wreq = NULL;
+	struct cfg80211_scan_request *creq;
+	int i, err, n_channels = 0;
+	enum ieee80211_band band;
+
+	if (!netif_running(dev))
+		return -ENETDOWN;
+
+	rdev = cfg80211_get_dev_from_ifindex(dev->ifindex);
+
+	if (IS_ERR(rdev))
+		return PTR_ERR(rdev);
+
+	if (rdev->scan_req) {
+		err = -EBUSY;
+		goto out;
+	}
+
+	wiphy = &rdev->wiphy;
+
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++)
+		if (wiphy->bands[band])
+			n_channels += wiphy->bands[band]->n_channels;
+
+	creq = kzalloc(sizeof(*creq) + sizeof(struct cfg80211_ssid) +
+		       n_channels * sizeof(void *),
+		       GFP_ATOMIC);
+	if (!creq) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	creq->wiphy = wiphy;
+	creq->ifidx = dev->ifindex;
+	creq->ssids = (void *)(creq + 1);
+	creq->channels = (void *)(creq->ssids + 1);
+	creq->n_channels = n_channels;
+	creq->n_ssids = 1;
+
+	/* all channels */
+	i = 0;
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		int j;
+		if (!wiphy->bands[band])
+			continue;
+		for (j = 0; j < wiphy->bands[band]->n_channels; j++) {
+			creq->channels[i] = &wiphy->bands[band]->channels[j];
+			i++;
+		}
+	}
+
+	/* translate scan request */
+	if (wrqu->data.length == sizeof(struct iw_scan_req)) {
+		wreq = (struct iw_scan_req *)extra;
+
+		if (wrqu->data.flags & IW_SCAN_THIS_ESSID) {
+			if (wreq->essid_len > IEEE80211_MAX_SSID_LEN)
+				return -EINVAL;
+			memcpy(creq->ssids[0].ssid, wreq->essid, wreq->essid_len);
+			creq->ssids[0].ssid_len = wreq->essid_len;
+		}
+		if (wreq->scan_type == IW_SCAN_TYPE_PASSIVE)
+			creq->n_ssids = 0;
+	}
+
+	rdev->scan_req = creq;
+	err = rdev->ops->scan(wiphy, dev, creq);
+	if (err) {
+		rdev->scan_req = NULL;
+		kfree(creq);
+	}
+ out:
+	cfg80211_put_dev(rdev);
+	return err;
+}
+EXPORT_SYMBOL(cfg80211_wext_siwscan);
+
+static void ieee80211_scan_add_ies(struct iw_request_info *info,
+				   struct cfg80211_scan_result *bss,
+				   char **current_ev, char *end_buf)
+{
+	u8 *pos, *end, *next;
+	struct iw_event iwe;
+
+	if (!bss->information_elements ||
+	    !bss->len_information_elements)
+		return;
+
+	/*
+	 * If needed, fragment the IEs buffer (at IE boundaries) into short
+	 * enough fragments to fit into IW_GENERIC_IE_MAX octet messages.
+	 */
+	pos = bss->information_elements;
+	end = pos + bss->len_information_elements;
+
+	while (end - pos > IW_GENERIC_IE_MAX) {
+		next = pos + 2 + pos[1];
+		while (next + 2 + next[1] - pos < IW_GENERIC_IE_MAX)
+			next = next + 2 + next[1];
+
+		memset(&iwe, 0, sizeof(iwe));
+		iwe.cmd = IWEVGENIE;
+		iwe.u.data.length = next - pos;
+		*current_ev = iwe_stream_add_point(info, *current_ev,
+						   end_buf, &iwe, pos);
+
+		pos = next;
+	}
+
+	if (end > pos) {
+		memset(&iwe, 0, sizeof(iwe));
+		iwe.cmd = IWEVGENIE;
+		iwe.u.data.length = end - pos;
+		*current_ev = iwe_stream_add_point(info, *current_ev,
+						   end_buf, &iwe, pos);
+	}
+}
+
+
+static char *
+ieee80211_scan_result(struct iw_request_info *info,
+		      struct cfg80211_scan_result *bss,
+		      char *current_ev, char *end_buf)
+{
+	struct iw_event iwe;
+	u8 *buf, *cfg, *p;
+	u8 *ie = bss->information_elements;
+	int rem = bss->len_information_elements, i;
+	bool ismesh = false;
+
+	if (time_after(jiffies, bss->ts + IEEE80211_SCAN_RESULT_EXPIRE))
+		return current_ev;
+
+	memset(&iwe, 0, sizeof(iwe));
+	iwe.cmd = SIOCGIWAP;
+	iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
+	memcpy(iwe.u.ap_addr.sa_data, bss->bssid, ETH_ALEN);
+	current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe,
+					  IW_EV_ADDR_LEN);
+
+	memset(&iwe, 0, sizeof(iwe));
+	iwe.cmd = SIOCGIWFREQ;
+	iwe.u.freq.m = ieee80211_frequency_to_channel(bss->channel->center_freq);
+	iwe.u.freq.e = 0;
+	current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe,
+					  IW_EV_FREQ_LEN);
+
+	memset(&iwe, 0, sizeof(iwe));
+	iwe.cmd = SIOCGIWFREQ;
+	iwe.u.freq.m = bss->channel->center_freq;
+	iwe.u.freq.e = 6;
+	current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe,
+					  IW_EV_FREQ_LEN);
+
+	memset(&iwe, 0, sizeof(iwe));
+	iwe.cmd = IWEVQUAL;
+#if 0
+	iwe.u.qual.qual = bss->qual;
+	iwe.u.qual.level = bss->signal;
+	iwe.u.qual.noise = bss->noise;
+	iwe.u.qual.updated = 0; /* XXXX */
+#endif
+	current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe,
+					  IW_EV_QUAL_LEN);
+
+	memset(&iwe, 0, sizeof(iwe));
+	iwe.cmd = SIOCGIWENCODE;
+	if (bss->capability & WLAN_CAPABILITY_PRIVACY)
+		iwe.u.data.flags = IW_ENCODE_ENABLED | IW_ENCODE_NOKEY;
+	else
+		iwe.u.data.flags = IW_ENCODE_DISABLED;
+	iwe.u.data.length = 0;
+	current_ev = iwe_stream_add_point(info, current_ev, end_buf,
+					  &iwe, "");
+
+	while (rem >= 2) {
+		/* invalid data */
+		if (ie[1] > rem - 2)
+			break;
+
+		switch (ie[0]) {
+		case WLAN_EID_SSID:
+			memset(&iwe, 0, sizeof(iwe));
+			iwe.cmd = SIOCGIWESSID;
+			iwe.u.data.length = ie[1];
+			iwe.u.data.flags = 1;
+			current_ev = iwe_stream_add_point(info, current_ev, end_buf,
+							  &iwe, ie + 2);
+			break;
+		case WLAN_EID_MESH_ID:
+			memset(&iwe, 0, sizeof(iwe));
+			iwe.cmd = SIOCGIWESSID;
+			iwe.u.data.length = ie[1];
+			iwe.u.data.flags = 1;
+			current_ev = iwe_stream_add_point(info, current_ev, end_buf,
+							  &iwe, ie + 2);
+			break;
+		case WLAN_EID_MESH_CONFIG:
+			ismesh = true;
+			buf = kmalloc(50, GFP_ATOMIC);
+			if (ie[1] != 19 /* XXX: MESH_CFG_LEN */)
+				break;
+			if (!buf)
+				break;
+			cfg = ie + 2;
+			memset(&iwe, 0, sizeof(iwe));
+			iwe.cmd = IWEVCUSTOM;
+			sprintf(buf, "Mesh network (version %d)", cfg[0]);
+			iwe.u.data.length = strlen(buf);
+			current_ev = iwe_stream_add_point(info, current_ev,
+							  end_buf,
+							  &iwe, buf);
+			sprintf(buf, "Path Selection Protocol ID: "
+				"0x%02X%02X%02X%02X", cfg[1], cfg[2], cfg[3],
+							cfg[4]);
+			iwe.u.data.length = strlen(buf);
+			current_ev = iwe_stream_add_point(info, current_ev,
+							  end_buf,
+							  &iwe, buf);
+			sprintf(buf, "Path Selection Metric ID: "
+				"0x%02X%02X%02X%02X", cfg[5], cfg[6], cfg[7],
+							cfg[8]);
+			iwe.u.data.length = strlen(buf);
+			current_ev = iwe_stream_add_point(info, current_ev,
+							  end_buf,
+							  &iwe, buf);
+			sprintf(buf, "Congestion Control Mode ID: "
+				"0x%02X%02X%02X%02X", cfg[9], cfg[10],
+							cfg[11], cfg[12]);
+			iwe.u.data.length = strlen(buf);
+			current_ev = iwe_stream_add_point(info, current_ev,
+							  end_buf,
+							  &iwe, buf);
+			sprintf(buf, "Channel Precedence: "
+				"0x%02X%02X%02X%02X", cfg[13], cfg[14],
+							cfg[15], cfg[16]);
+			iwe.u.data.length = strlen(buf);
+			current_ev = iwe_stream_add_point(info, current_ev,
+							  end_buf,
+							  &iwe, buf);
+			kfree(buf);
+			break;
+		case WLAN_EID_SUPP_RATES:
+		case WLAN_EID_EXT_SUPP_RATES:
+			/* display all supported rates in readable format */
+			p = current_ev + iwe_stream_lcp_len(info);
+
+			memset(&iwe, 0, sizeof(iwe));
+			iwe.cmd = SIOCGIWRATE;
+			/* Those two flags are ignored... */
+			iwe.u.bitrate.fixed = iwe.u.bitrate.disabled = 0;
+
+			for (i = 0; i < ie[1]; i++) {
+				iwe.u.bitrate.value =
+					((ie[i + 2] & 0x7f) * 500000);
+				p = iwe_stream_add_value(info, current_ev, p,
+						end_buf, &iwe, IW_EV_PARAM_LEN);
+			}
+			current_ev = p;
+			break;
+		}
+		rem -= ie[1] + 2;
+		ie += ie[1] + 2;
+	}
+
+	if (bss->capability & (WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_IBSS)
+	    || ismesh) {
+		memset(&iwe, 0, sizeof(iwe));
+		iwe.cmd = SIOCGIWMODE;
+		if (ismesh)
+			iwe.u.mode = IW_MODE_MESH;
+		else if (bss->capability & WLAN_CAPABILITY_ESS)
+			iwe.u.mode = IW_MODE_MASTER;
+		else
+			iwe.u.mode = IW_MODE_ADHOC;
+		current_ev = iwe_stream_add_event(info, current_ev, end_buf,
+						  &iwe, IW_EV_UINT_LEN);
+	}
+
+	buf = kmalloc(30, GFP_ATOMIC);
+	if (buf) {
+		memset(&iwe, 0, sizeof(iwe));
+		iwe.cmd = IWEVCUSTOM;
+		sprintf(buf, "tsf=%016llx", (unsigned long long)(bss->tsf));
+		iwe.u.data.length = strlen(buf);
+		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
+						  &iwe, buf);
+		memset(&iwe, 0, sizeof(iwe));
+		iwe.cmd = IWEVCUSTOM;
+		sprintf(buf, " Last beacon: %dms ago",
+			jiffies_to_msecs(jiffies - bss->ts));
+		iwe.u.data.length = strlen(buf);
+		current_ev = iwe_stream_add_point(info, current_ev,
+						  end_buf, &iwe, buf);
+		kfree(buf);
+	}
+
+	ieee80211_scan_add_ies(info, bss, &current_ev, end_buf);
+
+	return current_ev;
+}
+
+
+int ieee80211_scan_results(struct cfg80211_registered_device *dev,
+			   struct iw_request_info *info,
+			   char *buf, size_t len)
+{
+	char *current_ev = buf;
+	char *end_buf = buf + len;
+	struct cfg80211_scan_result *bss;
+
+	spin_lock_bh(&dev->scan_lock);
+	list_for_each_entry(bss, &dev->scan_list, list) {
+		if (buf + len - current_ev <= IW_EV_ADDR_LEN) {
+			spin_unlock_bh(&dev->scan_lock);
+			return -E2BIG;
+		}
+		current_ev = ieee80211_scan_result(info, bss,
+						   current_ev, end_buf);
+	}
+	spin_unlock_bh(&dev->scan_lock);
+	return current_ev - buf;
+}
+
+
+int cfg80211_wext_giwscan(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_point *data, char *extra)
+{
+	struct cfg80211_registered_device *rdev;
+	int res;
+
+	if (!netif_running(dev))
+		return -ENETDOWN;
+
+	rdev = cfg80211_get_dev_from_ifindex(dev->ifindex);
+
+	if (IS_ERR(rdev))
+		return PTR_ERR(rdev);
+
+	if (rdev->scan_req) {
+		res = -EAGAIN;
+		goto out;
+	}
+
+	res = ieee80211_scan_results(rdev, info, extra, data->length);
+	data->length = 0;
+	if (res >= 0) {
+		data->length = res;
+		res = 0;
+	}
+
+ out:
+	cfg80211_put_dev(rdev);
+	return res;
+}
+EXPORT_SYMBOL(cfg80211_wext_giwscan);
+#endif
--- everything.orig/net/mac80211/ieee80211_i.h	2008-09-19 05:09:31.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-09-19 05:15:31.000000000 +0200
@@ -651,16 +651,20 @@ struct ieee80211_local {
 
 	/* Scanning and BSS list */
 	bool sw_scanning, hw_scanning;
+	char scan_ssid_value[IEEE80211_MAX_SSID_LEN];
+	struct cfg80211_ssid scan_ssid;
+	struct cfg80211_scan_request int_scan_req;
+	struct cfg80211_scan_request *scan_req;
+	struct ieee80211_channel *scan_channel;
 	int scan_channel_idx;
-	enum ieee80211_band scan_band;
 
 	enum { SCAN_SET_CHANNEL, SCAN_SEND_PROBE } scan_state;
 	unsigned long last_scan_completed;
 	struct delayed_work scan_work;
 	struct ieee80211_sub_if_data *scan_sdata;
-	struct ieee80211_channel *oper_channel, *scan_channel;
-	u8 scan_ssid[IEEE80211_MAX_SSID_LEN];
-	size_t scan_ssid_len;
+
+	struct ieee80211_channel *oper_channel;
+
 	struct list_head bss_list;
 	struct ieee80211_bss *bss_hash[STA_HASH_SIZE];
 	spinlock_t bss_lock;
@@ -921,7 +925,7 @@ void ieee80211_send_probe_req(struct iee
 
 /* scan/BSS handling */
 int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
-			   u8 *ssid, size_t ssid_len);
+			   struct cfg80211_scan_request *req);
 int ieee80211_scan_results(struct ieee80211_local *local,
 			   struct iw_request_info *info,
 			   char *buf, size_t len);
@@ -936,7 +940,7 @@ int ieee80211_sta_set_extra_ie(struct ie
 
 void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local);
 int ieee80211_start_scan(struct ieee80211_sub_if_data *scan_sdata,
-			 u8 *ssid, size_t ssid_len);
+			 struct cfg80211_scan_request *req);
 struct ieee80211_bss *
 ieee80211_bss_info_update(struct ieee80211_local *local,
 			  struct ieee80211_rx_status *rx_status,
--- everything.orig/net/mac80211/scan.c	2008-09-19 05:09:31.000000000 +0200
+++ everything/net/mac80211/scan.c	2008-09-19 15:14:03.000000000 +0200
@@ -21,7 +21,6 @@
 #include <linux/wireless.h>
 #include <linux/if_arp.h>
 #include <net/mac80211.h>
-#include <net/iw_handler.h>
 
 #include "ieee80211_i.h"
 #include "mesh.h"
@@ -330,6 +329,7 @@ ieee80211_rx_result
 ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 		  struct ieee80211_rx_status *rx_status)
 {
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_mgmt *mgmt;
 	struct ieee80211_bss *bss;
 	u8 *elements;
@@ -385,6 +385,10 @@ ieee80211_scan_rx(struct ieee80211_sub_i
 	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
 		return RX_DROP_MONITOR;
 
+	if (local->scan_req && local->scan_req != &local->int_scan_req)
+		cfg80211_scan_result_frame(local->scan_req, channel,
+					   mgmt, skb->len, GFP_ATOMIC);
+
 	bss = ieee80211_bss_info_update(sdata->local, rx_status,
 					mgmt, skb->len, &elems,
 					freq, beacon);
@@ -428,22 +432,18 @@ void ieee80211_scan_completed(struct iee
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
-	union iwreq_data wrqu;
 
 	if (WARN_ON(!local->hw_scanning && !local->sw_scanning))
 		return;
 
-	local->last_scan_completed = jiffies;
-	memset(&wrqu, 0, sizeof(wrqu));
+	if (WARN_ON(!local->scan_req))
+		return;
 
-	/*
-	 * local->scan_sdata could have been NULLed by the interface
-	 * down code in case we were scanning on an interface that is
-	 * being taken down.
-	 */
-	sdata = local->scan_sdata;
-	if (sdata)
-		wireless_send_event(sdata->dev, SIOCGIWSCAN, &wrqu, NULL);
+	if (local->scan_req != &local->int_scan_req)
+		cfg80211_scan_done(local->scan_req);
+	local->scan_req = NULL;
+
+	local->last_scan_completed = jiffies;
 
 	if (local->hw_scanning) {
 		local->hw_scanning = false;
@@ -497,9 +497,8 @@ void ieee80211_scan_work(struct work_str
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local, scan_work.work);
 	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
-	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *chan;
-	int skip;
+	int skip, i;
 	unsigned long next_delay = 0;
 
 	/*
@@ -510,33 +509,13 @@ void ieee80211_scan_work(struct work_str
 
 	switch (local->scan_state) {
 	case SCAN_SET_CHANNEL:
-		/*
-		 * Get current scan band. scan_band may be IEEE80211_NUM_BANDS
-		 * after we successfully scanned the last channel of the last
-		 * band (and the last band is supported by the hw)
-		 */
-		if (local->scan_band < IEEE80211_NUM_BANDS)
-			sband = local->hw.wiphy->bands[local->scan_band];
-		else
-			sband = NULL;
-
-		/*
-		 * If we are at an unsupported band and have more bands
-		 * left to scan, advance to the next supported one.
-		 */
-		while (!sband && local->scan_band < IEEE80211_NUM_BANDS - 1) {
-			local->scan_band++;
-			sband = local->hw.wiphy->bands[local->scan_band];
-			local->scan_channel_idx = 0;
-		}
-
 		/* if no more bands/channels left, complete scan */
-		if (!sband || local->scan_channel_idx >= sband->n_channels) {
+		if (local->scan_channel_idx >= local->scan_req->n_channels) {
 			ieee80211_scan_completed(local_to_hw(local));
 			return;
 		}
 		skip = 0;
-		chan = &sband->channels[local->scan_channel_idx];
+		chan = local->scan_req->channels[local->scan_channel_idx];
 
 		if (chan->flags & IEEE80211_CHAN_DISABLED ||
 		    (sdata->vif.type == NL80211_IFTYPE_ADHOC &&
@@ -555,15 +534,6 @@ void ieee80211_scan_work(struct work_str
 
 		/* advance state machine to next channel/band */
 		local->scan_channel_idx++;
-		if (local->scan_channel_idx >= sband->n_channels) {
-			/*
-			 * scan_band may end up == IEEE80211_NUM_BANDS, but
-			 * we'll catch that case above and complete the scan
-			 * if that is the case.
-			 */
-			local->scan_band++;
-			local->scan_channel_idx = 0;
-		}
 
 		if (skip)
 			break;
@@ -576,10 +546,14 @@ void ieee80211_scan_work(struct work_str
 		next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
 		local->scan_state = SCAN_SET_CHANNEL;
 
-		if (local->scan_channel->flags & IEEE80211_CHAN_PASSIVE_SCAN)
+		if (local->scan_channel->flags & IEEE80211_CHAN_PASSIVE_SCAN ||
+		    !local->scan_req->n_ssids)
 			break;
-		ieee80211_send_probe_req(sdata, NULL, local->scan_ssid,
-					 local->scan_ssid_len);
+		for (i=0; i < local->scan_req->n_ssids; i++)
+			ieee80211_send_probe_req(
+				sdata, NULL,
+				local->scan_req->ssids[i].ssid,
+				local->scan_req->ssids[i].ssid_len);
 		next_delay = IEEE80211_CHANNEL_TIME;
 		break;
 	}
@@ -590,14 +564,19 @@ void ieee80211_scan_work(struct work_str
 
 
 int ieee80211_start_scan(struct ieee80211_sub_if_data *scan_sdata,
-			 u8 *ssid, size_t ssid_len)
+			 struct cfg80211_scan_request *req)
 {
 	struct ieee80211_local *local = scan_sdata->local;
 	struct ieee80211_sub_if_data *sdata;
 
-	if (ssid_len > IEEE80211_MAX_SSID_LEN)
+	if (!req)
 		return -EINVAL;
 
+	if (local->scan_req && local->scan_req != req)
+		return -EBUSY;
+
+	local->scan_req = req;
+
 	/* MLME-SCAN.request (page 118)  page 144 (11.1.3.1)
 	 * BSSType: INFRASTRUCTURE, INDEPENDENT, ANY_BSS
 	 * BSSID: MACAddress
@@ -625,7 +604,7 @@ int ieee80211_start_scan(struct ieee8021
 		int rc;
 
 		local->hw_scanning = true;
-		rc = local->ops->hw_scan(local_to_hw(local), ssid, ssid_len);
+		rc = local->ops->hw_scan(local_to_hw(local), req);
 		if (rc) {
 			local->hw_scanning = false;
 			return rc;
@@ -648,15 +627,10 @@ int ieee80211_start_scan(struct ieee8021
 	}
 	rcu_read_unlock();
 
-	if (ssid) {
-		local->scan_ssid_len = ssid_len;
-		memcpy(local->scan_ssid, ssid, ssid_len);
-	} else
-		local->scan_ssid_len = 0;
 	local->scan_state = SCAN_SET_CHANNEL;
 	local->scan_channel_idx = 0;
-	local->scan_band = IEEE80211_BAND_2GHZ;
 	local->scan_sdata = scan_sdata;
+	local->scan_req = req;
 
 	netif_addr_lock_bh(local->mdev);
 	local->filter_flags |= FIF_BCN_PRBRESP_PROMISC;
@@ -676,13 +650,21 @@ int ieee80211_start_scan(struct ieee8021
 
 
 int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
-			   u8 *ssid, size_t ssid_len)
+			   struct cfg80211_scan_request *req)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_sta *ifsta;
 
+	if (!req)
+		return -EINVAL;
+
+	if (local->scan_req && local->scan_req != req)
+		return -EBUSY;
+
+	local->scan_req = req;
+
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
-		return ieee80211_start_scan(sdata, ssid, ssid_len);
+		return ieee80211_start_scan(sdata, req);
 
 	/*
 	 * STA has a state machine that might need to defer scanning
@@ -697,241 +679,8 @@ int ieee80211_request_scan(struct ieee80
 	}
 
 	ifsta = &sdata->u.sta;
-
-	ifsta->scan_ssid_len = ssid_len;
-	if (ssid_len)
-		memcpy(ifsta->scan_ssid, ssid, ssid_len);
 	set_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request);
 	queue_work(local->hw.workqueue, &ifsta->work);
 
 	return 0;
 }
-
-
-static void ieee80211_scan_add_ies(struct iw_request_info *info,
-				   struct ieee80211_bss *bss,
-				   char **current_ev, char *end_buf)
-{
-	u8 *pos, *end, *next;
-	struct iw_event iwe;
-
-	if (bss == NULL || bss->ies == NULL)
-		return;
-
-	/*
-	 * If needed, fragment the IEs buffer (at IE boundaries) into short
-	 * enough fragments to fit into IW_GENERIC_IE_MAX octet messages.
-	 */
-	pos = bss->ies;
-	end = pos + bss->ies_len;
-
-	while (end - pos > IW_GENERIC_IE_MAX) {
-		next = pos + 2 + pos[1];
-		while (next + 2 + next[1] - pos < IW_GENERIC_IE_MAX)
-			next = next + 2 + next[1];
-
-		memset(&iwe, 0, sizeof(iwe));
-		iwe.cmd = IWEVGENIE;
-		iwe.u.data.length = next - pos;
-		*current_ev = iwe_stream_add_point(info, *current_ev,
-						   end_buf, &iwe, pos);
-
-		pos = next;
-	}
-
-	if (end > pos) {
-		memset(&iwe, 0, sizeof(iwe));
-		iwe.cmd = IWEVGENIE;
-		iwe.u.data.length = end - pos;
-		*current_ev = iwe_stream_add_point(info, *current_ev,
-						   end_buf, &iwe, pos);
-	}
-}
-
-
-static char *
-ieee80211_scan_result(struct ieee80211_local *local,
-		      struct iw_request_info *info,
-		      struct ieee80211_bss *bss,
-		      char *current_ev, char *end_buf)
-{
-	struct iw_event iwe;
-	char *buf;
-
-	if (time_after(jiffies,
-		       bss->last_update + IEEE80211_SCAN_RESULT_EXPIRE))
-		return current_ev;
-
-	memset(&iwe, 0, sizeof(iwe));
-	iwe.cmd = SIOCGIWAP;
-	iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
-	memcpy(iwe.u.ap_addr.sa_data, bss->bssid, ETH_ALEN);
-	current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe,
-					  IW_EV_ADDR_LEN);
-
-	memset(&iwe, 0, sizeof(iwe));
-	iwe.cmd = SIOCGIWESSID;
-	if (bss_mesh_cfg(bss)) {
-		iwe.u.data.length = bss_mesh_id_len(bss);
-		iwe.u.data.flags = 1;
-		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-						  &iwe, bss_mesh_id(bss));
-	} else {
-		iwe.u.data.length = bss->ssid_len;
-		iwe.u.data.flags = 1;
-		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-						  &iwe, bss->ssid);
-	}
-
-	if (bss->capability & (WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_IBSS)
-	    || bss_mesh_cfg(bss)) {
-		memset(&iwe, 0, sizeof(iwe));
-		iwe.cmd = SIOCGIWMODE;
-		if (bss_mesh_cfg(bss))
-			iwe.u.mode = IW_MODE_MESH;
-		else if (bss->capability & WLAN_CAPABILITY_ESS)
-			iwe.u.mode = IW_MODE_MASTER;
-		else
-			iwe.u.mode = IW_MODE_ADHOC;
-		current_ev = iwe_stream_add_event(info, current_ev, end_buf,
-						  &iwe, IW_EV_UINT_LEN);
-	}
-
-	memset(&iwe, 0, sizeof(iwe));
-	iwe.cmd = SIOCGIWFREQ;
-	iwe.u.freq.m = ieee80211_frequency_to_channel(bss->freq);
-	iwe.u.freq.e = 0;
-	current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe,
-					  IW_EV_FREQ_LEN);
-
-	memset(&iwe, 0, sizeof(iwe));
-	iwe.cmd = SIOCGIWFREQ;
-	iwe.u.freq.m = bss->freq;
-	iwe.u.freq.e = 6;
-	current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe,
-					  IW_EV_FREQ_LEN);
-	memset(&iwe, 0, sizeof(iwe));
-	iwe.cmd = IWEVQUAL;
-	iwe.u.qual.qual = bss->qual;
-	iwe.u.qual.level = bss->signal;
-	iwe.u.qual.noise = bss->noise;
-	iwe.u.qual.updated = local->wstats_flags;
-	current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe,
-					  IW_EV_QUAL_LEN);
-
-	memset(&iwe, 0, sizeof(iwe));
-	iwe.cmd = SIOCGIWENCODE;
-	if (bss->capability & WLAN_CAPABILITY_PRIVACY)
-		iwe.u.data.flags = IW_ENCODE_ENABLED | IW_ENCODE_NOKEY;
-	else
-		iwe.u.data.flags = IW_ENCODE_DISABLED;
-	iwe.u.data.length = 0;
-	current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-					  &iwe, "");
-
-	ieee80211_scan_add_ies(info, bss, &current_ev, end_buf);
-
-	if (bss->supp_rates_len > 0) {
-		/* display all supported rates in readable format */
-		char *p = current_ev + iwe_stream_lcp_len(info);
-		int i;
-
-		memset(&iwe, 0, sizeof(iwe));
-		iwe.cmd = SIOCGIWRATE;
-		/* Those two flags are ignored... */
-		iwe.u.bitrate.fixed = iwe.u.bitrate.disabled = 0;
-
-		for (i = 0; i < bss->supp_rates_len; i++) {
-			iwe.u.bitrate.value = ((bss->supp_rates[i] &
-							0x7f) * 500000);
-			p = iwe_stream_add_value(info, current_ev, p,
-					end_buf, &iwe, IW_EV_PARAM_LEN);
-		}
-		current_ev = p;
-	}
-
-	buf = kmalloc(30, GFP_ATOMIC);
-	if (buf) {
-		memset(&iwe, 0, sizeof(iwe));
-		iwe.cmd = IWEVCUSTOM;
-		sprintf(buf, "tsf=%016llx", (unsigned long long)(bss->timestamp));
-		iwe.u.data.length = strlen(buf);
-		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-						  &iwe, buf);
-		memset(&iwe, 0, sizeof(iwe));
-		iwe.cmd = IWEVCUSTOM;
-		sprintf(buf, " Last beacon: %dms ago",
-			jiffies_to_msecs(jiffies - bss->last_update));
-		iwe.u.data.length = strlen(buf);
-		current_ev = iwe_stream_add_point(info, current_ev,
-						  end_buf, &iwe, buf);
-		kfree(buf);
-	}
-
-	if (bss_mesh_cfg(bss)) {
-		u8 *cfg = bss_mesh_cfg(bss);
-		buf = kmalloc(50, GFP_ATOMIC);
-		if (buf) {
-			memset(&iwe, 0, sizeof(iwe));
-			iwe.cmd = IWEVCUSTOM;
-			sprintf(buf, "Mesh network (version %d)", cfg[0]);
-			iwe.u.data.length = strlen(buf);
-			current_ev = iwe_stream_add_point(info, current_ev,
-							  end_buf,
-							  &iwe, buf);
-			sprintf(buf, "Path Selection Protocol ID: "
-				"0x%02X%02X%02X%02X", cfg[1], cfg[2], cfg[3],
-							cfg[4]);
-			iwe.u.data.length = strlen(buf);
-			current_ev = iwe_stream_add_point(info, current_ev,
-							  end_buf,
-							  &iwe, buf);
-			sprintf(buf, "Path Selection Metric ID: "
-				"0x%02X%02X%02X%02X", cfg[5], cfg[6], cfg[7],
-							cfg[8]);
-			iwe.u.data.length = strlen(buf);
-			current_ev = iwe_stream_add_point(info, current_ev,
-							  end_buf,
-							  &iwe, buf);
-			sprintf(buf, "Congestion Control Mode ID: "
-				"0x%02X%02X%02X%02X", cfg[9], cfg[10],
-							cfg[11], cfg[12]);
-			iwe.u.data.length = strlen(buf);
-			current_ev = iwe_stream_add_point(info, current_ev,
-							  end_buf,
-							  &iwe, buf);
-			sprintf(buf, "Channel Precedence: "
-				"0x%02X%02X%02X%02X", cfg[13], cfg[14],
-							cfg[15], cfg[16]);
-			iwe.u.data.length = strlen(buf);
-			current_ev = iwe_stream_add_point(info, current_ev,
-							  end_buf,
-							  &iwe, buf);
-			kfree(buf);
-		}
-	}
-
-	return current_ev;
-}
-
-
-int ieee80211_scan_results(struct ieee80211_local *local,
-			   struct iw_request_info *info,
-			   char *buf, size_t len)
-{
-	char *current_ev = buf;
-	char *end_buf = buf + len;
-	struct ieee80211_bss *bss;
-
-	spin_lock_bh(&local->bss_lock);
-	list_for_each_entry(bss, &local->bss_list, list) {
-		if (buf + len - current_ev <= IW_EV_ADDR_LEN) {
-			spin_unlock_bh(&local->bss_lock);
-			return -E2BIG;
-		}
-		current_ev = ieee80211_scan_result(local, info, bss,
-						       current_ev, end_buf);
-	}
-	spin_unlock_bh(&local->bss_lock);
-	return current_ev - buf;
-}
--- everything.orig/net/mac80211/wext.c	2008-09-19 05:09:31.000000000 +0200
+++ everything/net/mac80211/wext.c	2008-09-19 13:43:08.000000000 +0200
@@ -526,59 +526,6 @@ static int ieee80211_ioctl_giwap(struct 
 }
 
 
-static int ieee80211_ioctl_siwscan(struct net_device *dev,
-				   struct iw_request_info *info,
-				   union iwreq_data *wrqu, char *extra)
-{
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct iw_scan_req *req = NULL;
-	u8 *ssid = NULL;
-	size_t ssid_len = 0;
-
-	if (!netif_running(dev))
-		return -ENETDOWN;
-
-	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
-	    sdata->vif.type != NL80211_IFTYPE_ADHOC &&
-	    sdata->vif.type != NL80211_IFTYPE_MESH_POINT &&
-	    sdata->vif.type != NL80211_IFTYPE_AP)
-		return -EOPNOTSUPP;
-
-	/* if SSID was specified explicitly then use that */
-	if (wrqu->data.length == sizeof(struct iw_scan_req) &&
-	    wrqu->data.flags & IW_SCAN_THIS_ESSID) {
-		req = (struct iw_scan_req *)extra;
-		ssid = req->essid;
-		ssid_len = req->essid_len;
-	}
-
-	return ieee80211_request_scan(sdata, ssid, ssid_len);
-}
-
-
-static int ieee80211_ioctl_giwscan(struct net_device *dev,
-				   struct iw_request_info *info,
-				   struct iw_point *data, char *extra)
-{
-	int res;
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	if (local->sw_scanning || local->hw_scanning)
-		return -EAGAIN;
-
-	res = ieee80211_scan_results(local, info, extra, data->length);
-	if (res >= 0) {
-		data->length = res;
-		return 0;
-	}
-	data->length = 0;
-	return res;
-}
-
-
 static int ieee80211_ioctl_siwrate(struct net_device *dev,
 				  struct iw_request_info *info,
 				  struct iw_param *rate, char *extra)
@@ -1191,8 +1138,8 @@ static const iw_handler ieee80211_handle
 	(iw_handler) ieee80211_ioctl_giwap,		/* SIOCGIWAP */
 	(iw_handler) ieee80211_ioctl_siwmlme,		/* SIOCSIWMLME */
 	(iw_handler) NULL,				/* SIOCGIWAPLIST */
-	(iw_handler) ieee80211_ioctl_siwscan,		/* SIOCSIWSCAN */
-	(iw_handler) ieee80211_ioctl_giwscan,		/* SIOCGIWSCAN */
+	(iw_handler) cfg80211_wext_siwscan,		/* SIOCSIWSCAN */
+	(iw_handler) cfg80211_wext_giwscan,		/* SIOCGIWSCAN */
 	(iw_handler) ieee80211_ioctl_siwessid,		/* SIOCSIWESSID */
 	(iw_handler) ieee80211_ioctl_giwessid,		/* SIOCGIWESSID */
 	(iw_handler) NULL,				/* SIOCSIWNICKN */
--- everything.orig/net/mac80211/mlme.c	2008-09-19 05:09:31.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-19 05:15:31.000000000 +0200
@@ -1903,7 +1903,15 @@ static void ieee80211_sta_merge_ibss(str
 
 	printk(KERN_DEBUG "%s: No active IBSS STAs - trying to scan for other "
 	       "IBSS networks with same SSID (merge)\n", sdata->dev->name);
-	ieee80211_request_scan(sdata, ifsta->ssid, ifsta->ssid_len);
+
+	/* XXX maybe racy? */
+	if (sdata->local->scan_req)
+		return;
+
+	memcpy(sdata->local->int_scan_req.ssids[0].ssid,
+	       ifsta->ssid, IEEE80211_MAX_SSID_LEN);
+	sdata->local->int_scan_req.ssids[0].ssid_len = ifsta->ssid_len;
+	ieee80211_request_scan(sdata, &sdata->local->int_scan_req);
 }
 
 
@@ -2120,8 +2128,15 @@ dont_join:
 			      IEEE80211_SCAN_INTERVAL)) {
 		printk(KERN_DEBUG "%s: Trigger new scan to find an IBSS to "
 		       "join\n", sdata->dev->name);
-		return ieee80211_request_scan(sdata, ifsta->ssid,
-					      ifsta->ssid_len);
+
+		/* XXX maybe racy? */
+		if (local->scan_req)
+			return -EBUSY;
+
+		memcpy(local->int_scan_req.ssids[0].ssid,
+		       ifsta->ssid, IEEE80211_MAX_SSID_LEN);
+		local->int_scan_req.ssids[0].ssid_len = ifsta->ssid_len;
+		return ieee80211_request_scan(sdata, &local->int_scan_req);
 	} else if (ifsta->state != IEEE80211_STA_MLME_IBSS_JOINED) {
 		int interval = IEEE80211_SCAN_INTERVAL;
 
@@ -2216,11 +2231,16 @@ static int ieee80211_sta_config_auth(str
 	} else {
 		if (ifsta->assoc_scan_tries < IEEE80211_ASSOC_SCANS_MAX_TRIES) {
 			ifsta->assoc_scan_tries++;
+			/* XXX maybe racy? */
+			if (local->scan_req)
+				return -1;
+			memcpy(local->int_scan_req.ssids[0].ssid,
+			       ifsta->ssid, IEEE80211_MAX_SSID_LEN);
 			if (ifsta->flags & IEEE80211_STA_AUTO_SSID_SEL)
-				ieee80211_start_scan(sdata, NULL, 0);
+				local->int_scan_req.ssids[0].ssid_len = 0;
 			else
-				ieee80211_start_scan(sdata, ifsta->ssid,
-							 ifsta->ssid_len);
+				local->int_scan_req.ssids[0].ssid_len = ifsta->ssid_len;
+			ieee80211_start_scan(sdata, &local->int_scan_req);
 			ifsta->state = IEEE80211_STA_MLME_AUTHENTICATE;
 			set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
 		} else
@@ -2256,8 +2276,7 @@ static void ieee80211_sta_work(struct wo
 	    ifsta->state != IEEE80211_STA_MLME_AUTHENTICATE &&
 	    ifsta->state != IEEE80211_STA_MLME_ASSOCIATE &&
 	    test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request)) {
-		ieee80211_start_scan(sdata, ifsta->scan_ssid,
-				     ifsta->scan_ssid_len);
+		ieee80211_start_scan(sdata, local->scan_req);
 		return;
 	}
 
--- everything.orig/net/mac80211/cfg.c	2008-09-19 05:09:31.000000000 +0200
+++ everything/net/mac80211/cfg.c	2008-09-19 13:45:50.000000000 +0200
@@ -993,6 +993,29 @@ static int ieee80211_change_bss(struct w
 	return 0;
 }
 
+static int ieee80211_scan(struct wiphy *wiphy,
+			  struct net_device *dev,
+			  struct cfg80211_scan_request *req)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	if (!netif_running(dev))
+		return -ENETDOWN;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
+	    sdata->vif.type != NL80211_IFTYPE_ADHOC &&
+	    sdata->vif.type != NL80211_IFTYPE_MESH_POINT &&
+	    sdata->vif.type != NL80211_IFTYPE_AP)
+		return -EOPNOTSUPP;
+
+	if (req->n_ssids != 1)
+		return -EINVAL;
+
+	return ieee80211_request_scan(sdata, req);
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -1017,4 +1040,5 @@ struct cfg80211_ops mac80211_config_ops 
 	.dump_mpath = ieee80211_dump_mpath,
 #endif
 	.change_bss = ieee80211_change_bss,
+	.scan = ieee80211_scan,
 };
--- everything.orig/net/wireless/Makefile	2008-09-19 05:09:30.000000000 +0200
+++ everything/net/wireless/Makefile	2008-09-19 05:15:31.000000000 +0200
@@ -1,5 +1,5 @@
 obj-$(CONFIG_WIRELESS_EXT) += wext.o
 obj-$(CONFIG_CFG80211) += cfg80211.o
 
-cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o
+cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o
 cfg80211-$(CONFIG_NL80211) += nl80211.o
--- everything.orig/net/mac80211/main.c	2008-09-19 05:09:31.000000000 +0200
+++ everything/net/mac80211/main.c	2008-09-19 13:12:13.000000000 +0200
@@ -736,6 +736,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 		return NULL;
 
 	wiphy->privid = mac80211_wiphy_privid;
+	wiphy->max_scan_ssids = 4;
 
 	local = wiphy_priv(wiphy);
 	local->hw.wiphy = wiphy;
@@ -793,25 +794,33 @@ int ieee80211_register_hw(struct ieee802
 	enum ieee80211_band band;
 	struct net_device *mdev;
 	struct ieee80211_master_priv *mpriv;
+	int channels, i, j;
 
 	/*
 	 * generic code guarantees at least one band,
 	 * set this very early because much code assumes
 	 * that hw.conf.channel is assigned
 	 */
+	channels = 0;
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		struct ieee80211_supported_band *sband;
 
 		sband = local->hw.wiphy->bands[band];
-		if (sband) {
+		if (sband && !local->oper_channel) {
 			/* init channel we're on */
 			local->hw.conf.channel =
 			local->oper_channel =
 			local->scan_channel = &sband->channels[0];
-			break;
 		}
+		if (sband)
+			channels += sband->n_channels;
 	}
 
+	local->int_scan_req.n_channels = channels;
+	local->int_scan_req.channels = kzalloc(sizeof(void *) * channels, GFP_KERNEL);
+	if (!local->int_scan_req.channels)
+		return -ENOMEM;
+
 	/* if low-level driver supports AP, we also support VLAN */
 	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_AP))
 		local->hw.wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP_VLAN);
@@ -821,7 +830,7 @@ int ieee80211_register_hw(struct ieee802
 
 	result = wiphy_register(local->hw.wiphy);
 	if (result < 0)
-		return result;
+		goto fail_wiphy_register;
 
 	/*
 	 * We use the number of queues for feature tests (QoS, HT) internally
@@ -932,6 +941,20 @@ int ieee80211_register_hw(struct ieee802
 
 	ieee80211_led_init(local);
 
+	/* alloc wext scan information */
+	i = 0;
+	local->int_scan_req.ssids = &local->scan_ssid;
+	local->scan_ssid.ssid = local->scan_ssid_value;
+	local->int_scan_req.n_ssids = 1;
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		if (!hw->wiphy->bands[band])
+			continue;
+		for (j = 0; j < hw->wiphy->bands[band]->n_channels; j++) {
+			local->int_scan_req.channels[i] = &hw->wiphy->bands[band]->channels[j];
+			i++;
+		}
+	}
+
 	return 0;
 
 fail_wep:
@@ -950,6 +973,8 @@ fail_workqueue:
 		free_netdev(local->mdev);
 fail_mdev_alloc:
 	wiphy_unregister(local->hw.wiphy);
+fail_wiphy_register:
+	kfree(local->int_scan_req.channels);
 	return result;
 }
 EXPORT_SYMBOL(ieee80211_register_hw);
@@ -995,6 +1020,7 @@ void ieee80211_unregister_hw(struct ieee
 	ieee80211_wep_free(local);
 	ieee80211_led_exit(local);
 	free_netdev(local->mdev);
+	kfree(local->int_scan_req.channels);
 }
 EXPORT_SYMBOL(ieee80211_unregister_hw);
 
--- everything.orig/net/wireless/nl80211.h	2008-09-19 05:09:30.000000000 +0200
+++ everything/net/wireless/nl80211.h	2008-09-19 05:15:31.000000000 +0200
@@ -7,6 +7,8 @@
 extern int nl80211_init(void);
 extern void nl80211_exit(void);
 extern void nl80211_notify_dev_rename(struct cfg80211_registered_device *rdev);
+extern void nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
+				   struct net_device *netdev);
 #else
 static inline int nl80211_init(void)
 {
@@ -19,6 +21,10 @@ static inline void nl80211_notify_dev_re
 	struct cfg80211_registered_device *rdev)
 {
 }
+static inline void
+nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
+		       struct net_device *netdev)
+{}
 #endif /* CONFIG_NL80211 */
 
 #endif /* __NET_WIRELESS_NL80211_H */
--- everything.orig/net/wireless/core.c	2008-09-19 05:09:30.000000000 +0200
+++ everything/net/wireless/core.c	2008-09-19 13:11:27.000000000 +0200
@@ -244,6 +244,8 @@ struct wiphy *wiphy_new(struct cfg80211_
 	mutex_init(&drv->mtx);
 	mutex_init(&drv->devlist_mtx);
 	INIT_LIST_HEAD(&drv->netdev_list);
+	spin_lock_init(&drv->scan_lock);
+	INIT_LIST_HEAD(&drv->scan_list);
 
 	device_initialize(&drv->wiphy.dev);
 	drv->wiphy.dev.class = &ieee80211_class;
@@ -263,6 +265,9 @@ int wiphy_register(struct wiphy *wiphy)
 	int i;
 	u16 ifmodes = wiphy->interface_modes;
 
+	if (WARN_ON(wiphy->max_scan_ssids < 1))
+		return -EINVAL;
+
 	/* sanity check ifmodes */
 	WARN_ON(!ifmodes);
 	ifmodes &= ((1 << __NL80211_IFTYPE_AFTER_LAST) - 1) & ~1;
@@ -361,8 +366,11 @@ EXPORT_SYMBOL(wiphy_unregister);
 
 void cfg80211_dev_free(struct cfg80211_registered_device *drv)
 {
+	struct cfg80211_scan_result *scan, *tmp;
 	mutex_destroy(&drv->mtx);
 	mutex_destroy(&drv->devlist_mtx);
+	list_for_each_entry_safe(scan, tmp, &drv->scan_list, list)
+		kfree(scan);
 	kfree(drv);
 }
 
--- everything.orig/net/wireless/core.h	2008-09-19 05:09:30.000000000 +0200
+++ everything/net/wireless/core.h	2008-09-19 13:59:46.000000000 +0200
@@ -28,6 +28,12 @@ struct cfg80211_registered_device {
 	struct mutex devlist_mtx;
 	struct list_head netdev_list;
 
+	/* scan results */
+	spinlock_t scan_lock;
+	struct list_head scan_list;
+	u32 scan_generation;
+	struct cfg80211_scan_request *scan_req;
+
 	/* must be last because of the way we do wiphy_priv(),
 	 * and it should at least be aligned to NETDEV_ALIGN */
 	struct wiphy wiphy __attribute__((__aligned__(NETDEV_ALIGN)));
--- everything.orig/include/net/wireless.h	2008-09-19 13:10:09.000000000 +0200
+++ everything/include/net/wireless.h	2008-09-19 13:10:33.000000000 +0200
@@ -191,6 +191,8 @@ struct wiphy {
 	/* Supported interface modes, OR together BIT(NL80211_IFTYPE_...) */
 	u16 interface_modes;
 
+	u8 max_scan_ssids;
+
 	/* If multiple wiphys are registered and you're handed e.g.
 	 * a regular netdev with assigned ieee80211_ptr, you won't
 	 * know whether it points to a wiphy your driver has registered
--- everything.orig/include/net/mac80211.h	2008-09-19 13:12:19.000000000 +0200
+++ everything/include/net/mac80211.h	2008-09-19 13:12:51.000000000 +0200
@@ -1217,7 +1217,8 @@ struct ieee80211_ops {
 	void (*update_tkip_key)(struct ieee80211_hw *hw,
 			struct ieee80211_key_conf *conf, const u8 *address,
 			u32 iv32, u16 *phase1key);
-	int (*hw_scan)(struct ieee80211_hw *hw, u8 *ssid, size_t len);
+	int (*hw_scan)(struct ieee80211_hw *hw,
+		       struct cfg80211_scan_request *req);
 	int (*get_stats)(struct ieee80211_hw *hw,
 			 struct ieee80211_low_level_stats *stats);
 	void (*get_tkip_seq)(struct ieee80211_hw *hw, u8 hw_key_idx,
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-09-19 13:13:12.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-09-19 13:29:47.000000000 +0200
@@ -3187,11 +3187,19 @@ static void iwl4965_bss_info_changed(str
 
 }
 
-static int iwl_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t ssid_len)
+static int iwl_mac_hw_scan(struct ieee80211_hw *hw,
+			   struct cfg80211_scan_request *req)
 {
 	int ret;
 	unsigned long flags;
 	struct iwl_priv *priv = hw->priv;
+	u8 *ssid = NULL;
+	size_t ssid_len = 0;
+
+	if (req->n_ssids) {
+		ssid = req->ssids[0].ssid;
+		ssid_len = req->ssids[0].ssid_len;
+	}
 
 	IWL_DEBUG_MAC80211("enter\n");
 
@@ -3226,7 +3234,7 @@ static int iwl_mac_hw_scan(struct ieee80
 	}
 	if (ssid_len) {
 		priv->one_direct_scan = 1;
-		priv->direct_ssid_len =  min_t(u8, ssid_len, IW_ESSID_MAX_SIZE);
+		priv->direct_ssid_len = ssid_len;
 		memcpy(priv->direct_ssid, ssid, priv->direct_ssid_len);
 	} else {
 		priv->one_direct_scan = 0;
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2008-09-19 13:17:56.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-core.c	2008-09-19 13:18:13.000000000 +0200
@@ -862,6 +862,7 @@ int iwl_setup_mac(struct iwl_priv *priv)
 		BIT(NL80211_IFTYPE_AP) |
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
+	hw->wiphy->max_scan_ssids = 1;
 	/* Default value; 4 EDCA QOS priorities */
 	hw->queues = 4;
 	/* queues to support 11n aggregation */
--- everything.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-09-19 13:13:11.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-09-19 13:30:16.000000000 +0200
@@ -6993,11 +6993,19 @@ static void iwl3945_bss_info_changed(str
 
 }
 
-static int iwl3945_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
+static int iwl3945_mac_hw_scan(struct ieee80211_hw *hw,
+			       struct cfg80211_scan_request *req)
 {
 	int rc = 0;
 	unsigned long flags;
 	struct iwl3945_priv *priv = hw->priv;
+	size_t len = 0;
+	u8 *ssid = NULL;
+
+	if (req->n_ssids) {
+		len = req->ssids[0].ssid_len;
+		ssid = req->ssids[0].ssid;
+	}
 
 	IWL_DEBUG_MAC80211("enter\n");
 
@@ -7034,9 +7042,8 @@ static int iwl3945_mac_hw_scan(struct ie
 			       iwl3945_escape_essid(ssid, len), (int)len);
 
 		priv->one_direct_scan = 1;
-		priv->direct_ssid_len = (u8)
-		    min((u8) len, (u8) IW_ESSID_MAX_SIZE);
-		memcpy(priv->direct_ssid, ssid, priv->direct_ssid_len);
+		priv->direct_ssid_len = len;
+		memcpy(priv->direct_ssid, ssid, len);
 	} else
 		priv->one_direct_scan = 0;
 
@@ -7926,6 +7933,8 @@ static int iwl3945_pci_probe(struct pci_
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
 
+	hw->wiphy->max_scan_ssids = 1;
+
 	/* 4 EDCA QOS priorities */
 	hw->queues = 4;
 
--- everything.orig/drivers/net/wireless/at76_usb.c	2008-09-19 13:20:34.000000000 +0200
+++ everything/drivers/net/wireless/at76_usb.c	2008-09-19 14:16:41.000000000 +0200
@@ -2015,14 +2015,16 @@ exit:
 	return;
 }
 
-static int at76_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
+static int at76_hw_scan(struct ieee80211_hw *hw,
+			struct cfg80211_scan_request *req)
 {
 	struct at76_priv *priv = hw->priv;
 	struct at76_req_scan scan;
 	int ret;
+	u8 *ssid = NULL;
+	int len = 0;
 
 	at76_dbg(DBG_MAC80211, "%s():", __func__);
-	at76_dbg_dump(DBG_MAC80211, ssid, len, "ssid %zd bytes:", len);
 
 	mutex_lock(&priv->mtx);
 
@@ -2030,8 +2032,14 @@ static int at76_hw_scan(struct ieee80211
 
 	memset(&scan, 0, sizeof(struct at76_req_scan));
 	memset(scan.bssid, 0xFF, ETH_ALEN);
-	scan.scan_type = SCAN_TYPE_ACTIVE;
-	if (priv->essid_size > 0) {
+	if (req->n_ssids) {
+		scan.scan_type = SCAN_TYPE_ACTIVE;
+		ssid = req->ssids[0].ssid;
+		len = req->ssids[0].ssid_len;
+	} else {
+		scan.scan_type = SCAN_TYPE_PASSIVE;
+	}
+	if (len) {
 		memcpy(scan.essid, ssid, len);
 		scan.essid_size = len;
 	}
@@ -2548,6 +2556,7 @@ static int at76_init_new_device(struct a
 				  IEEE80211_HW_SIGNAL_UNSPEC;
 
 	priv->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+	priv->hw->wiphy->max_scan_ssids = 1;
 
 	SET_IEEE80211_DEV(priv->hw, &interface->dev);
 	SET_IEEE80211_PERM_ADDR(priv->hw, priv->mac_addr);


