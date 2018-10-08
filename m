Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B779CC64EB8
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:03:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DE842087C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:03:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DE842087C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbeJHQN7 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 12:13:59 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:55034 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbeJHQN7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 12:13:59 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w98932rw025647, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w98932rw025647
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 8 Oct 2018 17:03:02 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Mon, 8 Oct
 2018 17:03:02 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     Stanislaw Gruszka <sgruszka@redhat.com>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC v2 03/12] rtw88: hci files
Thread-Topic: [RFC v2 03/12] rtw88: hci files
Thread-Index: AQHUXXAt00o5WDjqi0mvFShMBfsKOqUVDqog
Date:   Mon, 8 Oct 2018 09:03:00 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D172BDD2@RTITMBSVM01.realtek.com.tw>
References: <1538553748-26364-1-git-send-email-yhchuang@realtek.com>
        <1538553748-26364-4-git-send-email-yhchuang@realtek.com>
        <20181004130212.GC16819@redhat.com>
        <F7CD281DE3E379468C6D07993EA72F84D172A54A@RTITMBSVM01.realtek.com.tw>
 <87d0snfecr.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87d0snfecr.fsf@kamboji.qca.qualcomm.com>
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
> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Saturday, October 06, 2018 8:29 PM
> To: Tony Chuang
> Cc: Stanislaw Gruszka; Larry.Finger@lwfinger.net; Pkshih; Andy Huang;
> linux-wireless@vger.kernel.org
> Subject: Re: [RFC v2 03/12] rtw88: hci files
> 
> Tony Chuang <yhchuang@realtek.com> writes:
> 
> >> > +		}
> >> > +
> >> > +		info = IEEE80211_SKB_CB(skb);
> >> > +		ieee80211_tx_info_clear_status(info);
> >> > +		info->flags |= IEEE80211_TX_STAT_ACK;
> >> > +		ieee80211_tx_status_irqsafe(hw, skb);
> >>
> >> Always report ACK ?
> >
> > The ACK report is for mac80211 stack, it looks abnormal at the first glance.
> > But we can only do this for every data frame because there is no ack report
> > unless the driver ask the firmware to give one.
> > Ask for every data frame is resource consuming.
> 
> I don't remember how mac80211 wants to handle the cases when the
> hardware doesn't provide ack status, but lying that to mac80211 sounds
> like a bad idea to me. Anyone have any suggestions how this should be
> handled?
> 
> At the minimum add a proper comment explaining why you are lying to
> mac80211.
> 
> --
> Kalle Valo
> 

If mac80211 wants any specific packet to have a report,
it will pass IEEE80211_TX_CTL_REQ_TX_STATUS through
tx flags (most mlme or something important worth to know if it success).
Those packets need extra process for them to get report
from firmware. This will be added after the first RFC get accepted.

However, I can add a comment to describe this to avoid confusing.

Yan-Hsuan Chuang
