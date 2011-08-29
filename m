Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:39206 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab1H2CHn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Aug 2011 22:07:43 -0400
Received: by wwe5 with SMTP id 5so1988123wwe.1
        for <linux-wireless@vger.kernel.org>; Sun, 28 Aug 2011 19:07:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110826142210.GE2579@tuxdriver.com>
References: <1314236064-6339-1-git-send-email-thomas@cozybit.com>
	<20110826142210.GE2579@tuxdriver.com>
Date: Sun, 28 Aug 2011 19:07:42 -0700
Message-ID: <CAG6hwVM8t=v0_xZuKf-nodZR77R0S8nSUgea9QM5S-vB4h_8jg@mail.gmail.com> (sfid-20110829_040750_236224_2A878CBE)
Subject: Re: [PATCH] ath5k: Invoke irqsafe version of ieee80211_tx_status() to
 avoid deadlock
From: Thomas Pedersen <thomas@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, lrodriguez@atheros.com, me@bobcopeland.com,
	Javier Cardona <javier@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 26, 2011 at 7:22 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Wed, Aug 24, 2011 at 06:34:24PM -0700, Thomas Pedersen wrote:
>> From: Javier Cardona <javier@cozybit.com>
>>
>> This driver reports transmission status to the upper layer
>> (ath5k_tx_frame_completed()) while holding the lock on the transmission
>> queue (txq->lock).  Under failure conditions, the mesh stack will
>> attempt to send PERR messages to the previous sender of the failed
>> frame.  When that happens the driver will attempt to re-acquire the
>> txq->lock lock causing a deadlock.  There are two possible fixes for
>> this, (1) we could defer the transmission of the PERR frame until the
>> lock is released or (2) release the lock before invoking
>> ieee80211_tx_status().  The ath9k driver implements the second approach
>> (see ath_tx_complete() in ath9k/xmit.c) as well as the rt2x00 and b43
>> drivers.  The iwl driver, on the other hand, avoids this problem by
>> invoking  ieee80211_tx_status_irqsafe() which effectively defers
>> processing of transmission feedback status.  This last approach is the
>> least intrusive is implemented here.
>>
>> Reported by Pedro Larbig (ASPj)
>> ---
>>  drivers/net/wireless/ath/ath5k/base.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> Missing Signed-off-by...
>
Yikes. Also, it looks like ieee80211_tx_status() should not be called
from irq context. Will resubmit a v2 with signoff and comment shortly.

Thomas
