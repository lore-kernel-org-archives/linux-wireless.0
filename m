Received: from mta1.migadu.com (out-23.mta1.migadu.com [95.215.58.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DAD4968FE
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 12:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791376578; cv=none; b=bSVGD3Da6JdXSnMxYyYO0i25ZYkYKLLMYaV41l70ukkdyNXGGASAFz8fZUmUFYlGlZW3AzUCziTWZgd8v6pc6YV7WxOHCnWLrJsccaTqssq366A1xrsYpCq5znIubkt8CFbPT8AKII0u/RDqwbH4O+6k6aW7h18jpaJtO6m3gI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791376578; c=relaxed/simple;
	bh=ePmOP/7aDoYOtVlnmqC/U+uK2/Ey4hcyToI1BB4hIq0=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=ED+epFRPl2Z8hhbVMa0gb+QamAWcB78bk/W/9J3utzU/NoVUUGS44DBiVg9ZdI4HxQKAohZlIvtTPbIS7Qr0TWHvtL1FNOWlzS5pedgye23vUpi9qcP8LQujzmNsrzRysQPngG6CLgkkYRBNP1jIBS6OXuB19U9tfAFt9kymB60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow-tech.com; spf=pass smtp.mailfrom=cknow-tech.com; dkim=pass (2048-bit key) header.d=cknow-tech.com header.i=@cknow-tech.com header.b=NwiowIgx; arc=none smtp.client-ip=95.215.58.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow-tech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow-tech.com header.i=@cknow-tech.com header.b="NwiowIgx"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ePmOP/7aDoYOtVlnmqC/U+uK2/Ey4hcyToI1BB4hIq0=;
 c=simple/simple; d=cknow-tech.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791376564; v=1; x=1791981364;
 b=NwiowIgxFkO9Zw/arhNawihfFQu7WD7IFri0CIaZS6LqQPse48zDeaA9YvS2mtOhZ5unjVkp
 8S42UJ19XGyuN3qaV7GgIhAp4chZZxPDuMnyHw/23PBmvIBUQYHulG7Xpp7XfPcOEhigXS9/qBN
 Yn++qAcidl2R4n5biD8/miqGVBYI4y6iyP427yZFJH4z02rwM4UfWnEQKsXrCl0WUM8vgS8RXnx
 Pajx09Ow0B6ncPb03HeBcD3AFCXFUqoi5QlwQAXHFIgZGtbFEaHddNBrlDbLwPw4/d4znLuNZw5
 QO+dLoMdLAozsmlrDHmWdAAx8+xr2EYkriE3xr0k1nkoA==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a5dac2602c68c496;
	Wed, 07 Oct 2026 12:33:38 +0000
X-Mizu-Trace-ID: a5dac2602c68c496
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 07 Oct 2026 14:33:37 +0200
Message-Id: <DLYLXXBUOUF1.2KZNF19JFRFBW@cknow-tech.com>
Cc: "Diederik de Haas" <diederik@cknow-tech.com>, "Emmanuel Grumbach"
 <emmanuel.grumbach@intel.com>, <linux-wireless@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wifi: nl80211: don't WARN on a missing self-managed
 regdom
From: "Diederik de Haas" <diederik@cknow-tech.com>
To: =?utf-8?q?Fran=C3=A7ois_Roux?= <franzelfranzel@gmail.com>, "Johannes
 Berg" <johannes@sipsolutions.net>
X-Mailer: aerc 0.22.0-31-g5c1c510d2b65
References: <20261006161744.3804-1-franzelfranzel@gmail.com>
In-Reply-To: <20261006161744.3804-1-franzelfranzel@gmail.com>

Hi Fran=C3=A7ois,=20

On Tue Oct 6, 2026 at 6:17 PM CEST, Fran=C3=A7ois Roux wrote:
> nl80211_get_reg_do() has a WARN_ON() for a self-managed wiphy without a
> private regdomain. Userspace can trigger it with a plain
> NL80211_CMD_GET_REG request.
>
> Drivers can register such a wiphy first and set its regdomain later.
> ath12k, for example, calls ieee80211_register_hw() and only then applies
> the regdomain with ath12k_regd_update(). iwd queries the regdomain of a
> new wiphy as soon as it shows up, so it can hit that window at boot:
>
>   WARNING: net/wireless/nl80211.c:10828 at nl80211_get_reg_do+0x1d0/0x1fc=
 [cfg80211], CPU#5: iwd/721
>   Call trace:
>    nl80211_get_reg_do+0x1d0/0x1fc [cfg80211] (P)
>    genl_family_rcv_msg_doit+0xd0/0x138
>    genl_rcv_msg+0x58/0xd4
>    netlink_rcv_skb+0x5c/0x140
>    genl_rcv+0x34/0x4c
>    netlink_unicast+0x31c/0x39c
>    netlink_sendmsg+0x188/0x400
>
> The same trace has been reported with an Intel BE200 (iwlwifi). The dump
> variant, nl80211_get_reg_dump(), already skips a wiphy without a
> regdomain without warning.
>
> Keep returning -EINVAL, but drop the WARN_ON(). The same change was
> posted in 2021 but was never applied.
>
> Seen on a Microsoft Surface Pro 11 (WCN7850, ath12k) in 3 of 4 boots
> with next-20260929.

Thanks for this patch :-)

I added it to my 7.3-rc6 based kernel and booted into it.
With that kernel but without this patch, I (still) got the stack trace
as I reported earlier. But with this patch applied, I only see the followin=
g
in dmesg when I start ``iwd.service``:

```sh
[   99.031552] ACPI: <n/a>: failed to evaluate _DSM bf0212f2-788f-c64d-a5b3=
-1f738e285ade rev:0 func:0 (0x1001)
[   99.619075] wlan0: authenticate with 20:05:b7:00:29:19 (local address=3D=
f8:cf:52:97:97:58)
[   99.619887] wlan0: send auth to 20:05:b7:00:29:19 (try 1/3)
[   99.622752] wlan0: authenticated
[   99.624881] wlan0: associate with 20:05:b7:00:29:19 (try 1/3)
[   99.627724] wlan0: RX AssocResp from 20:05:b7:00:29:19 (capab=3D0x111 st=
atus=3D0 aid=3D1)
[   99.631005] wlan0: associated
[   99.657741] wlan0: Limiting TX power to 20 (23 - 3) dBm as advertised by=
 20:05:b7:00:29:19
```

Thus no longer a stack trace. So feel free to include my

Tested-by: Diederik de Haas <diederik@cknow-tech.com>  # NanoPC-T6 LTS + In=
tel BE200NGW

Cheers,
  Diederik

> Fixes: 1bdd716cbcca ("cfg80211: return private regdom for self-managed de=
vices")
> Reported-by: Diederik de Haas <diederik@cknow-tech.com>
> Closes: https://lore.kernel.org/all/DL5P72WYQVOQ.23G9D01OY3BAA@cknow-tech=
.com/
> Link: https://lore.kernel.org/all/iwlwifi.20210409123755.ba2ea961f4ae.I8f=
de32d3196e860efa3b4ec464c42194195b42ec@changeid/
> Assisted-by: LLM
> Signed-off-by: Fran=C3=A7ois Roux <franzelfranzel@gmail.com>
> ---
>  net/wireless/nl80211.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index a18240455..2589491af 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -10824,8 +10824,12 @@ static int nl80211_get_reg_do(struct sk_buff *sk=
b, struct genl_info *info)
> =20
>  		regdom =3D get_wiphy_regdom(wiphy);
> =20
> -		/* a self-managed-reg device must have a private regdom */
> -		if (WARN_ON(!regdom && self_managed)) {
> +		/*
> +		 * A self-managed-reg device gets its private regdom from the
> +		 * driver, which may happen only after the wiphy is registered.
> +		 * Userspace can ask before that, so don't WARN.
> +		 */
> +		if (!regdom && self_managed) {
>  			err =3D -EINVAL;
>  			goto nla_put_failure_rcu;
>  		}
>
> base-commit: 6474fa070f2b8013b4b87350b775b8c3be6e8aac


