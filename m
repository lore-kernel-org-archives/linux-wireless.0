Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:12425 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbZJTLh6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 07:37:58 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id 78B401480D3
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2009 13:37:58 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PfmZoynhC+wE for <linux-wireless@vger.kernel.org>;
	Tue, 20 Oct 2009 13:37:58 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95FA5CF.dip0.t-ipconnect.de [217.95.165.207])
	by mx51.mymxserver.com (Postfix) with ESMTP id 77AB11488FC
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2009 12:36:54 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 2D5181E0010
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2009 12:36:39 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: question: "possible recursive locking detected" with cfg80211 + monitor mode
Date: Tue, 20 Oct 2009 12:36:25 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910201236.25871.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi !

I'm about to add monitor mode to my cfg80211 code. I wanted to
keep as much of the monitor mode code from libertas that I could,
mainly

* priv->rtap_net_dev
* lbs_rtap_XXX() in main.c
* process_rxed_802_11_packet() in rx.c.


So my code is quite simply currently:

static struct cfg80211_ops lbs_cfg80211_ops = {
	// ...
        .change_virtual_intf = lbs_change_intf,
};

static int lbs_change_intf(struct wiphy *wiphy, struct net_device *dev,
        enum nl80211_iftype type, u32 *flags,
        struct vif_params *params)
{
        struct lbs_private *priv = wiphy_priv(wiphy);
        int ret = 0;

        lbs_deb_enter(LBS_DEB_CFG80211);

        switch(type) {
        case NL80211_IFTYPE_MONITOR:
                ret = lbs_enable_monitor_mode(priv, type == NL80211_IFTYPE_MONITOR);
                if (!priv->rtap_net_dev)
                        lbs_add_rtap(priv);
                if (ret)
                        goto done;
                break;

	// ...

However, when I now run "iw wlan0 interface type monitor", I get
this in dmesg:

[ 9366.886670] libertas enter: lbs_change_intf()
[ 9366.886765] ##HS type 6
[ 9366.886844] libertas enter: lbs_enable_monitor_mode()
[ 9366.886932] libertas enter: lbs_is_cmd_allowed()
[ 9366.887018] libertas leave: lbs_is_cmd_allowed()
[ 9366.887454] libertas cmd: DNLD_CMD: command 0x0098, seq 5, size 12
[ 9366.887545] libertas DNLD_CMD: 98 00 0c 00 05 00 00 00 01 00 01 00
[ 9366.892052] libertas cmd: CMD_RESP: response 0x8098, seq 5, size 12
[ 9366.892060] libertas CMD_RESP: 98 80 0c 00 05 00 02 00 01 00 01 00
[ 9366.892104] libertas: PREP_CMD: command 0x0098 failed: 2
[ 9366.892114] libertas leave: lbs_enable_monitor_mode()
[ 9366.892121] libertas enter: lbs_add_rtap()
[ 9366.892277]
[ 9366.892280] =============================================
[ 9366.892286] [ INFO: possible recursive locking detected ]
[ 9366.892293] 2.6.32-rc5-wl #24
[ 9366.892298] ---------------------------------------------
[ 9366.892304] iw/2782 is trying to acquire lock:
[ 9366.892311]  (rtnl_mutex){+.+.+.}, at: [<c03447c1>] rtnl_lock+0xf/0x11
[ 9366.892331]
[ 9366.892334] but task is already holding lock:
[ 9366.892340]  (rtnl_mutex){+.+.+.}, at: [<c03447c1>] rtnl_lock+0xf/0x11
[ 9366.892354]
[ 9366.892356] other info that might help us debug this:
[ 9366.892364] 3 locks held by iw/2782:
[ 9366.892369]  #0:  (genl_mutex){+.+.+.}, at: [<c034c652>] genl_rcv+0x12/0x2b
[ 9366.892386]  #1:  (rtnl_mutex){+.+.+.}, at: [<c03447c1>] rtnl_lock+0xf/0x11
[ 9366.892401]  #2:  (&rdev->mtx){+.+.+.}, at: [<f97d0810>] cfg80211_get_dev_from_ifindex+0x4f/0x66 [cfg80211]
[ 9366.892432]
[ 9366.892435] stack backtrace:
[ 9366.892443] Pid: 2782, comm: iw Not tainted 2.6.32-rc5-wl #24
[ 9366.892449] Call Trace:
[ 9366.892463]  [<c01419d7>] validate_chain+0x49b/0xb62
[ 9366.892476]  [<c01427bf>] __lock_acquire+0x721/0x787
[ 9366.892489]  [<c0140713>] ? trace_hardirqs_on_caller+0x107/0x12f
[ 9366.892500]  [<c0142881>] lock_acquire+0x5c/0x73
[ 9366.892511]  [<c03447c1>] ? rtnl_lock+0xf/0x11
[ 9366.892525]  [<c0399976>] mutex_lock_nested+0x47/0x28f
[ 9366.892536]  [<c03447c1>] ? rtnl_lock+0xf/0x11
[ 9366.892548]  [<c03488dc>] ? ether_setup+0x0/0x5c
[ 9366.892560]  [<c03447c1>] rtnl_lock+0xf/0x11
[ 9366.892572]  [<c033c96e>] register_netdev+0xc/0x3f
[ 9366.892594]  [<f98ed2f6>] lbs_add_rtap+0xb4/0x10f [libertas]
[ 9366.892612]  [<f98e6e1f>] lbs_change_intf+0x8c/0x4c9 [libertas]
[ 9366.892636]  [<f97d1905>] cfg80211_change_iface+0x9f/0xd5 [cfg80211]
[ 9366.892663]  [<f97d7886>] nl80211_set_interface+0xc1/0xff [cfg80211]
[ 9366.892676]  [<c034d774>] genl_rcv_msg+0x140/0x15c
[ 9366.892688]  [<c034d634>] ? genl_rcv_msg+0x0/0x15c
[ 9366.892698]  [<c034b15d>] netlink_rcv_skb+0x30/0x75
[ 9366.892709]  [<c034c65e>] genl_rcv+0x1e/0x2b
[ 9366.892719]  [<c034af3c>] netlink_unicast+0x1b7/0x229
[ 9366.892731]  [<c034ba58>] netlink_sendmsg+0x21b/0x228
[ 9366.892744]  [<c032fe2a>] sock_sendmsg+0xca/0xe1
[ 9366.892758]  [<c0133b8d>] ? autoremove_wake_function+0x0/0x33
[ 9366.892770]  [<c0142928>] ? lock_release_non_nested+0x90/0x1fc
[ 9366.892781]  [<c01613c0>] ? might_fault+0x4e/0x88
[ 9366.892792]  [<c01613c0>] ? might_fault+0x4e/0x88
[ 9366.892805]  [<c01fcea0>] ? copy_from_user+0x31/0x54
[ 9366.892816]  [<c033721b>] ? verify_iovec+0x40/0x71
[ 9366.892827]  [<c032ff90>] sys_sendmsg+0x14f/0x1aa
[ 9366.892841]  [<c01427e2>] ? __lock_acquire+0x744/0x787
[ 9366.892853]  [<c0142928>] ? lock_release_non_nested+0x90/0x1fc
[ 9366.892863]  [<c01613c0>] ? might_fault+0x4e/0x88
[ 9366.892877]  [<c0330d7a>] sys_socketcall+0x144/0x178
[ 9366.892889]  [<c01fcab4>] ? trace_hardirqs_on_thunk+0xc/0x10
[ 9366.892900]  [<c0102888>] sysenter_do_call+0x12/0x36


So it seems I cannot call register_netdev() while in
cfg80211_change_iface(), right ?   What would be a proper
approach then?

---
http://www.holgerschurig.de
