Received: from mail-pl1-f228.google.com (mail-pl1-f228.google.com [209.85.214.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565CE3AAF52
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 08:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785747303; cv=none; b=ZZ/o3yfYz6sQN7MOoaLCBwP3Qq5vZRKB1O0Nv/ovy0b7PBMjdzSm9Ld4vdQn12GiOTZH4hgh9W2hJnAfVLjcIpBnirSmf+vSqE6MdwjsCn1mCFsbA7rpEnlLUalaxzLYy1aZ7Mwy8F5x7C6pbNIehQHb5tPSvhHzEegi38EfJfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785747303; c=relaxed/simple;
	bh=AV0pToG9zNPBiZyyn1M9cI3XYMude2xTH+l+24aft2Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i5U4b1GxUViiRZDeBdSwRKAbxaTdxjWBaBTugv5gBJYfl4SSbOksSrf0h5cjyp4fO1hh40vmDEyDlldASubtDvNBfykW1D73o+hC4KkU88AHyhK1PGXp9Tmg4REr9Jy51dAtXEKSYt5RxDxNCi7PPqF076Yj7VAQZZznem2Phjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=HP4JwJ9s; arc=none smtp.client-ip=209.85.214.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="HP4JwJ9s"
Received: by mail-pl1-f228.google.com with SMTP id d9443c01a7336-2ce87c7e3bbso32345505ad.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 01:55:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785747302; x=1786352102;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=6QujGCeTnnZ3aprREzL53swawys0bVa+jOxZyTHDqDc=;
        b=U2vxn1+5Sd3WM+EGZOQeMtExIbC82AUU0IzrrfLiR9SdcsPYic04vuD339gPUAz14m
         jAFXKwPdnihxvctVI/fQyyOpxwbvowz/FxAn70eHLTOTPyLrT6Ww4fFugD6igjlnl0w9
         21Z83Fmxzo3AEOcva0YGRlJYrZgiWDOc1GRqRW4zkU/QI/1xhKqGrFReuyUnXj6YVBPu
         pBI2DEM3kMuEeQGPBcCWOdW2FtRsDcJac3BB9n2/Yk3wkFm7SoLHgh13h4Cs9XWj4IZn
         ppMpfclRP+raYPN8EVtSGlKseFFhC/yiOuN9nBrjLekw/9RVr/J/HnoRDliSQDXf2SJp
         DcIQ==
X-Gm-Message-State: AOJu0YwZ3BNBeBZEiA7J0AeYknrTuYMd+5ebpP4Y+TK+5iBz7OhPJFEs
	TQZSj2SFhjkFyRR8Jc6FBl/RSCTgnl2YAev5wrTxZZiWxQMS99fsXnenS3mXgGt3vXwcxIhIJr5
	nB74PnMZTuk5did1QH7PvAKRDRjaybXHGs8oGAWX+1I/nvAg1nHQiSeCAtwy26hp7tXEmT4L8XI
	c5JNak97BI1disEsnCbT/qwWtPqVN77xJRjF67Lx1FxcJH0TILqLaW+Hnodjx6Nb8wwLyFRWw6n
	aDxCkzPTwPk+QQbfKILFF7NWMEm
X-Gm-Gg: AR+sD11zoOkDgyyRjC7eaioOQfAjIDQMHzpbJv/WIDkK8OWG6A4ZUdTeVzViJwph/MF
	HW4YYeb9frL2aXGyep8X/RPk045uYZtH3Yxpdl00BrivdayFpSp61PbmJxmg5jp/ro3KvMN/Mxy
	806+Ywc7aZ1C2DPmZ5KK7nlHLMYLVR7wXF7SGOPAeBJh+NQrtVh3ZBg3WrFVrZX+1AHafRxu4Kz
	cgVtPJ9Jm+NTzjXzcanaKhIBq1OiXOCJ0+xJx8PRuZ24DgY3FucGVE9d6dZZVL40u/yoR/5iWdO
	0jKAoE0XtYOcXB5emzO6wCayOBAucW/w5625VTbStVbWQm8futqqaNjFA1sYg2Z5HSjdX4pbAci
	vy7MshPbIBixDrmjOnPlfGLiOeYRv30xD7HACv2vGRZBkYJ2WJ+2RihlBl/WWlMbeqtl5VvqZCG
	rUJi+qdrUlwS6xDoa/auNqINcHvtAcCHvSuQcFSuA=
X-Received: by 2002:a17:902:ebd2:b0:2b7:975c:dacc with SMTP id d9443c01a7336-2d0521ea576mr94746895ad.1.1785747301543;
        Mon, 03 Aug 2026 01:55:01 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-27.dlp.protect.broadcom.com. [144.49.247.27])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2d04ae3f5c7sm8871315ad.5.2026.08.03.01.55.01
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Aug 2026 01:55:01 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51c12e43b98so31567451cf.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 01:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785747300; x=1786352100; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6QujGCeTnnZ3aprREzL53swawys0bVa+jOxZyTHDqDc=;
        b=HP4JwJ9slPbJzazz6ZHBq5LNStXE1n/NmJCVdRqB/8vLAc/TuiZ3MZILwZDpTZimHb
         VvU92eWn71N59v7l1mzKqkBJzxLuNaW5aMX75nzJU70yzy3QPgZdI+DBchiG8G6j5XfH
         cjB5e4dHQoEWtdJRcZf1gykr0LKCckYxEszmY=
X-Received: by 2002:ac8:5fcb:0:b0:51c:e14:87ae with SMTP id d75a77b69052e-52b5686a056mr179473361cf.34.1785747300363;
        Mon, 03 Aug 2026 01:55:00 -0700 (PDT)
X-Received: by 2002:ac8:5fcb:0:b0:51c:e14:87ae with SMTP id d75a77b69052e-52b5686a056mr179473231cf.34.1785747299954;
        Mon, 03 Aug 2026 01:54:59 -0700 (PDT)
Received: from [10.176.2.103] ([192.19.176.250])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908434a2400sm70190036d6.18.2026.08.03.01.54.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 01:54:59 -0700 (PDT)
Message-ID: <c5aad785-8d7d-4015-a3c9-1f70f2a69579@broadcom.com>
Date: Mon, 3 Aug 2026 10:54:59 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: brcmfmac: Fix memory leak in
 brcmf_sdio_read_control()
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
 <c2589f1c-c754-4282-815b-df64f0250623@broadcom.com>
 <e628d43a4aca1763cafcde41338cf7a34fe57d6c.camel@sipsolutions.net>
Content-Language: en-US
From: Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <e628d43a4aca1763cafcde41338cf7a34fe57d6c.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 03/08/2026 10:35, Johannes Berg wrote:
> On Mon, 2026-08-03 at 10:21 +0200, Arend van Spriel wrote:
>>>
>>> I looked at moving the vfree() to the done: label, but the code also
>>> gets there in the success path to wakeup waiters. In the success path
>>> the buf is stored for further processing so it should not be freed.
> 
> Hah, my bad, sorry!
> 
>>> Maybe better to do:
>>>
>>>          spin_unlock_bh(&bus->rxctl_lock);
>>>          brcmf_sdio_dcmd_resp_wake(bus);
>>>          return;
>>>
>>> fail:
>>>          vfree(buf);
>>>          /* Awake any waiters */
>>>          brcmf_sdio_dcmd_resp_wake(bus);
>>> }
>> Actually it turns out brcmf_sdio_read_control() is only called once so
>> the brcmf_sdio_dcmd_resp_wake() can be taken outside the function.
> 
> Or just something like this?
> 
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -1827,15 +1827,17 @@ brcmf_sdio_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
>          if (bus->rxctl) {
>                  brcmf_err("last control frame is being processed.\n");
>                  spin_unlock_bh(&bus->rxctl_lock);
> -               vfree(buf);
>                  goto done;
>          }
>          bus->rxctl = buf + doff;
>          bus->rxctl_orig = buf;
>          bus->rxlen = len - doff;
>          spin_unlock_bh(&bus->rxctl_lock);
> +       /* buffer is queued */
> +       buf = NULL;
>   
>   done:
> +       vfree(buf);
>          /* Awake any waiters */
>          brcmf_sdio_dcmd_resp_wake(bus);
>   }
> 
> 
> It's already using vmalloc() so seems it wouldn't care that much about
> calling vfree(NULL) on the success path?
True. And yes, the existing vfree() should go, but I figured that goes 
without saying so I did not mention that. I am fine with your proposal, 
but I guess the author will have to submit a v2 patch, right?

Gr. AvS
