Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:15948 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbZJMI4y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 04:56:54 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id D0B40148004
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2009 10:55:45 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id edDtBX-vHczV for <linux-wireless@vger.kernel.org>;
	Tue, 13 Oct 2009 10:55:45 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95FA59B.dip0.t-ipconnect.de [217.95.165.155])
	by mx51.mymxserver.com (Postfix) with ESMTP id 1A94814800B
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2009 10:55:43 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 048171E0010
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2009 10:55:34 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: cfg80211 / libertas: an unusual race
Date: Tue, 13 Oct 2009 10:55:31 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910131055.31739.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So far I can connect via cfg80211, and therefore I now want to
disconnect as well.

The code in my driver is:


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
			lbs_cfg_ret_deauth, 0);

	return 0;
}

static int lbs_cfg_ret_deauth(struct lbs_private *priv, unsigned long dummy,
			    struct cmd_header *resp)
{
	struct cmd_ds_802_11_deauthenticate *deauth_resp = (void *)resp;
	struct ieee80211_mgmt mgmt;

	lbs_deb_enter(LBS_DEB_CFG80211);

	/* Fake a management frame */
	memset(&mgmt, 0, sizeof(mgmt));
	memcpy(mgmt.bssid, deauth_resp->macaddr, ETH_ALEN);
	/* Note: .sa / .da swapped */
	memcpy(mgmt.da, deauth_resp->macaddr, ETH_ALEN);
	memcpy(mgmt.sa, priv->current_addr, ETH_ALEN);
	mgmt.u.deauth.reason_code = le16_to_cpu(deauth_resp->reasoncode);
	cfg80211_send_deauth(priv->dev, (u8 *)&mgmt, sizeof(mgmt),
			     (void *)dummy);

	lbs_deb_leave(LBS_DEB_CFG80211);
	return 0;
}


A reader could *think* this happens:

1.    lbs_cfg_deauth() enters
2.    lbs_cfg_deauth sends CMD_802_11_DEAUTHENTICATE to firmware
      asynchronously via __lbs_cmd_async() and specifies
      a lbs_cfg_ret_deauth() as callback
3. a) lbs_cfg_deauth() leaves
3. b) cfg80211 does something related to disconnecting
4.    firmware responds with an IRQ
5.    libertas get's response and calls our callback
6.    lbs_cfg_ret_deauth() enters
7. a) cfg80211_send_deauth() get's called
7. b) cfg80211 does something related to disconnecting

But that is not what happens, and steps "3. b)" and
"7. b)" are executed in this sequence with an ath5k
driver.


In step "2.", __lbs_cmd_async() causes a preemption on my device
(CONFIG_PREEMPT). That changes the sequence of cfg80211
jobs. This is what really happens:

1.    lbs_cfg_deauth() enters
2. a) lbs_cfg_deauth sends CMD_802_11_DEAUTHENTICATE to firmware
      via __lbs_cmd_async()
2. b) IMPORTANT CHANGE: Linux preempts!
4.    firmware responds with an IRQ
5.    libertas get's response and calls our callback
6.    lbs_cfg_ret_deauth() enters
7. a) cfg80211_send_deauth() get's called
7. b) cfg80211 does something related to disconnecting
7. C) IMPORTANT CHANGE: preemption now schedules the
      original task, and thus this happens only now:
3. a) lbs_cfg_deauth() leaves
3. b) cfg80211 does something related to disconnecting

Now at step "7. b)" the function __cfg80211_disconnected()
clears wdev->current_bss to NULL.

But at step "3. b)", which now happens at a later time,
wdev_current_bss is no longer set. This triggers a
WARN_ON(!done) warning in __cfg80211_send_deauth(),
file net/wireless/mlme.c



Would it be O.K. to simply remove the WARN_ON(!done) ?
After all, wdev>current_bss was put'ted and cleared correctly.

-- 
http://www.holgerschurig.de
