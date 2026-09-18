Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418A933469C;
	Fri, 18 Sep 2026 13:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789739642; cv=none; b=XvN9iQm498U8oUoLHKRxCKAFSJbLFEtrSvhMcuC5nQCVnSyGy0CubnaucIm+VIgzCPCcDp+TD4XrcaNlVzc7CoWRPcakUVfQUYg6/+tTC2sUAMuujyBidkXQoBTeP+YZoVvN4ZDUBQrEcYpFCRsrHKEestniLQhM8kzdKGXiaK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789739642; c=relaxed/simple;
	bh=8+CpXVRk85+z24kHh4ZnsVqemD+JdL897z94DIkTqhg=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=GTbjxgOBbCmmI91T1QRKYTmKaZRjjDOnsTHomceadqSZAgvcXsBFRCh48dGpSPpu50SRngKsgpcVsqj69GrWEl9eJf5ghQ4LWsBtcO6f8CaL17hWDAlapoWzGKpW+jTPd1yFkGUs1vANnietGD2AC8NCHgTjoDjYpuGxrs5uFzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=McbYaB+U; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="McbYaB+U"
Received: from ehlo.thunderbird.net (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 2D30A21CB2;
	Fri, 18 Sep 2026 15:53:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1789739627;
	bh=/Gv9XiWQJYzlWlCFbkKRHOjWzQ7yzpHyBteuh5zHeWc=; h=From:To:Subject;
	b=McbYaB+UNWNUUHsb/Fxk9Vl53pzBCS/SYMjjk6A5Z/ksEC4ScPq5CMxU2yi7ArSbg
	 iGAgpjByHZkLlOA83fDK3iHaf9s4cuQWv7IWaMKXmJe4Iv95RP7se+zVyu0XYJMF3k
	 opFMFNvNOFoUn5VhwrAG//1Emr+CWlfs/bfTsrvy2tlUP0jMEk7oqg/rBLxIuJaWs6
	 Hg4zqyO2HMv6GuD8ZRopYbKuP0cn8dZqPTy/BbCIyGwenvoERNSOw7xAXZF+2NED6s
	 eKctaZRqu8qezfhHo4t4b6TAQdKG2dJfuMQkFtonIWd5TvdfqEpyAFnSpqOpdJynq9
	 CGiiPmQK4ie2w==
Date: Fri, 18 Sep 2026 15:53:46 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Heyang Tan <thy15333007817@163.com>, jeff.chen_1@nxp.com
CC: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2=5D_wifi=3A_nxpwifi=3A_bound_?=
 =?US-ASCII?Q?debugfs_output_to_the_allocated_page?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20260918131537.904-1-thy15333007817@163.com>
References: <20260918131537.904-1-thy15333007817@163.com>
Message-ID: <064632A8-436C-431B-9315-BA5BC42E8998@dolcini.it>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable



On 18 September 2026 15:15:36 CEST, Heyang Tan <thy15333007817@163=2Ecom> =
wrote:
>This patch fixes two page-buffer overflows in the nxpwifi debugfs
>read paths=2E

The commit message is not written in the way the Linux kernel=2E Not "this=
 patch fixed =2E=2E=2E", but "fix =2E=2E=2E"=20

In general if you have 2 fixes, I would expect two patches=2E

Read the Linux kernel doc on how to contribute and look at the previous ac=
cepted patches to get a better idea=20


>The patch passes:
>
>  git apply --check
>  scripts/checkpatch=2Epl --no-tree --strict

This info does not belong to the commit message=20

>
>checkpatch reports 0 errors, 0 warnings, 0 checks=2E  I also compiled
>the patched driver on x86_64 with CONFIG_NXPWIFI=3Dm,
>CONFIG_CFG80211=3Dm, and CONFIG_DEBUG_FS=3Dy; the kernel build and both
>nxpwifi=2Eko and cfg80211=2Eko completed cleanly with no compiler or
>modpost errors=2E

This neither=2E

>
>I do not have nxpwifi hardware or a runtime test environment, so the
>overflow sizes above are static upper-bound estimates and have not
>been reproduced with KASAN=2E  The practical exposure also depends on
>the debugfs mount mode, as noted above=2E

Untested patch, written by an LLM =2E=2E=2E did you review what the LLM di=
d?

>
>Assisted-by: LLM Codex
This tag is invalid, check the kernel docs=2E Just Assisted-by: LLM

With that wrote, I did not look at the code

Francesco=20

