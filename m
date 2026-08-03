Received: from mail-qt1-f226.google.com (mail-qt1-f226.google.com [209.85.160.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD68F380FC3
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 05:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785735855; cv=none; b=AdEXO7xWCAmbMamzJmWUFKJjwSMf7x7jmDKgdLvxW2nct1bTqnRi7Q8SnJzNgqE9d2m3XRhM/M+LnACH/K/83NxPMVBc3+OE+kpr1+s68u2serjDhr5i1KGuVzcbJby2vjdbXaMJPTVZ2qiuxm70/jqrlTPEqusHGUHC1CweShA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785735855; c=relaxed/simple;
	bh=yjB7RGHZWNCfModfSNNs6/sJuqTLBvL7I9fkLDpx6ag=;
	h=From:To:CC:Date:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=cYVZ1UVylQzGJN+U3qrVbYB/AoyFQYtK3MqYfz3VlUlucfDTOtkUBmGw4nt4R4r4AnyQKIX+PmLDhR9D0XPvG3zJl4OvwhMjzKtjtZ2jjxUUbYgHkFHPsMMFYgZAOJY1Uaj2muPo0muvcIaDvW8577pES+aFShQ4ecg99xfyNeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=PnWhTstw; arc=none smtp.client-ip=209.85.160.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="PnWhTstw"
Received: by mail-qt1-f226.google.com with SMTP id d75a77b69052e-51c2a76536bso27455361cf.1
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 22:44:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785735852; x=1786340652;
        h=content-transfer-encoding:content-type:mime-version:subject
         :user-agent:references:in-reply-to:message-id:date:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=df1R3651GFZlufP+Sp9/jqANKcFbF/GkeE2awbI5Hgs=;
        b=oNESPQpOLoWwC18rVdNaTveMO5DAU+ohmOqHx0kqpj8lmT920aZcEAM1qGq4X1huIv
         0OZfWoH3an9tvGZ4wnuqmqX9Z+9E1uS2tsvNpuw1muJ5iRotA32s3hao72YSgi69/O0E
         xQ6W+Y90l9E0p8WXVYRwHSUs3+4Xf82ex1UqnOVCuxsJZdPpfosw20QXW7fghLCr2Xj5
         J3l1xFfIohhbOHOvm3uw1k6PMHZZBfzWqmKRMmt/6LSHsi2avdtBynLI0cf+9z2es5WA
         qeC3Dk2J9OGvw/Jkr7SuzEj9i9scnr6DBeMZbNA/VXmflzy9owAE5RitYFYuMJW+gjlg
         JU4w==
X-Gm-Message-State: AOJu0Yy9LtOi6YKzx9F28MXCKBIzqfNRKzL8qu4vm4VB6yCTT98z+G3T
	L/zXxb9VCxsftMlB81BuSFvmOhhtNd+OHAgVj04FUyTSXkm6cyYWMOKOLk+l2fMB7P4audPn+fx
	mSTV4VSAnUT+hZCfvQB6JPEuWrrgIVCQhr61mySyQPrsQzw3kuYKJeFLl5mk1jGCuM0Bwixnq63
	ZX4ytGjvzN6+y2f4QdIx62dbl8SojoQVE1vKQOTo0Y9yY7ovywa93y9KuL4vcgPPCRTURGtHeKK
	mJpGBXWY4yn6WCEkiJFu5Y+6Tn0
X-Gm-Gg: AR+sD100b1Riu7oeJ1hSyFb1I76QPo1C1wLrYlY0WQdIQD8cKMkl55UIJcKdIj4X89W
	K5rxMZHp/8+MgRhLEvQ5TMmumTmaLTAiCZdiKI3zmp3xHIFMXZUSWvb3h37HE5TvlxczZ8Zx9Aj
	bVje7E8r7KAj1/WE5u/h0YM8agQebncRGH9n60RBgp+tdCM5f92WEVmL6EtbWfIc3HjJV0mxeTR
	vCYMnbwlHyuvESeTreAVOcr+tS0wO53TVaLrO8fqUAZ/lMnNfHgciZW79KJ300LBzz1gSc8oXpo
	xdv/OsTxs9wxPPBvql17bTqif/Gxp3SpATVNOQ3hRsD2AyyCyeHcrOR1HT30dwGigSw087a6Grf
	Jnu86MdFgxNyq9775uwhk7u2n/zhIiOtnoOZr7mnTrpALWuiaSoUmC5qjNpQVDtCLqIkPaBgeA4
	Lhip7cXZHScdH9XKnTr4bu5dcxceElIvUtUtc71nQ=
X-Received: by 2002:a05:622a:5913:b0:527:7a5b:ca67 with SMTP id d75a77b69052e-52b5673f0a0mr179036841cf.20.1785735852435;
        Sun, 02 Aug 2026 22:44:12 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id d75a77b69052e-52b4e81fb5dsm3699421cf.12.2026.08.02.22.44.11
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Aug 2026 22:44:12 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c1f548718d0so376478266b.0
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 22:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785735850; x=1786340650; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:subject
         :user-agent:references:in-reply-to:message-id:date:cc:to:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=df1R3651GFZlufP+Sp9/jqANKcFbF/GkeE2awbI5Hgs=;
        b=PnWhTstwB6GTPm+7ZWf5nCyzXES3Ag+gUw4MegEjp1Pj5YESi12kdGVHFntcwU1Dmm
         NaVbyzYw3Lk5GsVjspuiiMRc+8UTxMWqdYD0VblyG+L96Y0Ol5UMsEIAtAtI4Vvfm8U2
         H+hufJ6Jyfoqs0swJTsNDjAMUo0feP3Mn7RBk=
X-Received: by 2002:a17:906:f1cf:b0:c16:8931:245c with SMTP id a640c23a62f3a-c1fe81e1316mr455358866b.21.1785735849937;
        Sun, 02 Aug 2026 22:44:09 -0700 (PDT)
X-Received: by 2002:a17:906:f1cf:b0:c16:8931:245c with SMTP id a640c23a62f3a-c1fe81e1316mr455357966b.21.1785735849510;
        Sun, 02 Aug 2026 22:44:09 -0700 (PDT)
Received: from [192.168.178.59] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fd4537755sm496563766b.54.2026.08.02.22.44.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2026 22:44:09 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>, Abdun Nihaal <nihaal@cse.iitm.ac.in>
CC: <linux-wireless@vger.kernel.org>, <brcm80211@lists.linux.dev>, <brcm80211-dev-list.pdl@broadcom.com>, <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Date: Mon, 03 Aug 2026 07:44:08 +0200
Message-ID: <19fc626a040.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <6648c1d61a44ad732550ff20c0b1aecaa43676f6.camel@sipsolutions.net>
References: <20260722110713.115988-1-nihaal@cse.iitm.ac.in>
 <20260802083905.3819981-2-arend.vanspriel@broadcom.com>
 <e059b52701d3cad4480dfb506e61474924b9f29e.camel@sipsolutions.net>
 <6648c1d61a44ad732550ff20c0b1aecaa43676f6.camel@sipsolutions.net>
User-Agent: AquaMail/1.59.0 (build: 105900627)
Subject: Re: [PATCH] wifi: brcmfmac: Fix memory leak in brcmf_sdio_read_control()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Op 2 augustus 2026 18:44:40 schreef Johannes Berg <johannes@sipsolutions.net>:

> On Sun, 2026-08-02 at 18:41 +0200, Johannes Berg wrote:
>> On Sun, 2026-08-02 at 10:38 +0200, Arend van Spriel wrote:
>>> On Wed, 22 Jul 2026 16:37:12 +0530, Abdun Nihaal <nihaal@cse.iitm.ac.in> wrote:
>>>> The memory allocated for buf is not freed in some of the error paths in
>>>> brcmf_sdio_read_control(). Fix that by adding vfree() calls.
>>>>
>>>> Fixes: dd43a01c5cdb ("brcmfmac: use dynamically allocated control frame 
>>>> buffer")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
>>>> ---
>>>> Compile tested only. Issue found using static analysis.
>>>>
>>>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 3 +++
>>>> 1 file changed, 3 insertions(+)
>>>
>>> To be applied to wireless tree.
>>
>> I'm going to put this into wireless-next, at this point (-rc6) this just
>> doesn't cut it, the commit message makes it sound purely theoretical.
>
> Actually, I'm not even going to do that - sprinkling vfree()s over the
> code when moving the one that exists would be sufficient is, and I'm
> being generous here, not a good change.

Sorry, Johannes

I looked at moving the vfree() to the done: label, but the code also gets 
there in the success path to wakeup waiters. In the success path the buf is 
stored for further processing so it should not be freed. Maybe better to do:

        spin_unlock_bh(&bus->rxctl_lock);
        brcmf_sdio_dcmd_resp_wake(bus);
        return;

fail:
        vfree(buf);
        /* Awake any waiters */
        brcmf_sdio_dcmd_resp_wake(bus);
}

Gr. AvS



