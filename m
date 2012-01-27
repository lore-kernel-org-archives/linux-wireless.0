Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:43164 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688Ab2A0PKA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jan 2012 10:10:00 -0500
Message-ID: <4F22BE44.4000705@neratec.com> (sfid-20120127_161008_398367_6700E9AC)
Date: Fri, 27 Jan 2012 16:09:56 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	rodrigue@qca.qualcomm.com, adrian.chadd@gmail.com,
	kgiori@qca.qualcomm.com, shafi.wireless@gmail.com
Subject: Re: [RFC 1/2] ath9k: add DFS pattern detector
References: <1327592044-3319-1-git-send-email-zefir.kurtisi@neratec.com> <1327592044-3319-2-git-send-email-zefir.kurtisi@neratec.com> <4F2176DE.9010604@openwrt.org>
In-Reply-To: <4F2176DE.9010604@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2012 04:53 PM, Felix Fietkau wrote:
> On 2012-01-26 4:34 PM, Zefir Kurtisi wrote:
> [...]
>> +/**
>> + * struct pattern_detector - overloading base dfs_pattern_detector
>> + *
>> + * @exit(): destructor
>> + * @add_pulse(): add radar pulse to detector
>> + * @num_radar_types: number of different radar types
>> + * @last_pulse_ts: time stamp of last valid pulse
>> + * @radar_detector_specs: array of radar detection specs
>> + * @channel_detectors: list connecting channel_detector elements
>> + */
>> +struct pattern_detector {
>> +	void (*exit)(struct pattern_detector *_this);
>> +	enum dfs_detector_result (*add_pulse)
>> +		(struct pattern_detector *_this, struct pulse_event *pe);
>> +
>> +	u8 num_radar_types;
>> +	u64 last_pulse_ts;
>> +	struct radar_detector_specs *radar_spec;
>> +	struct list_head channel_detectors;
>> +};
> To overload it this way is quite fragile. It's better to embed struct
> dfs_pattern_detector here. In places where you need to go from the
> struct dfs_pattern_detector to this struct, you can then use the
> container_of macro, to get at least some form of type safety.
> 
> - Felix

Hi Felix,

thanks for taking a look.

Actually, for this initial post we do not need any polymorphism at all, I could basically make this derived class the interface in the PATCH to come.

Though (since I am used to this coding style) I'd like to understand your concern. By 'fragile' you are referring to the risk of base and derived class diverging, right? If it is that, I see that one is in trouble if you let that happen. Here with the base class being defined as external interface holding just two function pointers I thought the risk is negligible.

But generally you're right of course. I'll take it into account for the PATCH.


Thanks
Zefir
