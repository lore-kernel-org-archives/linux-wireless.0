Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A83C00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 09:20:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B136F20875
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 09:20:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B136F20875
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbeJEQSH convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 12:18:07 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:55475 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727809AbeJEQSH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 12:18:07 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w959K25h015175, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w959K25h015175
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 5 Oct 2018 17:20:02 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0399.000; Fri, 5 Oct 2018 17:20:02 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
CC:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC v2 04/12] rtw88: trx files
Thread-Topic: [RFC v2 04/12] rtw88: trx files
Thread-Index: AQHUW+TYbc6Uk9/+60ywbjX8pm9S+KUQOa8A
Date:   Fri, 5 Oct 2018 09:20:01 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D172A2BC@RTITMBSVM01.realtek.com.tw>
References: <1538553748-26364-1-git-send-email-yhchuang@realtek.com>
 <1538553748-26364-5-git-send-email-yhchuang@realtek.com>
 <20181004131908.GD16819@redhat.com>
In-Reply-To: <20181004131908.GD16819@redhat.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



> -----Original Message-----
> From: Stanislaw Gruszka [mailto:sgruszka@redhat.com]
> Sent: Thursday, October 04, 2018 9:19 PM
> To: Tony Chuang
> Cc: kvalo@codeaurora.org; Larry.Finger@lwfinger.net; Pkshih; Andy Huang;
> linux-wireless@vger.kernel.org
> Subject: Re: [RFC v2 04/12] rtw88: trx files
> 
> On Wed, Oct 03, 2018 at 04:02:20PM +0800, yhchuang@realtek.com wrote:
> > +static void rtw_rx_rssi_add(struct rtw_dev *rtwdev,
> > +			    struct rtw_rx_pkt_stat *pkt_stat,
> > +			    struct ieee80211_hdr *hdr)
> > +{
> > +	struct ieee80211_vif *vif;
> > +	struct rtw_vif *rtwvif;
> > +	struct rtw_sta_info *si;
> > +	__le16 fc = hdr->frame_control;
> > +	u8 *bssid;
> > +	u8 macid = RTW_BC_MC_MACID;
> > +	bool match_bssid = false;
> > +	bool is_packet_match_bssid;
> > +	bool if_addr_match;
> > +	bool hw_err;
> > +	bool ctl;
> > +
> > +	rcu_read_lock();
> > +
> > +	bssid = get_hdr_bssid(hdr);
> > +	rtwvif = get_hdr_vif(rtwdev, hdr);
> > +	vif = rtwvif ? rtwvif->vif : NULL;
> > +	pkt_stat->vif = vif;
> > +	if (unlikely(is_broadcast_ether_addr(hdr->addr1) ||
> > +		     is_multicast_ether_addr(hdr->addr1)))
> > +		match_bssid = get_hdr_match_bssid(rtwdev, hdr, bssid);
> > +	else if (vif)
> > +		match_bssid = ether_addr_equal(vif->bss_conf.bssid, bssid);
> > +	si = get_hdr_sta(rtwdev, vif, hdr);
> > +	macid = si ? si->mac_id : RTW_BC_MC_MACID;
> > +	pkt_stat->mac_id = macid;
> > +	pkt_stat->si = si;
> > +
> > +	if_addr_match = !!vif;
> > +	hw_err = pkt_stat->crc_err || pkt_stat->icv_err;
> > +	ctl = ieee80211_is_ctl(fc);
> > +	is_packet_match_bssid = !hw_err && !ctl && match_bssid;
> > +
> > +	if (((match_bssid && if_addr_match) || ieee80211_is_beacon(fc)) &&
> > +	    (!hw_err && !ctl) && (pkt_stat->phy_status && pkt_stat->si))
> > +		ewma_rssi_add(&pkt_stat->si->avg_rssi, pkt_stat->rssi);
> > +
> > +	rcu_read_unlock();
> 
> What for rcu_read_lock/unlock is here ? Maybe is needed,
> but perhaps not to protect entire function ?
> 

I thought that the entire function uses pointer si and vif, and hence should be
protected by rcu read lock, am I using the lock in a wrong way?

> > +static u8 get_tx_ampdu_factor(struct ieee80211_sta *sta)
> > +{
> > +	u8 exp = sta->ht_cap.ampdu_factor;
> > +
> > +	/* the least ampdu factor is 8K, and the value in the tx desc is the
> > +	 * max aggregation num, which represents val * 2 packets can be
> > +	 * aggregated in an AMPDU, so here we should use 8/2=4 as the base
> > +	 */
> > +	return (BIT(2) << exp) - 1;
> Using 4 whould be much more readable.
> 

OK

> > +static void rtw_tx_data_pkt_info_update(struct rtw_dev *rtwdev,
> > +					struct rtw_tx_pkt_info *pkt_info,
> > +					struct ieee80211_tx_control *control,
> > +					struct sk_buff *skb)
> > +{
> <snip>
> > +	if (sta->vht_cap.vht_supported)
> > +		rate = get_highest_vht_tx_rate(rtwdev, sta);
> > +	else if (sta->ht_cap.ht_supported)
> > +		rate = get_highest_ht_tx_rate(rtwdev, sta);
> > +	else if (sta->supp_rates[0] <= 0xf)
> > +		rate = DESC_RATE11M;
> > +	else
> > +		rate = DESC_RATE54M;
> No rate control, just use highest possible rate for each standard ?
> 

The major rate control system is in firmware, this is just a hint for it.

> > +
> > +	pkt_info->bmc = bmc;
> > +	pkt_info->sec_type = sec_type;
> > +	pkt_info->tx_pkt_size = skb->len;
> > +	pkt_info->offset = chip->tx_pkt_desc_sz;
> > +	pkt_info->qsel = skb->priority;
> 
> Shouldn't be qsel somehow mapped from skb->priority ?

Firmware handles it.

> 
> Thanks
> Stanislaw


Thanks
Yan-Hsuan Chuang
