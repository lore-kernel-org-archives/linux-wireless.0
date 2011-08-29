Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53334 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab1H2SNL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 14:13:11 -0400
Received: by wwf5 with SMTP id 5so6002082wwf.1
        for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2011 11:13:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEKwDSAXDgUY_Mc2A75x=-1VEMLF3Kd+=dgJOaBs+XOFn58dYw@mail.gmail.com>
References: <1314236064-6339-1-git-send-email-thomas@cozybit.com>
	<20110826142210.GE2579@tuxdriver.com>
	<CAG6hwVM8t=v0_xZuKf-nodZR77R0S8nSUgea9QM5S-vB4h_8jg@mail.gmail.com>
	<CAEKwDSAXDgUY_Mc2A75x=-1VEMLF3Kd+=dgJOaBs+XOFn58dYw@mail.gmail.com>
Date: Mon, 29 Aug 2011 11:13:10 -0700
Message-ID: <CAG6hwVMYaxsY6XcwbU9_nNMCEO0pC_RiQU-QJBPbpdxO9g4rnA@mail.gmail.com> (sfid-20110829_201315_261883_7D185BFA)
Subject: Re: [PATCH] ath5k: Invoke irqsafe version of ieee80211_tx_status() to
 avoid deadlock
From: Thomas Pedersen <thomas@cozybit.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, lrodriguez@atheros.com,
	Javier Cardona <javier@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 29, 2011 at 7:09 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Sun, Aug 28, 2011 at 10:07 PM, Thomas Pedersen <thomas@cozybit.com> wrote:
>> On Fri, Aug 26, 2011 at 7:22 AM, John W. Linville
>> <linville@tuxdriver.com> wrote:
>>> On Wed, Aug 24, 2011 at 06:34:24PM -0700, Thomas Pedersen wrote:
>>>> From: Javier Cardona <javier@cozybit.com>
>>>>
>>>> This driver reports transmission status to the upper layer
>>>> (ath5k_tx_frame_completed()) while holding the lock on the transmission
>>>> queue (txq->lock).  Under failure conditions, the mesh stack will
>>>> attempt to send PERR messages to the previous sender of the failed
>>>> frame.  When that happens the driver will attempt to re-acquire the
>>>> txq->lock lock causing a deadlock.  There are two possible fixes for
>>>> this, (1) we could defer the transmission of the PERR frame until the
>>>> lock is released or (2) release the lock before invoking
>>>> ieee80211_tx_status().  The ath9k driver implements the second approach
>>>> (see ath_tx_complete() in ath9k/xmit.c) as well as the rt2x00 and b43
>>>> drivers.  The iwl driver, on the other hand, avoids this problem by
>>>> invoking  ieee80211_tx_status_irqsafe() which effectively defers
>>>> processing of transmission feedback status.  This last approach is the
>>>> least intrusive is implemented here.
>>>>
>>>> Reported by Pedro Larbig (ASPj)
>>>> ---
>>>>  drivers/net/wireless/ath/ath5k/base.c |    2 +-
>>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> Missing Signed-off-by...
>>>
>> Yikes. Also, it looks like ieee80211_tx_status() should not be called
>> from irq context. Will resubmit a v2 with signoff and comment shortly.
>
> I don't get the last statement -- ieee80211_tx_status() -> irqsafe was

I meant to say "In addition to the above discussion,
ieee80211_tx_status() should not be called from interrupt context
anyway".

> the very change the patch added.  It's running in a bottom half
> though, not a hard irq.
>

Even in a bottom half we're still in "interrupt" context, right?
