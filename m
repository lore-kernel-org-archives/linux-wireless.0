Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E88E1C3F0C
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 01:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784768998; cv=pass; b=Xz5VfPCcaUydMhvQk86HEo7aFiJJYD5zqzrDEE/iTk+0uqrHIXU00U05QB+NGSSHNk+PrTQ/fDkPazJHzrC5IwG+Bx51o4aTH312TnMBV3jkV9WJjfy4OTSTMNXiChfhlU47wJ5g+G3b+rVqoy1ZfuiB4V4csbbcHvtmmfpLOWo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784768998; c=relaxed/simple;
	bh=XQgUFJcHrVYt/gu00yuydgpqEscujZmrmC++SBTuV1o=;
	h=In-Reply-To:References:MIME-Version:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ktjkd5t4m5bA7Qh9EwJ47ZV1cZ/TSUwu9hrs1W6TRXEol+LOmrnpSK2UNHuzDnRxyNPlzqsOawsZ0SvecogDQqpxJUx9JXGhCNraEcEvfGFXXi/FRqpELRfbV3dbzJFk10v74p2lM/i/m/wdxCU4Wm/YzyoryIVWsTFUVCyTbsE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WKHplWdX; arc=pass smtp.client-ip=209.85.217.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WKHplWdX"
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-74ac3ea9c9fso23830137.2
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 18:09:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784768996; cv=none;
        d=google.com; s=arc-20260327;
        b=FW/utEW7uxyvuwWTzijWeEnirE26Gh8LYOh2vuDw36TdizigFpTqpZ+YbqPlOjrJNu
         whtLOI4EoX60IkrVVJCUs9lFKFG1N7nRItld9vjQdwTls4LpcGkwE/u+97L+cLPA4h0e
         /w3T6jb47S8A4AhKhnA1OYADpQaoH3lxmreOZCVXnkjkY/GLZrasb0PDDGG6UDGf30Ar
         /1G4KJIrPaEMriIv+HwW9T9yRHUZWoaNQ8v6BvtbM1NEA1O/qMphORRQcE+P96HItpuX
         3ejIDz1Uf6FOo/48bhQxEOuAvDUOUE2+2Wtt3Wf5hFeKgsVmjleMqFpCjl8yMHlpi86E
         55tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:references
         :in-reply-to:dkim-signature;
        bh=cknJ4Y9jl+Hlu1GsDY602pJfVvZ6G49X7vzHwgawibQ=;
        fh=uRFnZbxsUgPvc+Hwmr6ETAp26wBMl5gQLAhq97u+714=;
        b=kPdP4gtZ2Y+LxKaT4iRuchZOy4lFIb8PtuEOXjw13T6W5aMggd0W7Mfz1tRS0XPfgt
         x3tKML6iqqMPh+eVnh0rUVkwQ43L0WF+QKbtuIr094Y2sampCvvVnjPXykijSUgyeSEZ
         l+4pZQHuGYaPY1pWUjtMnvjPdlaPR8AYL74tCcI0uXkUc0tzyKyA58B/GRgIiQJlDNma
         R2qck5+JiYxmzqEU3wJUgtu+lrgDbK7IwUSH6sIXdS6ABPh8y5xjzkM17DBRUYHKnXkb
         VX6QhRLHh6G4b57yiWFXyd9ZnwQuVwWXv4EgYgeHEs+lzaejV8GLgc10NqNV5M3goNUg
         FXsg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784768996; x=1785373796; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :references:in-reply-to:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cknJ4Y9jl+Hlu1GsDY602pJfVvZ6G49X7vzHwgawibQ=;
        b=WKHplWdXseyKwWXOA4nbDTALiDdg1w4WEVvEp5Zcn2kuqA33N3130dOoOrQg6O/mby
         mefZy626iAIxr4GfC5LkLJJ0SWfhxLzQuEzZUc/BqmsnDGjP8M6cD1T2u84H4Wgl9lXy
         6Qgn68+1ohBninXHwwKwztgD7RFIfiO/3+dP5yr2DEmncWJHNCRECWZqoTRyJatnKKJX
         1ln3piG8Gu98epv3r0MZdbCMtVT6m8si+fd9Nl2/q6NUODNPKJ4TrP+OTgXVf/Swv/H2
         L2HPEPf4CB4bBItSV1Tm0WPHTCU4IbGkzJuMlhVdWjij857hYCk8NPGV+gR8d11RDhdH
         BfOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784768996; x=1785373796;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :references:in-reply-to:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cknJ4Y9jl+Hlu1GsDY602pJfVvZ6G49X7vzHwgawibQ=;
        b=gaadhT9grVIZz65db8lwO9CDYE//BgquVKK3CtT2ED6+EOTNToXIxjKBySxEPzO8bk
         GVQWtINp5zmr2tbDJblD6Ap2DBbaTfxQAPaZE77T1PaZfchbd+n2cbL9VAsAVOPmrP2k
         0+JACAF/Rcf1C1/EvI8I1u9MgoK2nsBzVgeTmne2RwYXesfe357LrSlaZFfeshlie8Eq
         DGnJSk8Way0+8MWcjVfDqw9nM08DPauhVwMNcvUwCcEE3h9ogkCINCSccruNgE3mSq8X
         PZCQp1cMH6/PCtU7me3WB5QwDUmNuXtNrEeQwIMyFTzXijMgi0vcI1yVJG1TNgZEWA/C
         q5DQ==
X-Forwarded-Encrypted: i=1; AHgh+RrOS5KNBem/jBPQLyvB7KdGw+8amqnSXsynbGtLWrOvpdM6PieXRXF38W8icn24qMC8wXeBLRDOtjXDh8+6nw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyA5VXkbwvqUr3YfaopvLBkLkU62I87Sp210znxRUNpwSyLkjpM
	Iy1t2XY5yQmDfgaCGvYDHGxzRieC60foOOm3F4qeWSkQ8wVUbt9tKsYA8dbh1X0sdh01s446VQs
	ZKBalyfbR6Enn+8RvMeoOr2zuKy9aOdw=
X-Gm-Gg: AR+sD11CPjuSy7VZmdw/JmTceKcwDy1mCWLNYAvedGF0LbPgzfXCEFv5rcx4qTFCFX8
	1rrFhIY/+lhUzUEmG7qiiL2ai76WGDIJx6SjoIMiNLV8sIYDCqoiggVhtlU74pn5NSTO62NIDX6
	lgb63H4I0Jsl1+wO9UDiI/YdrgPzMdQvL5gFIq3APXP+E2vSS5qYxEQrvFhkehvWK5NV5RoA59j
	HEUz3UvtOLhLGYQa0HBmqwiFii0d3hgNnGaqq/rb8SlKSEPfar3DIOQ2Vg=
X-Received: by 2002:a05:6102:5125:b0:737:491:5e49 with SMTP id
 ada2fe7eead31-74d5fdd01b4mr337902137.18.1784768996111; Wed, 22 Jul 2026
 18:09:56 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 23 Jul 2026 01:09:55 +0000
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 23 Jul 2026 01:09:55 +0000
In-Reply-To: <209a011cf5f87881881cd338e1d3ec6baa75bef6.camel@sipsolutions.net>
References: <20260708195911.84365-1-enderaoelyther@gmail.com>
		 (sfid-20260708_215930_683827_CD8CF763) <573e7a49f4e9763b0cdb22bb4fc875bca1335c70.camel@sipsolutions.net>
 <209a011cf5f87881881cd338e1d3ec6baa75bef6.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Enderaoe Lyther <enderaoelyther@gmail.com>
Date: Thu, 23 Jul 2026 01:09:55 +0000
X-Gm-Features: AUfX_myxa6PfvDlkMrJSoOiR7oAWMKClMqTF58wA1hK_VXYOgnN8pphvAlqoRIQ
Message-ID: <CACHPgzwFVrpntk6sz8-iukmu=+-6-Eb9qU5MR11iASa_RH85mg@mail.gmail.com>
Subject: Re: [PATCH 0/8] wifi: fix PMSR lifetime and frame validation issues
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, miriam.rachel.korenblit@intel.com, 
	briannorris@chromium.org, francesco@dolcini.it, jaewan@google.com, 
	daniel.gabay@intel.com, emmanuel.grumbach@intel.com, benjamin.berg@intel.com, 
	pagadala.yesu.anjaneyulu@intel.com, peddolla.reddy@oss.qualcomm.com, 
	lorenzo@kernel.org, john@phrozen.org, patila@marvell.com, cluo@marvell.com, 
	linville@tuxdriver.com, quic_alokad@quicinc.com
Content-Type: text/plain; charset="UTF-8"

Hi Johannes,

Thanks for the reminder. They should never be a patchset. Patch 3/8 is with
the Intel maintainers, and 4/8 is applied. I'll send the remaining patches
individually after rebasing each one.

- 5/8 (probe-response countdown): cfg80211 already bounds a nonzero offset
  so original out-of-bounds explanation was totally wrong. But
  zero-initialized probe-response offsets are treated as valid, which
  corrupts resp->data[0]. The v2 skips zero offsets instead.

- 6/8 (S1G TWT): added a guard before the driver callback, with Lachlan
  and Lorenzo copied, sent to wireless-next.

- 7/8 (mwifiex action frame): will use IEEE80211_MIN_ACTION_SIZE() and go
  to the mwifiex maintainers.

Regards,
Zhao

On Wed, 22 Jul 2026 16:37:55 +0200, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2026-07-21 at 18:00 +0200, Johannes Berg wrote:
> >
> > > wifi: mac80211: validate probe response countdown offsets
> >
> > I think this one is falling into a typical LLM pattern patching trap, it
> > describes [0] as being out-of-bounds for some allocated data, and
> > neglects that the offsets have already been checked by cfg80211. Please
> > describe more why it's actually an issue beyond "there's a similar
> > pattern elsewhere".
> >
> > > wifi: mac80211: validate S1G TWT params before driver setup
> >
> > I don't know about this, you should probably resend it. Anyway I'm not
> > loosing sleep over it since there's no driver with the callback, tracing
> > is mostly not enabled, and while a potential 12 bytes OOB read at the
> > end of the SKB is a bug, it's not a very important one since there
> > should be stuff there anyway.
> >
> > > wifi: mwifiex: validate action frame fixed fields
> >
> > Francesco should look at that - again, sending it all together makes
> > this really hard - but it seems to me it should use MIN_ACTION_SIZE()?
>
> Also in addition - please resend these, the s1g should go also to
> Lachlan I think who wrote it, and I don't think anyone is paying
> attention to this patchset :)
>
> johannes
