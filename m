Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793698193;
	b=Kiz1843YX3OVQEucrWteGXwi6e0LgthvCXQ+xw0AiflbiCq7oja6Vkah/e3rq5nu1Ofr
	 eYBpurPPKdrZc3uIFOD7Eptqaj6x13LYvbYlSmnw2uBQBfr+VOsTsu2UUMqLKuhmRwgFk
	 gT8kFl/6v5doSnXtQ1SniikaRKlYeZQlUps6SqbClfvXGp6WIv0haYvaVUX2voyxmyw4r
	 AxtuYHTEkVxHXeI3G7adKprIRkItKgT9Z/3ql72I+IoRLi2fTXzdhk46VLEUlUQh0XSTy
	 JVvWknpbbZs+yepRULLBuKywcY4kFAiqj7Pyotvm63CF/mJ0UehV7wnn/k8HkszLlqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793698193;
	h=DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version:X-malware-bazaar;
	bh=SMplvVxf8/p47BNvDn5gjAEY3Oc+fBAYFb6Yz3/eTuY=;
	b=bO5z87hNlV9oMbJqpNOgynf3p0xkvwtjibt06TE9lMLLvEaQAQ0WEq0a8OwLVZMEy/gH
	 R8qOAnawZI/pBrlRMSs/S8+JqPHa/cVJ6D29XHw/qyqsMj6KWHMX/gyE4BiSU/kkdLwyR
	 6qqZG7aeQZZzRTzv1bFb2BxLHFv622AGdj8cezbfGQk/PiJdcu3cq+SYRCL3n/wgrm9hu
	 X+nQzIHp1L3FwU4vC525iaQkxkoQeqtbgbgCKyMrDJO3O35OwJJ9FkkACMGkbUFH4fQYG
	 yqYCsQggmhsEqheFok98qcSBHB4o9t/PhHRDCpZ7zzTAld+ffS5DVmrqn0A6fml1ZNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b="xRlp/STv";
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB64606A324
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 09:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=xRlp/STv
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=SMplvVxf8/p47BNvDn5gjAEY3Oc+fBAYFb6Yz3/eTuY=;
	t=1793698192; x=1794907792; b=xRlp/STvGEc0fAMBo9W7CLAsUUceTGsPP6rrUI8kZ8khkDt
	NgUEHBpiy5M7Vcq75wF0utj2y/YO5Hj9yjKFUWumOuKcb0iD9d2QTUxfgsxR1C6LjCoZcx4ZkUDiS
	jr+gJjS3lHvkRGEoE39xrFFtxlFP3nXP1bcmcFHCwPjGTBDJmQvQQ02EKVEj89Tu/fgRH+rs5FFIU
	66nVlxZYp+2m/CeGWQBXoTZl2o5gX5EEZJ3XkMDxCcZJ51XOSlZtwzLIkNfsoFDjgshOExWCijJse
	UJqmao/WAo0YFjEHxCC0A21FyAgZ2kYWeINa/IbLQCLAWXsczb+gTeBHskwPVC6A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xOApw-00000003DfD-2Blo;
	Tue, 03 Nov 2026 10:29:48 +0100
Message-ID: <3fee063254e28e421bade900080b8c2877f3fa30.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: mac80211: drain TXQ wake tasklet before freeing
 hardware
From: Johannes Berg <johannes@sipsolutions.net>
To: JB Tsai <jb.tsai@mediatek.com>
Cc: nbd@nbd.name, lorenzo@kernel.org, linux-wireless@vger.kernel.org, 
	linux-mediatek@lists.infradead.org, Sean.Wang@mediatek.com, 
	Evan-ym.Li@mediatek.com
Date: Tue, 03 Nov 2026 10:29:47 +0100
In-Reply-To: <20261103090953.1148722-1-jb.tsai@mediatek.com>
References: <20261103090953.1148722-1-jb.tsai@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Tue, 2026-11-03 at 17:09 +0800, JB Tsai wrote:
> From: Yin-Ming Li <evan-ym.li@mediatek.com>
>=20
> Driver queue wakeups schedule wake_txqs_tasklet asynchronously. Stopping
> the driver work that issued a wakeup does not wait for this tasklet, and
> ieee80211_unregister_hw() does not drain it.
>=20
> Drain the tasklet in ieee80211_free_hw(), before destroying the local
> mutex and releasing the hardware allocation. Drivers must stop their
> asynchronous producers before calling ieee80211_free_hw(); this drain
> waits for a tasklet those producers have already scheduled. Using the
> final free boundary also covers deferred wakeups scheduled while the
> driver finishes bus teardown after ieee80211_unregister_hw() returns.

This isn't really making sense, how would the *driver* possibly schedule
something on this tasklet after unregister_hw() and get past
tasklet_kill() too??

johannes
