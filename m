Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:62632 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542Ab3BVQk1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 11:40:27 -0500
Received: by mail-ea0-f173.google.com with SMTP id i1so354731eaa.4
        for <linux-wireless@vger.kernel.org>; Fri, 22 Feb 2013 08:40:26 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH] carl9170: fix frame drop and WARN due to minstrel_ht change
Date: Fri, 22 Feb 2013 17:40:21 +0100
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <201302220130.45434.chunkeey@googlemail.com> <51279938.6030807@openwrt.org>
In-Reply-To: <51279938.6030807@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201302221740.22323.chunkeey@googlemail.com> (sfid-20130222_174031_552778_64499FC4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 22 February 2013 17:13:44 Felix Fietkau wrote:
> On 2013-02-22 1:30 AM, Christian Lamparter wrote:
> > With "mac80211/minstrel_ht: add support for using CCK rates"
> > minstrel_ht selects legacy CCK rates as viable rates for
> > outgoing frames which might be sent as part of an A-MPDU
> > [IEEE80211_TX_CTL_AMPDU is set].
> > 
> > This behavior triggered the following WARN_ON in the driver:
> >> WARNING: at carl9170/tx.c:995 carl9170_op_tx+0x1dd/0x6fd
> > The driver assumed that the rate control algorithm made a
> > mistake and dropped the frame.
> > 
> > This patch removes the noisy warning altogether and allows
> > said A-MPDU frames with CCK sample and/or fallback rates to
> > be transmitted seamlessly.
> Shouldn't it prevent aggregation of frames with CCK in the fallback rate
> chain? I don't think transmitting an A-MPDU with a CCK rate works.
IEEE80211_TX_CTL_AMPDU is set on a per-frame base and not per-rate
(so strictly speaking for such frames we ought to form aggregates 
even with CCK rates...  Which of course would be - as you said it - 
totally bonkers.

But of course, the code in the patch does the right thing in
this case. It only sets the aggregation bit (for the HW) for
MCS rates.

BTW: doesn't minstrel_ht also select cck rates for sampling.
(i.e.: as the rate[0]/first rate? Is this alright?!)

Regards,
	Christian
