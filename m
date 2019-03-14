Return-Path: <SRS0=QiZU=RR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21FE6C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 13:50:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEC8F2184C
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 13:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbfCNNuS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Mar 2019 09:50:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54532 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727394AbfCNNuQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Mar 2019 09:50:16 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A69A33091752;
        Thu, 14 Mar 2019 13:50:16 +0000 (UTC)
Received: from localhost (unknown [10.43.2.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40B5D17DC4;
        Thu, 14 Mar 2019 13:50:13 +0000 (UTC)
Date:   Thu, 14 Mar 2019 14:50:12 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [RFC] mt76: add 3dBm for reporting txpower also for 1x1
Message-ID: <20190314135011.GA15786@redhat.com>
References: <1552484061-4647-1-git-send-email-sgruszka@redhat.com>
 <795dd253-53db-d837-4da6-6016a096cdc7@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <795dd253-53db-d837-4da6-6016a096cdc7@nbd.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 14 Mar 2019 13:50:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Mar 13, 2019 at 02:38:01PM +0100, Felix Fietkau wrote:
> On 2019-03-13 14:34, Stanislaw Gruszka wrote:
> > It's not clear for my why we should add 3dBm for 2x2 devices
> > and not for 1x1. 3dBm looks rater like minimal txpower and
> > hardware transmit at 3dBm + dev->txpower_cur / 2 .
> > 
> > With the change reported txpower value are closer to regulatory
> > values, but honestly I have no idea what should be reported.
> > 
> > Perhaps also some better comment should be added.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> The reason why we add 3dBm is because using two chains to transmit in
> the worst case (from regulatory point of view) doubles the transmit
> power (= +3dBm). There's no reason to do the same for 1x1.

Do we calculate and show correct txpower for mt76x0 then?

I have mt76x0u 50:3e:aa:a6:5d:32 and iwlmvm 1c:1b:b5:23:cf:58
devices on one laptop at the same location connected to AP.
RSSI values of both stations are quite similar:

Station 50:3e:aa:a6:5d:32 (on wlan0)
        inactive time:  4971 ms
        rx bytes:       11383
        rx packets:     97
        tx bytes:       2764
        tx packets:     17
        tx retries:     3
        tx failed:      1
        signal:         -55 [-65, -55] dBm
        signal avg:     -57 [-65, -57] dBm
        tx bitrate:     65.0 MBit/s MCS 6 short GI
        rx bitrate:     6.0 MBit/s
        authorized:     yes
        authenticated:  yes
        preamble:       long
        WMM/WME:        yes
        MFP:            no
        TDLS peer:      no
Station 1c:1b:b5:23:cf:58 (on wlan0)
        inactive time:  24261 ms
        rx bytes:       11320
        rx packets:     121
        tx bytes:       2274
        tx packets:     11
        tx retries:     0
        tx failed:      1
        signal:         -52 [-60, -52] dBm
        signal avg:     -54 [-59, -55] dBm
        tx bitrate:     6.5 MBit/s MCS 0
        rx bitrate:     6.0 MBit/s
        authorized:     yes
        authenticated:  yes
        preamble:       long
        WMM/WME:        yes
        MFP:            no
        TDLS peer:      no

On laptop txpower showed by iw for mt76x0u is 17 dBm , for iwlmvm
is 22 dBm (this is value from mac80211, iwlwifi does not implement
.get_txpower() callback). 

I do not consider this as big issue though, but can confuse some users.
Apparently confuses me.

Stanislaw
