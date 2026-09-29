Received: from mta1.migadu.com (out-115.mta1.migadu.com [95.215.58.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD6A417377
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 06:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790663187; cv=none; b=PV4dPa1gfvlGxrhCeWaj7Zjxtcitl/jHRU8hugzB2Ia8ZLh0/D7b0du/dOEISIn222S7c0EJrr/PGPpEItEYZ8NTHWrzM4ExPvIIvIljdyx9nawmlEoRzXxlVTL4269T5FUo0Z4YcVnusz2dnj//yfFCLOlHIQgIa26s0LC8Lz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790663187; c=relaxed/simple;
	bh=jUvogs66QM3UZRwtzv4kECXAX0N6N/SMMnyGrD9T0CA=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=XLkq3SZbWGRCzvt/kmfvn/9GrSnT2BOd68a/zZskj6u3lsLQkPK07qoOL4LN+vXJ4DM8UdMJGEynn/rvrLvAXaFc5BaZwewQI5Cedpda4hMwFS1Q1FKYlx92TN+YVaOuTY1wGcRLZ2hEkA7VoMbkiTW89PA3Koewv2e9UgoqR8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tX35khiy; arc=none smtp.client-ip=95.215.58.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tX35khiy"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=jUvogs66QM3UZRwtzv4kECXAX0N6N/SMMnyGrD9T0CA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790663184; v=1; x=1791267984;
 b=tX35khiydvqA9iiJWTKsPwJZ+EXl/6OhY/22BHbmsX/L3K8BPqsY8fMgLxbgCVEL/nUhziNg
 E7yA8OwYJBHcJrAcDkQtFFC3Plci/w4kW09A2qooJL/5kzIKTqGsnvOuruNVumP3BLfA9mXjenD
 Dvk/xi+BEyGhM8yM6p+jexvQ=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d177fc393ae7c2b3;
	Tue, 29 Sep 2026 06:26:24 +0000
X-Mizu-Trace-ID: d177fc393ae7c2b3
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 29 Sep 2026 06:26:19 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <a941bc47f9ba62ca4f360e9552df1ff80a08a388@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v3 3/6] wifi: rtw88: 8723b: add the RTL8723B chip driver
To: "Ping-Ke Shih" <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael  
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 luka.gejak@linux.dev
In-Reply-To: <78faacdc2ba04d48b663c91194f04bc8@realtek.com>
References: <20260921154347.82317-1-luka.gejak@linux.dev>
 <20260921154347.82317-4-luka.gejak@linux.dev>
 <39da13e5cdd840f5a5ab86ded478d07c@realtek.com>
 <DLN10FU8L1PQ.3NK0M6NVQ3Y53@linux.dev>
 <304bbb9a43a74e909eec0dd84d86d528@realtek.com>
 <92337f29a7dd8d517c2037e857e13eb2612e10e7@linux.dev>
 <78faacdc2ba04d48b663c91194f04bc8@realtek.com>

September 29, 2026 at 04:04, "Ping-Ke Shih" <pkshih@realtek.com mailto:pk=
shih@realtek.com?to=3D%22Ping-Ke%20Shih%22%20%3Cpkshih%40realtek.com%3E >=
 wrote:


>=20
>=20Luka Gejak <luka.gejak@linux.dev> wrote:
>=20
>=20>=20
>=20> Hi Ping-Ke,
> >=20=20
>=20>  September 24, 2026 at 06:11, "Ping-Ke Shih" <pkshih@realtek.com> w=
rote:
> >=20
>=20>  Luka Gejak <luka.gejak@linux.dev> wrote:
> >=20=20
>=20>  Answers in the order of your mail. The MAINTAINERS point is in a
> >  separate reply.
> >=20=20
>=20>  Can you also review other RTL8723B specific functions? I didn't re=
view
> >  them one by one by v3, but I wonder why it needs specific functions,
> >  not common flow. If any of them is necessary, please point out reaso=
ns.
> >=20
>=20>  By the way, I didn't only mention these three functions. At here t=
here
> >  are many specific functions. Please analyze them.
> >  (Honestly, I don't fully re-examinate your analysis in detail, and
> >  believe your results.)
> >=20=20
>=20>  I went through the whole file. The part that is already common flo=
w can
> >  be listed exactly, because those ops point at shared code:
> >=20=20
>=20>  power_on, power_off rtw_power_on, rtw_power_off
> >  mac_postinit rtw8723x_mac_postinit
> >  set_tx_power_index rtw8723x_set_tx_power_index
> >  false_alarm_statistics rtw8723x_false_alarm_statistics
> >  read_rf, write_rf rtw_phy_read_rf_sipi,
> >  rtw_phy_write_rf_reg_sipi
> >  read_efuse rtw8723x_read_efuse, plus the hardware
> >  capability, because this chip has no
> >  hardware feature report: the firmware
> >  reports id 0xfd instead of the C2H
> >  efuse_grant rtw8723x_efuse_grant, plus the 0x6b BT
> >  power cut and output isolation write that
> >  the vendor efuse path does
> >=20
>=20I think you have checked them. Please reconsider to rewrite them.=20
>=20
> As Johannes mentioned, LLM is a tool, but please not fully believe
> and rely on it. LLM can generate a lot of stuff, but I read by my
> eyes and then think and type by my hands. To understand and rework
> stuff generated by LLM is submitter's business.
>=20
>=20>=20
>=20> I think the better way is to assign proper rtwdev->hal.rcr per chip
> >  in rtw_core_init().
> >=20
>=20[..]
>=20
>=20>=20
>=20> If you prefer, I can put the core change in a small patch before th=
e
> >  chip series rather than in patch 3, so the chip series stays free of
> >  core changes.
> >=20
>=20Yes, that'd be good.=20
>=20
> The 8723BS specific stuff should do in the kind of rewriting.=20

Understood,=20already did while addressing Bitterblue's comments.

>=20
>=20>=20
>=20> Can you reuse the existing since they are the same?
> >=20
>=20I think I can refer a common rule...=20
>=20
> >=20
>=20> (Please quote the code; to reply to this, I need to switch to your
> >  patches again).
> >  On your last sentence, that the reason is hard to explain later if i=
t is
> >  not written down: whatever we change will carry its reason in the co=
de
> >  or in the commit message, not only in this mail. The same goes for t=
he
> >  two things I am asking to keep, cfg_ldo25() and the RESP_SIFS writes=
,
> >  which will say why they are there.
> >=20
>=20It is still hard to me to recall what I wrote at last sentence...
>=20
>=20Let's follow Bitterblue's comments on v4, and move to v5.
>=20
>=20I noted the copyright aren't all consistent. Check them yourself.

I noticed that too, and fixed it in v5. I will send it together with
other replys to Bitterblue's comments today.

>=20
>=20Ping-Ke
>
