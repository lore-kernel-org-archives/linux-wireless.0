Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:30072 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317AbZJLLgk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 07:36:40 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id EE36A4B009
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2009 13:35:32 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Quuuqs88mTEN for <linux-wireless@vger.kernel.org>;
	Mon, 12 Oct 2009 13:35:32 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95F92E8.dip0.t-ipconnect.de [217.95.146.232])
	by mx51.mymxserver.com (Postfix) with ESMTP id 5DF544B006
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2009 13:35:32 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 93AA31E0010
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2009 13:35:22 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: WARNING: slow-path
Date: Mon, 12 Oct 2009 13:35:21 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910121335.21807.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm getting a "slow-path" warning that I don't really comprehend:

[   33.357576] libertas leave: lbs_cfg_scan_worker()
[   33.368197] libertas enter: lbs_cfg_auth()
[   33.368356] libertas leave: lbs_cfg_auth(), ret 0
[   33.368554] libertas enter: lbs_cfg_ret_auth()
[   33.368746] libertas leave: lbs_cfg_ret_auth()

Next comes the .assoc function. This isn't yet coded so I return -ENOTSUPP

[   33.368832] libertas enter: lbs_cfg_assoc()
[   33.368902] libertas leave: lbs_cfg_assoc(-ENOTSUPP)

... with makes mlme.c call my .deauth function:

[   33.368970] libertas enter: lbs_cfg_deauth()
[   33.369768] libertas enter: lbs_cfg_ret_deauth()
[   33.369838] ------------[ cut here ]------------
[   33.369923] WARNING: at net/wireless/mlme.c:135 __cfg80211_send_deauth+0x3f/0x1e1 [cfg80211]()
[   33.370028] Hardware name: Amilo M1425
[   33.370096] Modules linked in: libertas_cs libertas cfg80211 lib80211 psmouse uhci_hcd [last unloaded: cfg80211]
[   33.370461] Pid: 1700, comm: lbs_main Not tainted 2.6.32-rc3-wl #21
[   33.370532] Call Trace:
[   33.370604]  [<c012395a>] warn_slowpath_common+0x60/0x77
[   33.370676]  [<c012397e>] warn_slowpath_null+0xd/0x10
[   33.370754]  [<f91205c0>] __cfg80211_send_deauth+0x3f/0x1e1 [cfg80211]
[   33.370834]  [<f9120c85>] cfg80211_send_deauth+0x33/0x5a [cfg80211]
[   33.370916]  [<f93324cc>] lbs_cfg_ret_deauth+0x9d/0xe7 [libertas]
[   33.370993]  [<f933242f>] ? lbs_cfg_ret_deauth+0x0/0xe7 [libertas]
[   33.371071]  [<f93380bc>] lbs_process_command_response+0x538/0xa96 [libertas]
[   33.371147]  [<c0399f7a>] ? _spin_unlock_irq+0x22/0x3b
[   33.371225]  [<f933ca77>] lbs_thread+0x358/0x747 [libertas]
[   33.371300]  [<c011ebbc>] ? default_wake_function+0x0/0xd
[   33.371377]  [<f933c71f>] ? lbs_thread+0x0/0x747 [libertas]
[   33.371450]  [<c0133c9c>] kthread+0x61/0x69
[   33.371520]  [<c0133c3b>] ? kthread+0x0/0x69
[   33.371591]  [<c010334b>] kernel_thread_helper+0x7/0x10
[   33.371661] ---[ end trace f5da223917368c61 ]---
[   33.371756] libertas leave: lbs_cfg_ret_deauth()

Bellow is lbs_cfg_deauth. I know from friday's debugging, that
__lbs_cmd_async also does a preempt (CONFIG_PREEMPT). That
might have something do to with it.


static int lbs_cfg_deauth(struct wiphy *wiphy, struct net_device *dev,
			  struct cfg80211_deauth_request *req,
			  void *cookie)
{
	struct lbs_private *priv = wiphy_priv(wiphy);
	struct cmd_ds_802_11_deauthenticate cmd;
	lbs_deb_enter(LBS_DEB_CFG80211);

	memset(&cmd, 0, sizeof(cmd));
	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
	memcpy(cmd.macaddr, &req->bss->bssid, ETH_ALEN);
	cmd.reasoncode = cpu_to_le16(req->reason_code);

	__lbs_cmd_async(priv, CMD_802_11_DEAUTHENTICATE,
			&cmd.hdr, sizeof(cmd),
			lbs_cfg_ret_deauth, (unsigned long) cookie);

	return 0;
}


lbs_cfg_ret_deauth() get's called as soon as the
firmware sends me back some response.


static int lbs_cfg_ret_deauth(struct lbs_private *priv, unsigned long dummy,
			    struct cmd_header *resp)
{
	struct cmd_ds_802_11_deauthenticate *deauth_resp = (void *)resp;
	struct ieee80211_mgmt mgmt;

	lbs_deb_enter(LBS_DEB_CFG80211);

	/* Fake a management frame */
	memset(&mgmt, 0, sizeof(mgmt));
	memcpy(mgmt.bssid, deauth_resp->macaddr, ETH_ALEN);
	memcpy(mgmt.sa, deauth_resp->macaddr, ETH_ALEN);
	memcpy(mgmt.da, priv->current_addr, ETH_ALEN);
	cfg80211_send_deauth(priv->dev, (u8 *)&mgmt, sizeof(mgmt),
			     (void *)dummy);

	lbs_deb_leave(LBS_DEB_CFG80211);
	return 0;
}



Any idea on how to fix that?

-- 
http://www.holgerschurig.de
