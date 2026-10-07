Received: from mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A90D299929
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 15:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791386319; cv=none; b=XHVZ7gWhzInNmydR8tJSMCgjo1svoSZLHrharUtVgmkH+qxpXcispT82nMHNSPFgSRnqGtDOanyzX1/zR1FC+++XJeIAveP7xoe/cIz4ursyLyW+cM8kc7XcMnYFk3FaPFrG9NNySU0raJX9ws5wmNggJtnZ76cJVQC+yyqQygM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791386319; c=relaxed/simple;
	bh=WfxnmXqZPqJh+A0ek5itXOZf1C/VdEvpiu7rHAaTZkI=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=BKVbQxqagbX44y1Fjzi0so320gblYZxFc/oWBqHGokq2ylovbXMcRK4JnfnlvQjmnxDydTr2y7hqN+2D8hg1VKS6iR2TABbcTLHInk4a1OdtQsauNBk/XJqVcln7OhHv+Upxp34xHnvmPQOU6LobhlH5QlDR8arQyL5DUgkbHEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow-tech.com; spf=pass smtp.mailfrom=cknow-tech.com; dkim=pass (2048-bit key) header.d=cknow-tech.com header.i=@cknow-tech.com header.b=mRkVORWC; arc=none smtp.client-ip=91.218.175.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow-tech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow-tech.com header.i=@cknow-tech.com header.b="mRkVORWC"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=WfxnmXqZPqJh+A0ek5itXOZf1C/VdEvpiu7rHAaTZkI=;
 c=simple/simple; d=cknow-tech.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791386311; v=1; x=1791991111;
 b=mRkVORWC1hIwSlDe5LyEe/cFGPbPCpSCPPUsgYQ1gop4V05yPW5B+toI0MqCl9zjMTzxbSc6
 dfLg73/1xL6PcJ6v5zQUUa91k3i8t0rL8F4AHpnGz1FRtQXOvBFVM0Xqrd3wAxyVy37ktKU9inS
 xmmyAt1UyY7dZU2o2/oyDfRH5bf1/oucveROG04sEyBgfJcoH5SQ9IdzfBdbr3UfeV4qqENaohc
 Sz+2o5mpaJfGl52Mft6xL0GjRRigM5/eYoVeKV3YnExvGMjehBfwRVsMQzM6jn+ZPqhKE5qd1XM
 PyA5dutcgTMOXs5TWm7W/3WzgMPUwhrVtyz6K2SvuscmA==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b441c3345877503e;
	Wed, 07 Oct 2026 15:18:21 +0000
X-Mizu-Trace-ID: b441c3345877503e
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 07 Oct 2026 17:18:19 +0200
Message-Id: <DLYPG0VDLX08.36QEI8PELLHV@cknow-tech.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
 =?utf-8?q?Fran=C3=A7ois_Roux?= <franzelfranzel@gmail.com>
Cc: "Diederik de Haas" <diederik@cknow-tech.com>, "Emmanuel Grumbach"
 <emmanuel.grumbach@intel.com>, <linux-wireless@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wifi: nl80211: don't WARN on a missing self-managed
 regdom
From: "Diederik de Haas" <diederik@cknow-tech.com>
X-Mailer: aerc 0.22.0-31-g5c1c510d2b65
References: <20261006161744.3804-1-franzelfranzel@gmail.com>
 <16aa99921c4e92e8d4da3c84aacbec2e673666aa.camel@sipsolutions.net>
In-Reply-To: <16aa99921c4e92e8d4da3c84aacbec2e673666aa.camel@sipsolutions.net>

On Wed Oct 7, 2026 at 4:55 PM CEST, Johannes Berg wrote:
> On Tue, 2026-10-06 at 18:17 +0200, Fran=C3=A7ois Roux wrote:
>> nl80211_get_reg_do() has a WARN_ON() for a self-managed wiphy without a
>> private regdomain. Userspace can trigger it with a plain
>> NL80211_CMD_GET_REG request.
>>=20
>> Drivers can register such a wiphy first and set its regdomain later.
>> ath12k, for example, calls ieee80211_register_hw() and only then applies
>> the regdomain with ath12k_regd_update(). iwd queries the regdomain of a
>> new wiphy as soon as it shows up, so it can hit that window at boot:
>>=20
>>   WARNING: net/wireless/nl80211.c:10828 at nl80211_get_reg_do+0x1d0/0x1f=
c [cfg80211], CPU#5: iwd/721
>
> I'm not a fan of this, I think the drivers should have the regdom ready.
>
>> The same trace has been reported with an Intel BE200 (iwlwifi).
>
> I _thought_ we fixed that issue.

If that fix is supposed to be in 7.3-rc6 (from Linus), then no.
If that's a recent fix/patch which is f.e. slated for -next/7.4(-rc1),
then can you point me to it? Happy to test it.

Before I reported the/my issue with Intel BE200 [1] I did search a bit
on the linux-wireless ML and saw some patches where ACPI was an (important?=
)
part. That's why I (so) explicitly mentioned that my system does NOT have
an ACPI based firmware (but U-Boot (with TF-A)).

Cheers,
  Diederik

[1] https://lore.kernel.org/linux-wireless/DL5P72WYQVOQ.23G9D01OY3BAA@cknow=
-tech.com/
