Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLACK autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D776C004D1
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:33:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFCD02170E
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:33:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DFCD02170E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729548AbeI1R4W convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:56:22 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:51061 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729232AbeI1R4W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 13:56:22 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w8SBWhLs008523, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w8SBWhLs008523
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Fri, 28 Sep 2018 19:32:43 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITCASV01.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Fri, 28 Sep
 2018 19:32:43 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
CC:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>
Subject: RE: [PATCH 01/12] rtwlan: main files
Thread-Topic: [PATCH 01/12] rtwlan: main files
Thread-Index: AQHUVmkc7fXueOv/LUWUMOOpXqM0maUFAMQw///nxICAAImvEA==
Date:   Fri, 28 Sep 2018 11:32:41 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D08DB7E3@RTITMBSVM01.realtek.com.tw>
References: <1537509847-21087-1-git-send-email-yhchuang@realtek.com>
 <1537509847-21087-2-git-send-email-yhchuang@realtek.com>
 <20180927135040.GA4712@redhat.com>
 <F7CD281DE3E379468C6D07993EA72F84D08D9F56@RTITMBSVM01.realtek.com.tw>
 <20180928092918.GC8323@redhat.com>
In-Reply-To: <20180928092918.GC8323@redhat.com>
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
> Sent: Friday, September 28, 2018 5:29 PM
> To: Tony Chuang
> Cc: kvalo@codeaurora.org; Larry.Finger@lwfinger.net;
> linux-wireless@vger.kernel.org; Pkshih; Andy Huang
> Subject: Re: [PATCH 01/12] rtwlan: main files
> 
> Hi
> 
> On Fri, Sep 28, 2018 at 03:20:45AM +0000, Tony Chuang wrote:
> > > > +	rtw_tx_pkt_info_update(rtwdev, &pkt_info, control, skb);
> > > > +	if (rtw_hci_tx(rtwdev, &pkt_info, skb))
> > > > +		goto out;
> > > > +
> > > > +	return;
> > > > +
> > > > +out:
> > > > +	dev_kfree_skb_any(skb);
> > > This can be simplified by just do kfree after if ().
> >
> >
> > OK, will replace them with ieee80211_free_txskb
> 
> I was thinking about:
> 
> 	if (rtw_hci_tx(rtwdev, &pkt_info, skb))
> 		dev_kfree_skb_any(skb)
> 
> just to remove 'return;' and out label.


OK, but why not use ieee80211_free_txskb, should it be better for mac80211?


> > Have not noticed so far, cause not we can only support on vif.
> >
> > And only STA mode is tested, should first modify the iface_conbination.
> > Then modify them back again if we submit patches support concurrents
> >
> > I think that vif_list & sta_list could be protected by a single mutex that
> > protects concurrent access against mac80211 callbacks, and further add
> > some rcu locks to protect sta_info. You have some suggestions?
> 
> That's good solution, sync multiple possible writes via mutex and
> reads of list against writes via RCU.
> 
> > I think mac80211 will do it "if the vif is different", but under the same vif,
> > mac80211 will protect it with "sdata->wdev.mtx". Not sure if I am right.
> 
> I need to check that as well :-)
> 
> > Yes, we can. If we have TDLS peer in STA mode or in AP mode, we could have
> > different bw_mode, by the sta_info mac80211 passed to us, and that
> sta_info is
> > checked by mac80211 based on the capabilities (IE) of the peer.
> How this work with respect we configure band-width when we change the
> channel?
> If we set band-width per sta, should then setting band-width on channel
> setup be droped ?


The channel setup and per-sta are required.

Now suppose we are STA mode, capable of 80Mhz, connecting to an AP that
is also capable of 80Mhz, then mac80211 will ask us to setup channel to 80Mhz.
Before change the channel, mac80211 will intersect the capabilities.

And now another peer joined, like TDLS, and the peer is only capable of 40Mhz,
after mac80211 intersect our capabilities, the sta_info passed will be 40Mhz.
Then we can talk to AP with 80Mhz BW, and to TDLS peer with 40Mhz.

Hence we need the per-sta capabilities.

> 
> > > > +static inline void rtw_load_table(struct rtw_dev *rtwdev,
> > > > +				  const struct rtw_table *tbl)
> > > > +{
> > > > +	(*tbl->parse)(rtwdev, tbl);
> > > > +}
> > >
> > > This interface of loading/processing tables of data looks very strange.
> > > I don't think is incorrect, but seems to be somewhat not necessary
> > > complicated. I'll try provide more detailed comment about that when
> > > review other files.
> >
> >
> > OK, but I think this is needed, our tables have different forms ....
> 
> Not sure if that is better solution, but could the tables be pre-prarsed
> by user-space program and then embed in the driver in ready to send
> to the hardware from ?
> 
> Also there are lot of redundancy in those tables, for example:
> 
> +	0x81C, 0xFF000003,
> +	0x81C, 0xF5000003,
> +	0x81C, 0xF4020003,
> +	0x81C, 0xF3040003,
> +	0x81C, 0xF2060003,
> +	0x81C, 0xF1080003,
> +	0x81C, 0xF00A0003,
> +	0x81C, 0xEF0C0003,
> +	0x81C, 0xEE0E0003,
> +	0x81C, 0xED100003,
> +	0x81C, 0xEC120003,
> +	0x81C, 0xEB140003,
> +	0x81C, 0xEA160003,
> +	0x81C, 0xE9180003,
> +	0x81C, 0xE81A0003,
> +	0x81C, 0xE71C0003,
> +	0x81C, 0xE61E0003,
> +	0x81C, 0xE5200003,
> 
> 0x81C and 0003 repeats in many lines.
> 
> This seems to be parse data, not that we have to write 0x81C
> register many times. Would be possible to remove the redundancy?


No, they cannot be removed, the sequence matters.
And it is really writing to 0x81C ...
It is really magic, I cannot believe to this, too.

Yan-Hsuan Chuang
