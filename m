Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028D51B87C0
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 09:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788687110; cv=none; b=f7ZouAYsfb6EChY0S9t7szAdr+BL7AsmBaQjY55K4XQNf1UEV8FtWrzIvjR3I0Jt60okmrKvoUdFTpCZCRDbsql34ChXImNGY+Oyaw4XlLEKgEchKw3mhloBUl45wn2SRQWUSTEyyez3eRFUuQVnm14EOe0qLtld7DqBVio75jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788687110; c=relaxed/simple;
	bh=cT4XTZr2Zl4x9V5f6a8LNpWLZ0yDGRLsSaT2C79YTYI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZM+RYG463E6sVBk31/qR+bZ/rMDw3ZgGYd83kcU7Ga9aAnhEOiUPj/516D9JlT8mSTyj6dQbxrDAeL5hRnRiWJvMW7y0Hg4oIVJu87c62ezAb/JDLaRjqKPLJzsWm72+LLcqYeepj4sgUVGIuAP1cXBI/Tlsdrwm9DWEoYhoBDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SERjp8Q8; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SERjp8Q8"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4995b0343c1so34354705e9.3
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 02:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788687106; x=1789291906; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PmkO3zaW5vPGMp4KXQ0+SoyDXDy+0wxf1IpxDkK3d3Y=;
        b=SERjp8Q8isQwWDmiuFbsVKFph5TVmgb8fm7Cg7+HVESLkmPxKNk7HTT0twRPg45Tgq
         NDdc1+vifUgYD1BMR6r0qszyU9X50NFz0OWQSuWdMqvYZgFVSxUpNle8znKYxo8FFUtC
         Z2BlMRKpvNeyWRLr3bExMXklmJhyaiUuBjj9H03LivrbUseD2paukepMrsq3xI1q/UCy
         woRLpFCH5FLXTBvHkzTfwNgCm/oBXIONH/4qvhcDGE2AZYP6LCHb1uWIEt+LyymYEHD5
         i+hqWgGpW7Vou2RPCA7S4QQmItMn5B0/kWQzhFfXxUfDWQtTaRIHhTijSOYlbaLYnyBU
         EmZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788687106; x=1789291906;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PmkO3zaW5vPGMp4KXQ0+SoyDXDy+0wxf1IpxDkK3d3Y=;
        b=LEyn8wwuF+0pqX+PBGeZbigAPyYZvbzTFhOYMg2F4m+YplC8cMaO72thKmPWZVl/Az
         /A+vphgd6y+9I4Sp2fWuj1QNaSkzEiN3qXqbGvkctuUHfxb+6yHZLj3+7ocpDWFmdN7i
         hyJ0HrqfZJu5yo8wwauMr9xvU/XbEg/8f4CEK+M9JUex5jegUp3hwEAIpxWnzV+bC0N6
         3tlkXf9quXbiryggPwrLljmU/HgLZaAa0/ExIkgZLd5FSKn2XVGtHN7Go7ochdrPkMk1
         H2INvnEoBlCJtShYONBlP/lIpvvTwJKSPSmQYLWPmVQq/bqDGuxPSje3WURs0V5iTKug
         19aQ==
X-Gm-Message-State: AFuF++l56qLw45JbelBwnlzEhHcZwCTsQgAVVsX5/iNuSCvCeBNZmnHs
	VGxLELjFO+toc2xBhXnJOzWG3RAeuORu+qFPd7ZJ2MVn04C6exGO38T0
X-Gm-Gg: AYBFou21j8N0Cb+rL8WZDzKVKLlA/1TtZguKHTyOKrunHpuJM3FtPaHo5bRmp2f0eUg
	Q912OwquwNhiYtYZDL0N/amjbe9Pvz0Ewb8Zcc124dhL16HWSV9afhOvyJ4e8jwqgks1D9jWH+1
	8EiiKE3JNF19ZRnH0m30ylWw9aCZpLFkXkzp0tXIl4FFht+/WaBuzzMwtTCAGAJAZVQLckyjI+z
	ibHvlIQD97q2lHufXHG69tkQZ9/VfhQbrqubyq+ci0c3n8XQ5cUBIjh6RdL35DScn1WDlDVNDbY
	+sf38Gcr6rvCXU/GbdtjZD3UiRfp4ieYpdazITgGQTlcPTFtpQ88VMhAJD2Ai3Yhk5b6MCeZ+AG
	IPIvwVtDXOrwgBw5Yv5QOyxf9ej1FvAs+RXtZGGycGE0v//LfHXURNpTurmnJOEFDVdehRafwUg
	ru3GsFvxrbXbSvyaJALoFJjby2i9SBBY1FuWYxtWVbQZP9XXzOMapCw8tOEkaVpt5EXwF1rBbnx
	6AXBceGP0uEyP68h35MuTBRd0y+Y+Iqj8vQyVAfTJhLzdnBx+DXcD1srnnONy1043g=
X-Received: by 2002:a05:600c:358a:b0:49c:dada:30b7 with SMTP id 5b1f17b1804b1-49cf82070famr162424505e9.2.1788687106045;
        Sun, 06 Sep 2026 02:31:46 -0700 (PDT)
Received: from shift.daheim (p200300d5ff3cee0050f496fffe46beef.dip0.t-ipconnect.de. [2003:d5:ff3c:ee00:50f4:96ff:fe46:beef])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ce58da3acsm667668245e9.0.2026.09.06.02.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 02:31:45 -0700 (PDT)
Received: from localhost ([127.0.0.1])
	by shift with esmtp (Exim 4.100)
	(envelope-from <chunkeey@gmail.com>)
	id 1x39E0-000000006OV-1Azc;
	Sun, 06 Sep 2026 11:31:44 +0200
Message-ID: <f3eb0dfe-3b9c-483b-b802-2207fe8b747b@gmail.com>
Date: Sun, 6 Sep 2026 11:31:44 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] wifi: p54: validate curve data length in the
 calibration curve converters
To: Shengzhuo Wei <me@cherr.cc>, "David S. Miller" <davem@davemloft.net>,
 "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260831-p54-pda-validation-v2-0-dae566b388c8@cherr.cc>
 <20260831-p54-pda-validation-v2-1-dae566b388c8@cherr.cc>
Content-Language: de-DE
From: Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20260831-p54-pda-validation-v2-1-dae566b388c8@cherr.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 8/30/26 8:42 PM, Shengzhuo Wei wrote:
> p54_convert_rev0() and p54_convert_rev1() read calibration curve
> data from the device-supplied EEPROM entry using channel and
> points-per-channel counts taken verbatim from that same entry, so
> an entry that declares more data than it carries drives an
> out-of-bounds read past the EEPROM buffer (verified with a KASAN
> reproducer of the conversion loop). The sibling converters
> p54_convert_output_limits() and p54_convert_db() already validate
> their counts against the entry length; this path was missed.
> 
> Reject the entry when the counts do not fit in the entry data.
> 
> Fixes: eff1a59c48e3 ("[P54]: add mac80211-based driver for prism54 softmac hardware")
> Cc: stable@vger.kernel.org
> Assisted-by: GLM:5.3
> Signed-off-by: Shengzhuo Wei <me@cherr.cc>
> ---
>   drivers/net/wireless/intersil/p54/eeprom.c | 19 +++++++++++++++----
>   1 file changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/intersil/p54/eeprom.c b/drivers/net/wireless/intersil/p54/eeprom.c
> index 95580921d933..0dc848d77c5e 100644
> --- a/drivers/net/wireless/intersil/p54/eeprom.c
> +++ b/drivers/net/wireless/intersil/p54/eeprom.c
> @@ -414,17 +414,22 @@ static int p54_generate_channel_lists(struct ieee80211_hw *dev)
>   }
>   
>   static int p54_convert_rev0(struct ieee80211_hw *dev,
> -			    struct pda_pa_curve_data *curve_data)
> +			    struct pda_pa_curve_data *curve_data, size_t len)
>   {
>   	struct p54_common *priv = dev->priv;
>   	struct p54_pa_curve_data_sample *dst;
>   	struct pda_pa_curve_data_sample_rev0 *src;
> +	size_t needed = curve_data->channels *
> +		(sizeof(*src) * curve_data->points_per_channel + 2);
>   	size_t cd_len = sizeof(*curve_data) +
>   		(curve_data->points_per_channel*sizeof(*dst) + 2) *
>   		 curve_data->channels;
>   	unsigned int i, j;
>   	void *source, *target;
>   
> +	if (len < sizeof(*curve_data) + needed)
> +		return -EINVAL;
> +

Hmm, Puh. Interessting. Several things. But yeah, this should work.

Acked-by: Christian Lamparter <chunkeey@gmail.com>

Still I have some questions: Did you write/touch any of this yourself?
Or is this patch straight from the model?

It's because I can grok (heh) why "needed" ended up as a separate variable next to cd_len.
But why was the sizeof(*curve_data) not included there too? It's only used once in the
if check so and this sounds like the "needed" needed some extra? Maybe because it was
already checked?

Well, I'm positive there will be an update from someone else to make it look "neat".
Probably they will complain that it looks like this functions use curve_data->points_per_channel
and curve_data->channels without being checked... Only to find out that it was checked already
because the code needs to know the revision before actually calling the functions and this all
being part of the information struct.

oh, well.
