Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C30476056;
	Sun,  4 Oct 2026 17:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134557; cv=none; b=XJ4Cnkn3FRtuoz/aGFavVshLY5o1/FW/uwvd18+963Rr9M9Q0CORX6zcRTQPNKxMl4jfdjZU2NrIGbsxgvMxYUINqYCRl1e/+0W7rKaUJLmDfzsFPQnARPEbhQ4cgTnaLMcx+YXmAAfEcTOZeAVwqyShaC50bxrtYvHTVzszEo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134557; c=relaxed/simple;
	bh=SVrTF2CEU/np8bUBv4RC8OzMd72SHpw8Bo8EyBlVIVg=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I4q1NlYPwIofRA4dol8Gj/sjrOKgiHrl0Dj6QWRAtLS5ZiF/HP+99q1qAb1BtdG8kJm6XuiJYL8/aZ9zveazAe+OMAAQArWCHX1dz3v0BON6HpFUrd7ORLo4JNH8dJV3u1gakD1OfGK82dg4njJWRCvsj8CxIu2a2kSaG8xljq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jZNTtFQS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jZNTtFQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4261F000FF;
	Sun,  4 Oct 2026 17:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791134556;
	bh=FTVVrhIO7Gv+QXA5Xg8uyaUhs115oHhhN8a4uGFWNVM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=jZNTtFQSGX+8OUPQhEbKv5KnjXcLT2kxmBDN08g49obLOcz+fueXbg+j8t7VXYkXg
	 k/Vz+rh2rat1caxwIVZOpIb72XQEvLdkthzJS/RBxsYfzazB8nfb+LfhLYY8VceyHa
	 Lh+/qUpr1Ms7sgBj1W2Whu51GjerHHhPbMPg4KD4UE9c5BdQEHMmvCymkDd/Eykm1m
	 qTYI4ODHXRhGkjRoiHzCbpNGY/JN3n8O7/8zuDqWCHQ0DMZORNE4wwyxXzddyVmUGj
	 TVXu2PKRxBVYjp6j5JvRzYnRX7ZXZqVAcoNCG81aVrT1PMR2d7O5CMYz1XUqM3AWhV
	 Z9dre5uBgwJjQ==
Subject: Re: [PATCH 15/16 net-next v3] netlabel: cipso: introduce CONFIG_CIPSO
 to decouple IPv4 dependency
From: netdev-bot+sashiko@kernel.org
To: fmancera@suse.de
Cc: netdev@vger.kernel.org, horms@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, edumazet@kernel.org, davem@davemloft.net,
 johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Sun, 04 Oct 2026 17:22:35 +0000
Message-ID: <179113455547.434549.7410696405500353621@kernel.org>
In-Reply-To: <20260930135334.4739-16-fmancera@suse.de>
References: <20260930135334.4739-16-fmancera@suse.de>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] When CONFIG_CIPSO=n, the NetLabel management PROTOCOLS dump
  still tells userspace that CIPSOv4 is supported.

--

netlabel: cipso: introduce CONFIG_CIPSO to decouple IPv4 dependency

This patch adds a new CONFIG_CIPSO symbol, which is enabled when both
NETLABEL and IPV4 are set. The CIPSO Makefile targets, sysctls and kernel
APIs are placed behind it, and the CIPSO kAPI is stubbed out when it is
disabled. This lets NetLabel and Smack build on IPv6-only kernels.

[ ... ]

> diff --git a/net/netlabel/Makefile b/net/netlabel/Makefile
> index 5a46381a64e77..8afc1bf004243 100644
> --- a/net/netlabel/Makefile
> +++ b/net/netlabel/Makefile
> @@ -12,5 +12,5 @@ obj-y	+= netlabel_mgmt.o
>
>  # protocol modules
>  obj-y	+= netlabel_unlabeled.o
> -obj-y	+= netlabel_cipso_v4.o
> +obj-$(CONFIG_CIPSO) += netlabel_cipso_v4.o
>  obj-$(subst m,y,$(CONFIG_IPV6)) += netlabel_calipso.o
> diff --git a/net/netlabel/netlabel_cipso_v4.h b/net/netlabel/netlabel_cipso_v4.h
> index 9518ab56ec98f..fb718f86bcbd7 100644
> --- a/net/netlabel/netlabel_cipso_v4.h
> +++ b/net/netlabel/netlabel_cipso_v4.h
> @@ -147,6 +147,13 @@ enum {
>  #define NLBL_CIPSOV4_A_MAX (__NLBL_CIPSOV4_A_MAX - 1)
>
>  /* NetLabel protocol functions */
> +#if IS_ENABLED(CONFIG_CIPSO)
>  int netlbl_cipsov4_genl_init(void);
> +#else
> +static inline int netlbl_cipsov4_genl_init(void)
> +{
> +	return 0;
> +}
> +#endif

[Severity: Medium]
With CONFIG_CIPSO=n, does the NLBL_MGMT_C_PROTOCOLS dump still tell
userspace that CIPSOv4 is supported?

This stub means the "NLBL_CIPSOv4" generic netlink family is never
registered. The rest of the CIPSO kAPI is stubbed out too, for example
cipso_v4_doi_getdef() returns NULL. But netlbl_mgmt_protocols() in
net/netlabel/netlabel_mgmt.c still reports CIPSOv4 unconditionally:

net/netlabel/netlabel_mgmt.c:netlbl_mgmt_protocols() {
    ...
	if (protos_sent == 1) {
		if (netlbl_mgmt_protocols_cb(skb,
					     cb,
					     NETLBL_NLTYPE_CIPSOV4) < 0)
			goto protocols_return;
		protos_sent++;
	}
#if IS_ENABLED(CONFIG_IPV6)
	if (protos_sent == 2) {
		if (netlbl_mgmt_protocols_cb(skb,
					     cb,
					     NETLBL_NLTYPE_CALIPSO) < 0)
			goto protocols_return;
		protos_sent++;
	}
#endif
    ...
}

The CALIPSO entry is guarded by CONFIG_IPV6, but the CIPSOv4 entry has no
guard.

On an IPv6-only kernel with NetLabel enabled (for example selected by
SMACK), userspace such as netlabel_tools would see CIPSOv4 in the list.
It would then fail to resolve the CIPSOv4 genl family. An NLBL_MGMT_C_ADD
with NLBL_MGMT_A_CV4DOI would also fail, because cipso_v4_doi_getdef()
returns NULL.

At this commit IPV4 is still def_bool y, so CIPSO always matches NETLABEL.
The later commit in the series, "ipv4: make CONFIG_IPV4 boolean", makes
IPV6=y, IPV4=n, NETLABEL=y a valid configuration. netlbl_mgmt_protocols()
is unchanged at the end of the series.

Wrapping the CIPSOv4 block in #if IS_ENABLED(CONFIG_CIPSO) would not be
enough by itself. The resume state in cb->args[0] uses fixed indices, and
the CALIPSO step checks protos_sent == 2, so skipping the CIPSOv4 step
would also stop CALIPSO from being reported.

Could netlbl_mgmt_protocols() always increment protos_sent for each step,
and only emit the message when that protocol is enabled?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260930135334.4739-1-fmancera%40suse.de
