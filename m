Received: from mta0.migadu.com (out-164.mta0.migadu.com [91.218.175.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE57411FA7
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 07:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789112475; cv=none; b=fTQAzxaLv/5xYVdifce/mfiCVNdIvrCC+ims+0P0nMG39AryjlQGSI89FfG/3kue+MgDDKiBfS0xG+eSuitBW6ub4YyHMC5ubBEXuRK5rjCDX3OPOcRl2EugAHKAtyE/LeWajTJHCXhwCf2IcYvHFiIu0QBoNprhPlp4MPE+VMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789112475; c=relaxed/simple;
	bh=hjsUTDS0aUfhWrQcW8ActP7iZuTl1bW/eidquzAMAC8=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=QnBbHzNw/4yz8LDxTLpNhLgpayfs8vdX8wTjl84fPe/lP73MxzdCiqntR1FkHs5IuP9jE+4203MNXvad8gzVtUEAT9jGqUdqJkaHoJ8ib2U3epaFo0O12ksx0cysy9dS7xyJbVhjEyBmpSUQirKIz6eqMWuKV3scyWwpPVdl264=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TopX4yvy; arc=none smtp.client-ip=91.218.175.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TopX4yvy"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=hjsUTDS0aUfhWrQcW8ActP7iZuTl1bW/eidquzAMAC8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789112470; v=1; x=1789717270;
 b=TopX4yvyCEzW4bZ8Qqigd/9cJBpUsNWFPZweIhgrwXovHWoWCBjlWGeG7Yw0/pEQ7oWUYY4a
 +c6F8StRMNIQC8w58MtsSlNDCpp8OTvhf8uqkLiURXclqH89JHJ5b1vhRtyYX8w9fF79RnkJotN
 Z3gHcbBgYurg/6Pn1kJdyWmE=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 357b0a632a779fc6;
	Fri, 11 Sep 2026 07:41:00 +0000
X-Mizu-Trace-ID: 357b0a632a779fc6
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 11 Sep 2026 09:40:55 +0200
Message-Id: <DLCBFNKN09SW.2SIEDXTB4PGJD@linux.dev>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH v11 4/7] wifi: rtw88: sdio: zero the padding added to a
 TX transfer
From: "Luka Gejak" <luka.gejak@linux.dev>
To: "Ping-Ke Shih" <pkshih@realtek.com>, "Luka Gejak" <luka.gejak@linux.dev>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260909074556.55709-1-luka.gejak@linux.dev>
 <20260909074556.55709-5-luka.gejak@linux.dev>
 <d6507fd0447c4c09a9c80bb57dfef35c@realtek.com>
 <DLBQ2H40DC71.2Z3B32X9JQ17I@linux.dev>
 <DLBR915C5L0S.1TEYXZ8LADNTH@linux.dev>
 <2294d792e937441fbf4ef8169c03df18@realtek.com>
 <a17a665d7d4c47fbb33e038d122ed200@realtek.com>
In-Reply-To: <a17a665d7d4c47fbb33e038d122ed200@realtek.com>

On Fri Sep 11, 2026 at 2:53 AM CEST, Ping-Ke Shih wrote:
> Ping-Ke Shih <pkshih@realtek.com> wrote:
>> Luka Gejak <luka.gejak@linux.dev> wrote:
>> > mac80211 reserves IEEE80211_ENCRYPT_TAILROOM, 18 bytes, and offers
>> > no way for a driver to ask for more on TX; extra_tx_headroom is headro=
om
>> > and extra_beacon_tailroom is beacons only.
>>=20
>> You can modify mac80211 to reserve larger ndev->needed_tailroom to
>> see if it can really resolve the symptom. If so, you can propose
>> to add fields for tailroom like headroom:
>>=20
>>   struct ieee80211_hw:: extra_tx_tailroom
>>   struct ieee80211_local:: tx_headroom
>>=20
>
> Note that the ndev->needed_tailroom isn't guaranteed by comments, so doin=
g
> some experiments by normal use case would be helpful to know if it's wort=
h.
>
>  *	@needed_tailroom: Extra tailroom the hardware may need, but not in all
>  *			  cases can this be guaranteed. Some cases also use
>  *			  LL_MAX_HEADER instead to allocate the skb
>
> Ping-Ke

I ran it: one line in net/mac80211/iface.c, IEEE80211_ENCRYPT_TAILROOM
+ 512, nothing else. It does not help. Over 60000 frames the average
tailroom went from 106 to 139 bytes against an average pad of 469, and
96% still reallocate.

Your caveat is why, and it is stronger than the comment suggests:
mac80211 never reads ndev->needed_tailroom as the field appears once in
net/mac80211, which is the assignment itself. The only code that acts on
it is skb_ensure_writable_head_tail(), whose one caller is net/dsa/user.c.
And the protocols that do honour it read it when they allocate, which TCP
never does, which is why only the few non-TCP frames moved the average.

So that tested the wrong knob rather than the idea.

Your fields do work. I built them and measured it. ieee80211_skb_resize()
is the only place on the TX path that grows tailroom, and it derives
tail_need from IEEE80211_ENCRYPT_TAILROOM alone, gated on the frame
needing software crypto tailroom, which is false for data frames under
hardware CCMP. The headroom side is already what you describe:
hw.extra_tx_headroom folds into local->tx_headroom and both callers add
it into head_need. Adding hw.extra_tx_tailroom, folding it into a new
local->tx_tailroom and adding that to tail_need outside the crypto gate
delivers the tailroom. One further piece is needed: ieee80211_build_hdr()
skips the resize entirely when it wants no headroom and the skb is not
cloned, so that condition has to widen as well.

With the driver asking for one SDIO block, frames arriving short of
tailroom go from 29056 in 30000 to 1 in 30000, and uplink is about 6%
faster in an interleaved A/B.

One caveat though: this does not remove the reallocation, it moves it.
pskb_expand_head() is called just as often, from ieee80211_skb_resize()
now instead of from __skb_pad() in the driver. The driver side becomes
much cheaper, 445 ms of __skb_pad per 20 s run against 82 ms, and total
time in pskb_expand_head falls by about a third, but whole system CPU
does not drop. The gain looks like moving the work off the SDIO critical
path rather than doing less of it.

I can write that up for Johannes as a separate mac80211 patch, with the
rtw88 side as a follow up. It is independent of this series, but considerin=
g
your question was about CPU usage and this change doesn't overall reduce it=
,
it is probably not worth it.

Best regards,
Luka Gejak
