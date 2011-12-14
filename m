Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2037 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757717Ab1LNUNn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 15:13:43 -0500
Message-ID: <4EE9036A.7000309@broadcom.com> (sfid-20111214_211357_015227_3C7C7087)
Date: Wed, 14 Dec 2011 21:13:30 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Larry Finger" <Larry.Finger@lwfinger.net>
cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Some funny code in brcmsmac
References: <4EE823C0.7080205@lwfinger.net>
In-Reply-To: <4EE823C0.7080205@lwfinger.net>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/14/2011 05:19 AM, Larry Finger wrote:
> Franky,
> 
> I was looking through the code and noticed the following in routine 
> wlc_phy_txpwrctrl_pwr_setup_nphy():
> 
>          if (pi->sh->sromrev < 4) {
> 		...
>                  target_pwr_qtrdbm[0] = 13 * 4;
>                  target_pwr_qtrdbm[1] = 13 * 4;
> 		...
>          } else {
>                  chan_freq_range = wlc_phy_get_chan_freq_range_nphy(pi, 0);
>                  switch (chan_freq_range) {
>                  case WL_CHAN_FREQ_RANGE_2G:
> 			...
>                          target_pwr_qtrdbm[0] =
>                                  pi->nphy_pwrctrl_info[0].max_pwr_2g;
>                          target_pwr_qtrdbm[1] =
>                                  pi->nphy_pwrctrl_info[1].max_pwr_2g;
> 			...
> 
>                          break;
>                  case WL_CHAN_FREQ_RANGE_5GL:
> 			...
>                          target_pwr_qtrdbm[0] =
>                                  pi->nphy_pwrctrl_info[0].max_pwr_5gl;
>                          target_pwr_qtrdbm[1] =
>                                  pi->nphy_pwrctrl_info[1].max_pwr_5gl;
> 			...
>                          break;
>                  case WL_CHAN_FREQ_RANGE_5GM:
> 			...
>                          target_pwr_qtrdbm[0] =
>                                  pi->nphy_pwrctrl_info[0].max_pwr_5gm;
>                          target_pwr_qtrdbm[1] =
>                                  pi->nphy_pwrctrl_info[1].max_pwr_5gm;
> 			...
>                          break;
>                  case WL_CHAN_FREQ_RANGE_5GH:
> 			...
>                          target_pwr_qtrdbm[0] =
>                                  pi->nphy_pwrctrl_info[0].max_pwr_5gh;
>                          target_pwr_qtrdbm[1] =
>                                  pi->nphy_pwrctrl_info[1].max_pwr_5gh;
> 			...
>                          break;
>                  default:
> 			...
>                          target_pwr_qtrdbm[0] = 13 * 4;
>                          target_pwr_qtrdbm[1] = 13 * 4;
> 			...
>                          break;
>                  }
>          }
> 
>          target_pwr_qtrdbm[0] = (s8) pi->tx_power_max;
>          target_pwr_qtrdbm[1] = (s8) pi->tx_power_max;
> 
> After going to some effort to customize the target_pwr_qtrdbm array depending on 
> the SPROM version and the particular channel being used, the array is 
> unconditionally overwritten in the end. Although gcc probably optimizes out the 
> statements that are not needed (I have not looked at the generated code.), 
> perhaps the code should be modified to make it clearer for human readers.

Yep. That looks pretty useless to me ;-) I will send a code-redux patch
for this. Feel free to share these kind of observations in a patch email
(so I can remain my lazy self and ack it ;-) ).

> Thanks,
> 
> Larry

Thanks
AvS

