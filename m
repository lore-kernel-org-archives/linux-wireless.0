Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792512527;
	b=JDfTpXQdgcK27zuamTkPjknVhQc/X5xGUz1x7P2OTSYq+YOoGS0YAQAlGcHuuKLoHbu8
	 260cxEwDimHzNiIcCfgN3jsgpA40WwA2ktGZeapSk2LHZShSULAxWfmXOt3fcj79LZo5b
	 daOBn1E9R3gWHvLZRs8HgBPQ925W07S3nF5waauWpE+gnbChhMK07PPiVWE/+1LQ1CIWf
	 viJtciVNCqXL3BwBcy9s/4KryN054q7syu/zqNxmG8BwSInCdqpUMBQIcdS4ZlHmCD99F
	 lwMC1VDJm6ygO2zkg6pu05IDSHISZddQNikocpRkLxKEb4rdPkTcHvC8IScNCgttSgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792512527;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=JZGvSJ/T2lFQAZNU+lUoUCnDcDPrtpGrw0LMffwgz3o=;
	b=V1W2Ot4Xsit5v/I4JdqYbX01zZh+njGNWYK2Fe75OSMprR3xn4JsFd8o++x6aOd6WECE
	 eu5bQpWkLhnBA6NxGejP5vSgvhQsTXH7ez1ae1+WMgpQrWP750Oq/foXjkxw7nzTC6ol+
	 TM8Jw2dBy20z/lhSr2P6xrgJaGY1GaHltom/XX/1NIkIIyoJVhH9SCF3QzsWs33KWny+Q
	 J4hRl9asUVK9Z8MNBTfyf/O7iAqk9DjCwdtPfURLKANd9E2hi6tjGvq5FAm2s6TJtEAsW
	 pnOJl/G+RvK4d4vb3sE5RH6G1qvOpNVK/gPorADxwPZL/mWCwa8x0966TQP14bH2UXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="GvCbYA/U";
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776B7606A333
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 16:08:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 776B7606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=GvCbYA/U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792512525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JZGvSJ/T2lFQAZNU+lUoUCnDcDPrtpGrw0LMffwgz3o=;
	b=GvCbYA/UB0M7Z3M2qQsXQ5hclNIg1GrEtSBrGDL8uEimjyyMPoTE7ywqoOyosx8IZr9his
	dvGVVPjsnEuQsIxVSGGGunZWTF429deMu1oFJWkO+RBHD1TxfRl2MbOP+y9AjcFHBnJkCm
	vwzDETVdHWwml8JI1bs28EwksII9NOs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-686-PrNzLbbOMWmkiqW3IDyx1g-1; Tue,
 20 Oct 2026 16:08:40 +0000
X-MC-Unique: PrNzLbbOMWmkiqW3IDyx1g-1
X-Mimecast-MFC-AGG-ID: PrNzLbbOMWmkiqW3IDyx1g_1792512517
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BB3F7195E915;
	Tue, 20 Oct 2026 16:08:36 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DF6651800495;
	Tue, 20 Oct 2026 16:08:32 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: julius@bairaktaris.de
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	baochen.qiang@oss.qualcomm.com,
	hujy652@gmail.com,
	jeff.johnson@oss.qualcomm.com,
	jjohnson@kernel.org,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	tamizh.raja@oss.qualcomm.com
Subject: Re: [PATCH v7 0/4] ath11k/ath12k: implement TX flow control
Date: Tue, 20 Oct 2026 18:08:30 +0200
Message-ID: <20261020160831.2133912-1-jtornosm@redhat.com>
In-Reply-To: <20261018131930.1116724-1-julius@bairaktaris.de>
References: <20261018131930.1116724-1-julius@bairaktaris.de>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Hi Julius,

Thanks for the review and the Tested-by.

> One thing on patch 3, from reading the code:
>
>> +             if (num_free == 0) {
>> +                     spin_unlock_bh(&tx_ring->wake_tx_lock);
>> +                     break;
>> +             }
>
> When this breaks, the frames stay in the txq and nothing restarts it
> until mac80211 queues the next frame for that txq. A sender waiting for
> ACKs then stalls until its retransmit timeout. With AQL I measured this
> in v4: one download in three stalled, max RTT 347 ms. A restart from
> ath11k_dp_tx_completion_handler() fixes it.

Good point. The break when the ring is full is intentional, it keeps
the frames safe in the txq instead of the current -ENOMEM drop. Your
TX completion restart (patch 6) would make the recovery from that
stall faster, which is a nice improvement on top. Another reason for
both series to land.

Since we agree, I am going to split ath11k and ath12k into separate
series to try to unblock both.

Thanks

Best regards
José Ignacio

