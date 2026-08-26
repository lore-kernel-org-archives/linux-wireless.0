Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9060C48CD4B
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 22:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787784978; cv=none; b=AU6gEafbb1XgHnS3hTlc/p+E+QbeC//hKIlKNkWtDgY8bpdXl4+8X7CWGDp2uFOXtVf46XMeC5xtSiII3A4FyY6lUCSFc+/ERTyLaoHIAcNrMUfmguHkKmBOX3KKSA5Yf4AadJHylxY5hSjbP5DqjCJTEIc/wOAVR3bLi2ZAYEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787784978; c=relaxed/simple;
	bh=PxKVj0IZYUWnD0NHQEJRF3DazD5DkRTD5M50t+bhIzw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=ldFJo55vZu1Nkrjwd128Eb9vJ7EfXFVGNkx+VRnuzzi7Il/qqzPjOtwEewVL192m319BXdZzlvFUK77bmh+YDkBsLexXCeg2F3tW9/kKEpETjoN9Hn0bLB3SoGiyN1IsjrzUjselHOEXFidJGoXK2rLNmOEk/H/WxU/AeKQTXwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=NpFBhOA2; arc=none smtp.client-ip=67.231.154.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="NpFBhOA2"
Received: from dispatch1-us1.ppe-hosted.com (ip6-localhost [127.0.0.1])
	by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 4DE2C5084DA
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 22:56:08 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 1D0DB8006D;
	Wed, 26 Aug 2026 22:55:59 +0000 (UTC)
Received: from smtpclient.apple (unknown [74.244.233.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id 1948013C2B0;
	Wed, 26 Aug 2026 15:55:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 1948013C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1787784956;
	bh=PxKVj0IZYUWnD0NHQEJRF3DazD5DkRTD5M50t+bhIzw=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=NpFBhOA2VTHwVLj3Fb/QxByrZ6AV5AEIX//E78Xtx+pMgFE5ItZdHifUr89i680iP
	 XgMzMdYDrVpuUxvJJNcBqb5t/DTVBJk17sE6oZnEPtUDbFPhhXT4SB7H5bmaG6irpU
	 vDJvcsAYUO+j4MqaAfwbbUVEyxm3aK2Zcg6QhcNE=
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: mac80211: HT disabled ("required MCSes not supported") on Xfinity
 network, RTL8852BE (rtw89) capped at ~20 Mbps on kernel 7.0.0
From: Alex Gavin <alex.gavin@candelatech.com>
In-Reply-To: <CAFE5c2sfBBn+z-epYGffZskffGbcpafmD020-j-NK0waQ_QFwg@mail.gmail.com>
Date: Wed, 26 Aug 2026 15:55:41 -0700
Cc: linux-wireless@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <3189233C-6DAC-4B98-925B-714556C5960C@candelatech.com>
References: <CAFE5c2sfBBn+z-epYGffZskffGbcpafmD020-j-NK0waQ_QFwg@mail.gmail.com>
To: Noah Yacob <noahgyacob@gmail.com>
X-Mailer: Apple Mail (2.3864.500.181)
X-MDID: 1787784959-jmhi_MSirn0Q
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1787784959;jmhi_MSirn0Q;<alex.gavin@candelatech.com>;fae81877abc83abcb8480b195aa61617
X-PPE-TRUSTED: V=1;DIR=OUT;

> On Aug 26, 2026, at 1:57=E2=80=AFPM, Noah Yacob <noahgyacob@gmail.com> =
wrote:
>=20
> Hello,
>=20
> I'm reporting a throughput regression that appears to match an issue
> discussed on the Arch Linux forums
> (https://bbs.archlinux.org/viewtopic.php?id=3D313033), where other =
users
> ran into the same symptom.
>=20
> - Wi-Fi throughput dropped from near-gigabit speeds to a hard ~20 Mbps =
cap.
> - Confirmed not an ISP or router issue: booting an older kernel
> (6.8.0-138-generic) on the same machine, same hardware, same network,
> restores normal (near-plan) speeds.
> - Confirmed not a driver-installation issue: the in-tree rtw89 driver
> is in use in both cases (no custom/out-of-tree driver).
> - The regression is reproducible simply by booting the newer kernel
> vs. the older one -- no other configuration changed.
>=20
> Hardware / environment:
> - Wi-Fi chipset: Realtek RTL8852BE (rtw89, rtw8852be), PCIe
> - Driver in use: in-tree rtw89 (rtw89_8852be / rtw89_pci / rtw89_core
> / mac80211 / cfg80211)
> - Firmware: rtw8852b_fw-1.bin, version 0.29.29.5 (da87cccd), cmd =
version 0
> - OS: Linux Mint
> - Broken kernel: 7.0.0-30-generic
> - Working kernel: 6.8.0-138-generic (confirmed via dpkg -l | grep
> linux-image and booting via GRUB "Advanced options")
> - ISP: Comcast Xfinity, 1 Gbps plan
>=20
> Symptom pattern:
> On the affected kernel, dmesg / journal shows mac80211 disabling HT
> ("required MCSes not supported, disabling HT"), and the link
> negotiates down to a 20 MHz, no-HT connection instead of HT/VHT/HE,
> which caps throughput at roughly 20 Mbps regardless of my ISP plan
> speed.
>=20
> The fix that resolved this for other users in the linked Arch thread
> is a community patch that removes mac80211's basic MCS/NSS check
> (github.com/WoodyWoodster/mac80211-mcs-patch). That fix has since been
> picked up into Arch's own kernel package as of version 7.0.13.
>=20
> I'm submitting this to add a confirmed data point (RTL8852BE, kernel
> 7.0.0, Xfinity) in case it's useful for tracking or prioritizing a fix
> upstream.
>=20
> Happy to provide any other diagnostics that would help.

Per my understanding, this should be resolved by an April patch
which reduced the strictness of HT IE checks to accomodate this.
Link here [1].

I believe this landed in Linux v7.1 and was included in v6.18
and v7.0 releases from v6.18.36 [2] and v7.0.13 [3], respectively.

Best,

Alex

[1] =
https://lore.kernel.org/linux-wireless/99Mv9QEceyPrQhSP52MtAVmz0_kWJmzqotJ=
jD9YW6LGLqk-AZloAueUyHCURilFkuqOh6Ecv8i2KKdSE1ujP3AnbU5QEouVisT1w_V3xdfc=3D=
@r26.me/
[2] https://lore.kernel.org/stable/2026061933-uproar-snarl-100e@gregkh/
[3] =
https://lore.kernel.org/stable/2026061959-baguette-handler-82ab@gregkh/

