Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:42383 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbaJWI17 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 04:27:59 -0400
Received: by mail-wi0-f175.google.com with SMTP id d1so3435164wiv.14
        for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2014 01:27:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1413807282-27951-5-git-send-email-michal.kazior@tieto.com>
References: <1413807282-27951-1-git-send-email-michal.kazior@tieto.com>
	<1413807282-27951-5-git-send-email-michal.kazior@tieto.com>
Date: Thu, 23 Oct 2014 10:27:57 +0200
Message-ID: <CA+BoTQ=P2XOaOsaVOj+=fEs=nGfhUCNQvDYx6qb=A=JRCnbQmg@mail.gmail.com> (sfid-20141023_102804_912231_8A476A69)
Subject: Re: [PATCH v2 4/6] ath10k: make warm reset a bit safer and faster
From: Michal Kazior <michal.kazior@tieto.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 October 2014 14:14, Michal Kazior <michal.kazior@tieto.com> wrote:
> One of the problems with warm reset I've found is
> that it must be guaranteed that copy engine
> registers are not being accessed while being
> reset. Otherwise in worst case scenario the host
> may lock up.
>
> Instead of using sleeps and hoping the device is
> operational in some arbitrary timeframes use
> firmware indication register.
>
> As a side effect this makes driver
> boot/stop/recovery faster.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>
> Notes:
>     v2:
>      * fix kernel panic on early fw crash due to CE not being fully initialized [Janusz]

Marek reported he sees a memory leak and git bisect blames this patch.
Please don't apply this patch yet.


Michał
