Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13424 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbbIUHYi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 03:24:38 -0400
Date: Mon, 21 Sep 2015 12:53:51 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix ldpc param for fixed rate
Message-ID: <20150921072347.GA28484@qca.qualcomm.com> (sfid-20150921_092441_492939_53FDFF36)
References: <1442389740-29053-1-git-send-email-rmanohar@qti.qualcomm.com>
 <CA+BoTQ=FMCyHtn8BMZv_6awOuLhJNFe5RhB2eNpCQfyk+5Jhcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CA+BoTQ=FMCyHtn8BMZv_6awOuLhJNFe5RhB2eNpCQfyk+5Jhcw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 21, 2015 at 09:05:54AM +0200, Michal Kazior wrote:
> On 16 September 2015 at 09:49, Rajkumar Manoharan
> <rmanohar@qti.qualcomm.com> wrote:
> > ldpc is not configured for fixed rates. This blocks auto rate vs fixed
> > rate performance comparison. Since firmware is considering ldpc vdev
> > param for fixed rate selection, it has to be configured to enable ldpc
> > for fixed rates.
> >
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> > ---
> [...]
> > @@ -6041,6 +6049,7 @@ static int ath10k_mac_op_set_bitrate_mask(struct ieee80211_hw *hw,
> >         band = def.chan->band;
> >         ht_mcs_mask = mask->control[band].ht_mcs;
> >         vht_mcs_mask = mask->control[band].vht_mcs;
> > +       ldpc = !!(ar->ht_cap_info & WMI_HT_CAP_LDPC);
> 
> Is still really correct? LDPC must be supported on the Rx side of
> destination stations hence I would assume you need to check whether
> all stations associated are LDPC capable before enabling it (e.g. via
> ieee80211_iterate_stations_atomic).
>
I already check with firmware on this regard. Below is the clarification
got from fw team. So no need to go through sta_iter.

"3) how does fixed rate work for non-LDPC clients (ex. legacy clients),
if LDPC support is enabled for the given vdev?
The rates are selected by ANDng the vdev_rates and client rates. If client does not
support LDPC and LDPC is enabled in vdev then, LDPC will not be used."

-Rajkumar
