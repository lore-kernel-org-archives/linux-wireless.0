Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E5B2C64EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 13:19:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B7612082A
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 13:19:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B7612082A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbeJDUM1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 16:12:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33210 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727367AbeJDUM1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 16:12:27 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2F0BE3082E24;
        Thu,  4 Oct 2018 13:19:11 +0000 (UTC)
Received: from localhost (unknown [10.43.2.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2E30453D;
        Thu,  4 Oct 2018 13:19:10 +0000 (UTC)
Date:   Thu, 4 Oct 2018 15:19:08 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        pkshih@realtek.com, tehuang@realtek.com,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC v2 04/12] rtw88: trx files
Message-ID: <20181004131908.GD16819@redhat.com>
References: <1538553748-26364-1-git-send-email-yhchuang@realtek.com>
 <1538553748-26364-5-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538553748-26364-5-git-send-email-yhchuang@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 04 Oct 2018 13:19:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 03, 2018 at 04:02:20PM +0800, yhchuang@realtek.com wrote:
> +static void rtw_rx_rssi_add(struct rtw_dev *rtwdev,
> +			    struct rtw_rx_pkt_stat *pkt_stat,
> +			    struct ieee80211_hdr *hdr)
> +{
> +	struct ieee80211_vif *vif;
> +	struct rtw_vif *rtwvif;
> +	struct rtw_sta_info *si;
> +	__le16 fc = hdr->frame_control;
> +	u8 *bssid;
> +	u8 macid = RTW_BC_MC_MACID;
> +	bool match_bssid = false;
> +	bool is_packet_match_bssid;
> +	bool if_addr_match;
> +	bool hw_err;
> +	bool ctl;
> +
> +	rcu_read_lock();
> +
> +	bssid = get_hdr_bssid(hdr);
> +	rtwvif = get_hdr_vif(rtwdev, hdr);
> +	vif = rtwvif ? rtwvif->vif : NULL;
> +	pkt_stat->vif = vif;
> +	if (unlikely(is_broadcast_ether_addr(hdr->addr1) ||
> +		     is_multicast_ether_addr(hdr->addr1)))
> +		match_bssid = get_hdr_match_bssid(rtwdev, hdr, bssid);
> +	else if (vif)
> +		match_bssid = ether_addr_equal(vif->bss_conf.bssid, bssid);
> +	si = get_hdr_sta(rtwdev, vif, hdr);
> +	macid = si ? si->mac_id : RTW_BC_MC_MACID;
> +	pkt_stat->mac_id = macid;
> +	pkt_stat->si = si;
> +
> +	if_addr_match = !!vif;
> +	hw_err = pkt_stat->crc_err || pkt_stat->icv_err;
> +	ctl = ieee80211_is_ctl(fc);
> +	is_packet_match_bssid = !hw_err && !ctl && match_bssid;
> +
> +	if (((match_bssid && if_addr_match) || ieee80211_is_beacon(fc)) &&
> +	    (!hw_err && !ctl) && (pkt_stat->phy_status && pkt_stat->si))
> +		ewma_rssi_add(&pkt_stat->si->avg_rssi, pkt_stat->rssi);
> +
> +	rcu_read_unlock();

What for rcu_read_lock/unlock is here ? Maybe is needed,
but perhaps not to protect entire function ?

> +static u8 get_tx_ampdu_factor(struct ieee80211_sta *sta)
> +{
> +	u8 exp = sta->ht_cap.ampdu_factor;
> +
> +	/* the least ampdu factor is 8K, and the value in the tx desc is the
> +	 * max aggregation num, which represents val * 2 packets can be
> +	 * aggregated in an AMPDU, so here we should use 8/2=4 as the base
> +	 */
> +	return (BIT(2) << exp) - 1;
Using 4 whould be much more readable.

> +static void rtw_tx_data_pkt_info_update(struct rtw_dev *rtwdev,
> +					struct rtw_tx_pkt_info *pkt_info,
> +					struct ieee80211_tx_control *control,
> +					struct sk_buff *skb)
> +{
<snip>
> +	if (sta->vht_cap.vht_supported)
> +		rate = get_highest_vht_tx_rate(rtwdev, sta);
> +	else if (sta->ht_cap.ht_supported)
> +		rate = get_highest_ht_tx_rate(rtwdev, sta);
> +	else if (sta->supp_rates[0] <= 0xf)
> +		rate = DESC_RATE11M;
> +	else
> +		rate = DESC_RATE54M;
No rate control, just use highest possible rate for each standard ?

> +
> +	pkt_info->bmc = bmc;
> +	pkt_info->sec_type = sec_type;
> +	pkt_info->tx_pkt_size = skb->len;
> +	pkt_info->offset = chip->tx_pkt_desc_sz;
> +	pkt_info->qsel = skb->priority;

Shouldn't be qsel somehow mapped from skb->priority ?

Thanks
Stanislaw
