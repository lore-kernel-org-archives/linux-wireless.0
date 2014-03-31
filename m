Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:50016 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbaCaNMl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2014 09:12:41 -0400
Received: by mail-we0-f181.google.com with SMTP id q58so4670405wes.40
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2014 06:12:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1396267459-9976-3-git-send-email-michal.kazior@tieto.com>
References: <1395409941-26303-1-git-send-email-michal.kazior@tieto.com>
	<1396267459-9976-1-git-send-email-michal.kazior@tieto.com>
	<1396267459-9976-3-git-send-email-michal.kazior@tieto.com>
Date: Mon, 31 Mar 2014 15:12:39 +0200
Message-ID: <CA+BoTQmiF1=zVJW+2fGQhj3La32tODBqtKYaOxs_eVbm2x5pZw@mail.gmail.com> (sfid-20140331_151244_821748_9A6034F9)
Subject: Re: [PATCH v3 2/5] mac80211: use chanctx reservation for AP CSA
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 March 2014 14:04, Michal Kazior <michal.kazior@tieto.com> wrote:
> Channel switch finalization is now 2-step. First
> step is when driver calls csa_finish(), the other
> is when reservation is actually finalized (which
> be defered for in-place reservation).
>
> Also remove the ieee80211_vif_change_channel()
> which isn't used anymore.
>
> It is now safe to call ieee80211_csa_finish() more
> then once.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
> v3:
>  * fix lockdep typo s/mtx/chanctx_mtx/ [Johannes]
>  * fix comment style [Johannes]
>  * use goto for cleaner unlocking/returning [Johannes]
>  * squash with ieee80211_vif_change_channel() removal patch [Johannes]

Eww, I hastily squashed it too early. It should have been squashed it
onto the following STA CSA patch instead of this one. I'll wait a bit
for more comments before I respin.


Micha³
