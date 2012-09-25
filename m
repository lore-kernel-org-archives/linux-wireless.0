Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-6.exch022.serverdata.net ([206.225.164.189]:23526
	"EHLO HUB022-nj-6.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752208Ab2IYF0i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 01:26:38 -0400
Message-ID: <50614089.6020105@posedge.com> (sfid-20120925_072641_811483_7AD9AD41)
Date: Tue, 25 Sep 2012 10:56:33 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH v2] mac80211: VHT peer STA caps
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCF5269@mbx022-e1-nj-10.exch022.domain.local> <1348477154.10257.2.camel@jlt4.sipsolutions.net>
In-Reply-To: <1348477154.10257.2.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/24/2012 02:29 PM, Johannes Berg wrote:
> On Mon, 2012-09-24 at 03:57 +0000, Mahesh Palivela wrote:
>> From: Mahesh Palivela <maheshp@posedge.com>
>>
>> To save peer STA VHT capabilities in mac80211.
>>
>> Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
>> ---
>> Taken care of Johannes comments in patch v1

>> +	vht_cap->cap = le16_to_cpu(vht_cap_ie->vht_cap_info);
>> +
>
> Well I think it'd be better to actually restrict/copy/update the feature
> bits correctly, this would simplify drivers.

I am not sure on what bits to be masked. wanted to keep it as future item.
Anyways I attempted few bits below. Let me know if they are ok...

         vht_cap->cap = le16_to_cpu(vht_cap_ie->vht_cap_info) &
                 (sband->ht_cap.cap |
                  ~(IEEE80211_VHT_CAP_RXLDPC |
                    IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE |
                    IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE |
                    IEEE80211_VHT_CAP_HTC_VHT));

>
> johannes
>
