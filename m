Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:61128 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaF0SRL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2014 14:17:11 -0400
Received: by mail-ob0-f178.google.com with SMTP id wn1so6119830obc.9
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jun 2014 11:17:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1403860015-31601-1-git-send-email-michal.kazior@tieto.com>
References: <1403860015-31601-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 27 Jun 2014 11:17:11 -0700
Message-ID: <CABnBrYWuro1i3SvjpEMF+5rcja=7e_7RP2y-m4hVi_Ld4LYHuQ@mail.gmail.com> (sfid-20140627_201715_127838_E80AC34D)
Subject: Re: [RFC/RFT 0/2] mac80211/ath10k: fix Rx reordering
From: Denton Gentry <denton.gentry@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With these two changes the iperf throughput of the Windows STA
increased to 283 Mbps, up from ~45 Mbps prior to these changes.

Everything else is as constant as I can hold it, no other code changes
and in the same physical location. It is an open air office
environment, the noise environment can vary day to day.

On Fri, Jun 27, 2014 at 2:06 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
> Hi,
>
> I'm posting these 2 patches together in a single
> patchset for easier review/testing for now. Once
> review goes well I can split up the patchset and
> send patches separately if it is desired so.
>
> Recently Denton pointed out ath10k fails to
> perform Rx reordering and this causes performance
> issues in some cases.
>
> Due to ath10k design I had to come up with a patch
> for mac80211 to allow Rx reordering offloading via
> existing Rx BA sessions code.
>
> I've tested this pretty lightly so far. With the
> patchset `iperf -u` reports 0* out-of-order
> frames. Without the patch I'm seeing 400+ per
> second (the particular number isn't relevant as it
> depends on throughput and environment). It seems
> to improve single-threaded TCP performance as
> well. All test traffic is station -> ath10k AP.
>
> * There are a few out-of-rder frames in the first
> second after Rx tid is set up. I suspect this is
> because ath10k is forced to start Rx BA sesion
> with an arbitrary start_seq_num.
>
> Note: This is based on https://github.com/kvalo/ath
> 30a165cb84793fa3896ad93497e11eed651b1813.
>
>
> Michal Kazior (2):
>   mac80211: add support for Rx reordering offloading
>   ath10k: fix Rx aggregation reordering
>
>  drivers/net/wireless/ath/ath10k/htt_rx.c |  92 +++++++++++++++++++++++++-
>  drivers/net/wireless/ath/ath10k/mac.c    |  30 +++++++++
>  drivers/net/wireless/ath/ath10k/txrx.c   |   3 +-
>  drivers/net/wireless/ath/ath10k/txrx.h   |   1 +
>  include/net/mac80211.h                   |  40 ++++++++++++
>  net/mac80211/agg-rx.c                    | 108 ++++++++++++++++++++++++-------
>  net/mac80211/ieee80211_i.h               |  16 +++++
>  net/mac80211/iface.c                     |  25 +++++++
>  8 files changed, 287 insertions(+), 28 deletions(-)
>
> --
> 1.8.5.3
>
