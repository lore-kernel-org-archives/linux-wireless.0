Received: from mail-10625.protonmail.ch (mail-10625.protonmail.ch [79.135.106.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9203B3C1D64
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 15:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791128943; cv=none; b=V1AOULk2uNS49AOHIfLhyLv+AMOTJBkMkz4h64RKg9nE5xwRyhp1yLy5KJN59UPAvLvje3uOB6MYcru+x0Ba52bSbpnhrhiRccmp/oJLx8yzu3BS45ACVD1vXPa1W7hCUfQDNgEXz3/t0tGAb5n0TC9VJVm4rn+/KZqvTRutLqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791128943; c=relaxed/simple;
	bh=PSwX767EX2hv++AzjqVtR+pkDkn+2Zh68DAKmSvkEZk=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qDS6maIp2Ru+DCclU7htpdXKTFC/4iFBMIBCPRtslrqGQxa2tN3YNGaYaKIwZBtVaYuzwDNBGnE+WPGy7bf3Y7jncMLuDwDIPVGrPbGsFCbBD7ytKQMKLRM99QWXEblC7UWJ9V+rm5EMHGlMhz+nnQZ6JuNQvW/xMDKkTbZivF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=empyreal.works; spf=pass smtp.mailfrom=empyreal.works; dkim=pass (2048-bit key) header.d=empyreal.works header.i=@empyreal.works header.b=eJWb1H6O; arc=none smtp.client-ip=79.135.106.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=empyreal.works
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=empyreal.works
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=empyreal.works header.i=@empyreal.works header.b="eJWb1H6O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=empyreal.works;
	s=protonmail2; t=1791128931; x=1791388131;
	bh=+/0FuyjeQsYFjCtLeb2mZ7Wmen6qfLAL/oZbGoTM/pA=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=eJWb1H6OTPecUADa6nw+pV8dNcWCkKO+AP5TZ0rYPtd9JjqVtPImdRxa/cNCzjS+t
	 9viarozwyukgXTNCta0sB7Y1Kkh8hOJOcmqVaojv9QtHDGPU9d+Hn6gSUF/4Gp8/hI
	 6c0l1rtpxwlZlnhjO4StSqkO/ls8EBHNsxYM6aiLjmMJBqS2PdflBwuKr0PhgiN8jK
	 BTFKtt/mSHYzlEDj4C4V++3jzCiIvqATq4q1Wl7qd20v34ebciecNn9LK1kcQiQHIy
	 aA40/loTRIn+Kuh72K9nP57MSVA4cgUt2hsQIyCpBllpI+VI8701YFI2y5Cmsynrmi
	 d0GIX4NpSnBkA==
Date: Sun, 04 Oct 2026 15:48:46 +0000
To: linux-wireless@vger.kernel.org, Devin Wittmayer <lucid_duck@justthetip.ca>, Jonas Hort <jonas.hort@posteo.de>
From: Andrei Rusu de Castro <arc@empyreal.works>
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, Sean Wang <sean.wang@kernel.org>, Thorsten Leemhuis <regressions@leemhuis.info>, regressions@lists.linux.dev, linux-mediatek@lists.infradead.org
Subject: Re: [REGRESSION] mt7925: MLO connectivity silently stalls with 6GHz link active
Message-ID: <20261004-mt7925-mld-v2-results-248bb5e6404f@empyreal.works>
In-Reply-To: <20261003180334.83575-1-lucid_duck@justthetip.ca>
References: <503eb10e-80cf-493e-95fd-04fc0f94ce01@posteo.de> <e4bc5ce3-9a6f-4365-9d36-f6440ded0865@posteo.de> <c64f5fa6-4c61-45b6-a513-b971e59d7723@posteo.de> <476e7721-580e-4a6b-86e5-5ed782a2c7ec@leemhuis.info> <c9f984c4-e3c4-4e41-a502-99db97ce724b@posteo.de> <20260829221319.25334-1-lucid_duck@justthetip.ca> <d245c4b1-dfba-4507-85a2-c6883f5eae64@posteo.de> <20261003180334.83575-1-lucid_duck@justthetip.ca>
Feedback-ID: 182420409:user:proton
X-Pm-Message-ID: d7a7a36871321b653cf873e4cac33e3ba5ee9992
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Devin, Jonas,

I reproduced the stall with my September patch on an MT7925 PCIe Z13
and traced the station commands sent to firmware. The missing case was
the primary update inside secondary link addition.

mt7925_mac_link_sta_add() updates the primary WCID first, then the new
secondary WCID. The new secondary is not in msta->link[] or valid_links
until both commands succeed. My first patch included an unpublished
link only when that link was the subject of the current command. It
therefore still sent a one-link MLD description to the primary WCID,
followed by a two-link description to the secondary WCID.

These are the captured fields during secondary addition, omitting an
earlier primary-only association update:

                           command WCID   count   entries (WCID/BSS)
  September patch                1          1     1/0
                                 2          2     1/0, 2/1
  September patch + early        1          2     1/0, 2/1
    link publication             2          2     1/0, 2/1
  v2                             1          2     1/0, 2/1
                                 2          2     1/0, 2/1

V2 passes the initialized pending secondary explicitly through both
station updates, without publishing it early. It keeps the existing
publication-after-success and host error cleanup. It also keeps stable
membership for subsequent updates. There is no new shared pending state.

On Linux 7.3-rc5 with firmware 20260813113118 and an ASUS GT-BE98:

  upstream MLD path           stalled at 157 seconds
  September patch            stalled at 289 seconds; repeated at 150
  v2                         813 seconds, 48 samples, no failures
  v2, second clean boot      812 seconds, no sustained stall under
                              20 Mbit/s traffic in each direction

The AP advertises three links. The active client pair was 5+6 GHz
(active_links=3D0x3, valid_links=3D0x7). Failed runs had roughly 27-second
full-band scans; both v2 runs returned to roughly 6.3-7.1 seconds.
The second v2 run transferred about 1.9 GB in each direction over 760
seconds. It had one gateway-ping timeout after a neighbor flush, with
REACHABLE neighbor state and successful IP/HTTPS probes in the same
sample, so it did not pass the strict zero-failure gate. Traffic did not
enter the persistent associated-but-dead state.

Tests used the in-tree driver plus the selected fix, with the separate
scheduled-scan withdrawal and WM2 reset correction held constant. Other
local platform patches did not change between these arms. My production
variant additionally retains the applicable local safety guards in a
separate patch; those guards are not part of this submission. That
variant passed the full zero-failure gate on two PCIe Z13 machines
(813 and 810 seconds), and both booted it successfully as their normal
default. Five ordinary reconnects also passed on the first local variant.

The changed objects build with W=3D1 and -Werror on both the tested rc5
source and the current mt76 integration branch. Source-extracted fixtures
exercise the pending-link records and host cleanup at eight failing MCU
command positions. Those tests do not establish firmware rollback after
a partly successful add.

Direct debugfs link switches and chip-reset tests exposed failures or
aggregation teardown warnings that also occur with my previous working
full-revert kernel. V2 is not claimed to resolve those. USB hardware and
your exact FritzBox setup have not been tested here.

The v2 posted in reply to this message is based on mt76 commit
0dbc9c9fa9b9. Could you try it on
the setups where the September patch still stalled?

Thanks,
Andrei

