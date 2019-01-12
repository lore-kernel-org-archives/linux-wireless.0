Return-Path: <SRS0=z9X+=PU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3F03C43387
	for <linux-wireless@archiver.kernel.org>; Sat, 12 Jan 2019 10:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B488E213A2
	for <linux-wireless@archiver.kernel.org>; Sat, 12 Jan 2019 10:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbfALKy6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 12 Jan 2019 05:54:58 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:52842 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfALKy6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 Jan 2019 05:54:58 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0CAsroV186576;
        Sat, 12 Jan 2019 10:54:53 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2pybjn8cg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Jan 2019 10:54:53 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x0CAsqWK017291
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Jan 2019 10:54:52 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x0CAspGU007614;
        Sat, 12 Jan 2019 10:54:51 GMT
Received: from kadam (/41.202.241.51)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 12 Jan 2019 02:54:50 -0800
Date:   Sat, 12 Jan 2019 13:54:41 +0300
From:   kbuild test robot <lkp@intel.com>
To:     kbuild@01.org,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, kbuild-all@01.org,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: Re: [PATCH 3/7] qtnfmac: add support for 4addr mode
Message-ID: <20190112105441.GQ1718@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190109160843.14832-4-sergey.matyukevich.os@quantenna.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9133 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901120096
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Sergey,

url:    https://github.com/0day-ci/linux/commits/Sergey-Matyukevich/qtnfmac-fixes-and-minor-enhancements/20190111-030606
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master

smatch warnings:
drivers/net/wireless/quantenna/qtnfmac/cfg80211.c:142 qtnf_change_virtual_intf() error: we previously assumed 'params' could be null (see line 135)
drivers/net/wireless/quantenna/qtnfmac/cfg80211.c:232 qtnf_add_virtual_intf() error: we previously assumed 'params' could be null (see line 229)

# https://github.com/0day-ci/linux/commit/6bf96047ef769f18b29bbfae576d829462da53f3
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 6bf96047ef769f18b29bbfae576d829462da53f3
vim +/params +142 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c

01efff52 Sergey Matyukevich 2018-01-22  117  
01efff52 Sergey Matyukevich 2018-01-22  118  static int
98f44cb0 Igor Mitsyanko     2017-05-11  119  qtnf_change_virtual_intf(struct wiphy *wiphy,
98f44cb0 Igor Mitsyanko     2017-05-11  120  			 struct net_device *dev,
98f44cb0 Igor Mitsyanko     2017-05-11  121  			 enum nl80211_iftype type,
98f44cb0 Igor Mitsyanko     2017-05-11  122  			 struct vif_params *params)
98f44cb0 Igor Mitsyanko     2017-05-11  123  {
98f44cb0 Igor Mitsyanko     2017-05-11  124  	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
98f44cb0 Igor Mitsyanko     2017-05-11  125  	u8 *mac_addr;
98f44cb0 Igor Mitsyanko     2017-05-11  126  	int ret;
98f44cb0 Igor Mitsyanko     2017-05-11  127  
01efff52 Sergey Matyukevich 2018-01-22  128  	ret = qtnf_validate_iface_combinations(wiphy, vif, type);
01efff52 Sergey Matyukevich 2018-01-22  129  	if (ret) {
01efff52 Sergey Matyukevich 2018-01-22  130  		pr_err("VIF%u.%u combination check: failed to set type %d\n",
01efff52 Sergey Matyukevich 2018-01-22  131  		       vif->mac->macid, vif->vifid, type);
01efff52 Sergey Matyukevich 2018-01-22  132  		return ret;
01efff52 Sergey Matyukevich 2018-01-22  133  	}
01efff52 Sergey Matyukevich 2018-01-22  134  
98f44cb0 Igor Mitsyanko     2017-05-11 @135  	if (params)
98f44cb0 Igor Mitsyanko     2017-05-11  136  		mac_addr = params->macaddr;
98f44cb0 Igor Mitsyanko     2017-05-11  137  	else
98f44cb0 Igor Mitsyanko     2017-05-11  138  		mac_addr = NULL;
98f44cb0 Igor Mitsyanko     2017-05-11  139  
98f44cb0 Igor Mitsyanko     2017-05-11  140  	qtnf_scan_done(vif->mac, true);
98f44cb0 Igor Mitsyanko     2017-05-11  141  
6bf96047 Sergey Matyukevich 2019-01-09 @142  	ret = qtnf_cmd_send_change_intf_type(vif, type, params->use_4addr,
6bf96047 Sergey Matyukevich 2019-01-09  143  					     mac_addr);
98f44cb0 Igor Mitsyanko     2017-05-11  144  	if (ret) {
c6ed298f Sergey Matyukevich 2018-10-05  145  		pr_err("VIF%u.%u: failed to change type to %d\n",
c6ed298f Sergey Matyukevich 2018-10-05  146  		       vif->mac->macid, vif->vifid, type);
98f44cb0 Igor Mitsyanko     2017-05-11  147  		return ret;
98f44cb0 Igor Mitsyanko     2017-05-11  148  	}
98f44cb0 Igor Mitsyanko     2017-05-11  149  
98f44cb0 Igor Mitsyanko     2017-05-11  150  	vif->wdev.iftype = type;
98f44cb0 Igor Mitsyanko     2017-05-11  151  	return 0;
98f44cb0 Igor Mitsyanko     2017-05-11  152  }
98f44cb0 Igor Mitsyanko     2017-05-11  153  
98f44cb0 Igor Mitsyanko     2017-05-11  154  int qtnf_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
98f44cb0 Igor Mitsyanko     2017-05-11  155  {
98f44cb0 Igor Mitsyanko     2017-05-11  156  	struct net_device *netdev =  wdev->netdev;
98f44cb0 Igor Mitsyanko     2017-05-11  157  	struct qtnf_vif *vif;
98f44cb0 Igor Mitsyanko     2017-05-11  158  
98f44cb0 Igor Mitsyanko     2017-05-11  159  	if (WARN_ON(!netdev))
98f44cb0 Igor Mitsyanko     2017-05-11  160  		return -EFAULT;
98f44cb0 Igor Mitsyanko     2017-05-11  161  
98f44cb0 Igor Mitsyanko     2017-05-11  162  	vif = qtnf_netdev_get_priv(wdev->netdev);
98f44cb0 Igor Mitsyanko     2017-05-11  163  
a715b3a0 Sergey Matyukevich 2017-09-18  164  	qtnf_scan_done(vif->mac, true);
a715b3a0 Sergey Matyukevich 2017-09-18  165  
98f44cb0 Igor Mitsyanko     2017-05-11  166  	/* Stop data */
98f44cb0 Igor Mitsyanko     2017-05-11  167  	netif_tx_stop_all_queues(netdev);
98f44cb0 Igor Mitsyanko     2017-05-11  168  	if (netif_carrier_ok(netdev))
98f44cb0 Igor Mitsyanko     2017-05-11  169  		netif_carrier_off(netdev);
98f44cb0 Igor Mitsyanko     2017-05-11  170  
98f44cb0 Igor Mitsyanko     2017-05-11  171  	if (netdev->reg_state == NETREG_REGISTERED)
98f44cb0 Igor Mitsyanko     2017-05-11  172  		unregister_netdevice(netdev);
98f44cb0 Igor Mitsyanko     2017-05-11  173  
87affdde Vasily Ulyanov     2018-01-22  174  	if (qtnf_cmd_send_del_intf(vif))
87affdde Vasily Ulyanov     2018-01-22  175  		pr_err("VIF%u.%u: failed to delete VIF\n", vif->mac->macid,
87affdde Vasily Ulyanov     2018-01-22  176  		       vif->vifid);
87affdde Vasily Ulyanov     2018-01-22  177  
98f44cb0 Igor Mitsyanko     2017-05-11  178  	vif->netdev->ieee80211_ptr = NULL;
98f44cb0 Igor Mitsyanko     2017-05-11  179  	vif->netdev = NULL;
98f44cb0 Igor Mitsyanko     2017-05-11  180  	vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
98f44cb0 Igor Mitsyanko     2017-05-11  181  
98f44cb0 Igor Mitsyanko     2017-05-11  182  	return 0;
98f44cb0 Igor Mitsyanko     2017-05-11  183  }
98f44cb0 Igor Mitsyanko     2017-05-11  184  
98f44cb0 Igor Mitsyanko     2017-05-11  185  static struct wireless_dev *qtnf_add_virtual_intf(struct wiphy *wiphy,
98f44cb0 Igor Mitsyanko     2017-05-11  186  						  const char *name,
98f44cb0 Igor Mitsyanko     2017-05-11  187  						  unsigned char name_assign_t,
98f44cb0 Igor Mitsyanko     2017-05-11  188  						  enum nl80211_iftype type,
98f44cb0 Igor Mitsyanko     2017-05-11  189  						  struct vif_params *params)
98f44cb0 Igor Mitsyanko     2017-05-11  190  {
98f44cb0 Igor Mitsyanko     2017-05-11  191  	struct qtnf_wmac *mac;
98f44cb0 Igor Mitsyanko     2017-05-11  192  	struct qtnf_vif *vif;
98f44cb0 Igor Mitsyanko     2017-05-11  193  	u8 *mac_addr = NULL;
01efff52 Sergey Matyukevich 2018-01-22  194  	int ret;
98f44cb0 Igor Mitsyanko     2017-05-11  195  
98f44cb0 Igor Mitsyanko     2017-05-11  196  	mac = wiphy_priv(wiphy);
98f44cb0 Igor Mitsyanko     2017-05-11  197  
98f44cb0 Igor Mitsyanko     2017-05-11  198  	if (!mac)
98f44cb0 Igor Mitsyanko     2017-05-11  199  		return ERR_PTR(-EFAULT);
98f44cb0 Igor Mitsyanko     2017-05-11  200  
01efff52 Sergey Matyukevich 2018-01-22  201  	ret = qtnf_validate_iface_combinations(wiphy, NULL, type);
01efff52 Sergey Matyukevich 2018-01-22  202  	if (ret) {
01efff52 Sergey Matyukevich 2018-01-22  203  		pr_err("MAC%u invalid combination: failed to add type %d\n",
01efff52 Sergey Matyukevich 2018-01-22  204  		       mac->macid, type);
01efff52 Sergey Matyukevich 2018-01-22  205  		return ERR_PTR(ret);
01efff52 Sergey Matyukevich 2018-01-22  206  	}
01efff52 Sergey Matyukevich 2018-01-22  207  
98f44cb0 Igor Mitsyanko     2017-05-11  208  	switch (type) {
98f44cb0 Igor Mitsyanko     2017-05-11  209  	case NL80211_IFTYPE_STATION:
98f44cb0 Igor Mitsyanko     2017-05-11  210  	case NL80211_IFTYPE_AP:
98f44cb0 Igor Mitsyanko     2017-05-11  211  		vif = qtnf_mac_get_free_vif(mac);
98f44cb0 Igor Mitsyanko     2017-05-11  212  		if (!vif) {
98f44cb0 Igor Mitsyanko     2017-05-11  213  			pr_err("MAC%u: no free VIF available\n", mac->macid);
98f44cb0 Igor Mitsyanko     2017-05-11  214  			return ERR_PTR(-EFAULT);
98f44cb0 Igor Mitsyanko     2017-05-11  215  		}
98f44cb0 Igor Mitsyanko     2017-05-11  216  
98f44cb0 Igor Mitsyanko     2017-05-11  217  		eth_zero_addr(vif->mac_addr);
9a3beeb5 Sergey Matyukevich 2018-05-29  218  		eth_zero_addr(vif->bssid);
98f44cb0 Igor Mitsyanko     2017-05-11  219  		vif->bss_priority = QTNF_DEF_BSS_PRIORITY;
9a3beeb5 Sergey Matyukevich 2018-05-29  220  		memset(&vif->wdev, 0, sizeof(vif->wdev));
98f44cb0 Igor Mitsyanko     2017-05-11  221  		vif->wdev.wiphy = wiphy;
98f44cb0 Igor Mitsyanko     2017-05-11  222  		vif->wdev.iftype = type;
98f44cb0 Igor Mitsyanko     2017-05-11  223  		break;
98f44cb0 Igor Mitsyanko     2017-05-11  224  	default:
98f44cb0 Igor Mitsyanko     2017-05-11  225  		pr_err("MAC%u: unsupported IF type %d\n", mac->macid, type);
98f44cb0 Igor Mitsyanko     2017-05-11  226  		return ERR_PTR(-ENOTSUPP);
98f44cb0 Igor Mitsyanko     2017-05-11  227  	}
98f44cb0 Igor Mitsyanko     2017-05-11  228  
98f44cb0 Igor Mitsyanko     2017-05-11 @229  	if (params)
98f44cb0 Igor Mitsyanko     2017-05-11  230  		mac_addr = params->macaddr;
98f44cb0 Igor Mitsyanko     2017-05-11  231  
6bf96047 Sergey Matyukevich 2019-01-09 @232  	ret = qtnf_cmd_send_add_intf(vif, type, params->use_4addr, mac_addr);
c6ed298f Sergey Matyukevich 2018-10-05  233  	if (ret) {
c6ed298f Sergey Matyukevich 2018-10-05  234  		pr_err("VIF%u.%u: failed to add VIF %pM\n",
c6ed298f Sergey Matyukevich 2018-10-05  235  		       mac->macid, vif->vifid, mac_addr);
98f44cb0 Igor Mitsyanko     2017-05-11  236  		goto err_cmd;
98f44cb0 Igor Mitsyanko     2017-05-11  237  	}
98f44cb0 Igor Mitsyanko     2017-05-11  238  
98f44cb0 Igor Mitsyanko     2017-05-11  239  	if (!is_valid_ether_addr(vif->mac_addr)) {
98f44cb0 Igor Mitsyanko     2017-05-11  240  		pr_err("VIF%u.%u: FW reported bad MAC: %pM\n",
98f44cb0 Igor Mitsyanko     2017-05-11  241  		       mac->macid, vif->vifid, vif->mac_addr);
c6ed298f Sergey Matyukevich 2018-10-05  242  		ret = -EINVAL;
98f44cb0 Igor Mitsyanko     2017-05-11  243  		goto err_mac;
98f44cb0 Igor Mitsyanko     2017-05-11  244  	}
98f44cb0 Igor Mitsyanko     2017-05-11  245  
c6ed298f Sergey Matyukevich 2018-10-05  246  	ret = qtnf_core_net_attach(mac, vif, name, name_assign_t);
c6ed298f Sergey Matyukevich 2018-10-05  247  	if (ret) {
98f44cb0 Igor Mitsyanko     2017-05-11  248  		pr_err("VIF%u.%u: failed to attach netdev\n", mac->macid,
98f44cb0 Igor Mitsyanko     2017-05-11  249  		       vif->vifid);
98f44cb0 Igor Mitsyanko     2017-05-11  250  		goto err_net;
98f44cb0 Igor Mitsyanko     2017-05-11  251  	}
98f44cb0 Igor Mitsyanko     2017-05-11  252  
98f44cb0 Igor Mitsyanko     2017-05-11  253  	vif->wdev.netdev = vif->netdev;
98f44cb0 Igor Mitsyanko     2017-05-11  254  	return &vif->wdev;
98f44cb0 Igor Mitsyanko     2017-05-11  255  
98f44cb0 Igor Mitsyanko     2017-05-11  256  err_net:
98f44cb0 Igor Mitsyanko     2017-05-11  257  	vif->netdev = NULL;
98f44cb0 Igor Mitsyanko     2017-05-11  258  err_mac:
98f44cb0 Igor Mitsyanko     2017-05-11  259  	qtnf_cmd_send_del_intf(vif);
98f44cb0 Igor Mitsyanko     2017-05-11  260  err_cmd:
98f44cb0 Igor Mitsyanko     2017-05-11  261  	vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
98f44cb0 Igor Mitsyanko     2017-05-11  262  
c6ed298f Sergey Matyukevich 2018-10-05  263  	return ERR_PTR(ret);
98f44cb0 Igor Mitsyanko     2017-05-11  264  }
98f44cb0 Igor Mitsyanko     2017-05-11  265  

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
