Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4894821ADC7;
	Tue, 28 Jul 2026 01:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.169.211.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785203154; cv=none; b=INFX1yoeoXjHbRK8sCnsSwN6AqJpJnO+dvAr9fk0k1uPko8DMHgj2dzQtDSS3DGbdtRGXNxB8c2NMNfvQ8xA0h4rppU0uGYFsydaH1S5mT8CXZ/iKJNrrr0FNgTuDEvNgQkYKmIrRfxT889o3hZfTQ70qd2PQZUm3hJHLF/+ZzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785203154; c=relaxed/simple;
	bh=QhLN/OHWsz0ANNAJGBwScJ9jDSugbm6tMuY1akxUza0=;
	h=Date:From:To:Cc:Subject:References:Mime-Version:Message-ID:
	 Content-Type; b=f0E26MWCAc/erfiDumtilDRob7EwNJ305UPJQJmWZz9WrE739YGoTz+9/onlH1yAp/Fcco5OUGNA9fJC7qk7rECnd29Xfflniq/++bHv5unJbj5OVjqPQvB8/363lBggpTfFCd6qME6czWBUFicIct9nY63r1eJKLCgJKrEvey4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=f9v4+riy; arc=none smtp.client-ip=18.169.211.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="f9v4+riy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1785203111;
	bh=QhLN/OHWsz0ANNAJGBwScJ9jDSugbm6tMuY1akxUza0=;
	h=Date:From:To:Subject:Mime-Version:Message-ID;
	b=f9v4+riyg/9w3/G2HBNhwVTwwLWkJW+gQTf+Ppa4W/51SQt0HhJnidk+zH/K451iz
	 2ONylMe++BAYFbJdMf20UpFz80VMbTnabNvoe+6vk73yyFMx0GofaxxeVbwabbmGR8
	 lG2Te03D4n7tsh4iZniPBtMZ2ZQ7G1FVJS6/n2Q4=
X-QQ-mid: esmtpsz19t1785203104t7b734666
X-QQ-Originating-IP: 6DR+UVQFjbxV/NRs5a6OdyIEQs3ahXlslo2PHL15DxY=
Received: from PEN002676 ( [124.126.19.250])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 28 Jul 2026 09:45:01 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 3024313782643152738
Date: Tue, 28 Jul 2026 09:45:02 +0800
From: =?GB2312?B?1dS98MP3?= <zhaojinming@uniontech.com>
To: "Jeff Johnson" <jeff.johnson@oss.qualcomm.com>, 
	baochen.qiang <baochen.qiang@oss.qualcomm.com>
Cc: ath11k <ath11k@lists.infradead.org>, 
	jjohnson <jjohnson@kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v6] wifi: ath11k: fix resource leak on error in ext IRQ setup
References: <b6903572-52cc-4c41-b9cf-5845e387c176@oss.qualcomm.com>, 
	<20260727065500.3827035-1-zhaojinming@uniontech.com>, 
	<81a72170-870a-47be-930d-0772b7934ab2@oss.qualcomm.com>
X-Priority: 3
X-GUID: 6E432D6D-07EF-4BE0-AE05-CD7A2A3DC886
X-Has-Attach: no
X-Mailer: Foxmail 7.2.25.375[cn]
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <A77EF7332E024D0E+202607280945015602200@uniontech.com>
Content-Type: text/plain;
	charset="GB2312"
Content-Transfer-Encoding: base64
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: MjA5tsjrlPcv4HKdR6ssGaBVI1GdQcdX/o5vTOTn/GF+BWh1a65Pe+MM
	iVsmhMrQMHilqTjI7TI52ihuLOT0ka1h7aLBaf9+S02D0SDbSTvWpLRUEhcpNfu3E44ZmKP
	zIYTbP+FhpCqeUd6EG1n0dhP8ggLtCC/mD7Xzr/KAltnYrS8c0jbjZQVlp4VuNwAOcAZh5O
	yqFO1RbjaHnER/kvtwCDquhO0CDvQWM4HhjPWGxdM9ZJHrc9WNpQAq6R0hfrKuoScU19Dgu
	tArg410wZjSIp/+bsX2fGFATQII3Pvj0NHCHtTZ2N2wZ+g5Luv6lSZZCrb0p+MyoQYLM5sU
	iqkEy8uJWhK46xfD/u8ktxaGralGQKVeFvVDbvN2MUCXGRE72gaELebEvAFD4UxZ0OBkXuQ
	UMDzdTQ0bW0AvWsIKdxqaKs2lSJA5UuUE6CmF2s7/wYdN2v8GMONwpdfvVh097BUDg1yQWH
	j4S0qtt4JdnbDh0Yh7f4Z9sNNNQADTFJPT8dHePwfZy2fN6B8Qb0AbbkayDU+6KIvUz405v
	X3HCAvZ5fhMFZBDMhVrwK/P9+xSK2SN9spBf654aw0SeJ2jO+/P3wyoL/LsaLubtDo6G1g7
	BjROTVfK0TJrnA5AtIHwQmMPBvpvO7v5REetxD15LtRL2eTFc7IEtg01ebVSbYaBZpAuVb7
	TLgLXlim3/T6qKqv5LMSBYEw4KAe3GlZD4qiDZl32b3eDgnAI0wMCoNNO7r2Sp4B2OpoQKj
	rCLMY4a8OtyesYKEVypD1VQkjL/+F6DbcgIAL3DUdUEB9shxM5l+x0Y9yPTiWWaW8zRThsZ
	Q11UTHGk4ps8rOhHANiW73wyHlH4XvJJOoafBKXlouHbAV8RhdXbschhQpR1r414nsCTmIA
	ebYtwBrmg8gv2KZ/bsMm6LBD2qGdQFzPx6H2k89PtryDAHkFtuaxRsJfX/gt1NaElYszHB/
	YOsD07XsNtjOnGl69RNiVLbUC69T3GoH/EJO9n4xyZhHvmw==
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0

SGkgSmVmZiwKClRoYW5rIHlvdSBmb3IgdGhlIHJlbWluZGVyLCBhbmQgSSBhcG9sb2dpemUgZm9y
IHRoZSBjb250aW51ZWQgbWlzc3RlcC4KCkkgZG8gcmVtZW1iZXIgeW91ciBwcmV2aW91cyBpbnN0
cnVjdGlvbiBhYm91dCBzdGFydGluZyBuZXcgcGF0Y2ggc2VyaWVzIGFzIHNlcGFyYXRlIHRocmVh
ZHMuIFRoZSByZWFzb24gSSBzZW50IHRoaXMgdjYgYXMgYSB0aHJlYWRlZCByZXBseSB0aGlzIHRp
bWUgd2FzIHRvIGtlZXAgdGhlIHJldmlldyBjb250ZXh0IGVhc2lseSBhY2Nlc3NpYmxlIGluIG15
IG1haWwgY2xpZW50IKGqIEkgZmluZCBpdCBoZWxwZnVsIHRvIGhhdmUgdGhlIGZlZWRiYWNrIGFu
ZCB0aGUgbmV3IHZlcnNpb24gZ3JvdXBlZCB0b2dldGhlciBmb3Igc2lkZT9ieT9zaWRlIHJlZmVy
ZW5jZSBkdXJpbmcgdGhlIHJldmlldyBwcm9jZXNzLgoKVGhhdCBzYWlkLCBJIGZ1bGx5IHVuZGVy
c3RhbmQgdGhhdCB0aGlzIGNvbnZlbmllbmNlIGZvciBteXNlbGYgY3JlYXRlcyBpbmNvbnZlbmll
bmNlIGZvciBvdGhlcnMsIGVzcGVjaWFsbHkgZm9yIHRob3NlIHdobyB1c2UgdGhyZWFkZWQgdmll
d3MgdG8gdHJhY2sgcGF0Y2ggZmxvdy4gTXkgaW50ZW50IHdhcyB0byBzZW5kIHRoZSBmaW5hbCwg
cmVhZHk/dG8/bWVyZ2UgdmVyc2lvbiBhcyBhIG5ldyB0aHJlYWQgb25jZSB0aGUgcmV2aWV3IG9u
IHRoaXMgcm91bmQgaGFkIHNldHRsZWQgoaogYnV0IEkgc2hvdWxkIGhhdmUgZm9sbG93ZWQgdGhl
IGVzdGFibGlzaGVkIHByb2Nlc3MgZnJvbSB0aGUgc3RhcnQuCgpUbyBjb3JyZWN0IHRoaXMsIEkg
d2lsbCBzZW5kIHY3IGFzIGEgY29tcGxldGVseSBuZXcgdGhyZWFkLCB3aXRoIHRoZSBsaW5rIHRv
IHRoaXMgZGlzY3Vzc2lvbiBhZGRlZCBhdCB0aGUgZW5kIG9mIHRoZSBjb21taXQgbWVzc2FnZSBm
b3IgdHJhY2VhYmlsaXR5LgoKQWdhaW4sIHNvcnJ5IGZvciB0aGUgbm9pc2UsIGFuZCB0aGFua3Mg
Zm9yIHlvdXIgcGF0aWVuY2UuCgpCZXN0IHJlZ2FyZHMsClpoYW8gSmlubWluZwoKCgo+QWZ0ZXIg
djQgSSByZW1pbmRlZCB5b3U6CgoKCj4+SW4gdGhlIGZ1dHVyZSBwbGVhc2UgcG9zdCBuZXcgdmVy
c2lvbnMgb2YgcGF0Y2hlcyBhcyBhIHNlcGFyYXRlIHRocmVhZC4KCgoKPgoKCgo+WWV0IG9uY2Ug
YWdhaW4geW91IHNlbnQgYSBuZXcgcGF0Y2ggYXMgYSB0aHJlYWRlZCByZXBseSBpbnN0ZWFkIG9m
IGFzIGEgbmV3CgoKCj50aHJlYWQuCgoKCj4KCgoKPjooCgoKCj4KCgoKPllvdSBhcmUgcnVpbmlu
ZyB5b3VyIHJlcHV0YXRpb24uCgoKCj4KCgoKPi9qZWZmCgoKCj4KCgo=

