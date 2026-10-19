Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792451067;
	b=nUkY6rMVbMpr0okbyPFMFSW4Sva/Gb/vMeWsHwyAJaQEw3KMbhWIoiUFUY5HqeXXC3yj
	 SsA6H8OmbImGfQv7IMA+17d5n1rU90l6ph5f4MT5FDHozBrztvkMjTrVt+twdVZVmP2u/
	 RcCrDXtaEDAAfVqfVxCqsxJrSL5ryX+I1xxzHYioBmBSk6FdShDmBvbZOalkc27gFLbE9
	 kyA/vx0Q15C+wt5Z3nCef3ohyRYGNiVXsT0N9qwHpAFujWYsWBAy/YZuxgBPYATj6n3H4
	 NWdWilLmN0SlznXtvkkpNur4bYPUWC5Z8+n4IvNysiK6N/rkLkk9NbqVa56kVUgEOew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792451067;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:From:Subject:To:Cc:References:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=ejzvlhIFW6GmHno4CqHvsMU5kkN5COxKCaAbK5ak6W8=;
	b=BS4zLai58yLArrWlYzS0iWnEppJenlOqCXwOYHRgWzlSROTZnOCBvbDtN2zckKS8mAyh
	 xgEuoi6e9c4FOFZV5HgBlOO3A7qD0wMeWnGIvStdYASxG/2l4W93mpcByvcaurmzPxX1/
	 YJUbkhwAZ3ZGh6UtMyp60f2hQhi2joGrmP6KpNTzm0c3hxJuDbgwbHw89M2hf8gSqpIf2
	 UaCqIpbz05vFHHdS2m5tKGAGcWzXcqPDLpMgyQeetMClV9uyVRA2rKB6MDIDTFMkT3xNT
	 9Fwu9RLm3uNnYmNEn7Uy4+t9Wsvt5M1Espa+uI0DeqetBBXivhO2/ryw0vuKYGXvVxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.de;
	spf=pass smtp.mailfrom=gmx.de;
	dkim=pass header.d=gmx.de header.i=aleksei.kharlamov@gmx.de header.a=rsa-sha256 header.s=s31663417 header.b="W1FTMsW/";
	arc=none smtp.remote-ip=212.227.15.15
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B14C606A319;
	Mon, 19 Oct 2026 23:04:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B14C606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.de header.i=aleksei.kharlamov@gmx.de header.a=rsa-sha256 header.s=s31663417 header.b=W1FTMsW/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1792451050; x=1793055850;
	i=aleksei.kharlamov@gmx.de;
	bh=ejzvlhIFW6GmHno4CqHvsMU5kkN5COxKCaAbK5ak6W8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:From:Subject:To:
	 Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=W1FTMsW/+Q61bw3cZ4sLNkap0vJBaVzpt92Oa51EUHqvhoG5WJjQZhxwdrnGoi8G
	 2FWvJtyQV6p0RFw6ISIDLs/54ZqhAt8gj+G+YUviCUnQWhiISu7V0HqIRFYf8ON0T
	 0GsyozUi18MZfmCiAJGRfE49P+0q6JiuIlN+Td/qylc16f+K8xFbarkNfGVmOExy3
	 0XCnFBDtexLEPN3ThYM5LKkQTQ020BMxs+LIKN22XgONSl00mhQbXHDbzT64JuF9b
	 DyPlxhbbPtOBw4X2EPtyICX6P6ChBNhV2ZRETYQWzoyRRN+V82aQv3eIYcU3DDqj7
	 jrVkkPGvK1UO8A8K3g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MHGCo-1xNK702EGe-005YOh; Tue, 20
 Oct 2026 01:04:10 +0200
Message-ID: <a523eda4-5708-4427-a044-a61c0386e5a9@gmx.de>
Date: Tue, 20 Oct 2026 01:04:08 +0200
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Aleksei Kharlamov <aleksei.kharlamov@gmx.de>
Subject: Re: [PATCH ath-next 1/3] wifi: ath10k: set the PMF peer flag on
 WCN3990
To: shunsuke@nagashi.ma, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
 linux-kernel@vger.kernel.org, David Heidelberg <david@ixit.cz>,
 Fabricio Akio <fabricioakio@gmail.com>
References: <20261016-ath10k-series-v1-send-v1-0-c847697b3558@nagashi.ma>
 <20261016-ath10k-series-v1-send-v1-1-c847697b3558@nagashi.ma>
Content-Language: en-US
In-Reply-To: <20261016-ath10k-series-v1-send-v1-1-c847697b3558@nagashi.ma>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:NcJY6hCX6NYQjKCxOjG5wFSMCYSGsvU+nEIsc2QdzR3+uecdzbX
 oGbBlvmKcI3MIop7YaNwoHkxDRmWVQynXJ/OFfMf5taTH/XLKDO6afEEl+3aSI8ZUVCS+Or
 l09ylevafSaVzuodOhRsxAulrwiQqkhcA5iWmltls3znxdvjrzS/G3gLL4qoVoP/bphJEYb
 2q/ViXG5+OnrgWKADpI5A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:WXqY/D80R8Q=;NJdp5Z8bTLuDrxtJD+bv4Dfs4b9
 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
 =

Hello,

On 10/16/26 02:17, Shunsuke Nagashima via B4 Relay wrote:
 > ath10k sets the PMF flag in the peer assoc command only when the
 > firmware file advertises ATH10K_FW_FEATURE_MFP_SUPPORT. That check came
 > with commit 90eceb3b5fb0 ("ath10k: set peer MFP flag in peer assoc
 > command"), because at that time "only firmwares 10.1.561 and above have
 > support for MFP". The WCN3990 firmware-5.bin files in linux-firmware do
 > not set that feature bit, so the flag is never sent on WCN3990, althoug=
h
 > mac80211 negotiates PMF with the AP. ath11k and ath12k set the flag for
 > every MFP station.

I independently found the same issue while investigating connectivity=20
issues on fairphone 4 (WCN3988, qcom,wcn3990-wifi, slightly patched=20
kernel v7.2.0-sm6350, firmware WLAN.HL.3.3.1-01704-QCAHLSWMTPLZ-1).

Setting PMF peer flag (my patch is crude and very similar to yours)=20
significantly improves the connection performance (please keep in mind=20
that fp4 seems to currently have multiple other issues, such as missing=20
a correct "board" file). I only tested station mode.

Thanks,
Aleksei

