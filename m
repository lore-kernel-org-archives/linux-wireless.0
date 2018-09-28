Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5389C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 09:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7D402172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 09:29:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A7D402172C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729141AbeI1PwO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 11:52:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43286 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbeI1PwN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 11:52:13 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 18BE45F73D;
        Fri, 28 Sep 2018 09:29:22 +0000 (UTC)
Received: from localhost (ovpn-204-174.brq.redhat.com [10.40.204.174])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2324D60920;
        Fri, 28 Sep 2018 09:29:20 +0000 (UTC)
Date:   Fri, 28 Sep 2018 11:29:19 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>
Subject: Re: [PATCH 01/12] rtwlan: main files
Message-ID: <20180928092918.GC8323@redhat.com>
References: <1537509847-21087-1-git-send-email-yhchuang@realtek.com>
 <1537509847-21087-2-git-send-email-yhchuang@realtek.com>
 <20180927135040.GA4712@redhat.com>
 <F7CD281DE3E379468C6D07993EA72F84D08D9F56@RTITMBSVM01.realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D08D9F56@RTITMBSVM01.realtek.com.tw>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 28 Sep 2018 09:29:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi

On Fri, Sep 28, 2018 at 03:20:45AM +0000, Tony Chuang wrote:
> > > +	rtw_tx_pkt_info_update(rtwdev, &pkt_info, control, skb);
> > > +	if (rtw_hci_tx(rtwdev, &pkt_info, skb))
> > > +		goto out;
> > > +
> > > +	return;
> > > +
> > > +out:
> > > +	dev_kfree_skb_any(skb);
> > This can be simplified by just do kfree after if ().
> 
> 
> OK, will replace them with ieee80211_free_txskb

I was thinking about:

	if (rtw_hci_tx(rtwdev, &pkt_info, skb))
		dev_kfree_skb_any(skb)

just to remove 'return;' and out label.

> Have not noticed so far, cause not we can only support on vif.
> 
> And only STA mode is tested, should first modify the iface_conbination.
> Then modify them back again if we submit patches support concurrents
> 
> I think that vif_list & sta_list could be protected by a single mutex that
> protects concurrent access against mac80211 callbacks, and further add
> some rcu locks to protect sta_info. You have some suggestions?

That's good solution, sync multiple possible writes via mutex and
reads of list against writes via RCU.

> I think mac80211 will do it "if the vif is different", but under the same vif,
> mac80211 will protect it with "sdata->wdev.mtx". Not sure if I am right.

I need to check that as well :-)

> Yes, we can. If we have TDLS peer in STA mode or in AP mode, we could have
> different bw_mode, by the sta_info mac80211 passed to us, and that sta_info is
> checked by mac80211 based on the capabilities (IE) of the peer.
How this work with respect we configure band-width when we change the channel?
If we set band-width per sta, should then setting band-width on channel
setup be droped ?

> > > +static inline void rtw_load_table(struct rtw_dev *rtwdev,
> > > +				  const struct rtw_table *tbl)
> > > +{
> > > +	(*tbl->parse)(rtwdev, tbl);
> > > +}
> > 
> > This interface of loading/processing tables of data looks very strange.
> > I don't think is incorrect, but seems to be somewhat not necessary
> > complicated. I'll try provide more detailed comment about that when
> > review other files.
> 
> 
> OK, but I think this is needed, our tables have different forms ....

Not sure if that is better solution, but could the tables be pre-prarsed
by user-space program and then embed in the driver in ready to send
to the hardware from ?

Also there are lot of redundancy in those tables, for example:

+	0x81C, 0xFF000003,
+	0x81C, 0xF5000003,
+	0x81C, 0xF4020003,
+	0x81C, 0xF3040003,
+	0x81C, 0xF2060003,
+	0x81C, 0xF1080003,
+	0x81C, 0xF00A0003,
+	0x81C, 0xEF0C0003,
+	0x81C, 0xEE0E0003,
+	0x81C, 0xED100003,
+	0x81C, 0xEC120003,
+	0x81C, 0xEB140003,
+	0x81C, 0xEA160003,
+	0x81C, 0xE9180003,
+	0x81C, 0xE81A0003,
+	0x81C, 0xE71C0003,
+	0x81C, 0xE61E0003,
+	0x81C, 0xE5200003,

0x81C and 0003 repeats in many lines. 

This seems to be parse data, not that we have to write 0x81C
register many times. Would be possible to remove the redundancy?

Thanks
Stanislaw
