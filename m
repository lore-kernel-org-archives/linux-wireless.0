Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574D9392C3D
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 09:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791278302; cv=none; b=BG/rF7KN9JsHUQTihHEU3xUQqnjblBFSf9QyshpMQchqbmIA6V/vsM3A4x31+Rcys+90D1J6Q3zSKsrCFpMjNJpGCQAl8pTL2K8v2LfdqKB/g9oAIxGJcvZIhupjVuaWkeOkBUJJLSwpy34rrkkG2J0O3j7YsHolGnjuXje1fOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791278302; c=relaxed/simple;
	bh=T9j0GIcaB+XxGHT9ytg6BQ1gbcx6zW3MDaStWERH+VY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XyP3W5gSDN2tWBfNAHzUqvMHNgyJCaMcwgQ/aCSyFVMsdlhzB/snpCOthX9g9BUYOCZS4IxCk7jHFeMwSbcqggb2Ll04o8SFgtLVIe5onQLfumW2D9RqaL8Jdcvhxaur9Xqwztsh32jVZqsWB85tG0CqPvGsen92u3x0KE6WsJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=TGckjlzH; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="TGckjlzH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=NxwdaKCfSUGUjHY/I3O6dk8h3VGVHlFPVoG5tWphCHs=; b=TGckjlzH9Ci0bfZacSxj1GL7kh
	TO+3Kdp2tIz+fdK0RzGodxfJjXtTMp1k1076Qom6uNSfuIQit+S9eWCh2hdWBYUxuDWXInEvfzz9Y
	yTYbDMTzTSimii4tX6k6TMi3hUrAhi61JWhiP9xp0MYbabYQqEI61E8naGGuk713iGJY=;
Received: from p54a434bb.dip0.t-ipconnect.de ([84.164.52.187] helo=nf.local)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xE1JO-00GqCx-0R;
	Tue, 06 Oct 2026 11:18:14 +0200
Message-ID: <701d9e27-8dcc-4a34-b8aa-17e8a7c732c3@nbd.name>
Date: Tue, 6 Oct 2026 11:18:13 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/23] wifi: mt76: mt7925: implement NAN MAC address
 randomization
To: Sean Wang <sean.wang@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
 yu-ching.liu@mediatek.com, jenhao.yang@mediatek.com, posh.sun@mediatek.com,
 Chengwei Yu <chengwei.yu@mediatek.com>, Sean Wang <sean.wang@mediatek.com>
References: <20260927210306.737669-1-sean.wang@kernel.org>
 <20260927210306.737669-4-sean.wang@kernel.org>
From: Felix Fietkau <nbd@nbd.name>
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
In-Reply-To: <20260927210306.737669-4-sean.wang@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27.09.26 23:02, Sean Wang wrote:
> From: Chengwei Yu <chengwei.yu@mediatek.com>
> 
> Add mt7925_nan_start/stop_mac_randomization() using a per-vif
> delayed_work and period stored in struct mt792x_nan.
> 
> Per-vif (not per-dev) because the NAN iface combinations allow up
> to two concurrent NAN_DATA vifs; a single dev-wide field would
> silently lose randomization for the second NDI or let it overwrite
> the first vif's pending work.
> 
> delayed_work (not timer_list) because the work function calls
> mt7925_nan_set_nmi/ndi_address() which invokes mt76_mcu_send_msg()
> with wait_resp=true; that can sleep, which is not allowed in softirq
> context. This is consistent with scan_work, mlo_pm_work and ps_work
> in this driver.
> 
> stop_mac_randomization() must be called without holding the dev
> mutex since the work function acquires it. No caller is wired up
> yet; the next patch does that in add/remove_interface.
> 
> Co-developed-by: Sean Wang <sean.wang@mediatek.com>
> Signed-off-by: Sean Wang <sean.wang@mediatek.com>
> Signed-off-by: Chengwei Yu <chengwei.yu@mediatek.com>
> ---
>   .../net/wireless/mediatek/mt76/mt7925/nan.c   | 59 +++++++++++++++++++
>   .../net/wireless/mediatek/mt76/mt7925/nan.h   |  7 +++
>   drivers/net/wireless/mediatek/mt76/mt792x.h   |  9 +++
>   3 files changed, 75 insertions(+)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
> index abbd3f7b081c..0b94bd4005d4 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
> @@ -745,6 +745,65 @@ int mt7925_nan_set_ndi_address(struct ieee80211_vif *vif,
> [...]
> +void mt7925_nan_start_mac_randomization(struct ieee80211_vif *vif,
> +					u32 period_sec)
> +{
> +	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
> +	struct mt792x_dev *dev = mvif->phy->dev;
> +
> +	if (!period_sec)
> +		return;
> +
> +	mvif->nan.mac_rand_period_sec = period_sec;
> +
> +	ieee80211_queue_delayed_work(mt76_hw(dev), &mvif->nan.mac_rand_work, 0);
> +}
This function is added, but not used in this series.

- Felix
