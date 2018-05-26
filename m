Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:42963 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1031606AbeEZLfR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 26 May 2018 07:35:17 -0400
From: YueHaibing <yuehaibing@huawei.com>
To: <davem@davemloft.net>, <jiri@resnulli.us>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <johannes@sipsolutions.net>, <kvalo@codeaurora.org>,
        <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>,
        <sameo@linux.intel.com>, <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: remove unnecessary genlmsg_cancel() calls
Date: Sat, 26 May 2018 19:15:48 +0800
Message-ID: <20180526111548.17184-1-yuehaibing@huawei.com> (sfid-20180526_133533_882724_94767EB9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

the message be freed immediately, no need to trim it
back to the previous size.

Inspired by commit 7a9b3ec1e19f ("nl80211: remove unnecessary genlmsg_cancel() calls")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/team/team.c               |  2 --
 drivers/net/wireless/mac80211_hwsim.c |  1 -
 net/core/devlink.c                    |  4 ----
 net/ipv6/seg6.c                       |  1 -
 net/ncsi/ncsi-netlink.c               |  1 -
 net/nfc/netlink.c                     | 17 -----------------
 6 files changed, 26 deletions(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index e6730a0..267dcc9 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2426,7 +2426,6 @@ static int team_nl_send_options_get(struct team *team, u32 portid, u32 seq,
 nla_put_failure:
 	err = -EMSGSIZE;
 errout:
-	genlmsg_cancel(skb, hdr);
 	nlmsg_free(skb);
 	return err;
 }
@@ -2720,7 +2719,6 @@ static int team_nl_send_port_list_get(struct team *team, u32 portid, u32 seq,
 nla_put_failure:
 	err = -EMSGSIZE;
 errout:
-	genlmsg_cancel(skb, hdr);
 	nlmsg_free(skb);
 	return err;
 }
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index c26469b..38e1135 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2514,7 +2514,6 @@ static void hwsim_mcast_new_radio(int id, struct genl_info *info,
 	return;
 
 out_err:
-	genlmsg_cancel(mcast_skb, data);
 	nlmsg_free(mcast_skb);
 }
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 475246b..f75ee02 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1826,7 +1826,6 @@ static int devlink_dpipe_tables_fill(struct genl_info *info,
 nla_put_failure:
 	err = -EMSGSIZE;
 err_table_put:
-	genlmsg_cancel(skb, hdr);
 	nlmsg_free(skb);
 	return err;
 }
@@ -2032,7 +2031,6 @@ int devlink_dpipe_entry_ctx_prepare(struct devlink_dpipe_dump_ctx *dump_ctx)
 	return 0;
 
 nla_put_failure:
-	genlmsg_cancel(dump_ctx->skb, dump_ctx->hdr);
 	nlmsg_free(dump_ctx->skb);
 	return -EMSGSIZE;
 }
@@ -2249,7 +2247,6 @@ static int devlink_dpipe_headers_fill(struct genl_info *info,
 nla_put_failure:
 	err = -EMSGSIZE;
 err_table_put:
-	genlmsg_cancel(skb, hdr);
 	nlmsg_free(skb);
 	return err;
 }
@@ -2551,7 +2548,6 @@ static int devlink_resource_fill(struct genl_info *info,
 	err = -EMSGSIZE;
 err_resource_put:
 err_skb_send_alloc:
-	genlmsg_cancel(skb, hdr);
 	nlmsg_free(skb);
 	return err;
 }
diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index 7f5621d..0fdf2a5 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -226,7 +226,6 @@ static int seg6_genl_get_tunsrc(struct sk_buff *skb, struct genl_info *info)
 
 nla_put_failure:
 	rcu_read_unlock();
-	genlmsg_cancel(msg, hdr);
 free_msg:
 	nlmsg_free(msg);
 	return -ENOMEM;
diff --git a/net/ncsi/ncsi-netlink.c b/net/ncsi/ncsi-netlink.c
index b09ef77..99f4c22 100644
--- a/net/ncsi/ncsi-netlink.c
+++ b/net/ncsi/ncsi-netlink.c
@@ -201,7 +201,6 @@ static int ncsi_pkg_info_nl(struct sk_buff *msg, struct genl_info *info)
 	return genlmsg_reply(skb, info);
 
 err:
-	genlmsg_cancel(skb, hdr);
 	kfree_skb(skb);
 	return rc;
 }
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index f018eaf..376181c 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -206,7 +206,6 @@ int nfc_genl_targets_found(struct nfc_dev *dev)
 	return genlmsg_multicast(&nfc_genl_family, msg, 0, 0, GFP_ATOMIC);
 
 nla_put_failure:
-	genlmsg_cancel(msg, hdr);
 free_msg:
 	nlmsg_free(msg);
 	return -EMSGSIZE;
@@ -237,7 +236,6 @@ int nfc_genl_target_lost(struct nfc_dev *dev, u32 target_idx)
 	return 0;
 
 nla_put_failure:
-	genlmsg_cancel(msg, hdr);
 free_msg:
 	nlmsg_free(msg);
 	return -EMSGSIZE;
@@ -269,7 +267,6 @@ int nfc_genl_tm_activated(struct nfc_dev *dev, u32 protocol)
 	return 0;
 
 nla_put_failure:
-	genlmsg_cancel(msg, hdr);
 free_msg:
 	nlmsg_free(msg);
 	return -EMSGSIZE;
@@ -299,7 +296,6 @@ int nfc_genl_tm_deactivated(struct nfc_dev *dev)
 	return 0;
 
 nla_put_failure:
-	genlmsg_cancel(msg, hdr);
 free_msg:
 	nlmsg_free(msg);
 	return -EMSGSIZE;
@@ -340,7 +336,6 @@ int nfc_genl_device_added(struct nfc_dev *dev)
 	return 0;
 
 nla_put_failure:
-	genlmsg_cancel(msg, hdr);
 free_msg:
 	nlmsg_free(msg);
 	return -EMSGSIZE;
@@ -370,7 +365,6 @@ int nfc_genl_device_removed(struct nfc_dev *dev)
 	return 0;
 
 nla_put_failure:
-	genlmsg_cancel(msg, hdr);
 free_msg:
 	nlmsg_free(msg);
 	return -EMSGSIZE;
@@ -434,8 +428,6 @@ int nfc_genl_llc_send_sdres(struct nfc_dev *dev, struct hlist_head *sdres_list)
 	return genlmsg_multicast(&nfc_genl_family, msg, 0, 0, GFP_ATOMIC);
 
 nla_put_failure:
-	genlmsg_cancel(msg, hdr);
-
 free_msg:
 	nlmsg_free(msg);
 
@@ -470,7 +462,6 @@ int nfc_genl_se_added(struct nfc_dev *dev, u32 se_idx, u16 type)
 	return 0;
 
 nla_put_failure:
-	genlmsg_cancel(msg, hdr);
 free_msg:
 	nlmsg_free(msg);
 	return -EMSGSIZE;
@@ -501,7 +492,6 @@ int nfc_genl_se_removed(struct nfc_dev *dev, u32 se_idx)
 	return 0;
 
 nla_put_failure:
-	genlmsg_cancel(msg, hdr);
 free_msg:
 	nlmsg_free(msg);
 	return -EMSGSIZE;
@@ -546,7 +536,6 @@ int nfc_genl_se_transaction(struct nfc_dev *dev, u8 se_idx,
 	return 0;
 
 nla_put_failure:
-	genlmsg_cancel(msg, hdr);
 free_msg:
 	/* evt_transaction is no more used */
 	devm_kfree(&dev->dev, evt_transaction);
@@ -585,7 +574,6 @@ int nfc_genl_se_connectivity(struct nfc_dev *dev, u8 se_idx)
 	return 0;
 
 nla_put_failure:
-	genlmsg_cancel(msg, hdr);
 free_msg:
 	nlmsg_free(msg);
 	return -EMSGSIZE;
@@ -703,7 +691,6 @@ int nfc_genl_dep_link_up_event(struct nfc_dev *dev, u32 target_idx,
 	return 0;
 
 nla_put_failure:
-	genlmsg_cancel(msg, hdr);
 free_msg:
 	nlmsg_free(msg);
 	return -EMSGSIZE;
@@ -735,7 +722,6 @@ int nfc_genl_dep_link_down_event(struct nfc_dev *dev)
 	return 0;
 
 nla_put_failure:
-	genlmsg_cancel(msg, hdr);
 free_msg:
 	nlmsg_free(msg);
 	return -EMSGSIZE;
@@ -1030,7 +1016,6 @@ static int nfc_genl_send_params(struct sk_buff *msg,
 	return 0;
 
 nla_put_failure:
-
 	genlmsg_cancel(msg, hdr);
 	return -EMSGSIZE;
 }
@@ -1290,7 +1275,6 @@ int nfc_genl_fw_download_done(struct nfc_dev *dev, const char *firmware_name,
 	return 0;
 
 nla_put_failure:
-	genlmsg_cancel(msg, hdr);
 free_msg:
 	nlmsg_free(msg);
 	return -EMSGSIZE;
@@ -1507,7 +1491,6 @@ static void se_io_cb(void *context, u8 *apdu, size_t apdu_len, int err)
 	return;
 
 nla_put_failure:
-	genlmsg_cancel(msg, hdr);
 free_msg:
 	nlmsg_free(msg);
 	kfree(ctx);
-- 
2.7.0
