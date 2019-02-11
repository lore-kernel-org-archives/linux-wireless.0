Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4AFCC169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 04:31:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B19420855
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 04:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbfBKEba convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 23:31:30 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:49970 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbfBKEba (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 23:31:30 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x1B4V4Z6026246, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x1B4V4Z6026246
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Mon, 11 Feb 2019 12:31:04 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCASV01.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Mon, 11 Feb
 2019 12:31:03 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Brian Norris <briannorris@chromium.org>
CC:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Andy Huang <tehuang@realtek.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 01/24] rtw88: report correct tx status if mac80211 requested one
Thread-Topic: [PATCH 01/24] rtw88: report correct tx status if mac80211
 requested one
Thread-Index: AQHUuV+XknyXKg2sIUuVU1GvRxjW06XWUHuAgAO1UbA=
Date:   Mon, 11 Feb 2019 04:31:03 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D17A2A22@RTITMBSVM04.realtek.com.tw>
References: <1548937297-14660-1-git-send-email-yhchuang@realtek.com>
 <1548937297-14660-2-git-send-email-yhchuang@realtek.com>
 <20190209030756.GB163159@google.com>
In-Reply-To: <20190209030756.GB163159@google.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.124]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



> -----Original Message-----
> From: Brian Norris [mailto:briannorris@chromium.org]
> 
> On Thu, Jan 31, 2019 at 08:21:14PM +0800, yhchuang@realtek.com wrote:
> > From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> >
> > Before this commit, driver always reports IEEE80211_TX_STAT_ACK for
> > every tx packet, but it will confuse the mac80211 stack for connection
> > monitor system. mac80211 stack needs correct ack information about some
> > specific packets such as prop_req, null, auth, assoc, in order to know
> > if AP is alive. And for such packets, mac80211 will pass a tx flag
> > IEEE80211_TX_CTL_REQ_TX_STATUS to driver. Driver then need to request a
> > tx report from hardware.
> 
> I think you're misinterpreting the mac80211 semantics here. This flag
> isn't for the driver to determine whether or not it should report ACKs
> -- it's to help ensure that status reports *really* make it back up to
> the upper layers (and don't get dropped).
> 
> On the contrary, if you look at __ieee80211_tx_status(), it's expecting
> that everything that has IEEE80211_HW_REPORTS_TX_ACK_STATUS will report
> an appropriate IEEE80211_TX_STAT_ACK status. The logic is basically:
> 
> 	if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
> 		if (!(info->flags & IEEE80211_TX_STAT_ACK))
> 			ieee80211_lost_packet(sta, info);
> 
> That explains why I see almost every packet get reported as lost in `iw
> wlan0 station dump`.

To fix `iw wlan0 station dump` display, I think I can just restore one line
in pci.c. That is, restore IEEE80211_TX_STAT_ACK flag line:

+			continue;
+		}
  		ieee80211_tx_info_clear_status(info);
-		info->flags |= IEEE80211_TX_STAT_ACK;
  		ieee80211_tx_status_irqsafe(hw, skb)

And with some modifications, such as IEEE80211_TX_CTL_NO_ACK check.
Then we can better reporting ACK status for data frames without
IEEE80211_TX_CTL_REQ_TX_STATUS. This way we can also ensure the
connection monitor can work. (but it will be no loss)


> 
> > The tx report is not passed by hardware with the tx'ed packet, it is
> > passed through C2H. So driver need to queue the packets that require
> > correct tx report and upon the tx report is received, report to mac80211
> > stack, with the frame is acked or not.
> >
> > In case of driver missed the C2H report, setup a 500ms timer to purge
> > the tx report skb queue (500ms is time mac80211 used as probe_time).
> >
> > Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> > ---
> >  drivers/net/wireless/realtek/rtw88/fw.c   | 21 ++++++-
> >  drivers/net/wireless/realtek/rtw88/fw.h   |  8 +++
> >  drivers/net/wireless/realtek/rtw88/main.c | 10 ++++
> >  drivers/net/wireless/realtek/rtw88/main.h | 13 +++++
> >  drivers/net/wireless/realtek/rtw88/pci.c  |  8 ++-
> >  drivers/net/wireless/realtek/rtw88/pci.h  |  1 +
> >  drivers/net/wireless/realtek/rtw88/tx.c   | 96
> +++++++++++++++++++++++++++++++
> >  drivers/net/wireless/realtek/rtw88/tx.h   |  8 +++
> >  8 files changed, 163 insertions(+), 2 deletions(-)
> 
> ...
> 
> > diff --git a/drivers/net/wireless/realtek/rtw88/pci.c
> b/drivers/net/wireless/realtek/rtw88/pci.c
> > index ef3c9bb..7de4638 100644
> > --- a/drivers/net/wireless/realtek/rtw88/pci.c
> > +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> > @@ -585,6 +585,7 @@ static int rtw_pci_xmit(struct rtw_dev *rtwdev,
> >
> >  	tx_data = rtw_pci_get_tx_data(skb);
> >  	tx_data->dma = dma;
> > +	tx_data->sn = pkt_info->sn;
> >  	skb_queue_tail(&ring->queue, skb);
> >
> >  	/* kick off tx queue */
> > @@ -716,8 +717,13 @@ static void rtw_pci_tx_isr(struct rtw_dev *rtwdev,
> struct rtw_pci *rtwpci,
> >  		skb_pull(skb, rtwdev->chip->tx_pkt_desc_sz);
> >
> >  		info = IEEE80211_SKB_CB(skb);
> > +
> > +		/* enqueue to wait for tx report */
> > +		if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) {
> > +			rtw_tx_report_enqueue(rtwdev, skb, tx_data->sn);
> 
> This reporting code appears to be very buggy. At least, it's extremely
> easy to hit the WARN() you've inserted ("purge skb(s) not reported by
> firmware"), which means that the TX reporting queue is not getting
> responses for a lot of packets.

It's not buggy I think, if firmware is not reporting status, something must
go wrong. And after some test I know why you feel it's unreliable.

For WOW implementation, we modified a lot in fw.c functions.
And correct some driver-firmware interface behaviors. To make sure the
firmware is running as expected. But the patches are still holding in my hand.
I can attach them in this patch set, and apparently I should. I will separate
them out of WOW patch set and resend again.

> 
> So it's not clear if you should be trying to accurately report
> everything (even if your firmware status reports are unreliable), or if
> you should just drop the REPORTS_TX_ACK_STATUS feature.

I think we should keep this feature. Because we actually can report status,
despite not for every packet. The only problem is when we use `iw wlan0
station dump` we could get *no* packet loss (like I've mentioned above,
report TX_STAT_ACK for every other packets not have
IEEE80211_TX_CTL_REQ_TX_STATUS). We cannot accurately report
everything by firmware report, it takes too many tx bandwidth, and
the performance will degrade severely. If we really cannot accept reporting
tx status this way, we need to find another way to solve it. That means I
need some time to investigate and test connect monitor system and get
a better report logic if we drop the REPORTS_TX_ACK_STATUS feature.
Or if you have a point of view, we can discuss about it.
Thanks!

> 
> > +			continue;
> > +		}
> >  		ieee80211_tx_info_clear_status(info);
> > -		info->flags |= IEEE80211_TX_STAT_ACK;
> >  		ieee80211_tx_status_irqsafe(hw, skb);
> 
> One other problem with your code is that it doesn't check for
> IEEE80211_TX_CTL_NO_ACK anywhere. With that flag, you should be
> reporting IEEE80211_TX_STAT_NOACK_TRANSMITTED instead of
> IEEE80211_TX_STAT_ACK.

Should add the check with that restored line I mentioned for pci.c

> 
> >  	}
> >
> 
> Brian
> 

Yan-Hsuan
