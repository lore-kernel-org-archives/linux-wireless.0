Return-Path: <SRS0=j5ME=N6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1353C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 17:41:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C8A72145D
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 17:41:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bx8EobnR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C8A72145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389874AbeKTEFj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Nov 2018 23:05:39 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44679 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389196AbeKTEFi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Nov 2018 23:05:38 -0500
Received: by mail-ot1-f66.google.com with SMTP id z33so28386425otz.11;
        Mon, 19 Nov 2018 09:41:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i3aw8l6515lnEIYuI3zH+3p6IRogzSbTUw4yitJl+Vs=;
        b=Bx8EobnRDPP7bHZJrHupC/t/PojAU6dAINe3YtuY4Ovy9SbRCD5+s3F3hSdZs0h1Gn
         nyFENz0YtwVo9CMtmZROp+Cv6MWS6k/xc4cPtgH4lWe37OriT9I952/UOblDdP2IW2c4
         lJBRKhHmj03i4OksLC4T2KW7bgvKpfiVUQuwEbqOoZftuK/bT2qDmFGiuZQw7Cl2qZCv
         P8iJe5/oAccBzIfg4Hsd7oLWr5yUBNz+6pADDi5uatndzVDJAUQn6YqwYJ7nHHl6UPJt
         x1geHsv5yX6s6RBgulCrlJA1pVOxZEuZvftUYJK76npBaPPNmRK8MvoqfZCthTf+IFkf
         90Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i3aw8l6515lnEIYuI3zH+3p6IRogzSbTUw4yitJl+Vs=;
        b=pqio+S6x1lJGVGlsIb8wC3BTpAOWiMzDvV5wv0GrA1rhMHfNcgY9foTTwwjyUcEgvt
         gg+ydolg7qK2G2oVcQzBRtCb9Z57TVRyetVdUaTdiSaTHI6CQ4o9WseLBWzdiTpudCqF
         hIb713vgl2hE4mWe+7MPOJXQNha2zgwbDTdQn7JDSInd5F3gFjA7HLkD7Oe6ULoD5f2Q
         SGslV3VI34TjPLU+5vfHr5SqVi5p3n1oeW15ww/7wH8McNU1A0Bon95Jk67N92ePe2cj
         xN0KiK2Qkg8MRXU+XgDP4rDOnKm0YJ5pgJ2U1ozddiY+rstmHD/BejrvM9TLA5lne4w7
         qLOg==
X-Gm-Message-State: AGRZ1gJkLvjj3SaelctQ4T85+zNoqtZCsM6D9onZ1eJA7Zy3bYJ414ul
        XJv+yYRw5yE0Sip0Su4732sS8KwM
X-Google-Smtp-Source: AJdET5d4TiSEVamPoh97izEUmAENkuf8mCOSe0ws8g7TypsHVjF9TJzaHhir5LhMKP4zBd5Qkh+2sg==
X-Received: by 2002:a9d:5b51:: with SMTP id e17mr14520651otj.44.1542649269399;
        Mon, 19 Nov 2018 09:41:09 -0800 (PST)
Received: from [192.168.1.104] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id q13sm3005917otb.5.2018.11.19.09.41.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Nov 2018 09:41:08 -0800 (PST)
Subject: Re: [PATCH v3 3/3] b43: Use cordic algorithm from kernel library
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Priit Laes <plaes@plaes.org>, Kees Cook <keescook@chromium.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Colin Ian King <colin.king@canonical.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <cover.c0b1738f3f06bbf87f4ad3200ece93322a5f135f.1542219596.git-series.plaes@plaes.org>
 <d93962cdc5a32fe99e6e5a25172920d28583aa6a.1542219596.git-series.plaes@plaes.org>
 <d630ca3e-4070-5395-54c2-e20e0c552dc3@lwfinger.net>
 <20181118082327.ttrz2nl5owi2hoqv@plaes.org>
 <df798743-10bb-0455-be83-2fb59eca3209@lwfinger.net>
 <87lg5pcppn.fsf@kamboji.qca.qualcomm.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <35b98c89-1a5c-79d8-3d00-1de1044bb9ab@lwfinger.net>
Date:   Mon, 19 Nov 2018 11:41:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <87lg5pcppn.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/19/18 4:43 AM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
> 
>>>>> @@ -1570,10 +1571,10 @@ static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
>>>>>     	angle = 0;
>>>>>     	for (i = 0; i < len; i++) {
>>>>> -		samples[i] = b43_cordic(angle);
>>>>> +		samples[i] = cordic_calc_iq(angle);
>>>>>     		angle += rot;
>>>>> -		samples[i].q = CORDIC_CONVERT(samples[i].q * max);
>>>>> -		samples[i].i = CORDIC_CONVERT(samples[i].i * max);
>>>>> +		samples[i].q = CORDIC_FLOAT(samples[i].q * max);
>>>>> +		samples[i].i = CORDIC_FLOAT(samples[i].i * max);
>>>>>     	}
>>>>>     	i = b43_nphy_load_samples(dev, samples, len);
>>>>
>>>> There is a fundamental flaw in this patch. Routine b43_cordic() takes an
>>>> angle in degrees scaled by 2^16, whereas cordic_calc_iq() takes an angle in
>>>> degrees. For a given input, the two routines must get different answers. At
>>>> a minimum, the calculation of rot would need to remove the left shift of 16.
>>>
>>> Thanks for the hint. I modified my "test harness" a bit to plot out values
>>> from -360 .. 360 and transformed the theta for b43_cordic argument
>>> using CORDIC_FIXED macro:
>>>
>>> b43_cordic(CORDIC_FIXED(theta));
>>> cordic_calc_iq(theta);
>>>
>>> Then I plotted the results and well.. they are not that pretty.
>>> While the results give
>>> identical answers between certain ranges of degrees, the cordic
>>> algorithm for b43 seems
>>> to be broken for certain ranges: (-270..-180 ; -90 .. 0; 90.. 180 and 270..360).
>>>
>>> You can find my test harnesses here:
>>>
>>> https://gist.github.com/plaes/284993a4fc65e0926d0628a11f0cf874
>>
>> I found a problem with the b43 implementation. The local variables for
>> that routine includes
>>
>>          u32 angle = 0;
>>
>> If one looks further down in the algorithm, if the reduced value of
>> "theta" is less than 0, then "angle" should be negative. That causes
>> the calculation to blow up. This explains why some ranges of angles
>> got the same result for both routines. When that declaration is
>> changed to "int angle = 0", the two routines give the same answer for
>> all inputs.
>>
>> My test setup has a hardware failure, thus I cannot test your patch,
>> but I now believe it to be correct. Thus your first and third patches
>> may be annotated with
>> ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>
>>
>> One thing that should be done is to fix the error in the b43 code for
>> stable as it was introduced in 2.6.34. I propose adding the attached
>> patched to your series placed between your current 2nd and 3rd patches
>> so that the old kernels get fixed. Of course, your 3rd patch will need
>> to be revised. If all 4 of the patches get submitted together there
>> will be no problems with the timing. My change will exist for seconds
>> in the mainline kernel, but it will get propagated back through
>> stable.
> 
> Sorry Larry, I'm not fully understanding what you mean here. So I'm
> going to just drop the whole series and assume that Priit will submit a
> new version. Please let me know if I should do something else.

Dropping the entire series is the right thing to do. The complication is that 
with Priit's changes, my fix is irrelevant for HEAD, but it is still needed for 
stable. My patch must be submitted before his 3rd one, but then his will not 
apply cleanly.If he respins his patches and puts mine in the series before he 
changes b43, then my patch will be available for stable even though his next 
patch will replace my new code. That seems to be the best approach.

Larry
