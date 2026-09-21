Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2363ACA7C
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 19:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790019590; cv=none; b=qw5Dh9dYchUWxKdLDZ4do4sK6dNwNSlbLgPqxKQzVKtfYVlKDuEASavdeFKy5HQGx9K4EDVrB36AtRH4n9Oosw0m+f6v5pDp7YIQwRxeGtexed3x5HLx5sj+g+lT2drY5W50LtMIuwFw/e2TofdnmfQWpMIe+QjFy3e4InJVYTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790019590; c=relaxed/simple;
	bh=t1DFtvX68cZy3NISZhI1E9+crqPmZBie+sgWlmjNfZc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sNRwTP33/7VRcgFE5rxJ30ut50TWjzwOlzZAScRku9cR7a3VMMFZf7PQDYG8P9MzZcEB/JAM9FlJHbK5mtgctJJppTMSRALTaPDn99GiTfHcb13pUFYMI+qS/fEVubHPrDvi8ffbBtUKpN4OQhSCKubD3R+LGNZwWt4G08wFbpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fXCi+50g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fXCi+50g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3DB1F00898
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 19:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790019589;
	bh=TlEfKXCg5rHiDJTVNsbZVHr7bZvcSttFpXBa5Vfys1Y=;
	h=References:In-Reply-To:From:Date:Subject:To:List-Id:Cc;
	b=fXCi+50g/p6esnKbXrT5l4yOjkyme47lIAOq0dB5cRkLF2KIs6GzFdtPXYLVK8yGT
	 hHCJQER3efnQMbY8TgYuYm9QGDH/WzeDtOnrG+wGe9AHVpPxCtVAk3ngSIV8dz9jrp
	 bQ9To2081tZyhZ5jugatQkysS+2w37QcjrWvu4JIJp63BbTlPGKyxwavLnTdbtVnaW
	 Fobv3CAi54ZHj1NKCFrLGnndnW+Mr30RevnGWUeNG7jeflM7bdpHwAyTx/NwLQTtYF
	 Lcr+p8PmwO+jDPFrJkDAY6Jmds34hq1xguy4oOr4f1u5In14Njq6J8i+MjJNzCNGgf
	 CVDfgj4SLPxxw==
Received: by mail-yx2-f43.google.com with SMTP id 956f58d0204a3-67109935888so3363109d50.3
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 12:39:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxRxre2r5bOIwYIkGVS/KOl4nOfyA9GWNcACjWhASzsNYzz65qMxivviQwakkr1js56nN248qY0Vfk5r6UgGw==@vger.kernel.org
X-Gm-Message-State: AFuF++kD0qz2U6J+xvLdz55lQfYh48Pp4s7qk7zft8O7yR9BVjocSFDo
	lQs7f1KS/MGddlL+BZ4w5+2d67yKhNA018LT9nr31SlZHqAitgtYKNnzeZ34otUJXFUyhUTnkWb
	QUV2Hugp0C1fBoWJpnk25xpjrnEvcYJ4=
X-Received: by 2002:a05:690e:1408:b0:671:70d2:5290 with SMTP id
 956f58d0204a3-6718227eb94mr3905390d50.83.1790019588512; Mon, 21 Sep 2026
 12:39:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <3c89c245-3a4f-46f0-93eb-a138f10a1ef2@oss.qualcomm.com>
In-Reply-To: <3c89c245-3a4f-46f0-93eb-a138f10a1ef2@oss.qualcomm.com>
From: Josh Boyer <jwboyer@kernel.org>
Date: Mon, 21 Sep 2026 15:39:37 -0400
X-Gmail-Original-Message-ID: <CA+5PVA4BCQm8yVav7Tcxjyo61jyHpk+W4QbsR2JB+GZAxGpzhQ@mail.gmail.com>
X-Gm-Features: AcwNN1UJvQ-v6KBYcktupCrDFyB4cuYBhh0oniY8Yx8HTq1Dje0_HKhmeUNPLNQ
Message-ID: <CA+5PVA4BCQm8yVav7Tcxjyo61jyHpk+W4QbsR2JB+GZAxGpzhQ@mail.gmail.com>
Subject: Re: [PULL linux-firmware] ath10k, ath11k and ath12k firmware ath-20260921
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-firmware@kernel.org, linux-wireless@vger.kernel.org, 
	ath10k@lists.infradead.org, ath11k@lists.infradead.org, 
	ath12k@lists.infradead.org, jjohnson@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Merged and pushed out.

https://gitlab.com/kernel-firmware/linux-firmware/-/merge_requests/1270

josh

On Mon, Sep 21, 2026 at 2:58=E2=80=AFPM Jeff Johnson
<jeff.johnson@oss.qualcomm.com> wrote:
>
> Hi,
> Here's a new pull request for ath10k, ath11k and ath12k firmware.
>
> For ath10k and ath11k there are no changes.
>
> For ath12k there are two board updates:
> QCC2072 hw1.0: Add initial support for CQ2390 targeted for IOT platforms
> WCN7850 hw2.0: Add support for board-ids 0x201 & 0x202
>
> Please let me know if there are any problems.
>
> Thanks,
> /jeff
>
> ----------------------------------------------------------------
>
> The following changes since commit 2b8daaf611fbade74f26a5b58ec1defe6a02f5=
e0:
>
>   Merge branch 'qcom-fw-version-diff' into 'main' (2026-09-19 17:16:57 +0=
000)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/ath/linux-firmware.git at=
h-20260921
>
> for you to fetch changes up to e88807ffbf0fce50130cf1f7475acfb8ba365c12:
>
>   ath12k: WCN7850 hw2.0: update board-2.bin (2026-09-21 11:50:36 -0700)
>
> ----------------------------------------------------------------
> Jeff Johnson (2):
>       ath12k: QCC2072 hw1.0: update board-2.bin
>       ath12k: WCN7850 hw2.0: update board-2.bin
>
>  ath12k/QCC2072/hw1.0/board-2.bin | Bin 401232 -> 526720 bytes
>  ath12k/WCN7850/hw2.0/board-2.bin | Bin 2253964 -> 2431852 bytes
>  2 files changed, 0 insertions(+), 0 deletions(-)
