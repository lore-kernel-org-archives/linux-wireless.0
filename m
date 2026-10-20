Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792462845;
	b=lA4pa4Qcwcs2Nc72yRYi3/5M90QXd8Sg/vayAMsZIRITlKpFwdlMRNz+dVczYuSRgTze
	 napnYbsKRS88IEPyI2/PkQ3SPTXauE8DkWNHYJGfwQcrLHr83LVKGAXfGeQTqpzhS9JFa
	 CiZdEc6Pm3jMMpjp1lzSNZZ+TRWLXlOxRRg4e5o/guzgoidUL6o4s7prucfNRTCXnp412
	 /r6ZoBKAy0lGeTUAnHaDde/NvB5HzP9OYg5zlT1zTkGz5935QjwJFvOqXvbITBHZzFDf5
	 1ztsLdAoH218jGdp+AAaPx1fl99gVq6rLxc3ovWX4jcl/DYMCN8v6EoeaV1mpKEGy2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792462845;
	h=DMARC-Filter:DKIM-Signature:Date:From:To:Cc:Subject:X-Priority:
	 X-Mailer:In-Reply-To:References:X-NTES-SC:Content-Transfer-Encoding:
	 Content-Type:MIME-Version:Message-ID:X-Coremail-Locale:X-CM-TRANSID:
	 X-CM-SenderInfo:X-Coremail-Antispam;
	bh=gvZ+1wYNb7l4gwD0FmPAMuwgxz7ckvcfGr4ESh+a9ro=;
	b=47LTlBzwpy/VF//9mXMpnfu2z9MC8IF16D8RdVPD0uOwpagX2A6hqPxfKJF/cufhpnBt
	 BHME3bRLa+iJZuPPH0bSN+dWj07CWi1KZOs8t+rr69qRA3QdvgCF90VWcaiqXRw3vqCTr
	 JoalRBfiBRt7M72ljfDBgZFSFx9CwY9G7K3Gy41Xt6dM7/subfQReJcW7UBUndx2VIXsi
	 1/cZCyZMb6SBda8rkkPqMpvoNfLdBWlESIScAZPF2gLfTj1Ph/M2RRjXyXcX9Gpu8Fv6T
	 WTaEJcLetl5NcFE2gO0YXeCjxKNvxaCrJwhzO9L32gwtOs6h4tqFKNDyzo6Kjt6lXcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=RAwMTGUK;
	arc=none smtp.remote-ip=117.135.210.5
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF631606A31B;
	Tue, 20 Oct 2026 02:20:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF631606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=RAwMTGUK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=gvZ+1wYNb7l4gwD0FmPAMuwgxz7ckvcfGr4ESh+a9ro=; b=R
	AwMTGUKXIVhjaos7LYXRZcBu7c5VY2rl6hV9jrSyJ34NtR5bVlhhIU+F0zmYjMxR
	sulQcNEf08sd6TfsLQQ1OdWmiuE73dDOkaa7jhHPz5t/ihRXoJ3t+93Mrkvu8k6r
	qc9Sqaq1aU8mTXH7Ui88JkY99XGwCYJ3nGKiMbI0jM=
Date: Tue, 20 Oct 2026 10:19:59 +0800 (CST)
From: "jiale yao" <19888972804@163.com>
To: "Jeff Johnson" <jjohnson@kernel.org>,
	"Manikanta Pubbisetty" <quic_mpubbise@quicinc.com>,
	"Sathishkumar Muruganandam" <quic_murugana@quicinc.com>,
	"Anilkumar Kolli" <quic_akolli@quicinc.com>,
	"John Crispin" <john@phrozen.org>, "Kalle Valo" <kvalo@kernel.org>,
	"P Praneesh" <quic_ppranees@quicinc.com>,
	"Balamurugan Selvarajan" <quic_bselvara@quicinc.com>,
	"Karthikeyan Periyasamy" <quic_periyasa@quicinc.com>,
	"Vasanthakumar Thiagarajan" <quic_vthiagar@quicinc.com>,
	linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org, ath12k@lists.infradead.org
Cc: "Jiale Yao" <jiale.yao@example.com>
Subject: Re:[PATCH 0/4] wifi: ath11k/ath12k: validate firmware array lengths
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <20261019100029.1908660-1-yaojiale02@163.com>
References: <20261019100029.1908660-1-yaojiale02@163.com>
X-NTES-SC: AL_Qu2SAPidvU8i7ymdZukcn08ShO49XMOyvfoi2YFTc98FtwD2/gAgcWZ6I2D88/+uBy+FqSWSfhhg4+5wV5Nyzw8s5Pw1j42aNSXwdx+QjA==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-ID: <b573b6f.2196.1a1571bc45e.Coremail.19888972804@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:hygvCgDnt83Qz9ZqVzglAA--.644W
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzRB4smrWz9C5QQAA3M
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

VGhpcyBwYXRjaCBzZXJpZXMgaXMgc3VwZXJzZWRlZCChqiBwbGVhc2UgaWdub3JlIGl0IGR1ZSB0
byB0aGUgaW5jb3JyZWN0IHNlbmRlciBuYW1lLgpOZXcgb25lIGlzIGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2xrbWwvMjAyNjEwMTkxMDA1MDYuMTkxNTE4MS0xLXlhb2ppYWxlMDJAMTYzLmNvbQpB
dCAyMDI2LTEwLTE5IDE4OjAwOjI1LCAiSmlhbGUgWWFvIiA8eWFvamlhbGUwMkAxNjMuY29tPiB3
cm90ZToKPkZyb206IEppYWxlIFlhbyA8amlhbGUueWFvQGV4YW1wbGUuY29tPgo+Cj5hdGgxMWsg
YW5kIGF0aDEyayBjb25zdW1lIHR3byBmaXJtd2FyZS1wcm92aWRlZCBhcnJheXMgd2l0aG91dCBm
dWxseQo+dmFsaWRhdGluZyB0aGVpciBsZW5ndGhzLiBUaGUgc2VydmljZS1yZWFkeS1leHQgcGFy
c2VyIGFjY2VwdHMgZmV3ZXIKPmV4dGVuZGVkIHJlZ3VsYXRvcnkgY2FwYWJpbGl0eSBlbnRyaWVz
IHRoYW4gdGhlIHNlcGFyYXRlbHkgcmVwb3J0ZWQgUEhZCj5jb3VudCwgd2hpbGUgdGhlIHJlYWR5
LWV2ZW50IHBhcnNlciB0cnVzdHMgdGhlIHJlcG9ydGVkIGV4dHJhIE1BQyBhZGRyZXNzCj5jb3Vu
dCB3aXRob3V0IGNoZWNraW5nIHRoZSBmaXhlZC1zdHJ1Y3R1cmUgYXJyYXkgbGVuZ3RoLgo+Cj5N
YWxmb3JtZWQgZmlybXdhcmUgZGF0YSBjYW4gdGhlcmVmb3JlIG1ha2UgYm90aCBkcml2ZXJzIHJl
YWQgYmV5b25kIHRoZQo+Y29ycmVzcG9uZGluZyBUTFYgYXJyYXlzLiBBZGQgbWF0Y2hpbmcgdmFs
aWRhdGlvbiB0byBlYWNoIGRyaXZlciBiZWZvcmUKPnRoZSBhcnJheXMgYXJlIGluZGV4ZWQuCj4K
PlRoZSBmb3VyIHBhdGNoZXMgYXJlIGluZGVwZW5kZW50IGFuZCBlYWNoIGFkZHJlc3NlcyBvbmUg
cGFyc2luZyBwYXRoIGluCj5vbmUgZHJpdmVyLgo+Cj5KaWFsZSBZYW8gKDQpOgo+ICB3aWZpOiBh
dGgxMWs6IHZhbGlkYXRlIGV4dGVuZGVkIHJlZ3VsYXRvcnkgY2FwYWJpbGl0eSBjb3VudAo+ICB3
aWZpOiBhdGgxMms6IHZhbGlkYXRlIGV4dGVuZGVkIHJlZ3VsYXRvcnkgY2FwYWJpbGl0eSBjb3Vu
dAo+ICB3aWZpOiBhdGgxMWs6IHZhbGlkYXRlIHJlYWR5IGV2ZW50IE1BQyBhZGRyZXNzIGFycmF5
IGxlbmd0aAo+ICB3aWZpOiBhdGgxMms6IHZhbGlkYXRlIHJlYWR5IGV2ZW50IE1BQyBhZGRyZXNz
IGFycmF5IGxlbmd0aAo+Cj4gZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDExay93bWkuYyB8
IDEwICsrKysrKysrKysKPiBkcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTJrL3dtaS5jIHwg
MTAgKysrKysrKysrKwo+IDIgZmlsZXMgY2hhbmdlZCwgMjAgaW5zZXJ0aW9ucygrKQo+Cj4tLSAK
PjIuMzQuMQo=
