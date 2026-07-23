Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD0F305691;
	Thu, 23 Jul 2026 01:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.132.163.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784771266; cv=none; b=E1WkGAxoTGTb8M+C27GWUxzGN9L7cYqb4Dgcjm7FZvvasuCmY54Z8dVrdO3NaIDP+JLNx8Wt+HfGlkRmewTuHvXQp/qcNc6cgflICRk/dtOR7jW/WU1pHDwP/LUAiRmWKzdisyj0ekTjiTGAnOzvhPnIn1l3XchoGFwSuPJWU5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784771266; c=relaxed/simple;
	bh=CkCD0N5eKYDtP8VmtiMpJNfuGPfsrOwQiLyZZIoZgz4=;
	h=Date:From:To:Cc:Subject:References:Mime-Version:Message-ID:
	 Content-Type; b=sej1Hcn6GqxxO7k5ISPpbgoSQn/Yc0/19FG/S4F7nhqjPhDSUcKiUZtKWmvB4m9ijHWprX0p3MlkZfam+Io4oibzANyzdyJjqzOGc/9TSYmINbxZHJs4uMDZJoJpa9FUZb5H813SYvtwl9na7Va+R5lw8kY/fmmPLffbPdMSeVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=kiQ2JgTw; arc=none smtp.client-ip=18.132.163.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="kiQ2JgTw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784771215;
	bh=CkCD0N5eKYDtP8VmtiMpJNfuGPfsrOwQiLyZZIoZgz4=;
	h=Date:From:To:Subject:Mime-Version:Message-ID;
	b=kiQ2JgTwh/mXt2y/xIzjIMvduAMnBAx/lahZy+EWwXkU+RvYhpn/ricfclpHqlyqI
	 tXzBjjgE3rEkxSZfW/FM4KioXi+9oX2MI3UnwDAcPSdPLE0Cv8XKmbkq2e44oG7rEy
	 4M+4p2vJQdXEAC7TVJAZu0v28VJuGyYTg+O2dwv0=
X-QQ-mid: esmtpsz20t1784771208tf887a9fd
X-QQ-Originating-IP: PaKfn33E4EFRyLbyRcM3Gj6iFB92ntrONRqg5uRBE1A=
Received: from PEN002676 ( [124.126.19.250])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 23 Jul 2026 09:46:46 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 7623040968990130878
Date: Thu, 23 Jul 2026 09:46:47 +0800
From: =?GB2312?B?1dS98MP3?= <zhaojinming@uniontech.com>
To: "Jeff Johnson" <jeff.johnson@oss.qualcomm.com>, 
	baochen.qiang <baochen.qiang@oss.qualcomm.com>, 
	jjohnson <jjohnson@kernel.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>, 
	ath11k <ath11k@lists.infradead.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] wifi: ath11k: fix resource leak on error in ext IRQ setup
References: <20260722095419.1411003-1-zhaojinming@uniontech.com>, 
	<c8634216-e35a-4d01-8f76-d6951e4689b5@oss.qualcomm.com>
X-Priority: 3
X-GUID: F2CAE0A0-F86E-4B50-8EAB-5BCB4BB1C59C
X-Has-Attach: no
X-Mailer: Foxmail 7.2.25.375[cn]
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <65A86BD3493F1A12+2026072309464585258810@uniontech.com>
Content-Type: text/plain;
	charset="GB2312"
Content-Transfer-Encoding: base64
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: M5ksmywBLdRIieNdvLkSpVBNhbwrDOJzE7ISfgvxHh4SUM8kpxPEozdD
	VVPbWsS4W3s03DJa8yGTQ0XCEI9nqHh6LaOu90qAIGG78sxkiXUg40uVZF90UtJdq5/yz5q
	llw1g8nb1ws/L8C3lUdHm80CWPxmId1OK7w/wtDYpaz4M+DMFDnrJs8mWHcf79qEKWMjJbP
	HieTj0KDCei3zrr++ZHUuIo99K2a/hqk2WjiqAJ9afpfmZNysD80hMCaLMHwP3LHdNNmS1H
	ppuFVFOcCNXdplsauA/vtJMy21O8xkjirA5IOySB0DqI/+ZSXPv7C7tvlklotWB8rNnA6KY
	qPYjWjw0z4YSIxpuURfR2kNcruMBn/r/6rB1Z/qD7K3X7Qg1VAsrd8S4CT3EBvUTw0tGg75
	4ARsdV2qi+oNG6nsLBz9WEtyk4FhDIVFYlwVGqN/9o1fTSJLRacaiWQIWIV/nh7U/gKpcYd
	033bExzGVoPrMaklhsqyOI1Kq1WDlbxw6RaX/uD0MW5BMQ2UtEMPfDu4ezodF2SeYCU1fRU
	7Nv7mBt6Cwu0I1lHCcP92RARPArOQL4uuraptDjrGWVK+EnCIFrA/nIu9eSpxPiNPi4QwIV
	+pegO2KKccI4Y2N5OKztara6WPcC25J6f6HQp4UsHUAJXNiOTDrTo8RY5zHpUpehSPP5iAr
	z4sbEYGiGfocFN733UmxqF670sgQ8gVTFRVC/DCj9aypsQJLb0jVeNNkVO4fGm4OuGC8ML5
	T0a45PvOiHiCmP5v3UyVyINFl8H7EEOlHWD7WKnkjo4o3GmD3ul/D23XNq9A9MZyfbMGzCY
	/6Vm4Oh3COL9lSJ/kY9CWyhNHL5KfUImduwA4G/yfwAupQ+xB9udfEjSY9J/BBxb2Z5nHae
	2zm9kOFNTur7y9XT3DpjBil5seF+e5yO0cq1anaQx42VWyrq2w4HeOrY1fbuj89YSyxFcUH
	PZvQTY0OEj4AP0kQ9Cg5O6sjNL0ZFa0cTcWOFedwBvITdI3bKq7loi4uBmGYCWK9s3Qu54o
	Y8Q/sDQvbQHTJr/tPQ
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0

UmVzZW5kIGFzIHY1IGluIGEgZnJlc2ggdGhyZWFkLiBObyBjb250ZW50IGNoYW5nZXMgZnJvbSB2
NC4KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtd2lyZWxlc3MvMjAyNjA3MjMwMTM4MTgu
MzkzNDcwLTEtemhhb2ppbm1pbmdAdW5pb250ZWNoLmNvbS8KCgotLS0tLS0tLS0tLS0tLQoKCgpa
aGFvSmlubWluZwoKCgo+QW5kIG5vdyB0aGVyZSBhcmUgdHdvIHBhdGNoZXMgd2l0aCB0aGUgZXhh
Y3Qgc2FtZSBzdWJqZWN0LgoKCgo+CgoKCj5JZiB5b3UgcmVwb3N0LCB5b3Ugc2hvdWxkIGVpdGhl
ciBhZGQgYSBSRVBPU1QgdGFnIG9yIHlvdSBzaG91bGQgYnVtcCB0aGUKCgoKPnZlcnNpb24gbnVt
YmVyLgoKCgo+CgoKCj4vamVmZgoKCgo+CgoK

