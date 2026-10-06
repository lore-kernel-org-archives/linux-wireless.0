Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2529B3B71C9
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 14:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791298128; cv=none; b=Ixl+eIKxRGm4iQD/twYukvkoU8DFXWAbvaYfL4P1NoKg4bnGWUfCB84FuTEssTqzGfGbRpZKZDBhPz5+YlLNFwwFoim6eC48YvPxkZFC7ryf5mY38V2YPG5gdizBUDvUylvoIX6sIRLFzc1ChrOLnyzxInxiPBqmaHLAo0wk+ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791298128; c=relaxed/simple;
	bh=hrYo+zr8/QF0Q0y646UerxjQLvKLs097D+3JrPm9AgA=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=tOePtSaVTJIFkZnetisRHp9SjBkp58NAnf0I543wcTo82jhycPsT8HSXPBMjIU7cr1E+QdJg163PaEBYRNXD10D8fGqx/iAA5BxhOE6By3U8fdd++mpREgkUkob7E8bo007yjAd0rtzeCKs0hyWa9pBWcHWJKwiwfHNtqXd/WXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=X5XxRCQ4; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="X5XxRCQ4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:
	Cc:To:Subject:From:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Oucqut4+PItL4Z7D8mOArQh/3IGpy12z1U4M2PMEnEk=; b=X5XxRCQ4/JxjoOoyPFror9nb/U
	xELFsSyPqjGZlk2UET7UZEWFh/Ivjct0ObKcnxKgTdHHFCu2qSmcJfLyWcxmVqo3RdlGdTkOM3Xcb
	Pl4lFRg2gG783CNshi6NLbTzu8+MIaiwZCZSIttRHb7FexF/2i5rrrxb7twdixOOAmf8=;
Received: from p54a434bb.dip0.t-ipconnect.de ([84.164.52.187] helo=nf.local)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xE6T2-00Gzw8-1o;
	Tue, 06 Oct 2026 16:48:32 +0200
Message-ID: <cb2f423f-b3eb-4d19-9fe1-ccc19c9690b2@nbd.name>
Date: Tue, 6 Oct 2026 16:48:31 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v4 5/5] [PATCH v4] [PATCH 05/05] wifi: mt76:
 mt7922/mt7928: send Tx/Rx statistics to FW for link tuning
To: Anthony Liu <anthony.liu@mediatek.com>, lorenzo@kernel.org
Cc: Sean.Wang@mediatek.com, Leon.Yen@mediatek.com, Quan.Zhou@mediatek.com,
 Ryder.lee@mediatek.com, litien.chang@mediatek.com, kun.wu@mediatek.com,
 jb.tsai@mediatek.com, emery.hsin@mediatek.com,
 linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org
References: <20261005083155.104718-1-anthony.liu@mediatek.com>
Content-Language: en-US
Autocrypt: addr=nbd@nbd.name; keydata=
 xsDiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwc0cRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPsJgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQzsFNBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabwkkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCeMncXpbbWNT2AtoAYICrKyX5R3iMAoMhw
 cL98efvrjdstUfTCP2pfetyN
In-Reply-To: <20261005083155.104718-1-anthony.liu@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 05.10.26 10:31, Anthony Liu wrote:
> Update Tx/Rx statistics to FW for link speed tuning in FW.
> 
> Signed-off-by: Anthony Liu <anthony.liu@mediatek.com>
A few issues in this series:
1. Please fix the email subject
2. It seems that some places may need checks to exclude mt7921.
3. Some duplication in debugfs.c
4. mt792x_mcu_set_perf_ind could be static
5. Check if the pointer derefs in mt792x_perf_account_rx are safe.

Aside from this, I also have some questions:
- is this on by default or can it only be enabled via debugfs?
- why does the host have to keep statistics on tx/rx, when the firmware 
could do that and handle it internally?

Thanks,

- Felix
