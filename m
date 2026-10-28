Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.255.225.202
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208929;
	b=hYOe6XiuNCE6NYYDport6+Vsi2dKnSmuLrzgEqJOpUMNzslQHB6sMuo/Py4Ai/Aiv8/1
	 Nxricc+K8O0knjQdvSAR1Xy7m2/sORmN6E+DbbMrhP9NK/MZg0l05SNodxUbvL+npg1GP
	 1RF1GKhpdZqVfcWY5RjLfMkM4yyVbasMV/8QSHRhq5Iyilb4CA0QlxziObc2FrRGGM5MN
	 JYzu9ZSo5zp2XfFaZTQd+PvTUGI+3dEeD+Bepuf0QRWqVQVf4iQIX8/PKCZ25xfA68zjH
	 Zuw3a106XSNX1viyKHIpP3Zj1WK0+lJzdFcmhkpdQqaQLye6Z2wpcX8kDcBkre6PgCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208929;
	h=DMARC-Filter:Received:DKIM-Signature:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ThreatScanner-Verdict:X-IPAS-Result:IronPort-PHdr:
	 IronPort-Data:IronPort-HdrOrdr:X-Talos-CUID:X-Talos-MUID:
	 X-IronPort-Anti-Spam-Filtered:X-IronPort-AV:Received:Received:Date:
	 From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=trN9sfkyUF5lmYW35ov02jIT/bOiVDmYEcGexehOUmk=;
	b=S7lKRkTfvD2uHxRbUE9u0yAwiinBZiiX2R0Jh8W583IXVs3eBqwzh3+/+NsOG7noSVKM
	 3iUBcRAkmL45eKvnyrKe0krwvKemSPj7phF5aolJGUsDnV8vXF361j2GC36QutuYZ/Z75
	 1DVvm+2VeOvkStxtfUv5iQlnHCPnbGcoAa6msrT/lV2hLATO7r178FV+vgLtndkxt332N
	 6G9wAQzz4vcXDo4zMBQ7LoM1V8fYJkwWGXzzH1uH0/CTYB5+hFsWdUIqu1Bf0QeN9hIkH
	 U0S3yxsfi0ByGCYUHqRp7EAQa0B+8AwE/bGhpgUlEHyznygq59P7q4ELrUfXWX6VexA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=pobox.sk;
	spf=pass smtp.mailfrom=pobox.sk;
	dkim=pass header.d=pobox.sk header.i=@pobox.sk header.a=rsa-sha256 header.s=mail header.b=GbOyvRmX;
	arc=none smtp.remote-ip=46.255.225.202
Received: from gmmr-1.centrum.cz (gmmr-1.centrum.cz [46.255.225.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61573606A31D;
	Wed, 28 Oct 2026 17:35:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61573606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pobox.sk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.sk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=pobox.sk header.i=@pobox.sk header.a=rsa-sha256 header.s=mail header.b=GbOyvRmX
Received: from gmmr-1.centrum.cz (localhost [127.0.0.1])
	by gmmr-1.centrum.cz (Postfix) with ESMTP id D902B2BCA9;
	Wed, 28 Oct 2026 18:35:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.sk; s=mail;
	t=1793208921; bh=trN9sfkyUF5lmYW35ov02jIT/bOiVDmYEcGexehOUmk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GbOyvRmXT7iGVTGGmsXavM/uamnqXgLIEZUA7lQP8KpeUE+YusCBAy1arlS313Age
	 TfbjDkNSWmmSAG30+dz8vQVdtm8znObYN000HLpWcyCY3buKTGrF8dB/rXQjmbl5mV
	 g7P2RL7uxGzui3UkXeE572CAD9zOtLiOjUfptBms=
Received: from antispam96.centrum.cz (antispam96.cent [10.30.208.96])
	by gmmr-1.centrum.cz (Postfix) with ESMTP id D74D72326A;
	Wed, 28 Oct 2026 18:35:21 +0100 (CET)
X-CSE-ConnectionGUID: n1+mL73WTAW4rAObaix9Fw==
X-CSE-MsgGUID: wfnk4Q5QShOOUQYpmpBZbA==
X-ThreatScanner-Verdict: Negative
X-IPAS-Result: =?us-ascii?q?A2GtAADsMeJq/0vj/y5aHAEBAQEBAQcBARIBAQQEAQFJg?=
 =?us-ascii?q?TUFAQELAQGDSoFslk9VhSWMcWGEAoZOgX4PAQEBAQEBAQEBCUQNBAEBAwQ4D?=
 =?us-ascii?q?4Q3Ao4dJzYHDgECBAMCAwEBAQEBAQEBAQEBCwEBBgEBAQEBAQYGAQKBHYYJR?=
 =?us-ascii?q?g1JAQEBiTsHBIIIAYEkgSYBAQEBAQEBAQEBAQEdAg1+AQUyAUYQCw0LLhBGB?=
 =?us-ascii?q?hODA4I5AToUtiKBNBoCZdx/FoE0gW4GFYE4AYheAYUDdoR9ggtEhEA+iwgEg?=
 =?us-ascii?q?iKBDJZGUngcA1ksAUsKNQwzckMDgSlLBTdlEj8hHSgeOQI4BgUSIBEZQUNbR?=
 =?us-ascii?q?FWBB11wOylgAQIfJx8tFYF2AoJRgSMHVgIBSUEOB0VTCSVDEkckIggSCQETG?=
 =?us-ascii?q?i4LgRo1RSZBFRhYCxoFGkgIAgsCDHYoERATHiAmMgQDdz03FRkEkwCEOBDJM?=
 =?us-ascii?q?QeEIYRzhy+WGoE3gicBlAwDkm6ZCIwQgXqbOYFuAYIPTYMmATQSQBmXRskoe?=
 =?us-ascii?q?gEBOwcCBw8ChyqIcoILgUwBAQ?=
IronPort-PHdr: A9a23:6BAuhhbo1XpHbbUnyWmFs9n/LTG714qcDmcuAnoPtbtCf+yZ8oj4O
 wSHvLMx1wGPBd+Qsqwd07GempujcFJDyK7JiGoFfp1IWk1NouQttCtkLei7TGbWF7rUVRE8B
 9lIT1R//nu2YgB/Ecf6YEDO8DXptWZBUhrwOhBoKevrB4Xck9q41/yo+53Ufg5EmCexbal9I
 Ri4rAjdrNUajZVtJqosyxbFv2dEdupLzm50OFyfmArx6ci38JN/6Spbpugv99RHUaX0fqQ4S
 aJXATE7OG0r58PlqAfOQxKX6nUTSmsZnQNEDhbK4h/nRpv+vTf0ueR72CmBIM35Vqs0Vii47
 6dqUxDnliEKPCMk/W7Ni8xwiKVboA+9pxF63oXZbp2ZOOZ4c6jAZt4RW3ZPUdhNWCxAGoO8b
 pUAD+wdPeZDsoLxo0ICoQaiCQWwAe/izCJDiH3r0q0gy+kvHwHI0hI+EtwTs3rUotr6O7sPX
 u66zqbF1inDYvBQ3DTj9ITEbgwtreyKULltccTR004vFwbdg1uOrozlOima1v8QuGaF6OpgU
 +KvhHQ6qwFqvDev3Nonh47Vho4P1lDE8iN5wIYvKt2lU050f8SkHYBItyGdLIR2RcwjT3tzu
 CY507ALv4OwcycWxpo93RHfd+CHfJaS4hLlTOucITh2iXJndb+/gxu//0euxvDyW8e701tHq
 jRIn8XQu30R1RHd5MmKR+V580mh2TiC0x3f5+5YLE40laTWN5wsz7gtnZQdtkTDGzX5mETwj
 KKOdUUr5PKo6+L5bbXivJOcMJV0ig74P68zmcK/Gfw1PwcPUmSB5+ix1L3u8VfnTLlUjPA6i
 KvUvZDCKcgGpaO0ABVZ3psi5hu9FTuqzdoVkHsdIF5YeB+Ki47kMEzULv/iF/ewmVGsnS9ux
 /DBI7LuHI3ALmPGkLf9ZbZ97FNcyBYrwdBf+Z1UDrYBLer8Wk/0rdDYFRo5MxCsw+r6FNlxz
 J8RVnyJAq+FKqPSrFqI6vgzLOiNfIMVuTD9JOY55/P2gnI0mEURcbep0JYXcny0AOpqLkeDb
 XfugtoNCWIKsRA/TOzuhl2CSzlTZ3OqUqIg/D07FIWmDYHDRo+3nbyBxzm0HodNa2BeDVCDC
 nDodoqeV/cXayKeOtVhnSAcVbi9V48h0gmjtAnhxLV6NefU/DYXuo/52Nhz/eLTkA89+SRuD
 8uBy2GNU310nmQQSj8q26B/olJyx0yf0ah/gPxXC8Zf6O5KUgsiL57T0/R6C8zuWgLGZtqJT
 FemQtO7ATA+V94xwMEBY1x7G9q8ihDOxDSqA7ALmLyRHpA08bzT32L3J8ljz3bKzq4hj0MpQ
 sdXL22pmrZ/9xTPB47Oi0iZk6eqdaIB3C/C7WuCw2uOvFtGXw50T6rFRmsfa1DIrdT2+EzCV
 aWiCbc5PQtbz86NNK9KZsfujVVcS/fvINLebHmplGeqGRmI3q+MbJbte2gF0yjREFULkwMS/
 XaDLQUwHiivrGzAAjJyCV/hZVvg/vR7qHyhVE870xmHYVV42bSt9RAZneecS+sd3r8coCkvs
 i16Elnul+7RXuaHpAcpXA6MYNc05lsC98kJrQNwOIetKeg2mlkdfixruEDjkRl0XNZui88v+
 U8tyQNpYZ6f1lNIaiiVx9ikJvvLLW/y9Q20ZrT+wlbU18bQ4aRZu6dwkEnqoAz8ThlqyH5gy
 dQAliLEvv33
IronPort-Data: A9a23:T/1O9q/qhuqfU6JW4iEtDrUDh3+TJUtcMsCJ2f8bNWPcYEJGY0x3y
 2FMC2HQb6rbZGf2c9Bwa9i18UNSupeHx9AwS1A6riBEQiMRo6IpJzg4wmQcnc+2BpeeJK6yx
 5xGMrEsFOhtEDmE4EvrauG/xZVF/fngbqLmD+LZMTxGSwZhSSMw4TpugOdRbrRA2LBVOCvT/
 4mtyyHjEAX9gWAtajhEs/7rRC5H5ZwehhtJ4zTSWtgU5Dcyp1FNZLoDKKe4KWfPQ4U8NoaSW
 +bZwbilyXjS9hErB8nNuu6TnpoiH9Y+lSDX4pZnc/DKbipq/0Te4Y5nXBYoUnq7vh3S9zxH4
 I4U6cHvE1dB0prkw4zxWzEAe8130DYvFLXveRBTuuTLp6HKnueFL1yDwyjaMKVBktubD12i+
 tQecXMISk/YuN6f/+6hY85mj8Uzfef0adZ3VnFIlVk1DN4pRNXYRrnSvIce1zo2mtpTGLDVd
 aL1axIzMlKaPkAJYA1ITs1j9AurriCXnzlwtBSJoqw36nXIwRZZyL/nN8qTYd/iqcB9xxfA/
 TqaoDqoav0cHMORzznZyy+Vve/ouh7CaZoXDJeK/Nc/1TV/wURWUnX6T2CTp/O1oki0V5RZI
 kkZkgIyqqs/3FCsTdS7Ux7QiHqFuAMMHtldCes37CmTxafOpQWUHG4JSnhGctNOnMs3QyE6k
 0CIhd7tCCd0mKOaRGjb9bqOqz62fy8PIgc/iTQsEVVDuYS+5ttp0VSQE76PDZKIszE8Ihmoq
 xjikcT0r+x7YRIjv0ljwW36vg==
IronPort-HdrOrdr: A9a23:+28iKKH4AHumQkxNpLqE5ceALOsnbusQ8zAXPo5KJiC9Vvbo8v
 xG+85rsSMc6QxhOk3I9urrBEDtex7hHNtOkO4s1NSZLWrbUQmTTb2KhLGKq1bd8m/FltK1vp
 0PT0ERMrHNMWQ=
X-Talos-CUID: 9a23:P8OIeG18Ufh80rlcj1sKCLxfHJlmd1mCl0jsCnDkE09OQrSUWQ6+5/Yx
X-Talos-MUID: =?us-ascii?q?9a23=3AcBOOYQ06ax5BqArLUXiVqjdx8jUj/KqoCxw0zKw?=
 =?us-ascii?q?9u+6jCBVBIzKFpga9a9py?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.27,183,1787004000"; 
   d="scan'208";a="190304769"
Received: from unknown (HELO gm-smtp10.centrum.cz) ([46.255.227.75])
  by antispam96.centrum.cz with ESMTP; 28 Oct 2026 18:35:21 +0100
Received: from blackbox (188-167-137-159.dynamic.chello.sk [188.167.137.159])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gm-smtp10.centrum.cz (Postfix) with ESMTPSA id 6E45B101612D5;
	Wed, 28 Oct 2026 18:35:21 +0100 (CET)
Date: Wed, 28 Oct 2026 18:35:12 +0100
From: Tomas Tonhauser <t.tonhauser@pobox.sk>
To: Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] wifi: ath9k: clear destination mask for
 non-aggregate frames
Message-ID: <auIyUEqdQIOJqEWp@blackbox>
References: <20261003192957.761090-1-t.tonhauser@pobox.sk>
 <87mrs9v3aa.fsf@toke.dk>
 <atufwCYLtoF3UaMk@blackbox>
 <87jyn7pk5v.fsf@toke.dk>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87jyn7pk5v.fsf@toke.dk>

On Sat, Oct 24, 2026 at 10:39:08AM +0200, Toke Høiland-Jørgensen wrote:
> Alright, sounds good!

v2 is out, as a two-patch series:
https://lore.kernel.org/linux-wireless/20261028171652.1125692-1-t.tonhauser@pobox.sk/T/

Tomas

> 
> -Toke
