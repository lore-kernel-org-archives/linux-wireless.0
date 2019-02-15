Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FAKE_REPLY_C,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1E61C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 06:16:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 589DD214DA
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 06:16:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bsTUXKgF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388457AbfBOGQo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 01:16:44 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:58538 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbfBOGQo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 01:16:44 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1F64AI8119332;
        Fri, 15 Feb 2019 06:16:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2018-07-02;
 bh=3L6B25Jsc+aBztR53B8CfpGvWvmwSsnwB36pQ7O1WrI=;
 b=bsTUXKgFDtJAwqhjcA+NFp2nKkFps2lrFCtCDbnBzcBgRT2LN7CjouYFy7BAzeGW8SYM
 jY2sLZkwL+4lnu365gNF4/SkACgKOYD5h8BKgrK8BGjXR+Z4dtI/bYm2OW7GhiCl/qJJ
 OPsFcAEXeVYL44m13COK5Dp+a0AoWuJynuvYiKfU7aVJp6RxE5eyrqqILg1QN3i9lK6a
 bF/WEzmI/X8Zz48MvFvur4qi2FC0UyWm0F99nAURYS1bkS0pzc1Nf3CFtQhpRCM67A25
 k/WyYRzc1wZnnumHDgylCunBSenPvXcofBUbnbSmaRf6yuRMlwel9M82tHq+iRpXsQVG yw== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2qhre5uwve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Feb 2019 06:16:16 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1F6GB1k029796
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Feb 2019 06:16:11 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1F6GAs1018088;
        Fri, 15 Feb 2019 06:16:11 GMT
Received: from kadam (/197.157.0.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 Feb 2019 06:16:09 +0000
Date:   Fri, 15 Feb 2019 09:16:01 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@01.org, =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     kbuild-all@01.org, Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH] brcmfmac: use bphy_err() in all wiphy-related code
Message-ID: <20190215061601.GE2304@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190213112619.23899-1-zajec5@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9167 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902150045
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Rafał,

url:    https://github.com/0day-ci/linux/commits/Rafa-Mi-ecki/brcmfmac-use-bphy_err-in-all-wiphy-related-code/20190214-140004
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master

smatch warnings:
drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c:114 brcmf_fweh_call_event_handler() warn: variable dereferenced before check 'ifp' (see line 110)
drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c:187 brcmf_fweh_handle_if_event() error: we previously assumed 'ifp' could be null (see line 184)
drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c:189 brcmf_fweh_handle_if_event() warn: variable dereferenced before check 'ifp' (see line 187)

# https://github.com/0day-ci/linux/commit/e12dba9f5ed77216c5984a4b57ddc31ba23376c9
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout e12dba9f5ed77216c5984a4b57ddc31ba23376c9
vim +/ifp +114 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c

5c36b99a drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  104  
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  105  static int brcmf_fweh_call_event_handler(struct brcmf_if *ifp,
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  106  					 enum brcmf_fweh_event_code code,
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  107  					 struct brcmf_event_msg *emsg,
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  108  					 void *data)
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  109  {
e12dba9f drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c Rafał Miłecki    2019-02-13 @110  	struct wiphy *wiphy = ifp->drvr->wiphy;
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  111  	struct brcmf_fweh_info *fweh;
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  112  	int err = -EINVAL;
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  113  
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14 @114  	if (ifp) {
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  115  		fweh = &ifp->drvr->fweh;
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  116  
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  117  		/* handle the event if valid interface and handler */
5857f9c6 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2013-04-05  118  		if (fweh->evt_handler[code])
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  119  			err = fweh->evt_handler[code](ifp, emsg, data);
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  120  		else
e12dba9f drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c Rafał Miłecki    2019-02-13  121  			bphy_err(wiphy, "unhandled event %d ignored\n", code);
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  122  	} else {
e12dba9f drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c Rafał Miłecki    2019-02-13  123  		bphy_err(wiphy, "no interface object\n");
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  124  	}
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  125  	return err;
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  126  }
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  127  
5c36b99a drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  128  /**
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  129   * brcmf_fweh_handle_if_event() - handle IF event.
5c36b99a drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  130   *
5c36b99a drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  131   * @drvr: driver information object.
5c36b99a drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  132   * @item: queue entry.
5c36b99a drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  133   * @ifpp: interface object (may change upon ADD action).
5c36b99a drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  134   */
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  135  static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  136  				       struct brcmf_event_msg *emsg,
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  137  				       void *data)
5c36b99a drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  138  {
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  139  	struct brcmf_if_event *ifevent = data;
e12dba9f drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c Rafał Miłecki    2019-02-13  140  	struct wiphy *wiphy = drvr->wiphy;
5c36b99a drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  141  	struct brcmf_if *ifp;
ddddfed2 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2015-08-26  142  	bool is_p2pdev;
5c36b99a drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  143  	int err = 0;
5c36b99a drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  144  
37a869ec drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c Hante Meuleman   2015-10-29  145  	brcmf_dbg(EVENT, "action: %u ifidx: %u bsscfgidx: %u flags: %u role: %u\n",
37a869ec drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c Hante Meuleman   2015-10-29  146  		  ifevent->action, ifevent->ifidx, ifevent->bsscfgidx,
8fdd1578 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2013-04-05  147  		  ifevent->flags, ifevent->role);
5c36b99a drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  148  
35a3cbcc drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Hante Meuleman   2015-09-18  149  	/* The P2P Device interface event must not be ignored contrary to what
35a3cbcc drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Hante Meuleman   2015-09-18  150  	 * firmware tells us. Older firmware uses p2p noif, with sta role.
cb8dc71f drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Hante Meuleman   2015-09-18  151  	 * This should be accepted when p2pdev_setup is ongoing. TDLS setup will
cb8dc71f drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Hante Meuleman   2015-09-18  152  	 * use the same ifevent and should be ignored.
87c47903 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2014-09-12  153  	 */
35a3cbcc drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Hante Meuleman   2015-09-18  154  	is_p2pdev = ((ifevent->flags & BRCMF_E_IF_FLAG_NOIF) &&
35a3cbcc drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Hante Meuleman   2015-09-18  155  		     (ifevent->role == BRCMF_E_IF_ROLE_P2P_CLIENT ||
cb8dc71f drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Hante Meuleman   2015-09-18  156  		      ((ifevent->role == BRCMF_E_IF_ROLE_STA) &&
cb8dc71f drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Hante Meuleman   2015-09-18  157  		       (drvr->fweh.p2pdev_setup_ongoing))));
ddddfed2 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2015-08-26  158  	if (!is_p2pdev && (ifevent->flags & BRCMF_E_IF_FLAG_NOIF)) {
2ee8382f drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2013-08-10  159  		brcmf_dbg(EVENT, "event can be ignored\n");
2ee8382f drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2013-08-10  160  		return;
2ee8382f drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2013-08-10  161  	}
5c36b99a drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  162  	if (ifevent->ifidx >= BRCMF_MAX_IFS) {
e12dba9f drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c Rafał Miłecki    2019-02-13  163  		bphy_err(wiphy, "invalid interface index: %u\n",
e12dba9f drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c Rafał Miłecki    2019-02-13  164  			 ifevent->ifidx);
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  165  		return;
5c36b99a drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  166  	}
5c36b99a drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  167  
37a869ec drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c Hante Meuleman   2015-10-29  168  	ifp = drvr->iflist[ifevent->bsscfgidx];
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  169  
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  170  	if (ifevent->action == BRCMF_E_IF_ADD) {
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  171  		brcmf_dbg(EVENT, "adding %s (%pM)\n", emsg->ifname,
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  172  			  emsg->addr);
37a869ec drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c Hante Meuleman   2015-10-29  173  		ifp = brcmf_add_if(drvr, ifevent->bsscfgidx, ifevent->ifidx,
ddddfed2 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2015-08-26  174  				   is_p2pdev, emsg->ifname, emsg->addr);
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  175  		if (IS_ERR(ifp))
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  176  			return;
2b76acdb drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Hante Meuleman   2015-10-08  177  		if (!is_p2pdev)
9fdc64bb drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c Franky Lin       2017-03-10  178  			brcmf_proto_add_if(drvr, ifp);
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  179  		if (!drvr->fweh.evt_handler[BRCMF_E_IF])
9390ace9 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2013-05-27  180  			if (brcmf_net_attach(ifp, false) < 0)
9390ace9 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2013-05-27  181  				return;
5c36b99a drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  182  	}
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  183  
87c47903 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2014-09-12 @184  	if (ifp && ifevent->action == BRCMF_E_IF_CHANGE)
66ded1f8 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c Franky Lin       2017-03-10  185  		brcmf_proto_reset_if(drvr, ifp);
bb8c8063 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2013-04-03  186  
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14 @187  	err = brcmf_fweh_call_event_handler(ifp, emsg->event_code, emsg, data);
3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  188  
a63b0987 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c Rafał Miłecki    2016-06-29 @189  	if (ifp && ifevent->action == BRCMF_E_IF_DEL) {
a63b0987 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c Rafał Miłecki    2016-06-29  190  		bool armed = brcmf_cfg80211_vif_event_armed(drvr->config);
a63b0987 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c Rafał Miłecki    2016-06-29  191  
a63b0987 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c Rafał Miłecki    2016-06-29  192  		/* Default handling in case no-one waits for this event */
a63b0987 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c Rafał Miłecki    2016-06-29  193  		if (!armed)
b50ddfa8 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c Rafał Miłecki    2016-06-17  194  			brcmf_remove_interface(ifp, false);
bb8c8063 drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2013-04-03  195  	}
a63b0987 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c Rafał Miłecki    2016-06-29  196  }
5c36b99a drivers/net/wireless/brcm80211/brcmfmac/fweh.c          Arend van Spriel 2012-11-14  197  

:::::: The code at line 114 was first introduced by commit
:::::: 3e0a97e1507c482d2299a6ff24e597c1316ba60a brcmfmac: restructure handling of IF event

:::::: TO: Arend van Spriel <arend@broadcom.com>
:::::: CC: John W. Linville <linville@tuxdriver.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
