Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:26282 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752785AbeA3N7m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Jan 2018 08:59:42 -0500
Date: Tue, 30 Jan 2018 19:29:49 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: kbuild test robot <lkp@intel.com>
CC: <kbuild-all@01.org>, <linux-wireless@vger.kernel.org>,
        <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>
Subject: Re: [PATCH v2 13/14] staging: wilc1000: rename Handle_Connect() to
 avoid camelCase
Message-ID: <20180130192949.016ed06a@ajaysk-VirtualBox> (sfid-20180130_150006_233162_C96CE739)
In-Reply-To: <201801300113.VYPjzW6k%fengguang.wu@intel.com>
References: <1516616547-24654-14-git-send-email-ajay.kathat@microchip.com>
        <201801300113.VYPjzW6k%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 30 Jan 2018 02:13:53 +0800
kbuild test robot <lkp@intel.com> wrote:

> Hi Ajay,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on staging/staging-testing]
> [cannot apply to v4.15 next-20180126]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Ajay-Singh/fix-to-remove-unnecessary-parenthesis-typedef-and-avoid-camelCase/20180123-115314
> 
> New smatch warnings:
> drivers/staging/wilc1000/host_interface.c:937 handle_connect() error: potential null dereference 'hif_drv->usr_conn_req.ssid'.  (kmalloc returns null)
> 
> Old smatch warnings:
> drivers/staging/wilc1000/host_interface.c:514 handle_cfg_param() warn: always true condition '(cfg_param_attr->auth_timeout < 65536) => (0-u16max < 65536)'
> drivers/staging/wilc1000/host_interface.c:583 handle_cfg_param() warn: always true condition '(cfg_param_attr->rts_threshold < 65536) => (0-u16max < 65536)'
> drivers/staging/wilc1000/host_interface.c:636 handle_cfg_param() warn: always true condition '(cfg_param_attr->beacon_interval < 65536) => (0-u16max < 65536)'
> drivers/staging/wilc1000/host_interface.c:677 handle_cfg_param() warn: always true condition '(cfg_param_attr->site_survey_scan_time < 65536) => (0-u16max < 65536)'
> drivers/staging/wilc1000/host_interface.c:691 handle_cfg_param() warn: always true condition '(cfg_param_attr->active_scan_time < 65536) => (0-u16max < 65536)'
> drivers/staging/wilc1000/host_interface.c:705 handle_cfg_param() warn: always true condition '(cfg_param_attr->passive_scan_time < 65536) => (0-u16max < 65536)'
> 
> vim +937 drivers/staging/wilc1000/host_interface.c
> 
> c5c77ba1 Johnny Kim   2015-05-11   903  
> e554a305 Leo Kim      2015-11-19   904  u8 wilc_connected_ssid[6] = {0};
> cd1931cf Ajay Singh   2018-01-22   905  static s32 handle_connect(struct wilc_vif *vif,
> 3891285c Ajay Singh   2018-01-22   906  			  struct connect_attr *attr)
> c5c77ba1 Johnny Kim   2015-05-11   907  {
> 31390eec Leo Kim      2015-10-19   908  	s32 result = 0;
> 5a99cdf9 Ajay Singh   2018-01-22   909  	struct wid wid_list[8];
> 7046f41b Ajay Singh   2018-01-22   910  	u32 wid_cnt = 0, dummyval = 0;
> 44ea7461 Ajay Singh   2018-01-22   911  	u8 *cur_byte = NULL;
> 5e18dd82 Ajay Singh   2018-01-22   912  	struct join_bss_param *bss_param;
> 71130e81 Glen Lee     2015-12-21   913  	struct host_if_drv *hif_drv = vif->hif_drv;
> c5c77ba1 Johnny Kim   2015-05-11   914  
> 3891285c Ajay Singh   2018-01-22   915  	if (memcmp(attr->bssid, wilc_connected_ssid, ETH_ALEN) == 0) {
> 31390eec Leo Kim      2015-10-19   916  		result = 0;
> b92f9304 Chris Park   2016-02-22   917  		netdev_err(vif->ndev, "Discard connect request\n");
> 31390eec Leo Kim      2015-10-19   918  		return result;
> c5c77ba1 Johnny Kim   2015-05-11   919  	}
> c5c77ba1 Johnny Kim   2015-05-11   920  
> 5e18dd82 Ajay Singh   2018-01-22   921  	bss_param = attr->params;
> 5e18dd82 Ajay Singh   2018-01-22   922  	if (!bss_param) {
> b92f9304 Chris Park   2016-02-22   923  		netdev_err(vif->ndev, "Required BSSID not found\n");
> 31390eec Leo Kim      2015-10-19   924  		result = -ENOENT;
> 24db713f Leo Kim      2015-09-16   925  		goto ERRORHANDLER;
> c5c77ba1 Johnny Kim   2015-05-11   926  	}
> c5c77ba1 Johnny Kim   2015-05-11   927  
> 3891285c Ajay Singh   2018-01-22   928  	if (attr->bssid) {
> 788f6fc0 Chaehyun Lim 2016-02-12   929  		hif_drv->usr_conn_req.bssid = kmalloc(6, GFP_KERNEL);
> 3891285c Ajay Singh   2018-01-22   930  		memcpy(hif_drv->usr_conn_req.bssid, attr->bssid, 6);
> c5c77ba1 Johnny Kim   2015-05-11   931  	}
> c5c77ba1 Johnny Kim   2015-05-11   932  
> 3891285c Ajay Singh   2018-01-22   933  	hif_drv->usr_conn_req.ssid_len = attr->ssid_len;
> 3891285c Ajay Singh   2018-01-22   934  	if (attr->ssid) {
> 3891285c Ajay Singh   2018-01-22   935  		hif_drv->usr_conn_req.ssid = kmalloc(attr->ssid_len + 1, GFP_KERNEL);
> 3891285c Ajay Singh   2018-01-22   936  		memcpy(hif_drv->usr_conn_req.ssid, attr->ssid, attr->ssid_len);
> 3891285c Ajay Singh   2018-01-22  @937  		hif_drv->usr_conn_req.ssid[attr->ssid_len] = '\0';
> c5c77ba1 Johnny Kim   2015-05-11   938  	}
> c5c77ba1 Johnny Kim   2015-05-11   939  
> 3891285c Ajay Singh   2018-01-22   940  	hif_drv->usr_conn_req.ies_len = attr->ies_len;
> 3891285c Ajay Singh   2018-01-22   941  	if (attr->ies) {
> 3891285c Ajay Singh   2018-01-22   942  		hif_drv->usr_conn_req.ies = kmalloc(attr->ies_len, GFP_KERNEL);
> 3891285c Ajay Singh   2018-01-22   943  		memcpy(hif_drv->usr_conn_req.ies, attr->ies, attr->ies_len);
> c5c77ba1 Johnny Kim   2015-05-11   944  	}
> c5c77ba1 Johnny Kim   2015-05-11   945  
> 3891285c Ajay Singh   2018-01-22   946  	hif_drv->usr_conn_req.security = attr->security;
> 3891285c Ajay Singh   2018-01-22   947  	hif_drv->usr_conn_req.auth_type = attr->auth_type;
> 3891285c Ajay Singh   2018-01-22   948  	hif_drv->usr_conn_req.conn_result = attr->result;
> 3891285c Ajay Singh   2018-01-22   949  	hif_drv->usr_conn_req.arg = attr->arg;
> c5c77ba1 Johnny Kim   2015-05-11   950  
> 7046f41b Ajay Singh   2018-01-22   951  	wid_list[wid_cnt].id = WID_SUCCESS_FRAME_COUNT;
> 7046f41b Ajay Singh   2018-01-22   952  	wid_list[wid_cnt].type = WID_INT;
> 7046f41b Ajay Singh   2018-01-22   953  	wid_list[wid_cnt].size = sizeof(u32);
> 7046f41b Ajay Singh   2018-01-22   954  	wid_list[wid_cnt].val = (s8 *)(&(dummyval));
> 7046f41b Ajay Singh   2018-01-22   955  	wid_cnt++;
> c5c77ba1 Johnny Kim   2015-05-11   956  
> 7046f41b Ajay Singh   2018-01-22   957  	wid_list[wid_cnt].id = WID_RECEIVED_FRAGMENT_COUNT;
> 7046f41b Ajay Singh   2018-01-22   958  	wid_list[wid_cnt].type = WID_INT;
> 7046f41b Ajay Singh   2018-01-22   959  	wid_list[wid_cnt].size = sizeof(u32);
> 7046f41b Ajay Singh   2018-01-22   960  	wid_list[wid_cnt].val = (s8 *)(&(dummyval));
> 7046f41b Ajay Singh   2018-01-22   961  	wid_cnt++;
> c5c77ba1 Johnny Kim   2015-05-11   962  
> 7046f41b Ajay Singh   2018-01-22   963  	wid_list[wid_cnt].id = WID_FAILED_COUNT;
> 7046f41b Ajay Singh   2018-01-22   964  	wid_list[wid_cnt].type = WID_INT;
> 7046f41b Ajay Singh   2018-01-22   965  	wid_list[wid_cnt].size = sizeof(u32);
> 7046f41b Ajay Singh   2018-01-22   966  	wid_list[wid_cnt].val = (s8 *)(&(dummyval));
> 7046f41b Ajay Singh   2018-01-22   967  	wid_cnt++;
> c5c77ba1 Johnny Kim   2015-05-11   968  
> c5c77ba1 Johnny Kim   2015-05-11   969  	{
> 7046f41b Ajay Singh   2018-01-22   970  		wid_list[wid_cnt].id = WID_INFO_ELEMENT_ASSOCIATE;
> 7046f41b Ajay Singh   2018-01-22   971  		wid_list[wid_cnt].type = WID_BIN_DATA;
> 7046f41b Ajay Singh   2018-01-22   972  		wid_list[wid_cnt].val = hif_drv->usr_conn_req.ies;
> 7046f41b Ajay Singh   2018-01-22   973  		wid_list[wid_cnt].size = hif_drv->usr_conn_req.ies_len;
> 7046f41b Ajay Singh   2018-01-22   974  		wid_cnt++;
> c5c77ba1 Johnny Kim   2015-05-11   975  
> 3891285c Ajay Singh   2018-01-22   976  		if (memcmp("DIRECT-", attr->ssid, 7)) {
> 331ed080 Leo Kim      2015-10-29   977  			info_element_size = hif_drv->usr_conn_req.ies_len;
> dfef7b84 Leo Kim      2015-10-15   978  			info_element = kmalloc(info_element_size, GFP_KERNEL);
> a3b2f4b9 Leo Kim      2015-10-29   979  			memcpy(info_element, hif_drv->usr_conn_req.ies,
> dfef7b84 Leo Kim      2015-10-15   980  			       info_element_size);
> c5c77ba1 Johnny Kim   2015-05-11   981  		}
> c5c77ba1 Johnny Kim   2015-05-11   982  	}
> 7046f41b Ajay Singh   2018-01-22   983  	wid_list[wid_cnt].id = (u16)WID_11I_MODE;
> 7046f41b Ajay Singh   2018-01-22   984  	wid_list[wid_cnt].type = WID_CHAR;
> 7046f41b Ajay Singh   2018-01-22   985  	wid_list[wid_cnt].size = sizeof(char);
> 7046f41b Ajay Singh   2018-01-22   986  	wid_list[wid_cnt].val = (s8 *)&hif_drv->usr_conn_req.security;
> 7046f41b Ajay Singh   2018-01-22   987  	wid_cnt++;
> c5c77ba1 Johnny Kim   2015-05-11   988  
> 3891285c Ajay Singh   2018-01-22   989  	if (memcmp("DIRECT-", attr->ssid, 7))
> a0942c57 Chaehyun Lim 2016-02-12   990  		mode_11i = hif_drv->usr_conn_req.security;
> c5c77ba1 Johnny Kim   2015-05-11   991  
> 7046f41b Ajay Singh   2018-01-22   992  	wid_list[wid_cnt].id = (u16)WID_AUTH_TYPE;
> 7046f41b Ajay Singh   2018-01-22   993  	wid_list[wid_cnt].type = WID_CHAR;
> 7046f41b Ajay Singh   2018-01-22   994  	wid_list[wid_cnt].size = sizeof(char);
> 7046f41b Ajay Singh   2018-01-22   995  	wid_list[wid_cnt].val = (s8 *)&hif_drv->usr_conn_req.auth_type;
> 7046f41b Ajay Singh   2018-01-22   996  	wid_cnt++;
> c5c77ba1 Johnny Kim   2015-05-11   997  
> 3891285c Ajay Singh   2018-01-22   998  	if (memcmp("DIRECT-", attr->ssid, 7))
> 7d069728 Leo Kim      2015-10-29   999  		auth_type = (u8)hif_drv->usr_conn_req.auth_type;
> c5c77ba1 Johnny Kim   2015-05-11  1000  
> 7046f41b Ajay Singh   2018-01-22  1001  	wid_list[wid_cnt].id = (u16)WID_JOIN_REQ_EXTENDED;
> 7046f41b Ajay Singh   2018-01-22  1002  	wid_list[wid_cnt].type = WID_STR;
> 7046f41b Ajay Singh   2018-01-22  1003  	wid_list[wid_cnt].size = 112;
> 7046f41b Ajay Singh   2018-01-22  1004  	wid_list[wid_cnt].val = kmalloc(wid_list[wid_cnt].size, GFP_KERNEL);
> c5c77ba1 Johnny Kim   2015-05-11  1005  
> 3891285c Ajay Singh   2018-01-22  1006  	if (memcmp("DIRECT-", attr->ssid, 7)) {
> 7046f41b Ajay Singh   2018-01-22  1007  		join_req_size = wid_list[wid_cnt].size;
> 0626baaa Leo Kim      2015-10-15  1008  		join_req = kmalloc(join_req_size, GFP_KERNEL);
> c5c77ba1 Johnny Kim   2015-05-11  1009  	}
> 7046f41b Ajay Singh   2018-01-22  1010  	if (!wid_list[wid_cnt].val) {
> 31390eec Leo Kim      2015-10-19  1011  		result = -EFAULT;
> 24db713f Leo Kim      2015-09-16  1012  		goto ERRORHANDLER;
> 24db713f Leo Kim      2015-09-16  1013  	}
> c5c77ba1 Johnny Kim   2015-05-11  1014  
> 44ea7461 Ajay Singh   2018-01-22  1015  	cur_byte = wid_list[wid_cnt].val;
> c5c77ba1 Johnny Kim   2015-05-11  1016  
> 3891285c Ajay Singh   2018-01-22  1017  	if (attr->ssid) {
> 3891285c Ajay Singh   2018-01-22  1018  		memcpy(cur_byte, attr->ssid, attr->ssid_len);
> 3891285c Ajay Singh   2018-01-22  1019  		cur_byte[attr->ssid_len] = '\0';
> c5c77ba1 Johnny Kim   2015-05-11  1020  	}
> 44ea7461 Ajay Singh   2018-01-22  1021  	cur_byte += MAX_SSID_LEN;
> 44ea7461 Ajay Singh   2018-01-22  1022  	*(cur_byte++) = INFRASTRUCTURE;
> ae4dfa57 Leo Kim      2015-10-13  1023  
> 3891285c Ajay Singh   2018-01-22  1024  	if (attr->ch >= 1 && attr->ch <= 14) {
> 3891285c Ajay Singh   2018-01-22  1025  		*(cur_byte++) = attr->ch;
> c5c77ba1 Johnny Kim   2015-05-11  1026  	} else {
> b92f9304 Chris Park   2016-02-22  1027  		netdev_err(vif->ndev, "Channel out of range\n");
> 44ea7461 Ajay Singh   2018-01-22  1028  		*(cur_byte++) = 0xFF;
> c5c77ba1 Johnny Kim   2015-05-11  1029  	}
> 5e18dd82 Ajay Singh   2018-01-22  1030  	*(cur_byte++)  = (bss_param->cap_info) & 0xFF;
> 5e18dd82 Ajay Singh   2018-01-22  1031  	*(cur_byte++)  = ((bss_param->cap_info) >> 8) & 0xFF;
> c5c77ba1 Johnny Kim   2015-05-11  1032  
> 3891285c Ajay Singh   2018-01-22  1033  	if (attr->bssid)
> 3891285c Ajay Singh   2018-01-22  1034  		memcpy(cur_byte, attr->bssid, 6);
> 44ea7461 Ajay Singh   2018-01-22  1035  	cur_byte += 6;
> c5c77ba1 Johnny Kim   2015-05-11  1036  
> 3891285c Ajay Singh   2018-01-22  1037  	if (attr->bssid)
> 3891285c Ajay Singh   2018-01-22  1038  		memcpy(cur_byte, attr->bssid, 6);
> 44ea7461 Ajay Singh   2018-01-22  1039  	cur_byte += 6;
> c0f52fba Tony Cho     2015-10-20  1040  
> 5e18dd82 Ajay Singh   2018-01-22  1041  	*(cur_byte++)  = (bss_param->beacon_period) & 0xFF;
> 5e18dd82 Ajay Singh   2018-01-22  1042  	*(cur_byte++)  = ((bss_param->beacon_period) >> 8) & 0xFF;
> 5e18dd82 Ajay Singh   2018-01-22  1043  	*(cur_byte++)  =  bss_param->dtim_period;
> ae4dfa57 Leo Kim      2015-10-13  1044  
> 5e18dd82 Ajay Singh   2018-01-22  1045  	memcpy(cur_byte, bss_param->supp_rates, MAX_RATES_SUPPORTED + 1);
> 44ea7461 Ajay Singh   2018-01-22  1046  	cur_byte += (MAX_RATES_SUPPORTED + 1);
> c5c77ba1 Johnny Kim   2015-05-11  1047  
> 5e18dd82 Ajay Singh   2018-01-22  1048  	*(cur_byte++)  =  bss_param->wmm_cap;
> 5e18dd82 Ajay Singh   2018-01-22  1049  	*(cur_byte++)  = bss_param->uapsd_cap;
> c5c77ba1 Johnny Kim   2015-05-11  1050  
> 5e18dd82 Ajay Singh   2018-01-22  1051  	*(cur_byte++)  = bss_param->ht_capable;
> 5e18dd82 Ajay Singh   2018-01-22  1052  	hif_drv->usr_conn_req.ht_capable = bss_param->ht_capable;
> c5c77ba1 Johnny Kim   2015-05-11  1053  
> 5e18dd82 Ajay Singh   2018-01-22  1054  	*(cur_byte++)  =  bss_param->rsn_found;
> 5e18dd82 Ajay Singh   2018-01-22  1055  	*(cur_byte++)  =  bss_param->rsn_grp_policy;
> 5e18dd82 Ajay Singh   2018-01-22  1056  	*(cur_byte++) =  bss_param->mode_802_11i;
> ae4dfa57 Leo Kim      2015-10-13  1057  
> 5e18dd82 Ajay Singh   2018-01-22  1058  	memcpy(cur_byte, bss_param->rsn_pcip_policy, sizeof(bss_param->rsn_pcip_policy));
> 5e18dd82 Ajay Singh   2018-01-22  1059  	cur_byte += sizeof(bss_param->rsn_pcip_policy);
> c5c77ba1 Johnny Kim   2015-05-11  1060  
> 5e18dd82 Ajay Singh   2018-01-22  1061  	memcpy(cur_byte, bss_param->rsn_auth_policy, sizeof(bss_param->rsn_auth_policy));
> 5e18dd82 Ajay Singh   2018-01-22  1062  	cur_byte += sizeof(bss_param->rsn_auth_policy);
> c5c77ba1 Johnny Kim   2015-05-11  1063  
> 5e18dd82 Ajay Singh   2018-01-22  1064  	memcpy(cur_byte, bss_param->rsn_cap, sizeof(bss_param->rsn_cap));
> 5e18dd82 Ajay Singh   2018-01-22  1065  	cur_byte += sizeof(bss_param->rsn_cap);
> c5c77ba1 Johnny Kim   2015-05-11  1066  
> 44ea7461 Ajay Singh   2018-01-22  1067  	*(cur_byte++) = REAL_JOIN_REQ;
> 5e18dd82 Ajay Singh   2018-01-22  1068  	*(cur_byte++) = bss_param->noa_enabled;
> c5c77ba1 Johnny Kim   2015-05-11  1069  
> 5e18dd82 Ajay Singh   2018-01-22  1070  	if (bss_param->noa_enabled) {
> 5e18dd82 Ajay Singh   2018-01-22  1071  		*(cur_byte++) = (bss_param->tsf) & 0xFF;
> 5e18dd82 Ajay Singh   2018-01-22  1072  		*(cur_byte++) = ((bss_param->tsf) >> 8) & 0xFF;
> 5e18dd82 Ajay Singh   2018-01-22  1073  		*(cur_byte++) = ((bss_param->tsf) >> 16) & 0xFF;
> 5e18dd82 Ajay Singh   2018-01-22  1074  		*(cur_byte++) = ((bss_param->tsf) >> 24) & 0xFF;
> c5c77ba1 Johnny Kim   2015-05-11  1075  
> 5e18dd82 Ajay Singh   2018-01-22  1076  		*(cur_byte++) = bss_param->opp_enabled;
> 5e18dd82 Ajay Singh   2018-01-22  1077  		*(cur_byte++) = bss_param->idx;
> c5c77ba1 Johnny Kim   2015-05-11  1078  
> 5e18dd82 Ajay Singh   2018-01-22  1079  		if (bss_param->opp_enabled)
> 5e18dd82 Ajay Singh   2018-01-22  1080  			*(cur_byte++) = bss_param->ct_window;
> c5c77ba1 Johnny Kim   2015-05-11  1081  
> 5e18dd82 Ajay Singh   2018-01-22  1082  		*(cur_byte++) = bss_param->cnt;
> c5c77ba1 Johnny Kim   2015-05-11  1083  
> 5e18dd82 Ajay Singh   2018-01-22  1084  		memcpy(cur_byte, bss_param->duration, sizeof(bss_param->duration));
> 5e18dd82 Ajay Singh   2018-01-22  1085  		cur_byte += sizeof(bss_param->duration);
> c5c77ba1 Johnny Kim   2015-05-11  1086  
> 5e18dd82 Ajay Singh   2018-01-22  1087  		memcpy(cur_byte, bss_param->interval, sizeof(bss_param->interval));
> 5e18dd82 Ajay Singh   2018-01-22  1088  		cur_byte += sizeof(bss_param->interval);
> c5c77ba1 Johnny Kim   2015-05-11  1089  
> 5e18dd82 Ajay Singh   2018-01-22  1090  		memcpy(cur_byte, bss_param->start_time, sizeof(bss_param->start_time));
> 5e18dd82 Ajay Singh   2018-01-22  1091  		cur_byte += sizeof(bss_param->start_time);
> c4f97526 Chris Park   2016-02-04  1092  	}
> c5c77ba1 Johnny Kim   2015-05-11  1093  
> 44ea7461 Ajay Singh   2018-01-22  1094  	cur_byte = wid_list[wid_cnt].val;
> 7046f41b Ajay Singh   2018-01-22  1095  	wid_cnt++;
> c5c77ba1 Johnny Kim   2015-05-11  1096  
> 3891285c Ajay Singh   2018-01-22  1097  	if (memcmp("DIRECT-", attr->ssid, 7)) {
> 44ea7461 Ajay Singh   2018-01-22  1098  		memcpy(join_req, cur_byte, join_req_size);
> 7036c624 Glen Lee     2015-12-21  1099  		join_req_vif = vif;
> c5c77ba1 Johnny Kim   2015-05-11  1100  	}
> c5c77ba1 Johnny Kim   2015-05-11  1101  
> 3891285c Ajay Singh   2018-01-22  1102  	if (attr->bssid)
> 3891285c Ajay Singh   2018-01-22  1103  		memcpy(wilc_connected_ssid,attr->bssid, ETH_ALEN);
> c5c77ba1 Johnny Kim   2015-05-11  1104  
> 5a99cdf9 Ajay Singh   2018-01-22  1105  	result = wilc_send_config_pkt(vif, SET_CFG, wid_list,
> 7046f41b Ajay Singh   2018-01-22  1106  				      wid_cnt,
> eb9939b7 Glen Lee     2015-12-21  1107  				      wilc_get_vif_idx(vif));
> 31390eec Leo Kim      2015-10-19  1108  	if (result) {
> b92f9304 Chris Park   2016-02-22  1109  		netdev_err(vif->ndev, "failed to send config packet\n");
> 31390eec Leo Kim      2015-10-19  1110  		result = -EFAULT;
> 24db713f Leo Kim      2015-09-16  1111  		goto ERRORHANDLER;
> c5c77ba1 Johnny Kim   2015-05-11  1112  	} else {
> b60005a8 Leo Kim      2015-10-29  1113  		hif_drv->hif_state = HOST_IF_WAITING_CONN_RESP;
> c5c77ba1 Johnny Kim   2015-05-11  1114  	}
> c5c77ba1 Johnny Kim   2015-05-11  1115  
> 24db713f Leo Kim      2015-09-16  1116  ERRORHANDLER:
> 31390eec Leo Kim      2015-10-19  1117  	if (result) {
> 6a247004 Ajay Singh   2018-01-22  1118  		struct connect_info conn_info;
> c5c77ba1 Johnny Kim   2015-05-11  1119  
> 81a59506 Leo Kim      2015-10-29  1120  		del_timer(&hif_drv->connect_timer);
> c5c77ba1 Johnny Kim   2015-05-11  1121  
> 6a247004 Ajay Singh   2018-01-22  1122  		memset(&conn_info, 0, sizeof(struct connect_info));
> c5c77ba1 Johnny Kim   2015-05-11  1123  
> 3891285c Ajay Singh   2018-01-22  1124  		if (attr->result) {
> 3891285c Ajay Singh   2018-01-22  1125  			if (attr->bssid)
> 6a247004 Ajay Singh   2018-01-22  1126  				memcpy(conn_info.bssid, attr->bssid, 6);
> c5c77ba1 Johnny Kim   2015-05-11  1127  
> 3891285c Ajay Singh   2018-01-22  1128  			if (attr->ies) {
> 6a247004 Ajay Singh   2018-01-22  1129  				conn_info.req_ies_len = attr->ies_len;
> 6a247004 Ajay Singh   2018-01-22  1130  				conn_info.req_ies = kmalloc(attr->ies_len, GFP_KERNEL);
> 6a247004 Ajay Singh   2018-01-22  1131  				memcpy(conn_info.req_ies, attr->ies, attr->ies_len);
> c5c77ba1 Johnny Kim   2015-05-11  1132  			}
> c5c77ba1 Johnny Kim   2015-05-11  1133  
> 3891285c Ajay Singh   2018-01-22  1134  			attr->result(CONN_DISCONN_EVENT_CONN_RESP,
> 6a247004 Ajay Singh   2018-01-22  1135  							       &conn_info,
> c5c77ba1 Johnny Kim   2015-05-11  1136  							       MAC_DISCONNECTED,
> c5c77ba1 Johnny Kim   2015-05-11  1137  							       NULL,
> 3891285c Ajay Singh   2018-01-22  1138  							       attr->arg);
> b60005a8 Leo Kim      2015-10-29  1139  			hif_drv->hif_state = HOST_IF_IDLE;
> 6a247004 Ajay Singh   2018-01-22  1140  			kfree(conn_info.req_ies);
> 6a247004 Ajay Singh   2018-01-22  1141  			conn_info.req_ies = NULL;
> c5c77ba1 Johnny Kim   2015-05-11  1142  
> c5c77ba1 Johnny Kim   2015-05-11  1143  		} else {
> b92f9304 Chris Park   2016-02-22  1144  			netdev_err(vif->ndev, "Connect callback is NULL\n");
> c5c77ba1 Johnny Kim   2015-05-11  1145  		}
> c5c77ba1 Johnny Kim   2015-05-11  1146  	}
> c5c77ba1 Johnny Kim   2015-05-11  1147  
> 3891285c Ajay Singh   2018-01-22  1148  	kfree(attr->bssid);
> 3891285c Ajay Singh   2018-01-22  1149  	attr->bssid = NULL;
> c5c77ba1 Johnny Kim   2015-05-11  1150  
> 3891285c Ajay Singh   2018-01-22  1151  	kfree(attr->ssid);
> 3891285c Ajay Singh   2018-01-22  1152  	attr->ssid = NULL;
> c5c77ba1 Johnny Kim   2015-05-11  1153  
> 3891285c Ajay Singh   2018-01-22  1154  	kfree(attr->ies);
> 3891285c Ajay Singh   2018-01-22  1155  	attr->ies = NULL;
> c5c77ba1 Johnny Kim   2015-05-11  1156  
> 44ea7461 Ajay Singh   2018-01-22  1157  	kfree(cur_byte);
> 31390eec Leo Kim      2015-10-19  1158  	return result;
> c5c77ba1 Johnny Kim   2015-05-11  1159  }
> c5c77ba1 Johnny Kim   2015-05-11  1160  
> 
> :::::: The code at line 937 was first introduced by commit
> :::::: 3891285c9a8a05a4789a3c286d7f9bdbde6b23c7 staging: wilc1000: rename pstrHostIFconnectAttr argument to avoid camelCase


The patch only change variable names to avoid the camelCase, didn't modify any extra code to dereference memory.
I think, with the use of shorter variable name now memcpy() is taking 1 line instead of 3 lines. So, now line 937 has different code line(as code is swifted up by few lines).So because of that new potential NULL dereference error is popped up for same existing code.  
The code to validate dynamically allocated memory before access, will be include in separate patch to keep it segregated from variable names changes. 
I will rework on this patch and resend again.


> 
> :::::: TO: Ajay Singh <ajay.kathat@microchip.com>
> :::::: CC: 0day robot <fengguang.wu@intel.com>
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
