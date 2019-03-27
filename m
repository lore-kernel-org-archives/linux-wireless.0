Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64608C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 05:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36F4E2075E
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 05:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725791AbfC0FHk convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 01:07:40 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:39019 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbfC0FHk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 01:07:40 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x2R57IUG015511, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x2R57IUG015511
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 27 Mar 2019 13:07:18 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Wed, 27 Mar
 2019 13:07:18 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Brian Norris <briannorris@chromium.org>
CC:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
Subject: RE: [PATCH v8 03/14] rtw88: hci files
Thread-Topic: [PATCH v8 03/14] rtw88: hci files
Thread-Index: AQHU2VNRV2ab8RA6e0q0FRHPGCHboaYb9v2AgAMLpqA=
Date:   Wed, 27 Mar 2019 05:07:17 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D17CB987@RTITMBSVM04.realtek.com.tw>
References: <1552450443-351-1-git-send-email-yhchuang@realtek.com>
 <1552450443-351-4-git-send-email-yhchuang@realtek.com>
 <20190325143439.pxe2sppqssdad4in@penguin>
In-Reply-To: <20190325143439.pxe2sppqssdad4in@penguin>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.183]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> Hi,
> 
> On Wed, Mar 13, 2019 at 12:13:52PM +0800, yhchuang@realtek.com wrote:
> > diff --git a/drivers/net/wireless/realtek/rtw88/pci.c
> b/drivers/net/wireless/realtek/rtw88/pci.c
> > new file mode 100644
> > index 0000000..cf3bffb
> > --- /dev/null
> > +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> > @@ -0,0 +1,1211 @@
> ...
> > +static u8 ac_to_hwq[] = {
> > +	[0] = RTW_TX_QUEUE_VO,
> > +	[1] = RTW_TX_QUEUE_VI,
> > +	[2] = RTW_TX_QUEUE_BE,
> > +	[3] = RTW_TX_QUEUE_BK,
> > +};
> 
> I don't want to dig up and repeat the details of my comments, but I
> think you missed my earlier suggestion here: you should use the
> ieee80211_ac_numbers enum instead of bare 0-3 indexing.

Fixed, thanks. Will be in the next patches.

> 
> > +static u8 rtw_hw_queue_mapping(struct sk_buff *skb)
> > +{
> > +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
> > +	__le16 fc = hdr->frame_control;
> > +	u8 q_mapping = skb_get_queue_mapping(skb);
> > +	u8 queue;
> > +
> > +	if (unlikely(ieee80211_is_beacon(fc)))
> > +		queue = RTW_TX_QUEUE_BCN;
> > +	else if (unlikely(ieee80211_is_mgmt(fc) || ieee80211_is_ctl(fc)))
> > +		queue = RTW_TX_QUEUE_MGMT;
> > +	else
> > +		queue = ac_to_hwq[q_mapping];
> 
> It also seems wise to be defensive about the values of 'q_mapping', so
> we don't accidentally overstep the array if for some reason the
> implementation details of mac80211 change some day. e.g.:
> 
> 	else if (WARN_ON_ONCE(q_mapping >= ARRAY_SIZE(ac_to_hwq)))
> 		// Pick a default.

Yeah, should check if q_mapping does not fit into the array.
Thanks.

> 
> Brian
> 
> > +
> > +	return queue;
> > +}
> > +
> 

Yan-Hsuan
