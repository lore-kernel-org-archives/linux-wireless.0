Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40273 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab1H2OJs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 10:09:48 -0400
Received: by qyk34 with SMTP id 34so3772006qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2011 07:09:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG6hwVM8t=v0_xZuKf-nodZR77R0S8nSUgea9QM5S-vB4h_8jg@mail.gmail.com>
References: <1314236064-6339-1-git-send-email-thomas@cozybit.com>
	<20110826142210.GE2579@tuxdriver.com>
	<CAG6hwVM8t=v0_xZuKf-nodZR77R0S8nSUgea9QM5S-vB4h_8jg@mail.gmail.com>
Date: Mon, 29 Aug 2011 10:09:47 -0400
Message-ID: <CAEKwDSAXDgUY_Mc2A75x=-1VEMLF3Kd+=dgJOaBs+XOFn58dYw@mail.gmail.com> (sfid-20110829_160954_940058_F66C44BD)
Subject: Re: [PATCH] ath5k: Invoke irqsafe version of ieee80211_tx_status() to
 avoid deadlock
From: Bob Copeland <me@bobcopeland.com>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, lrodriguez@atheros.com,
	Javier Cardona <javier@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 28, 2011 at 10:07 PM, Thomas Pedersen <thomas@cozybit.com> wrote:
> On Fri, Aug 26, 2011 at 7:22 AM, John W. Linville
> <linville@tuxdriver.com> wrote:
>> On Wed, Aug 24, 2011 at 06:34:24PM -0700, Thomas Pedersen wrote:
>>> From: Javier Cardona <javier@cozybit.com>
>>>
>>> This driver reports transmission status to the upper layer
>>> (ath5k_tx_frame_completed()) while holding the lock on the transmission
>>> queue (txq->lock).  Under failure conditions, the mesh stack will
>>> attempt to send PERR messages to the previous sender of the failed
>>> frame.  When that happens the driver will attempt to re-acquire the
>>> txq->lock lock causing a deadlock.  There are two possible fixes for
>>> this, (1) we could defer the transmission of the PERR frame until the
>>> lock is released or (2) release the lock before invoking
>>> ieee80211_tx_status().  The ath9k driver implements the second approach
>>> (see ath_tx_complete() in ath9k/xmit.c) as well as the rt2x00 and b43
>>> drivers.  The iwl driver, on the other hand, avoids this problem by
>>> invoking  ieee80211_tx_status_irqsafe() which effectively defers
>>> processing of transmission feedback status.  This last approach is the
>>> least intrusive is implemented here.
>>>
>>> Reported by Pedro Larbig (ASPj)
>>> ---
>>>  drivers/net/wireless/ath/ath5k/base.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> Missing Signed-off-by...
>>
> Yikes. Also, it looks like ieee80211_tx_status() should not be called
> from irq context. Will resubmit a v2 with signoff and comment shortly.

I don't get the last statement -- ieee80211_tx_status() -> irqsafe was
the very change the patch added.  It's running in a bottom half
though, not a hard irq.

-- 
Bob Copeland %% www.bobcopeland.com
