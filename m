Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:31071 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752988AbeCPKGT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 06:06:19 -0400
Date: Fri, 16 Mar 2018 18:18:54 +0800
From: kbuild test robot <lkp@intel.com>
To: hariprasath.elango@gmail.com
Cc: kbuild-all@01.org, aditya.shankar@microchip.com,
        gregkh@linuxfoundation.org, ganesh.krishna@microchip.com,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, hariprasath.elango@gmail.com
Subject: Re: [PATCH 7/7] staging: wilc1000: use kmemdup to replace
 kmalloc/memcpy
Message-ID: <201803161829.tgpTJelQ%fengguang.wu@intel.com> (sfid-20180316_110636_708506_0391D15D)
References: <b6c247886023a9822120169aef4d5d279d065ebf.1521030891.git.hariprasath.elango@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b6c247886023a9822120169aef4d5d279d065ebf.1521030891.git.hariprasath.elango@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi HariPrasath,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on next-20180309]
[cannot apply to v4.16-rc4 v4.16-rc3 v4.16-rc2 v4.16-rc5]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/hariprasath-elango-gmail-com/staging-wilc1000-Fix-code-block-alignment/20180316-104440


coccinelle warnings: (new ones prefixed by >>)

>> drivers/staging/wilc1000/host_interface.c:943:2-29: alloc with no test, possible model on line 995
   drivers/staging/wilc1000/host_interface.c:949:2-28: alloc with no test, possible model on line 995
   drivers/staging/wilc1000/host_interface.c:958:2-27: alloc with no test, possible model on line 995

vim +943 drivers/staging/wilc1000/host_interface.c

c5c77ba18 Johnny Kim         2015-05-11   917  
e554a3055 Leo Kim            2015-11-19   918  u8 wilc_connected_ssid[6] = {0};
3ccff3322 Ajay Singh         2018-02-19   919  static s32 handle_connect(struct wilc_vif *vif,
120ae5938 Tony Cho           2015-09-21   920  			  struct connect_attr *pstrHostIFconnectAttr)
c5c77ba18 Johnny Kim         2015-05-11   921  {
31390eec7 Leo Kim            2015-10-19   922  	s32 result = 0;
173508b82 Ajay Singh         2018-01-30   923  	struct wid wid_list[8];
cdbdae15d Ajay Singh         2018-01-30   924  	u32 wid_cnt = 0, dummyval = 0;
e33ff51ef Ajay Singh         2018-01-30   925  	u8 *cur_byte = NULL;
24701563e Ajay Singh         2018-02-20   926  	struct join_bss_param *bss_param;
71130e812 Glen Lee           2015-12-21   927  	struct host_if_drv *hif_drv = vif->hif_drv;
c5c77ba18 Johnny Kim         2015-05-11   928  
e554a3055 Leo Kim            2015-11-19   929  	if (memcmp(pstrHostIFconnectAttr->bssid, wilc_connected_ssid, ETH_ALEN) == 0) {
31390eec7 Leo Kim            2015-10-19   930  		result = 0;
b92f9304a Chris Park         2016-02-22   931  		netdev_err(vif->ndev, "Discard connect request\n");
31390eec7 Leo Kim            2015-10-19   932  		return result;
c5c77ba18 Johnny Kim         2015-05-11   933  	}
c5c77ba18 Johnny Kim         2015-05-11   934  
24701563e Ajay Singh         2018-02-20   935  	bss_param = pstrHostIFconnectAttr->params;
24701563e Ajay Singh         2018-02-20   936  	if (!bss_param) {
b92f9304a Chris Park         2016-02-22   937  		netdev_err(vif->ndev, "Required BSSID not found\n");
31390eec7 Leo Kim            2015-10-19   938  		result = -ENOENT;
24db713fe Leo Kim            2015-09-16   939  		goto ERRORHANDLER;
c5c77ba18 Johnny Kim         2015-05-11   940  	}
c5c77ba18 Johnny Kim         2015-05-11   941  
91109e113 Leo Kim            2015-10-19   942  	if (pstrHostIFconnectAttr->bssid) {
788f6fc08 Chaehyun Lim       2016-02-12  @943  		hif_drv->usr_conn_req.bssid = kmalloc(6, GFP_KERNEL);
788f6fc08 Chaehyun Lim       2016-02-12   944  		memcpy(hif_drv->usr_conn_req.bssid, pstrHostIFconnectAttr->bssid, 6);
c5c77ba18 Johnny Kim         2015-05-11   945  	}
c5c77ba18 Johnny Kim         2015-05-11   946  
74ab5e45e Leo Kim            2015-10-29   947  	hif_drv->usr_conn_req.ssid_len = pstrHostIFconnectAttr->ssid_len;
91109e113 Leo Kim            2015-10-19   948  	if (pstrHostIFconnectAttr->ssid) {
72216411b Chaehyun Lim       2016-02-12   949  		hif_drv->usr_conn_req.ssid = kmalloc(pstrHostIFconnectAttr->ssid_len + 1, GFP_KERNEL);
72216411b Chaehyun Lim       2016-02-12   950  		memcpy(hif_drv->usr_conn_req.ssid,
8c8360b3f Leo Kim            2015-10-19   951  		       pstrHostIFconnectAttr->ssid,
8b3c9fa68 Leo Kim            2015-10-13   952  		       pstrHostIFconnectAttr->ssid_len);
72216411b Chaehyun Lim       2016-02-12   953  		hif_drv->usr_conn_req.ssid[pstrHostIFconnectAttr->ssid_len] = '\0';
c5c77ba18 Johnny Kim         2015-05-11   954  	}
c5c77ba18 Johnny Kim         2015-05-11   955  
331ed0800 Leo Kim            2015-10-29   956  	hif_drv->usr_conn_req.ies_len = pstrHostIFconnectAttr->ies_len;
91109e113 Leo Kim            2015-10-19   957  	if (pstrHostIFconnectAttr->ies) {
a3b2f4b91 Leo Kim            2015-10-29   958  		hif_drv->usr_conn_req.ies = kmalloc(pstrHostIFconnectAttr->ies_len, GFP_KERNEL);
a3b2f4b91 Leo Kim            2015-10-29   959  		memcpy(hif_drv->usr_conn_req.ies,
8c8360b3f Leo Kim            2015-10-19   960  		       pstrHostIFconnectAttr->ies,
b59d5c5b5 Leo Kim            2015-10-13   961  		       pstrHostIFconnectAttr->ies_len);
c5c77ba18 Johnny Kim         2015-05-11   962  	}
c5c77ba18 Johnny Kim         2015-05-11   963  
a0942c579 Chaehyun Lim       2016-02-12   964  	hif_drv->usr_conn_req.security = pstrHostIFconnectAttr->security;
7d0697282 Leo Kim            2015-10-29   965  	hif_drv->usr_conn_req.auth_type = pstrHostIFconnectAttr->auth_type;
33bfb198f Leo Kim            2015-10-29   966  	hif_drv->usr_conn_req.conn_result = pstrHostIFconnectAttr->result;
73abaa490 Leo Kim            2015-10-29   967  	hif_drv->usr_conn_req.arg = pstrHostIFconnectAttr->arg;
c5c77ba18 Johnny Kim         2015-05-11   968  
cdbdae15d Ajay Singh         2018-01-30   969  	wid_list[wid_cnt].id = WID_SUCCESS_FRAME_COUNT;
cdbdae15d Ajay Singh         2018-01-30   970  	wid_list[wid_cnt].type = WID_INT;
cdbdae15d Ajay Singh         2018-01-30   971  	wid_list[wid_cnt].size = sizeof(u32);
cdbdae15d Ajay Singh         2018-01-30   972  	wid_list[wid_cnt].val = (s8 *)(&(dummyval));
cdbdae15d Ajay Singh         2018-01-30   973  	wid_cnt++;
c5c77ba18 Johnny Kim         2015-05-11   974  
cdbdae15d Ajay Singh         2018-01-30   975  	wid_list[wid_cnt].id = WID_RECEIVED_FRAGMENT_COUNT;
cdbdae15d Ajay Singh         2018-01-30   976  	wid_list[wid_cnt].type = WID_INT;
cdbdae15d Ajay Singh         2018-01-30   977  	wid_list[wid_cnt].size = sizeof(u32);
cdbdae15d Ajay Singh         2018-01-30   978  	wid_list[wid_cnt].val = (s8 *)(&(dummyval));
cdbdae15d Ajay Singh         2018-01-30   979  	wid_cnt++;
c5c77ba18 Johnny Kim         2015-05-11   980  
cdbdae15d Ajay Singh         2018-01-30   981  	wid_list[wid_cnt].id = WID_FAILED_COUNT;
cdbdae15d Ajay Singh         2018-01-30   982  	wid_list[wid_cnt].type = WID_INT;
cdbdae15d Ajay Singh         2018-01-30   983  	wid_list[wid_cnt].size = sizeof(u32);
cdbdae15d Ajay Singh         2018-01-30   984  	wid_list[wid_cnt].val = (s8 *)(&(dummyval));
cdbdae15d Ajay Singh         2018-01-30   985  	wid_cnt++;
c5c77ba18 Johnny Kim         2015-05-11   986  
cdbdae15d Ajay Singh         2018-01-30   987  	wid_list[wid_cnt].id = WID_INFO_ELEMENT_ASSOCIATE;
cdbdae15d Ajay Singh         2018-01-30   988  	wid_list[wid_cnt].type = WID_BIN_DATA;
cdbdae15d Ajay Singh         2018-01-30   989  	wid_list[wid_cnt].val = hif_drv->usr_conn_req.ies;
cdbdae15d Ajay Singh         2018-01-30   990  	wid_list[wid_cnt].size = hif_drv->usr_conn_req.ies_len;
cdbdae15d Ajay Singh         2018-01-30   991  	wid_cnt++;
c5c77ba18 Johnny Kim         2015-05-11   992  
f7bbd9cf9 Leo Kim            2015-10-13   993  	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
331ed0800 Leo Kim            2015-10-29   994  		info_element_size = hif_drv->usr_conn_req.ies_len;
8b38942e3 HariPrasath Elango 2018-03-14  @995  		info_element = kmemdup(hif_drv->usr_conn_req.ies,
8b38942e3 HariPrasath Elango 2018-03-14   996  				       info_element_size,
8b38942e3 HariPrasath Elango 2018-03-14   997  				       GFP_KERNEL);
8b38942e3 HariPrasath Elango 2018-03-14   998  		if (!info_element) {
8b38942e3 HariPrasath Elango 2018-03-14   999  			result = -ENOMEM;
8b38942e3 HariPrasath Elango 2018-03-14  1000  			goto ERRORHANDLER;
8b38942e3 HariPrasath Elango 2018-03-14  1001  		}
c5c77ba18 Johnny Kim         2015-05-11  1002  	}
06ea0cb65 HariPrasath Elango 2018-03-14  1003  
cdbdae15d Ajay Singh         2018-01-30  1004  	wid_list[wid_cnt].id = (u16)WID_11I_MODE;
cdbdae15d Ajay Singh         2018-01-30  1005  	wid_list[wid_cnt].type = WID_CHAR;
cdbdae15d Ajay Singh         2018-01-30  1006  	wid_list[wid_cnt].size = sizeof(char);
cdbdae15d Ajay Singh         2018-01-30  1007  	wid_list[wid_cnt].val = (s8 *)&hif_drv->usr_conn_req.security;
cdbdae15d Ajay Singh         2018-01-30  1008  	wid_cnt++;
c5c77ba18 Johnny Kim         2015-05-11  1009  
f7bbd9cf9 Leo Kim            2015-10-13  1010  	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7))
a0942c579 Chaehyun Lim       2016-02-12  1011  		mode_11i = hif_drv->usr_conn_req.security;
c5c77ba18 Johnny Kim         2015-05-11  1012  
cdbdae15d Ajay Singh         2018-01-30  1013  	wid_list[wid_cnt].id = (u16)WID_AUTH_TYPE;
cdbdae15d Ajay Singh         2018-01-30  1014  	wid_list[wid_cnt].type = WID_CHAR;
cdbdae15d Ajay Singh         2018-01-30  1015  	wid_list[wid_cnt].size = sizeof(char);
cdbdae15d Ajay Singh         2018-01-30  1016  	wid_list[wid_cnt].val = (s8 *)&hif_drv->usr_conn_req.auth_type;
cdbdae15d Ajay Singh         2018-01-30  1017  	wid_cnt++;
c5c77ba18 Johnny Kim         2015-05-11  1018  
f7bbd9cf9 Leo Kim            2015-10-13  1019  	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7))
7d0697282 Leo Kim            2015-10-29  1020  		auth_type = (u8)hif_drv->usr_conn_req.auth_type;
c5c77ba18 Johnny Kim         2015-05-11  1021  
cdbdae15d Ajay Singh         2018-01-30  1022  	wid_list[wid_cnt].id = (u16)WID_JOIN_REQ_EXTENDED;
cdbdae15d Ajay Singh         2018-01-30  1023  	wid_list[wid_cnt].type = WID_STR;
cdbdae15d Ajay Singh         2018-01-30  1024  	wid_list[wid_cnt].size = 112;
cdbdae15d Ajay Singh         2018-01-30  1025  	wid_list[wid_cnt].val = kmalloc(wid_list[wid_cnt].size, GFP_KERNEL);
c5c77ba18 Johnny Kim         2015-05-11  1026  
f7bbd9cf9 Leo Kim            2015-10-13  1027  	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
cdbdae15d Ajay Singh         2018-01-30  1028  		join_req_size = wid_list[wid_cnt].size;
0626baaac Leo Kim            2015-10-15  1029  		join_req = kmalloc(join_req_size, GFP_KERNEL);
c5c77ba18 Johnny Kim         2015-05-11  1030  	}
cdbdae15d Ajay Singh         2018-01-30  1031  	if (!wid_list[wid_cnt].val) {
31390eec7 Leo Kim            2015-10-19  1032  		result = -EFAULT;
24db713fe Leo Kim            2015-09-16  1033  		goto ERRORHANDLER;
24db713fe Leo Kim            2015-09-16  1034  	}
c5c77ba18 Johnny Kim         2015-05-11  1035  
e33ff51ef Ajay Singh         2018-01-30  1036  	cur_byte = wid_list[wid_cnt].val;
c5c77ba18 Johnny Kim         2015-05-11  1037  
91109e113 Leo Kim            2015-10-19  1038  	if (pstrHostIFconnectAttr->ssid) {
e33ff51ef Ajay Singh         2018-01-30  1039  		memcpy(cur_byte, pstrHostIFconnectAttr->ssid, pstrHostIFconnectAttr->ssid_len);
e33ff51ef Ajay Singh         2018-01-30  1040  		cur_byte[pstrHostIFconnectAttr->ssid_len] = '\0';
c5c77ba18 Johnny Kim         2015-05-11  1041  	}
e33ff51ef Ajay Singh         2018-01-30  1042  	cur_byte += MAX_SSID_LEN;
e33ff51ef Ajay Singh         2018-01-30  1043  	*(cur_byte++) = INFRASTRUCTURE;
ae4dfa572 Leo Kim            2015-10-13  1044  
7bf0242a7 Ajay Singh         2018-01-22  1045  	if (pstrHostIFconnectAttr->ch >= 1 && pstrHostIFconnectAttr->ch <= 14) {
e33ff51ef Ajay Singh         2018-01-30  1046  		*(cur_byte++) = pstrHostIFconnectAttr->ch;
c5c77ba18 Johnny Kim         2015-05-11  1047  	} else {
b92f9304a Chris Park         2016-02-22  1048  		netdev_err(vif->ndev, "Channel out of range\n");
e33ff51ef Ajay Singh         2018-01-30  1049  		*(cur_byte++) = 0xFF;
c5c77ba18 Johnny Kim         2015-05-11  1050  	}
24701563e Ajay Singh         2018-02-20  1051  	*(cur_byte++)  = (bss_param->cap_info) & 0xFF;
24701563e Ajay Singh         2018-02-20  1052  	*(cur_byte++)  = ((bss_param->cap_info) >> 8) & 0xFF;
c5c77ba18 Johnny Kim         2015-05-11  1053  
91109e113 Leo Kim            2015-10-19  1054  	if (pstrHostIFconnectAttr->bssid)
e33ff51ef Ajay Singh         2018-01-30  1055  		memcpy(cur_byte, pstrHostIFconnectAttr->bssid, 6);
e33ff51ef Ajay Singh         2018-01-30  1056  	cur_byte += 6;
c5c77ba18 Johnny Kim         2015-05-11  1057  
c0f52fbac Tony Cho           2015-10-20  1058  	if (pstrHostIFconnectAttr->bssid)
e33ff51ef Ajay Singh         2018-01-30  1059  		memcpy(cur_byte, pstrHostIFconnectAttr->bssid, 6);
e33ff51ef Ajay Singh         2018-01-30  1060  	cur_byte += 6;
c0f52fbac Tony Cho           2015-10-20  1061  
24701563e Ajay Singh         2018-02-20  1062  	*(cur_byte++)  = (bss_param->beacon_period) & 0xFF;
24701563e Ajay Singh         2018-02-20  1063  	*(cur_byte++)  = ((bss_param->beacon_period) >> 8) & 0xFF;
24701563e Ajay Singh         2018-02-20  1064  	*(cur_byte++)  =  bss_param->dtim_period;
ae4dfa572 Leo Kim            2015-10-13  1065  
24701563e Ajay Singh         2018-02-20  1066  	memcpy(cur_byte, bss_param->supp_rates, MAX_RATES_SUPPORTED + 1);
e33ff51ef Ajay Singh         2018-01-30  1067  	cur_byte += (MAX_RATES_SUPPORTED + 1);
c5c77ba18 Johnny Kim         2015-05-11  1068  
24701563e Ajay Singh         2018-02-20  1069  	*(cur_byte++)  =  bss_param->wmm_cap;
24701563e Ajay Singh         2018-02-20  1070  	*(cur_byte++)  = bss_param->uapsd_cap;
c5c77ba18 Johnny Kim         2015-05-11  1071  
24701563e Ajay Singh         2018-02-20  1072  	*(cur_byte++)  = bss_param->ht_capable;
24701563e Ajay Singh         2018-02-20  1073  	hif_drv->usr_conn_req.ht_capable = bss_param->ht_capable;
c5c77ba18 Johnny Kim         2015-05-11  1074  
24701563e Ajay Singh         2018-02-20  1075  	*(cur_byte++)  =  bss_param->rsn_found;
24701563e Ajay Singh         2018-02-20  1076  	*(cur_byte++)  =  bss_param->rsn_grp_policy;
24701563e Ajay Singh         2018-02-20  1077  	*(cur_byte++) =  bss_param->mode_802_11i;
ae4dfa572 Leo Kim            2015-10-13  1078  
24701563e Ajay Singh         2018-02-20  1079  	memcpy(cur_byte, bss_param->rsn_pcip_policy, sizeof(bss_param->rsn_pcip_policy));
24701563e Ajay Singh         2018-02-20  1080  	cur_byte += sizeof(bss_param->rsn_pcip_policy);
c5c77ba18 Johnny Kim         2015-05-11  1081  
24701563e Ajay Singh         2018-02-20  1082  	memcpy(cur_byte, bss_param->rsn_auth_policy, sizeof(bss_param->rsn_auth_policy));
24701563e Ajay Singh         2018-02-20  1083  	cur_byte += sizeof(bss_param->rsn_auth_policy);
c5c77ba18 Johnny Kim         2015-05-11  1084  
24701563e Ajay Singh         2018-02-20  1085  	memcpy(cur_byte, bss_param->rsn_cap, sizeof(bss_param->rsn_cap));
24701563e Ajay Singh         2018-02-20  1086  	cur_byte += sizeof(bss_param->rsn_cap);
c5c77ba18 Johnny Kim         2015-05-11  1087  
e33ff51ef Ajay Singh         2018-01-30  1088  	*(cur_byte++) = REAL_JOIN_REQ;
24701563e Ajay Singh         2018-02-20  1089  	*(cur_byte++) = bss_param->noa_enabled;
c5c77ba18 Johnny Kim         2015-05-11  1090  
24701563e Ajay Singh         2018-02-20  1091  	if (bss_param->noa_enabled) {
24701563e Ajay Singh         2018-02-20  1092  		*(cur_byte++) = (bss_param->tsf) & 0xFF;
24701563e Ajay Singh         2018-02-20  1093  		*(cur_byte++) = ((bss_param->tsf) >> 8) & 0xFF;
24701563e Ajay Singh         2018-02-20  1094  		*(cur_byte++) = ((bss_param->tsf) >> 16) & 0xFF;
24701563e Ajay Singh         2018-02-20  1095  		*(cur_byte++) = ((bss_param->tsf) >> 24) & 0xFF;
c5c77ba18 Johnny Kim         2015-05-11  1096  
24701563e Ajay Singh         2018-02-20  1097  		*(cur_byte++) = bss_param->opp_enabled;
24701563e Ajay Singh         2018-02-20  1098  		*(cur_byte++) = bss_param->idx;
c5c77ba18 Johnny Kim         2015-05-11  1099  
24701563e Ajay Singh         2018-02-20  1100  		if (bss_param->opp_enabled)
24701563e Ajay Singh         2018-02-20  1101  			*(cur_byte++) = bss_param->ct_window;
c5c77ba18 Johnny Kim         2015-05-11  1102  
24701563e Ajay Singh         2018-02-20  1103  		*(cur_byte++) = bss_param->cnt;
c5c77ba18 Johnny Kim         2015-05-11  1104  
24701563e Ajay Singh         2018-02-20  1105  		memcpy(cur_byte, bss_param->duration, sizeof(bss_param->duration));
24701563e Ajay Singh         2018-02-20  1106  		cur_byte += sizeof(bss_param->duration);
c5c77ba18 Johnny Kim         2015-05-11  1107  
24701563e Ajay Singh         2018-02-20  1108  		memcpy(cur_byte, bss_param->interval, sizeof(bss_param->interval));
24701563e Ajay Singh         2018-02-20  1109  		cur_byte += sizeof(bss_param->interval);
c5c77ba18 Johnny Kim         2015-05-11  1110  
24701563e Ajay Singh         2018-02-20  1111  		memcpy(cur_byte, bss_param->start_time, sizeof(bss_param->start_time));
24701563e Ajay Singh         2018-02-20  1112  		cur_byte += sizeof(bss_param->start_time);
c4f97526a Chris Park         2016-02-04  1113  	}
c5c77ba18 Johnny Kim         2015-05-11  1114  
e33ff51ef Ajay Singh         2018-01-30  1115  	cur_byte = wid_list[wid_cnt].val;
cdbdae15d Ajay Singh         2018-01-30  1116  	wid_cnt++;
c5c77ba18 Johnny Kim         2015-05-11  1117  
f7bbd9cf9 Leo Kim            2015-10-13  1118  	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
e33ff51ef Ajay Singh         2018-01-30  1119  		memcpy(join_req, cur_byte, join_req_size);
7036c6244 Glen Lee           2015-12-21  1120  		join_req_vif = vif;
c5c77ba18 Johnny Kim         2015-05-11  1121  	}
c5c77ba18 Johnny Kim         2015-05-11  1122  
e3f16965c Chris Park         2016-02-04  1123  	if (pstrHostIFconnectAttr->bssid)
e554a3055 Leo Kim            2015-11-19  1124  		memcpy(wilc_connected_ssid,
e554a3055 Leo Kim            2015-11-19  1125  		       pstrHostIFconnectAttr->bssid, ETH_ALEN);
c5c77ba18 Johnny Kim         2015-05-11  1126  
173508b82 Ajay Singh         2018-01-30  1127  	result = wilc_send_config_pkt(vif, SET_CFG, wid_list,
cdbdae15d Ajay Singh         2018-01-30  1128  				      wid_cnt,
eb9939b76 Glen Lee           2015-12-21  1129  				      wilc_get_vif_idx(vif));
31390eec7 Leo Kim            2015-10-19  1130  	if (result) {
b92f9304a Chris Park         2016-02-22  1131  		netdev_err(vif->ndev, "failed to send config packet\n");
31390eec7 Leo Kim            2015-10-19  1132  		result = -EFAULT;
24db713fe Leo Kim            2015-09-16  1133  		goto ERRORHANDLER;
c5c77ba18 Johnny Kim         2015-05-11  1134  	} else {
b60005a8c Leo Kim            2015-10-29  1135  		hif_drv->hif_state = HOST_IF_WAITING_CONN_RESP;
c5c77ba18 Johnny Kim         2015-05-11  1136  	}
c5c77ba18 Johnny Kim         2015-05-11  1137  
24db713fe Leo Kim            2015-09-16  1138  ERRORHANDLER:
31390eec7 Leo Kim            2015-10-19  1139  	if (result) {
3b0437e18 Chaehyun Lim       2016-02-25  1140  		struct connect_info strConnectInfo;
c5c77ba18 Johnny Kim         2015-05-11  1141  
81a59506f Leo Kim            2015-10-29  1142  		del_timer(&hif_drv->connect_timer);
c5c77ba18 Johnny Kim         2015-05-11  1143  
3b0437e18 Chaehyun Lim       2016-02-25  1144  		memset(&strConnectInfo, 0, sizeof(struct connect_info));
c5c77ba18 Johnny Kim         2015-05-11  1145  
91109e113 Leo Kim            2015-10-19  1146  		if (pstrHostIFconnectAttr->result) {
91109e113 Leo Kim            2015-10-19  1147  			if (pstrHostIFconnectAttr->bssid)
d4a24e082 Chaehyun Lim       2016-02-25  1148  				memcpy(strConnectInfo.bssid, pstrHostIFconnectAttr->bssid, 6);
c5c77ba18 Johnny Kim         2015-05-11  1149  
91109e113 Leo Kim            2015-10-19  1150  			if (pstrHostIFconnectAttr->ies) {
4607f9ccb Chaehyun Lim       2016-02-25  1151  				strConnectInfo.req_ies_len = pstrHostIFconnectAttr->ies_len;
4ff485707 Chaehyun Lim       2016-02-25  1152  				strConnectInfo.req_ies = kmalloc(pstrHostIFconnectAttr->ies_len, GFP_KERNEL);
4ff485707 Chaehyun Lim       2016-02-25  1153  				memcpy(strConnectInfo.req_ies,
2ea158c47 Leo Kim            2015-10-13  1154  				       pstrHostIFconnectAttr->ies,
b59d5c5b5 Leo Kim            2015-10-13  1155  				       pstrHostIFconnectAttr->ies_len);
c5c77ba18 Johnny Kim         2015-05-11  1156  			}
c5c77ba18 Johnny Kim         2015-05-11  1157  
6abcc11db Leo Kim            2015-10-13  1158  			pstrHostIFconnectAttr->result(CONN_DISCONN_EVENT_CONN_RESP,
c5c77ba18 Johnny Kim         2015-05-11  1159  							       &strConnectInfo,
c5c77ba18 Johnny Kim         2015-05-11  1160  							       MAC_DISCONNECTED,
c5c77ba18 Johnny Kim         2015-05-11  1161  							       NULL,
8f38db897 Leo Kim            2015-10-13  1162  							       pstrHostIFconnectAttr->arg);
b60005a8c Leo Kim            2015-10-29  1163  			hif_drv->hif_state = HOST_IF_IDLE;
4ff485707 Chaehyun Lim       2016-02-25  1164  			kfree(strConnectInfo.req_ies);
4ff485707 Chaehyun Lim       2016-02-25  1165  			strConnectInfo.req_ies = NULL;
c5c77ba18 Johnny Kim         2015-05-11  1166  
c5c77ba18 Johnny Kim         2015-05-11  1167  		} else {
b92f9304a Chris Park         2016-02-22  1168  			netdev_err(vif->ndev, "Connect callback is NULL\n");
c5c77ba18 Johnny Kim         2015-05-11  1169  		}
c5c77ba18 Johnny Kim         2015-05-11  1170  	}
c5c77ba18 Johnny Kim         2015-05-11  1171  
9254db077 Leo Kim            2015-10-13  1172  	kfree(pstrHostIFconnectAttr->bssid);
9254db077 Leo Kim            2015-10-13  1173  	pstrHostIFconnectAttr->bssid = NULL;
c5c77ba18 Johnny Kim         2015-05-11  1174  
f7bbd9cf9 Leo Kim            2015-10-13  1175  	kfree(pstrHostIFconnectAttr->ssid);
f7bbd9cf9 Leo Kim            2015-10-13  1176  	pstrHostIFconnectAttr->ssid = NULL;
c5c77ba18 Johnny Kim         2015-05-11  1177  
2ea158c47 Leo Kim            2015-10-13  1178  	kfree(pstrHostIFconnectAttr->ies);
2ea158c47 Leo Kim            2015-10-13  1179  	pstrHostIFconnectAttr->ies = NULL;
c5c77ba18 Johnny Kim         2015-05-11  1180  
e33ff51ef Ajay Singh         2018-01-30  1181  	kfree(cur_byte);
31390eec7 Leo Kim            2015-10-19  1182  	return result;
c5c77ba18 Johnny Kim         2015-05-11  1183  }
c5c77ba18 Johnny Kim         2015-05-11  1184  

:::::: The code at line 943 was first introduced by commit
:::::: 788f6fc0810f35add6077f1cfd40b7f030e955ba staging: wilc1000: rename pu8bssid in struct user_conn_req

:::::: TO: Chaehyun Lim <chaehyun.lim@gmail.com>
:::::: CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
