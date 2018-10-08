Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B1FC00449
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5869B20878
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:25:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5869B20878
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbeJHQgf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 12:36:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47354 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbeJHQgf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 12:36:35 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E2E6981254;
        Mon,  8 Oct 2018 09:25:48 +0000 (UTC)
Received: from localhost (ovpn-204-38.brq.redhat.com [10.40.204.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D99E6374C;
        Mon,  8 Oct 2018 09:25:47 +0000 (UTC)
Date:   Mon, 8 Oct 2018 11:25:47 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v2 04/12] rtw88: trx files
Message-ID: <20181008092546.GD1961@redhat.com>
References: <1538553748-26364-1-git-send-email-yhchuang@realtek.com>
 <1538553748-26364-5-git-send-email-yhchuang@realtek.com>
 <20181004131908.GD16819@redhat.com>
 <F7CD281DE3E379468C6D07993EA72F84D172A2BC@RTITMBSVM01.realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D172A2BC@RTITMBSVM01.realtek.com.tw>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 08 Oct 2018 09:25:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Oct 05, 2018 at 09:20:01AM +0000, Tony Chuang wrote:
> > > +	rcu_read_lock();
> > > +
> > > +	bssid = get_hdr_bssid(hdr);
> > > +	rtwvif = get_hdr_vif(rtwdev, hdr);
> > > +	vif = rtwvif ? rtwvif->vif : NULL;
> > > +	pkt_stat->vif = vif;
> > > +	if (unlikely(is_broadcast_ether_addr(hdr->addr1) ||
> > > +		     is_multicast_ether_addr(hdr->addr1)))
> > > +		match_bssid = get_hdr_match_bssid(rtwdev, hdr, bssid);
> > > +	else if (vif)
> > > +		match_bssid = ether_addr_equal(vif->bss_conf.bssid, bssid);
> > > +	si = get_hdr_sta(rtwdev, vif, hdr);
> > > +	macid = si ? si->mac_id : RTW_BC_MC_MACID;
> > > +	pkt_stat->mac_id = macid;
> > > +	pkt_stat->si = si;
> > > +
> > > +	if_addr_match = !!vif;
> > > +	hw_err = pkt_stat->crc_err || pkt_stat->icv_err;
> > > +	ctl = ieee80211_is_ctl(fc);
> > > +	is_packet_match_bssid = !hw_err && !ctl && match_bssid;
> > > +
> > > +	if (((match_bssid && if_addr_match) || ieee80211_is_beacon(fc)) &&
> > > +	    (!hw_err && !ctl) && (pkt_stat->phy_status && pkt_stat->si))
> > > +		ewma_rssi_add(&pkt_stat->si->avg_rssi, pkt_stat->rssi);
> > > +
> > > +	rcu_read_unlock();
> > 
> > What for rcu_read_lock/unlock is here ? Maybe is needed,
> > but perhaps not to protect entire function ?
> > 
> 
> I thought that the entire function uses pointer si and vif, and hence should be
> protected by rcu read lock, am I using the lock in a wrong way?

It's fine, it wasn't clear to me what need to be protected.

Thanks
Stanislaw
