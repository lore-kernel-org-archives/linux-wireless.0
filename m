Received: from mail-pl1-f228.google.com (mail-pl1-f228.google.com [209.85.214.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33973BCD24
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 22:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785103872; cv=none; b=R8JODtpJvV1qlTq8zEkRECFo3tXH4Qj9V9jHjVpRUp5hrXqWsa4sTb7oZu6mKx36MGZB6Jg5h7T8Re+RyVOKmaDKwKVc7EzStVI8wx62sCBAzCmTi7qc2eU6iTdzw0wJyY129iYn2A9so6DB5P0mAgFF3zqMiB6Akiqg55dpeKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785103872; c=relaxed/simple;
	bh=2CIxhBpPAZNB8okkFClso/bOGlpCuZh9vzdfx8hWPZw=;
	h=From:To:CC:Date:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=tDVRP5/y97/gATe7mtSPKpdY1KwzO5Q9Kh7ZNe8pYEP7efrSr6oN574laHS/1DoD3cQExMIgRFq9oUkAkWE3d9mjPLOzZWjvuSesbS8tZmyVJFajWGEnRC+lrFCty5lir6embkZfIrqflKqEjzTmYumAq+WwYN56LeNlUvoMysw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=eOiWV5t6; arc=none smtp.client-ip=209.85.214.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="eOiWV5t6"
Received: by mail-pl1-f228.google.com with SMTP id d9443c01a7336-2ce87c7e3bbso23549365ad.1
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 15:11:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785103870; x=1785708670;
        h=content-transfer-encoding:content-type:mime-version:subject
         :user-agent:references:in-reply-to:message-id:date:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Dz7NlMBaqq6fhbUxmafTBTywhLBIEqhclVZzBK73Jd0=;
        b=ORKoa7ab9xAkMYyvMn6MPlowPZkxFkGXBzSBcyLy/N9e48Yhzq3SWwAI7q3ZUv/BFX
         LawGKi4r9Fny7rmJBivl1dhkAZyKzCuAMJRxtoPScicVqY2HYFhVSjda3KpPcMCo5bTD
         gKUcyzfdbixnA+tkQVpbj0w1uP0abHum9k2VT9rd44ic00KXYoRsRNQpnP93t0OTChW0
         UAWLE0NZokQN2z7yDw2NZjvWlZWy2GcU1ZJyc4onzvHbfT6DSeSRcGY5VdfxpiuGzzwR
         YMh2YnO/WYmWG4MOpuGdQs96TUvVpz2b0HwB/xsf1+aSCkHd3HS9hEizUiBx2vn0YvXk
         6rAg==
X-Gm-Message-State: AOJu0YxMYP+xKj2oabyUC4VDbKpVv6Q2DzVR5HrZzkZS7xVpj52ftKuQ
	8zI3edFM441fiBJWIYlMOU/5jwRZ4qYsadnHtADL2zCXCZKVJ4nXcG26QC7TyGsiY5/hIETtjBU
	XP5a22R24vIBV823Ax9Yu7j8Y0xvIkBnUps8Vw3PxwyRuk4x5OHEtLNsezU96C0Lm2qXIh/Y+Nd
	80Mkt7mjGC6JTP6PbTEDXCM7mcUnB8bpweExvQdhhKaJGKrHFvpcmYnWoNesleegOMiEbIs5Tri
	nvH1zImTM+uh6GQvi6tLhOFEnNh
X-Gm-Gg: AR+sD12kLXJgi6MCPYfBJrswA0W6aBFxprDPg4px7YMQVqYcow0K3ykp/V4+7NWRQAN
	sWCpxh8xj/1DBaz7MfyDf64WVNb+rxHpJ9EWAcMJuOecUI0mLVI+oHhDaXSawWJOr730TJ2F6lC
	4fRDLdmlyjfdDkCMKHj9DzTctxXZa8IWdu5C8gRwgXd1ZFTokesnRWHX5VjmcqVtxnp095S0KH7
	0yXBNultHVaLypvng1Ed7zjtbYYVMyrn5KV+h9+l7p2gNtasB5clfg78XTu5aRMyrYQHtpZDdnh
	6VwWQNilgv4DFhUEwec+fOWMk2NxIq3XZjUKfUEoLI7Dmfc8jI7+q15MOMeXU9SeOEbU+YFZaC8
	fr4gOMzTqAfpFyRQ02FuTZOD+K+9DXyPMlM76DzYs7A6DJ+ggxhfuhk/eAZNd/aAeRiomUa9ioy
	czIJkUpYO/pG55DTCv+RoSknXsX91Thbnk7FwsZ/o=
X-Received: by 2002:a17:903:4687:b0:2b7:975c:dacc with SMTP id d9443c01a7336-2cfde79058fmr57673405ad.1.1785103870070;
        Sun, 26 Jul 2026 15:11:10 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2cfde5b54desm5623505ad.16.2026.07.26.15.11.08
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jul 2026 15:11:10 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-69abf97d53aso2344240a12.3
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 15:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785103867; x=1785708667; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:subject
         :user-agent:references:in-reply-to:message-id:date:cc:to:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Dz7NlMBaqq6fhbUxmafTBTywhLBIEqhclVZzBK73Jd0=;
        b=eOiWV5t6+9Qnlluk/+q7IvCllJXXbtOKGNHErN4Did8Hi8W4RuUpEfJX8ooigC2tjc
         dY6VO2l/KoguKKbNIPhNyN/v/f6bHmM8N2nQR0jCUMSFKvDDtv6vPN8gnyrqhtOnqJcw
         kZfWH8/b8/QET3orTFfHjqFIILQgTyrvmOIs0=
X-Received: by 2002:a05:6402:2383:b0:698:3eda:1197 with SMTP id 4fb4d7f45d1cf-69fc1160c0fmr1962282a12.20.1785103866777;
        Sun, 26 Jul 2026 15:11:06 -0700 (PDT)
X-Received: by 2002:a05:6402:2383:b0:698:3eda:1197 with SMTP id 4fb4d7f45d1cf-69fc1160c0fmr1962276a12.20.1785103866316;
        Sun, 26 Jul 2026 15:11:06 -0700 (PDT)
Received: from [192.168.178.59] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69fb50bd467sm1891417a12.1.2026.07.26.15.11.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2026 15:11:05 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <brcm80211@lists.linux.dev>
Date: Mon, 27 Jul 2026 00:11:04 +0200
Message-ID: <19fa07b50c0.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <ded836f0-d683-4469-bae8-d95bb3e3cb63@oss.qualcomm.com>
References: <20260726192541.2816743-1-arend.vanspriel@broadcom.com>
 <20260726192541.2816743-2-arend.vanspriel@broadcom.com>
 <9b00d432905facbe0f86556eda6c2986df79888d.camel@sipsolutions.net>
 <ded836f0-d683-4469-bae8-d95bb3e3cb63@oss.qualcomm.com>
User-Agent: AquaMail/1.59.0 (build: 105900627)
Subject: Re: [PATCH -next 01/10] wifi: cfg80211: pre-assign cookie for remain_on_channel, mgmt_tx, probe_peer and tx_control_port
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Op 26 juli 2026 22:29:09 schreef Jeff Johnson <jeff.johnson@oss.qualcomm.com>:

> On 7/26/2026 12:37 PM, Johannes Berg wrote:
>> On Sun, 2026-07-26 at 21:25 +0200, Arend van Spriel wrote:
>>> Having a single place for cookie assignment and keeping that
>>> responsibility in the cfg80211 subsystem is a logical choice as it
>>> handles the userspace nl80211 API. add_nan_func already does this:
>>> cfg80211 calls cfg80211_assign_cookie() before invoking the driver.
>>> Apply the same pattern to remain_on_channel, mgmt_tx, probe_peer and
>>> tx_control_port by pre-assigning the cookie in the nl80211 command
>>> handlers before the rdev_* call. For tx_control_port the cookie is
>>> only pre-assigned when the caller requests an ack (cookie pointer
>>> non-NULL).
>>>
>>> Drivers may still overwrite the value for now; subsequent patches will
>>> remove per-driver cookie generation. Update the cfg80211_ops kerneldoc
>>> to note that the cookie is pre-assigned and drivers must not modify it.
>>>
>>> Assisted-by: Claude:claude-sonnet-4-6
>>
>> Hah, I _knew_ it, just based on the text style, before even reading
>> beyond the cover letter ... I'm starting to even be able to tell the
>> companies apart (not models yet, i.e. you could've told me this was
>> Opus). E.g. "Patch 1 is the enabling change: [...]", "Non-obvious
>> aspects" or "This means the cookie field is threaded through" etc.
>>
>> Fun. What weird times we live in.
>
> Indeed. And yes, I tend to edit the LLM commit text since the tense is often
> wrong and the vocabulary often isn't want I'd use.

@Johannes: Glad you can see the fun of it ;-)

Agree that LLM text show some typical choice of words and phrasing. I only 
edit (or prompt to correct) the text when I do not understand what is 
written, too much words are used, or missing details I care about.

>
>
>>
>> But you forgot S-o-b.
>
> also wrong branch tag: s/-next/wireless-next/

Patchwork seems to have no problem determining the branch/repo.

Will repost with the S-o-B in place.

Gr. AvS
>



