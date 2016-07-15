Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15291 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbcGONat (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2016 09:30:49 -0400
Date: Fri, 15 Jul 2016 21:29:18 +0800
From: kbuild test robot <lkp@intel.com>
To: Alex Briskin <br.shurik@gmail.com>
Cc: kbuild-all@01.org, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net, Alex Briskin <br.shurik@gmail.com>
Subject: Re: [PATCH 4/4 v2 iface_work] Function renaming
Message-ID: <201607152136.JJNPH5sA%fengguang.wu@intel.com> (sfid-20160715_153054_663216_721CB9E4)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5vNYLRcllDrimb99"
In-Reply-To: <1468573596-20055-4-git-send-email-br.shurik@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

[auto build test ERROR on mac80211/master]
[also build test ERROR on v4.7-rc7]
[cannot apply to mac80211-next/master next-20160715]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Alex-Briskin/New-function-ieee80211_is_skb_handled_by_pkt_type/20160715-195540
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git master
config: alpha-defconfig (attached as .config)
compiler: alpha-linux-gnu-gcc (Debian 5.3.1-8) 5.3.1 20160205
reproduce:
        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=alpha 

All error/warnings (new ones prefixed by >>):

>> net/mac80211/iface.c:1249:11: warning: 'struct ieee80211_sub_if_datai' declared inside parameter list
       struct ieee80211_sub_if_datai *sdata)
              ^
>> net/mac80211/iface.c:1249:11: warning: its scope is only this definition or declaration, which is probably not what you want
   net/mac80211/iface.c: In function 'mac80211_is_skb_handled_by_frame_control':
>> net/mac80211/iface.c:1251:39: error: dereferencing pointer to incomplete type 'struct ieee80211_sub_if_datai'
     struct ieee80211_local *local = sdata->local;
                                          ^
>> net/mac80211/iface.c:1260:26: error: passing argument 1 of 'sta_info_get_bss' from incompatible pointer type [-Werror=incompatible-pointer-types]
      sta = sta_info_get_bss(sdata, mgmt->sa);
                             ^
   In file included from net/mac80211/ieee80211_i.h:34:0,
                    from net/mac80211/iface.c:21:
   net/mac80211/sta_info.h:644:18: note: expected 'struct ieee80211_sub_if_data *' but argument is of type 'struct ieee80211_sub_if_datai *'
    struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
                     ^
>> net/mac80211/iface.c:1272:29: error: passing argument 1 of 'ieee80211_process_delba' from incompatible pointer type [-Werror=incompatible-pointer-types]
        ieee80211_process_delba(sdata, sta, mgmt, len);
                                ^
   In file included from net/mac80211/iface.c:21:0:
   net/mac80211/ieee80211_i.h:1700:6: note: expected 'struct ieee80211_sub_if_data *' but argument is of type 'struct ieee80211_sub_if_datai *'
    void ieee80211_process_delba(struct ieee80211_sub_if_data *sdata,
         ^
>> net/mac80211/iface.c:1284:32: error: passing argument 1 of 'ieee80211_process_mu_groups' from incompatible pointer type [-Werror=incompatible-pointer-types]
       ieee80211_process_mu_groups(sdata, mgmt);
                                   ^
   In file included from net/mac80211/iface.c:21:0:
   net/mac80211/ieee80211_i.h:1737:6: note: expected 'struct ieee80211_sub_if_data *' but argument is of type 'struct ieee80211_sub_if_datai *'
    void ieee80211_process_mu_groups(struct ieee80211_sub_if_data *sdata,
         ^
   net/mac80211/iface.c:1309:26: error: passing argument 1 of 'sta_info_get_bss' from incompatible pointer type [-Werror=incompatible-pointer-types]
      sta = sta_info_get_bss(sdata, mgmt->sa);
                             ^
   In file included from net/mac80211/ieee80211_i.h:34:0,
                    from net/mac80211/iface.c:21:
   net/mac80211/sta_info.h:644:18: note: expected 'struct ieee80211_sub_if_data *' but argument is of type 'struct ieee80211_sub_if_datai *'
    struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
                     ^
   net/mac80211/iface.c: In function 'ieee80211_iface_work':
>> net/mac80211/iface.c:1366:54: error: passing argument 2 of 'mac80211_is_skb_handled_by_frame_control' from incompatible pointer type [-Werror=incompatible-pointer-types]
          !mac80211_is_skb_handled_by_frame_control(skb, sdata)) {
                                                         ^
   net/mac80211/iface.c:1248:13: note: expected 'struct ieee80211_sub_if_datai *' but argument is of type 'struct ieee80211_sub_if_data *'
    static bool mac80211_is_skb_handled_by_frame_control(struct sk_buff *skb,
                ^
   cc1: some warnings being treated as errors

vim +1251 net/mac80211/iface.c

4ea9593c0 Alex Briskin  2016-07-15  1243  	}
4ea9593c0 Alex Briskin  2016-07-15  1244  	/*will return true if pkt_type found and handled */
4ea9593c0 Alex Briskin  2016-07-15  1245  	return true;
4ea9593c0 Alex Briskin  2016-07-15  1246  }
4ea9593c0 Alex Briskin  2016-07-15  1247  
9ea4267a9 Alex Briskin  2016-07-15  1248  static bool mac80211_is_skb_handled_by_frame_control(struct sk_buff *skb,
9ea4267a9 Alex Briskin  2016-07-15 @1249  			struct ieee80211_sub_if_datai *sdata)
4ea9593c0 Alex Briskin  2016-07-15  1250  {
4ea9593c0 Alex Briskin  2016-07-15 @1251  	struct ieee80211_local *local = sdata->local;
4ea9593c0 Alex Briskin  2016-07-15  1252  	struct sta_info *sta;
4ea9593c0 Alex Briskin  2016-07-15  1253  	struct ieee80211_mgmt *mgmt = (void *)skb->data;
4ea9593c0 Alex Briskin  2016-07-15  1254  
f10059ca6 Alex Briskin  2016-07-15  1255  	if (ieee80211_is_action(mgmt->frame_control) &&
bed7ee6e4 Johannes Berg 2010-06-10  1256  	    mgmt->u.action.category == WLAN_CATEGORY_BACK) {
bed7ee6e4 Johannes Berg 2010-06-10  1257  		int len = skb->len;
bed7ee6e4 Johannes Berg 2010-06-10  1258  
a93e36443 Johannes Berg 2010-06-10  1259  		mutex_lock(&local->sta_mtx);
875ae5f68 Felix Fietkau 2010-07-17 @1260  		sta = sta_info_get_bss(sdata, mgmt->sa);
bed7ee6e4 Johannes Berg 2010-06-10  1261  		if (sta) {
bed7ee6e4 Johannes Berg 2010-06-10  1262  			switch (mgmt->u.action.u.addba_req.action_code) {
bed7ee6e4 Johannes Berg 2010-06-10  1263  			case WLAN_ACTION_ADDBA_REQ:
f10059ca6 Alex Briskin  2016-07-15  1264  				ieee80211_process_addba_request(local, sta,
f10059ca6 Alex Briskin  2016-07-15  1265  								mgmt, len);
bed7ee6e4 Johannes Berg 2010-06-10  1266  				break;
bed7ee6e4 Johannes Berg 2010-06-10  1267  			case WLAN_ACTION_ADDBA_RESP:
bed7ee6e4 Johannes Berg 2010-06-10  1268  				ieee80211_process_addba_resp(local, sta,
bed7ee6e4 Johannes Berg 2010-06-10  1269  							     mgmt, len);
bed7ee6e4 Johannes Berg 2010-06-10  1270  				break;
bed7ee6e4 Johannes Berg 2010-06-10  1271  			case WLAN_ACTION_DELBA:
f10059ca6 Alex Briskin  2016-07-15 @1272  				ieee80211_process_delba(sdata, sta, mgmt, len);
bed7ee6e4 Johannes Berg 2010-06-10  1273  				break;
bed7ee6e4 Johannes Berg 2010-06-10  1274  			default:
bed7ee6e4 Johannes Berg 2010-06-10  1275  				WARN_ON(1);
bed7ee6e4 Johannes Berg 2010-06-10  1276  				break;
bed7ee6e4 Johannes Berg 2010-06-10  1277  			}
bed7ee6e4 Johannes Berg 2010-06-10  1278  		}
a93e36443 Johannes Berg 2010-06-10  1279  		mutex_unlock(&local->sta_mtx);
23a1f8d44 Sara Sharon   2015-12-08  1280  	} else if (ieee80211_is_action(mgmt->frame_control) &&
23a1f8d44 Sara Sharon   2015-12-08  1281  		   mgmt->u.action.category == WLAN_CATEGORY_VHT) {
23a1f8d44 Sara Sharon   2015-12-08  1282  		switch (mgmt->u.action.u.vht_group_notif.action_code) {
23a1f8d44 Sara Sharon   2015-12-08  1283  		case WLAN_VHT_ACTION_GROUPID_MGMT:
23a1f8d44 Sara Sharon   2015-12-08 @1284  			ieee80211_process_mu_groups(sdata, mgmt);
23a1f8d44 Sara Sharon   2015-12-08  1285  			break;
23a1f8d44 Sara Sharon   2015-12-08  1286  		default:
23a1f8d44 Sara Sharon   2015-12-08  1287  			WARN_ON(1);
23a1f8d44 Sara Sharon   2015-12-08  1288  			break;
23a1f8d44 Sara Sharon   2015-12-08  1289  		}
344eec67c Johannes Berg 2010-06-10  1290  	} else if (ieee80211_is_data_qos(mgmt->frame_control)) {
344eec67c Johannes Berg 2010-06-10  1291  		struct ieee80211_hdr *hdr = (void *)mgmt;
344eec67c Johannes Berg 2010-06-10  1292  		/*
344eec67c Johannes Berg 2010-06-10  1293  		 * So the frame isn't mgmt, but frame_control
344eec67c Johannes Berg 2010-06-10  1294  		 * is at the right place anyway, of course, so
344eec67c Johannes Berg 2010-06-10  1295  		 * the if statement is correct.
344eec67c Johannes Berg 2010-06-10  1296  		 *
344eec67c Johannes Berg 2010-06-10  1297  		 * Warn if we have other data frame types here,
344eec67c Johannes Berg 2010-06-10  1298  		 * they must not get here.
344eec67c Johannes Berg 2010-06-10  1299  		 */
344eec67c Johannes Berg 2010-06-10  1300  		WARN_ON(hdr->frame_control &
344eec67c Johannes Berg 2010-06-10  1301  			cpu_to_le16(IEEE80211_STYPE_NULLFUNC));
f10059ca6 Alex Briskin  2016-07-15  1302  		WARN_ON(!(hdr->seq_ctrl & cpu_to_le16(IEEE80211_SCTL_FRAG)));
344eec67c Johannes Berg 2010-06-10  1303  		/*
344eec67c Johannes Berg 2010-06-10  1304  		 * This was a fragment of a frame, received while
344eec67c Johannes Berg 2010-06-10  1305  		 * a block-ack session was active. That cannot be
344eec67c Johannes Berg 2010-06-10  1306  		 * right, so terminate the session.
344eec67c Johannes Berg 2010-06-10  1307  		 */
a93e36443 Johannes Berg 2010-06-10  1308  		mutex_lock(&local->sta_mtx);
875ae5f68 Felix Fietkau 2010-07-17 @1309  		sta = sta_info_get_bss(sdata, mgmt->sa);
344eec67c Johannes Berg 2010-06-10  1310  		if (sta) {
344eec67c Johannes Berg 2010-06-10  1311  			u16 tid = *ieee80211_get_qos_ctl(hdr) &
344eec67c Johannes Berg 2010-06-10  1312  			    IEEE80211_QOS_CTL_TID_MASK;
344eec67c Johannes Berg 2010-06-10  1313  
f10059ca6 Alex Briskin  2016-07-15  1314  			__ieee80211_stop_rx_ba_session(sta, tid,
f10059ca6 Alex Briskin  2016-07-15  1315  						       WLAN_BACK_RECIPIENT,
53f73c09d Johannes Berg 2010-10-05  1316  						       WLAN_REASON_QSTA_REQUIRE_SETUP,
53f73c09d Johannes Berg 2010-10-05  1317  						       true);
344eec67c Johannes Berg 2010-06-10  1318  		}
a93e36443 Johannes Berg 2010-06-10  1319  		mutex_unlock(&local->sta_mtx);
f10059ca6 Alex Briskin  2016-07-15  1320  	} else {
f10059ca6 Alex Briskin  2016-07-15  1321  		return false;
f10059ca6 Alex Briskin  2016-07-15  1322  	}
f10059ca6 Alex Briskin  2016-07-15  1323  	return true;
f10059ca6 Alex Briskin  2016-07-15  1324  }
f10059ca6 Alex Briskin  2016-07-15  1325  
9ea4267a9 Alex Briskin  2016-07-15  1326  static void mac80211_skb_handle_by_vif_type(struct sk_buff *skb,
698f121a4 Alex Briskin  2016-07-15  1327  					    struct ieee80211_sub_if_data *sdata)
698f121a4 Alex Briskin  2016-07-15  1328  {
698f121a4 Alex Briskin  2016-07-15  1329  	switch (sdata->vif.type) {
698f121a4 Alex Briskin  2016-07-15  1330  	case NL80211_IFTYPE_STATION:
698f121a4 Alex Briskin  2016-07-15  1331  		ieee80211_sta_rx_queued_mgmt(sdata, skb);
698f121a4 Alex Briskin  2016-07-15  1332  		break;
698f121a4 Alex Briskin  2016-07-15  1333  	case NL80211_IFTYPE_ADHOC:
698f121a4 Alex Briskin  2016-07-15  1334  		ieee80211_ibss_rx_queued_mgmt(sdata, skb);
698f121a4 Alex Briskin  2016-07-15  1335  		break;
698f121a4 Alex Briskin  2016-07-15  1336  	case NL80211_IFTYPE_MESH_POINT:
698f121a4 Alex Briskin  2016-07-15  1337  		if (!ieee80211_vif_is_mesh(&sdata->vif))
698f121a4 Alex Briskin  2016-07-15  1338  			break;
698f121a4 Alex Briskin  2016-07-15  1339  		ieee80211_mesh_rx_queued_mgmt(sdata, skb);
698f121a4 Alex Briskin  2016-07-15  1340  		break;
698f121a4 Alex Briskin  2016-07-15  1341  	default:
698f121a4 Alex Briskin  2016-07-15  1342  		WARN(1, "frame for unexpected interface type");
698f121a4 Alex Briskin  2016-07-15  1343  		break;
698f121a4 Alex Briskin  2016-07-15  1344  	}
698f121a4 Alex Briskin  2016-07-15  1345  }
698f121a4 Alex Briskin  2016-07-15  1346  
f10059ca6 Alex Briskin  2016-07-15  1347  static void ieee80211_iface_work(struct work_struct *work)
f10059ca6 Alex Briskin  2016-07-15  1348  {
f10059ca6 Alex Briskin  2016-07-15  1349  	struct ieee80211_sub_if_data *sdata =
f10059ca6 Alex Briskin  2016-07-15  1350  		container_of(work, struct ieee80211_sub_if_data, work);
f10059ca6 Alex Briskin  2016-07-15  1351  	struct ieee80211_local *local = sdata->local;
f10059ca6 Alex Briskin  2016-07-15  1352  	struct sk_buff *skb;
f10059ca6 Alex Briskin  2016-07-15  1353  
f10059ca6 Alex Briskin  2016-07-15  1354  	if (!ieee80211_sdata_running(sdata))
f10059ca6 Alex Briskin  2016-07-15  1355  		return;
f10059ca6 Alex Briskin  2016-07-15  1356  
f10059ca6 Alex Briskin  2016-07-15  1357  	if (test_bit(SCAN_SW_SCANNING, &local->scanning))
f10059ca6 Alex Briskin  2016-07-15  1358  		return;
f10059ca6 Alex Briskin  2016-07-15  1359  
f10059ca6 Alex Briskin  2016-07-15  1360  	if (!ieee80211_can_run_worker(local))
f10059ca6 Alex Briskin  2016-07-15  1361  		return;
f10059ca6 Alex Briskin  2016-07-15  1362  
f10059ca6 Alex Briskin  2016-07-15  1363  	/* first process frames */
f10059ca6 Alex Briskin  2016-07-15  1364  	while ((skb = skb_dequeue(&sdata->skb_queue))) {
9ea4267a9 Alex Briskin  2016-07-15  1365  		if (!mac80211_is_skb_handled_by_pkt_type(skb, sdata) &&
9ea4267a9 Alex Briskin  2016-07-15 @1366  		    !mac80211_is_skb_handled_by_frame_control(skb, sdata)) {
9ea4267a9 Alex Briskin  2016-07-15  1367  			mac80211_skb_handle_by_vif_type(skb, sdata);
1fa57d017 Johannes Berg 2010-06-10  1368  		}
36b3a628a Johannes Berg 2010-06-10  1369  

:::::: The code at line 1251 was first introduced by commit
:::::: 4ea9593c0fc996ef6869e82aefc22a58ee6186f7 New function ieee80211_is_skb_handled_by_pkt_type

:::::: TO: Alex Briskin <br.shurik@gmail.com>
:::::: CC: 0day robot <fengguang.wu@intel.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--5vNYLRcllDrimb99
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
j1OtoICN1aL2Fz4pQw2DxQAA

--5vNYLRcllDrimb99--
