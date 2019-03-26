Return-Path: <SRS0=Lwp6=R5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E3E1C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 11:35:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C21A2070B
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 11:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731438AbfCZLfG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Mar 2019 07:35:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50846 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729662AbfCZLfG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Mar 2019 07:35:06 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7DF1F90AC2;
        Tue, 26 Mar 2019 11:35:05 +0000 (UTC)
Received: from localhost (unknown [10.43.2.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 17A63B5448;
        Tue, 26 Mar 2019 11:35:04 +0000 (UTC)
Date:   Tue, 26 Mar 2019 12:35:03 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        daniel@makrotopia.org
Subject: Re: [PATCH 2/2] rt2x00: enable experimental MFP with HW crypt
Message-ID: <20190326113502.GA9012@redhat.com>
References: <1552417902-11040-1-git-send-email-pozega.tomislav@gmail.com>
 <1552417902-11040-2-git-send-email-pozega.tomislav@gmail.com>
 <20190313091252.GB2663@redhat.com>
 <CAKR_QV+sFc6J97f5dtW9OtxGoEj5udB=fY5qAb3_QgF4jfqEVA@mail.gmail.com>
 <20190313130910.GD2003@redhat.com>
 <CAKR_QVLB9k0bGiRW9ON3PeQR1ZoMfWbrXg3W+Bg4N4G+9pAsZg@mail.gmail.com>
 <20190313140607.GE2003@redhat.com>
 <CAKR_QV+gEJEE2+hwfE1wsF5mdEZVDGtNskivcpFUutGEbwKyKg@mail.gmail.com>
 <977a3cf4-3ec5-4aaa-b3d4-eea2e8593652@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <977a3cf4-3ec5-4aaa-b3d4-eea2e8593652@nbd.name>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 26 Mar 2019 11:35:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Mar 26, 2019 at 11:41:37AM +0100, Felix Fietkau wrote:
> On 2019-03-13 15:41, Tom Psyborg wrote:
> > On 13/03/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> >> On Wed, Mar 13, 2019 at 02:48:01PM +0100, Tom Psyborg wrote:
> >>> On 13/03/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> >>> > On Wed, Mar 13, 2019 at 02:02:32PM +0100, Tom Psyborg wrote:
> >>> >> On 13/03/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> >>> >> > On Tue, Mar 12, 2019 at 08:11:42PM +0100, Tomislav Požega wrote:
> >>> >> >> MFP can work with enabled HW crypt engine, but in this case
> >>> >> >> available bandwidth is reduced at least when connecting to
> >>> >> >> Archer C7 (QCA9558). Enable the feature for known to work chipsets-
> >>> >> >> MT7620, RT3070 and RT5390. Userspace setting for ieee80211w should
> >>> >> >> default to 0 in order to prevent unintentional bandwidth drop.
> >>> >> >>
> >>> >> >> Signed-off-by: Tomislav Po?ega <pozega.tomislav@gmail.com>
> >>> >> >> ---
> >>> >> >>  drivers/net/wireless/ralink/rt2x00/rt2800lib.c |   11 +++++++----
> >>> >> >>  1 files changed, 7 insertions(+), 4 deletions(-)
> >>> >> >>
> >>> >> >> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> >>> >> >> b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> >>> >> >> index a03b528..bb8204d 100644
> >>> >> >> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> >>> >> >> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> >>> >> >> @@ -9326,6 +9326,13 @@ static int rt2800_probe_hw_mode(struct
> >>> >> >> rt2x00_dev
> >>> >> >> *rt2x00dev)
> >>> >> >>  	ieee80211_hw_set(rt2x00dev->hw, SIGNAL_DBM);
> >>> >> >>  	ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_PS);
> >>> >> >>
> >>> >> >> +	/* Experimental: Set MFP with HW crypto enabled. */
> >>> >> >> +	if (rt2x00_rt(rt2x00dev, RT3070) || rt2x00_rt(rt2x00dev, RT5390)
> >>> >> >> ||
> >>> >> >> +	    rt2x00_rt(rt2x00dev, RT6352))
> >>> >> >> +		ieee80211_hw_set(rt2x00dev->hw, MFP_CAPABLE);
> >>> >> >
> >>> >> > Is not that we support MFP in hardware. We just return -EOPNOTSUPP
> >>> >> > in rt2x00mac_set_key() when mac80211 will try to set MFP ciphers
> >>> >> > (since rt2x00crypto_key_to_cipher() will return CIPHER_NONE) and
> >>> >> > we fallback to software encryption.
> >>> >> >
> >>> >> > Please repost patch that enable MFP unconditionally with
> >>> >> > 'Cc: stable@vger.kernel.org' tag.
> >>> >> >
> >>> >> > Stanislaw
> >>> >> >
> >>> >>
> >>> >> No, I have not test any other chipsets besides the ones I enabled it
> >>> >> for. It is possible this would cause problems on other devices, so
> >>> >> just enable it for the known to work ones.
> >>> >
> >>> > It's just matter of sending already encrypted frames. All chipsets
> >>> > handle that.
> >>> >
> >>> > Stanislaw
> >>> >
> >>>
> >>> The question is how well all chipsets handle that. I've seen some lags
> >>> too with MFP enabled connection. While being about 40-50% lower,
> >>> throughput would still occasionally drop to very low values, like
> >>> 800Kbps.
> >>
> >> The only reason I can image that might have impact on throughput
> >> in this case is limited CPU power since encryption is done in
> >> software. Would be good to compare with PA2 with nohwcrypte, if
> >> there are similar lags. However MFP can require more CPU power.
> >>
> >> Stanislaw
> >>
> > 
> > nohwcrypt=y mfp=require: there was no throughput drop, no lag,
> > measured about 80-85Mbps but the connection frozen after a minute or
> > two. might be related to rekeying.
> > 
> > CPU power cannot be the problem since I run it on laptop (2x2.20GHz)
> The lag is probably caused by failed A-MPDU setup exchanges due to
> broken management frames.
> 
> I think it's likely that rt28xx chipsets are behaving like mt7612e in
> that area (since the MAC design is very similar).
> I've spent quite a bit of time making MFP work properly in mt76 on that
> chipset, and here are my findings:
> Hardware crypto for management frames is broken.
> When using management frame protection, the same pairwise encryption key
> needs to be used for both data frames and management frames.
> There is a flag in mac80211 that allows software-encryption for
> management frames only.
> That leads us to the next issue: CCMP PN is usually generated in
> hardware and stored in on-chip memory, which means the mac80211 key
> tx_pn counter will be out of sync and software-encrypted management
> packets will trigger replay protection on the other side.
> To fix this, you need to enable software generated IV if management
> frames are to be sent with the same key.
> In that case you need to set TXINFO_W0_WIV and fill TXWI_W2_IV+TXWI_W3_EIV.
> Also, for software encrypted frames you need to mask out WCID, since
> otherwise the hardware will try to encrypt the frame again.
> You can use mt76 as reference for how to do all of this

I see, I got it completely wrong. I thought with MFP we will use non
supported rt2x00 cipher and we will fallback to software encryption
anyway.

So, until properly implemented we should stay with nohwcrypt for MFP.

Stanislaw
