Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55562C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 14:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B3A32147C
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 14:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfCMOGL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 10:06:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43194 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726772AbfCMOGL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 10:06:11 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BD9C830FE5A5;
        Wed, 13 Mar 2019 14:06:10 +0000 (UTC)
Received: from localhost (unknown [10.43.2.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5DFA15ED2B;
        Wed, 13 Mar 2019 14:06:10 +0000 (UTC)
Date:   Wed, 13 Mar 2019 15:06:08 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        daniel@makrotopia.org
Subject: Re: [PATCH 2/2] rt2x00: enable experimental MFP with HW crypt
Message-ID: <20190313140607.GE2003@redhat.com>
References: <1552417902-11040-1-git-send-email-pozega.tomislav@gmail.com>
 <1552417902-11040-2-git-send-email-pozega.tomislav@gmail.com>
 <20190313091252.GB2663@redhat.com>
 <CAKR_QV+sFc6J97f5dtW9OtxGoEj5udB=fY5qAb3_QgF4jfqEVA@mail.gmail.com>
 <20190313130910.GD2003@redhat.com>
 <CAKR_QVLB9k0bGiRW9ON3PeQR1ZoMfWbrXg3W+Bg4N4G+9pAsZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKR_QVLB9k0bGiRW9ON3PeQR1ZoMfWbrXg3W+Bg4N4G+9pAsZg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Wed, 13 Mar 2019 14:06:10 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Mar 13, 2019 at 02:48:01PM +0100, Tom Psyborg wrote:
> On 13/03/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > On Wed, Mar 13, 2019 at 02:02:32PM +0100, Tom Psyborg wrote:
> >> On 13/03/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> >> > On Tue, Mar 12, 2019 at 08:11:42PM +0100, Tomislav Požega wrote:
> >> >> MFP can work with enabled HW crypt engine, but in this case
> >> >> available bandwidth is reduced at least when connecting to
> >> >> Archer C7 (QCA9558). Enable the feature for known to work chipsets-
> >> >> MT7620, RT3070 and RT5390. Userspace setting for ieee80211w should
> >> >> default to 0 in order to prevent unintentional bandwidth drop.
> >> >>
> >> >> Signed-off-by: Tomislav Po?ega <pozega.tomislav@gmail.com>
> >> >> ---
> >> >>  drivers/net/wireless/ralink/rt2x00/rt2800lib.c |   11 +++++++----
> >> >>  1 files changed, 7 insertions(+), 4 deletions(-)
> >> >>
> >> >> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> >> >> b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> >> >> index a03b528..bb8204d 100644
> >> >> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> >> >> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> >> >> @@ -9326,6 +9326,13 @@ static int rt2800_probe_hw_mode(struct
> >> >> rt2x00_dev
> >> >> *rt2x00dev)
> >> >>  	ieee80211_hw_set(rt2x00dev->hw, SIGNAL_DBM);
> >> >>  	ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_PS);
> >> >>
> >> >> +	/* Experimental: Set MFP with HW crypto enabled. */
> >> >> +	if (rt2x00_rt(rt2x00dev, RT3070) || rt2x00_rt(rt2x00dev, RT5390) ||
> >> >> +	    rt2x00_rt(rt2x00dev, RT6352))
> >> >> +		ieee80211_hw_set(rt2x00dev->hw, MFP_CAPABLE);
> >> >
> >> > Is not that we support MFP in hardware. We just return -EOPNOTSUPP
> >> > in rt2x00mac_set_key() when mac80211 will try to set MFP ciphers
> >> > (since rt2x00crypto_key_to_cipher() will return CIPHER_NONE) and
> >> > we fallback to software encryption.
> >> >
> >> > Please repost patch that enable MFP unconditionally with
> >> > 'Cc: stable@vger.kernel.org' tag.
> >> >
> >> > Stanislaw
> >> >
> >>
> >> No, I have not test any other chipsets besides the ones I enabled it
> >> for. It is possible this would cause problems on other devices, so
> >> just enable it for the known to work ones.
> >
> > It's just matter of sending already encrypted frames. All chipsets
> > handle that.
> >
> > Stanislaw
> >
> 
> The question is how well all chipsets handle that. I've seen some lags
> too with MFP enabled connection. While being about 40-50% lower,
> throughput would still occasionally drop to very low values, like
> 800Kbps.

The only reason I can image that might have impact on throughput
in this case is limited CPU power since encryption is done in 
software. Would be good to compare with PA2 with nohwcrypte, if 
there are similar lags. However MFP can require more CPU power.

Stanislaw
