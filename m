Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-5.exch022.serverdata.net ([206.225.164.188]:13341
	"EHLO HUB022-nj-5.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754371Ab2IYJtk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 05:49:40 -0400
Message-ID: <50617E2C.6050000@posedge.com> (sfid-20120925_114944_100508_F8B45EC9)
Date: Tue, 25 Sep 2012 15:19:32 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH v2] mac80211: VHT peer STA caps
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCF5269@mbx022-e1-nj-10.exch022.domain.local>  <1348477154.10257.2.camel@jlt4.sipsolutions.net>  <50614089.6020105@posedge.com> <1348557902.10041.17.camel@jlt4.sipsolutions.net>
In-Reply-To: <1348557902.10041.17.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/25/2012 12:55 PM, Johannes Berg wrote:
>>
>>           vht_cap->cap = le16_to_cpu(vht_cap_ie->vht_cap_info) &
>>                   (sband->ht_cap.cap |
>
> err, vht_cap

Sorry, I meant vht_cap only. Typo..

>
>>                    ~(IEEE80211_VHT_CAP_RXLDPC |
>>                      IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE |
>>                      IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE |
>>                      IEEE80211_VHT_CAP_HTC_VHT));
>
> I don't think that can be right. It seems to me it should be something
> like
>
> cap = cap_info & sband->vht_cap.cap &
> 	(MAX_MPDU_LENGTH_... |
> 	 SHORT_GI_... | HTC_VHT | ... ? )
>
> if (cap_info & SU_BEAMFORMEE_CAPABLE &&
>      sband->vht_cap.cap & SU_BEAMFORMER_CAPABLE)
> 	cap |= SU_BEAMFORMEE_CAPABLE;
>
> etc.?
>
> OTOH, this would only matter to drivers that actually support all these
> features, and those drivers could take care of not enabling the features
> if their hardware doesn't support them. However, think of a driver that
> is for different hardware, some that supports beamforming and some that
> doesn't. Then if we mask out the beamforming capability of a station if
> it's not locally supported, that driver could be simpler? Then again, if
> we don't the driver just has to check if the hardware supports it, which
> seems reasonable as well.
>
> Do you understand the issue?
>

why should we mask out remote STA caps bits. Our local hw caps are in 
sband->sta.vht_caps. remote caps sta_info->sta.vht_caps. In what way 
drivers are connected with remote STA vht caps bits.

> So maybe if you document it right, your original v2 patch is sufficient.
> Convince me :)
>
> johannes
>
