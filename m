Received: from mail-yx1-f98.google.com (mail-yx1-f98.google.com [74.125.224.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B603390219
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 08:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785745270; cv=none; b=t8n8nWx8swp0ICRJbQ0OJxX8Y5sOsnV6jO+VVyXnKWrH7+QorrgjVj/oFAtPgdCSdPyDbLm/9BVY9EstJpX2NXoDfkNDnAmN6sHbDLf1ta8oXA/4KKwOpwqG9w2DT/IUPV1vKaXUjw4bQq6OdYSh4+Z4MwQaR6T2Eui4rv4wB+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785745270; c=relaxed/simple;
	bh=Pg0dLujnHeta+8k9PUkwaeX7IBhCH3Vp8JK79I4o2qs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=S5NAjOaGC3iviDALeSmMaruAkiBAb7wyl8Bq3pIpFImlOn+vEZOGgrggFx9ROBSwPkDDm0O4DLuihq0TaZwCdd5jT770Ys7WZslIBiVhRJBNsmBcSsqTEV9VrwqfDar7kpDJF+ascq4gp8rwwVB/0vvAPGFAm7UgUo2obdfRDk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=S/vNP+dB; arc=none smtp.client-ip=74.125.224.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="S/vNP+dB"
Received: by mail-yx1-f98.google.com with SMTP id 956f58d0204a3-66899fe9077so4289550d50.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 01:21:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785745267; x=1786350067;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=umawf+BlMbUojF4hA2eaASvm/LHe9PC11Jo6AdX6bp8=;
        b=s/1CWLDsPJk5Wz1dPBtWwQNVz3W7MNn2bb+fKAopjGsbZquVV8KcJHvhD+AhfUA+gL
         okAPRkvOmt3qVfQEY88eHt6wLL2A0Ur5lAU4m1n/WCWZlYAUHHknk8aToBAAw0tqBtOU
         URScFKQJp9EwhndTcdK9yvfMxqjvM56Q/DG5Vi2NJurQJgyFYuH0WPaPI/xDoASqxP3h
         qrNtrWCfHPL9yPVPwR7kZ7rIf7JCjARE9OFPjjIopag5fNSmJIxceEfGpd3IeUJpzAv3
         HAdTxCVzzZpMkDk1g/TLLpJIKUtQSZ5q5PuYPm3sbLQuYrQ3URbeyl/Atp+HF809CJdo
         rp9A==
X-Gm-Message-State: AOJu0YxnctnOkiEZYaAX8le5UrFqew+Kk3Mo+Xq/xvuTha6ryFSnFkFk
	Go8kpG1juIkkokPemsL2iQ7XsqKTLLrCGAMqgWkK5K69elrQ+CwAeI7H7Y2lNLuSNccZyvvBnbT
	8xI4He3NkT/z0Tkf7zQEj80H8T6PbY2UWsrX98h1vbI2ROleW/uz1ezvGK1PyK8wcrd06kflVoX
	Es5R78bbJ7hJ1MsB/KlBLGRCsKaLiCqmzrHOu/14AI/vH8Acyf2LSfHU2hy4ShScAHXd55Q2fzS
	LjIbGAoj7Hng8mFSNl/fa3wpxXE
X-Gm-Gg: AR+sD11UySAe/akfCySFiLm5E9CkIWQza2AASg6G7cMY7biVHPEs87fxpf6NgKRCttA
	53PwWn1opQqKBVYufZ3O95kzLunFGY7It4tSHw8uWMmLBbvYaiM0H6MX8tLHs/EpfShH5N87yuR
	ynf28ZBsHrKidsKaPCIMoEE+aOEIweAVvIr1iKPkm08VsS0Cmjbkrj0nvx2BsXGZl8/mqdSoVTF
	Ga9M19odv+dQS0twUtBQAJZzF8FuqCtWEeWPUKXKEyhc+7PMCkXcan6ioBh5Lwl6Oe1QcJ3HDpI
	uVDNzqmJbyOboCRdqBVWEqZP/InI/+ejTN6HeVxtnPNlGp/B+DnolERH9d6OdThYxMdede4d3Xu
	lnQZ+Sop8k1FWqZXlg2y9ts5mUJIR/+DP4smvu+aMXq+PyF6DTvP2lFWmNqoQy0wvAGZBE/5qtw
	OelOkmEtBg28qlwc3E/Z+QkkBtsDMEEVTstOjWpiI=
X-Received: by 2002:a53:dacf:0:b0:667:5960:a594 with SMTP id 956f58d0204a3-6694f26980amr8252785d50.54.1785745267384;
        Mon, 03 Aug 2026 01:21:07 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-22.dlp.protect.broadcom.com. [144.49.247.22])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-6694af4d78esm333877d50.15.2026.08.03.01.21.07
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Aug 2026 01:21:07 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38dd87656d3so4362555a91.2
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 01:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785745266; x=1786350066; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=umawf+BlMbUojF4hA2eaASvm/LHe9PC11Jo6AdX6bp8=;
        b=S/vNP+dB2r8dfC99LwWLupiUUelWHCzPGrii4uDLA7/qrFOK/BB2g4nsOt3Hq2yrZq
         8grCzW3/DlwIZmDvFHl/ZpYzxndP1rIF16+/+oJyH2mRTiKXMfjVgC1s1S4D+W0ZPEfB
         Z0nwcSMxoX9LtVgZCiB6i2VJCG9p9iBhd3DgU=
X-Received: by 2002:a17:90b:4f48:b0:381:c500:b0d1 with SMTP id 98e67ed59e1d1-38fbc4ff4ccmr8731215a91.20.1785745265909;
        Mon, 03 Aug 2026 01:21:05 -0700 (PDT)
X-Received: by 2002:a17:90b:4f48:b0:381:c500:b0d1 with SMTP id 98e67ed59e1d1-38fbc4ff4ccmr8731186a91.20.1785745265384;
        Mon, 03 Aug 2026 01:21:05 -0700 (PDT)
Received: from [10.176.2.103] ([192.19.176.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd9be04sm33069820eec.9.2026.08.03.01.21.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 01:21:04 -0700 (PDT)
Message-ID: <c2589f1c-c754-4282-815b-df64f0250623@broadcom.com>
Date: Mon, 3 Aug 2026 10:21:03 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: brcmfmac: Fix memory leak in
 brcmf_sdio_read_control()
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>,
 Abdun Nihaal <nihaal@cse.iitm.ac.in>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260722110713.115988-1-nihaal@cse.iitm.ac.in>
 <20260802083905.3819981-2-arend.vanspriel@broadcom.com>
 <e059b52701d3cad4480dfb506e61474924b9f29e.camel@sipsolutions.net>
 <6648c1d61a44ad732550ff20c0b1aecaa43676f6.camel@sipsolutions.net>
 <19fc626a040.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
Content-Language: en-US
In-Reply-To: <19fc626a040.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 03/08/2026 07:44, Arend van Spriel wrote:
> Op 2 augustus 2026 18:44:40 schreef Johannes Berg 
> <johannes@sipsolutions.net>:
> 
>> On Sun, 2026-08-02 at 18:41 +0200, Johannes Berg wrote:
>>> On Sun, 2026-08-02 at 10:38 +0200, Arend van Spriel wrote:
>>>> On Wed, 22 Jul 2026 16:37:12 +0530, Abdun Nihaal 
>>>> <nihaal@cse.iitm.ac.in> wrote:
>>>>> The memory allocated for buf is not freed in some of the error 
>>>>> paths in
>>>>> brcmf_sdio_read_control(). Fix that by adding vfree() calls.
>>>>>
>>>>> Fixes: dd43a01c5cdb ("brcmfmac: use dynamically allocated control 
>>>>> frame buffer")
>>>>> Cc: stable@vger.kernel.org
>>>>> Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
>>>>> ---
>>>>> Compile tested only. Issue found using static analysis.
>>>>>
>>>>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 3 +++
>>>>> 1 file changed, 3 insertions(+)
>>>>
>>>> To be applied to wireless tree.
>>>
>>> I'm going to put this into wireless-next, at this point (-rc6) this just
>>> doesn't cut it, the commit message makes it sound purely theoretical.
>>
>> Actually, I'm not even going to do that - sprinkling vfree()s over the
>> code when moving the one that exists would be sufficient is, and I'm
>> being generous here, not a good change.
> 
> Sorry, Johannes
> 
> I looked at moving the vfree() to the done: label, but the code also 
> gets there in the success path to wakeup waiters. In the success path 
> the buf is stored for further processing so it should not be freed. 
> Maybe better to do:
> 
>         spin_unlock_bh(&bus->rxctl_lock);
>         brcmf_sdio_dcmd_resp_wake(bus);
>         return;
> 
> fail:
>         vfree(buf);
>         /* Awake any waiters */
>         brcmf_sdio_dcmd_resp_wake(bus);
> }
Actually it turns out brcmf_sdio_read_control() is only called once so 
the brcmf_sdio_dcmd_resp_wake() can be taken outside the function.

Gr. AvS
