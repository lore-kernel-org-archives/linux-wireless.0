Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39619 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab2IYHY0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 03:24:26 -0400
Message-ID: <1348557902.10041.17.camel@jlt4.sipsolutions.net> (sfid-20120925_092429_866697_BFA99606)
Subject: Re: [PATCH v2] mac80211: VHT peer STA caps
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Date: Tue, 25 Sep 2012 09:25:02 +0200
In-Reply-To: <50614089.6020105@posedge.com>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCF5269@mbx022-e1-nj-10.exch022.domain.local>
	 <1348477154.10257.2.camel@jlt4.sipsolutions.net>
	 <50614089.6020105@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-25 at 10:56 +0530, Mahesh Palivela wrote:

> > Well I think it'd be better to actually restrict/copy/update the feature
> > bits correctly, this would simplify drivers.
> 
> I am not sure on what bits to be masked. wanted to keep it as future item.
> Anyways I attempted few bits below. Let me know if they are ok...
> 
>          vht_cap->cap = le16_to_cpu(vht_cap_ie->vht_cap_info) &
>                  (sband->ht_cap.cap |

err, vht_cap

>                   ~(IEEE80211_VHT_CAP_RXLDPC |
>                     IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE |
>                     IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE |
>                     IEEE80211_VHT_CAP_HTC_VHT));

I don't think that can be right. It seems to me it should be something
like

cap = cap_info & sband->vht_cap.cap &
	(MAX_MPDU_LENGTH_... |
	 SHORT_GI_... | HTC_VHT | ... ? )

if (cap_info & SU_BEAMFORMEE_CAPABLE &&
    sband->vht_cap.cap & SU_BEAMFORMER_CAPABLE)
	cap |= SU_BEAMFORMEE_CAPABLE;

etc.?

OTOH, this would only matter to drivers that actually support all these
features, and those drivers could take care of not enabling the features
if their hardware doesn't support them. However, think of a driver that
is for different hardware, some that supports beamforming and some that
doesn't. Then if we mask out the beamforming capability of a station if
it's not locally supported, that driver could be simpler? Then again, if
we don't the driver just has to check if the hardware supports it, which
seems reasonable as well.

Do you understand the issue?

So maybe if you document it right, your original v2 patch is sufficient.
Convince me :)

johannes

