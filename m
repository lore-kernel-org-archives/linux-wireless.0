Received: from zg8tmtu5ljy1ljeznc42.icoremail.net (zg8tmtu5ljy1ljeznc42.icoremail.net [159.65.134.6])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 624161DA53;
	Tue, 21 May 2024 07:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.65.134.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716277987; cv=none; b=Fs5Ta116PleoC+p6hPI+vYEOl8O3VJAUit4yfxPclOrLJbB04YFMGUvq+hplQ/V+njUlpxvdnoEyw1H5FLYoZeRvmz/QAPiEDT/6xqV1Z5gk63H634LnIRpFgD/RPYIqySVX2yNGY3bjh8m8uCbPO8dzwrNe0oq5GxY/qSrVmPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716277987; c=relaxed/simple;
	bh=Ed/mU92lRZOOTt8qyjeVjCl7Dcw57Tgbu2JuglKnYdo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=tw/Fme90OLWkHjkfovfB/JoQUWJ57wbV68Z13LPrNz6HVCLLvdt+owUAjFDvPSR7pNuW0jXMg2vlCMYB9eL/QRYLhJ8FeRq6apxYR1WLjQnwdVGJsqTRFWnqQetDoUZVeJClgfHU3+GFvNNU2tYBDlcAveuAVsmb9mSlIZSDJTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=159.65.134.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from linma$zju.edu.cn ( [42.120.103.55] ) by
 ajax-webmail-mail-app3 (Coremail) ; Tue, 21 May 2024 15:52:40 +0800
 (GMT+08:00)
Date: Tue, 21 May 2024 15:52:40 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: "Lin Ma" <linma@zju.edu.cn>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 net] cfg80211: pmsr: use correct nla_get_uX functions
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT5 build
 20231205(37e20f0e) Copyright (c) 2002-2024 www.mailtech.cn zju.edu.cn
In-Reply-To: <b7583de35462b06bbfbeb39bf2435bcb5f04be06.camel@sipsolutions.net>
References: <20240520073311.44117-1-linma@zju.edu.cn>
 <b7583de35462b06bbfbeb39bf2435bcb5f04be06.camel@sipsolutions.net>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <453346a6.15c2e.18f9a235eed.Coremail.linma@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:cC_KCgBn4VjIUkxmEmfSAA--.24115W
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/1tbiAwMCEmZDiAoQOgAVsI
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=

SGVsbG8gdGhlcmUsCgo+IAo+IE1heWJlIG1lbnRpb24gYSBiaXQgbW9yZSBjbGVhcmx5IHRoYXQg
dGhlIF9wb2xpY3lfIGFjdHVhbGx5IGRlZmluZXMgdGhlbQo+IHdpdGggdGhvc2UgdHlwZXMsIHNv
IHRoZSB1c2VycyBhcmUgaW5jb3JyZWN0LCB2cy4gYSBwb3NzaWJsZSBzY2VuYXJpbwo+IHdoZXJl
IHRoZSBrZXJuZWwncyBkb2N1bWVudGF0aW9uIGlzIGp1c3QgaW5jb3JyZWN0IGFuZCB3ZSBoYXZl
IHRvIGtlZXAKPiB0aGUgY29kZSBhcy1pcyBmb3IgdXNlcnNwYWNlIHRvIGNvbnRpbnVlIHRvIGZ1
bmN0aW9uLgo+IAo+IEkgYmVsaWV2ZSB0aGUgY2hhbmdlcyBhcmUgY29ycmVjdCBzaW5jZSB0aGUg
cG9saWN5IHdhbnRzIHRoZSByaWdodCB0eXBlcwo+IGFuZCB0aGVuIG9uIGxpdHRsZS1lbmRpYW4g
cGxhdGZvcm1zIGl0J2xsIGFsbCB3b3JrIC4uLgo+IAo+IGpvaGFubmVzCgpUaGFua3MgZm9yIHRo
ZSBraW5kIHJlcGx5IGFuZCBzdWdnZXN0aW9ucywKSSd2ZSBzZW50IHRoZSBWMiB2ZXJzaW9uIGFu
ZCBwbGVhc2UgY2hlY2sgdGhhdC4KClJlZ2FyZHMKTGlu
