Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.186]:47604 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbYKKEcn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 23:32:43 -0500
Received: by fk-out-0910.google.com with SMTP id 18so3673567fkq.5
        for <linux-wireless@vger.kernel.org>; Mon, 10 Nov 2008 20:32:41 -0800 (PST)
Message-ID: <8e92b4100811102032j7698254ct7020879e4cd5af1d@mail.gmail.com> (sfid-20081111_053249_569004_980D64BD)
Date: Tue, 11 Nov 2008 10:02:41 +0530
From: "Vivek Natarajan" <vivek.natraj@gmail.com>
To: "Kalle Valo" <kalle.valo@nokia.com>
Subject: Re: [RFC] mac80211 dynamic powersave
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1226245439-30329-1-git-send-email-kalle.valo@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1226245439-30329-1-git-send-email-kalle.valo@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 9, 2008 at 9:13 PM, Kalle Valo <kalle.valo@nokia.com> wrote:
>
> Here's my first version of dynamic powersave patches. I have tested them
> only with stlc45xx on Nokia N810. Unfortunately stlc45xx's psm command is
> buggy and I haven't been able to run any longer tests, yet. Next week I will
> also test with iwl3945.
>
> These are RFC patches, not to be applied.
>
> TODO:
> o Johannes' subif_start_xmit suggestion
> o test with intel hardware (only in-tree driver using IEEE80211_CONF_PS)
> o disable power save when software scanning
> o association check to the work structs?
> o cancel_work_sync()
>
Hello Kalle,
  I have a few questions on the PS implementation. Here they are,

1) I see from your patch that power save is enabled whenever there
   is no Tx for the specified 'timeout' period. Should we also take into
   account the type of power connection( i.e battery or direct ac supply)
   before enabling PS?

2) Do you intend to leave the NULL frame formation, waking up the chip
     for TIM and modifying sleep/awake time according to  DTIM to
    the driver since I did not see this in your TODO list?( I understand from
    the iwlwifi code that it just sends a request to the firmware for sending
    NULL frame and the firmware takes care of the rest. But it may not be
    so in the case of other vendor drivers.)

3) Is the PS-POLL concept(or M frames in N milliseconds concept of Johannes)
     dropped after the DNS response timings related discussion that you had
     since it might save some more power in low-traffic conditions?

Thanks,
Vivek.
