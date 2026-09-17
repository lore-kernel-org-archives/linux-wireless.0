Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A227B4399F4
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 06:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789627237; cv=none; b=VoBib+R3FAdxVVXmtFViQdcWvq3W1urIsZptRU2dgJ7obpIx9KaZBZgIn58rhilEv+bbdSHJEKcLS97JtFxigVuhApoUxqNEE7aR/7Z3AvFXs8o5UlNUz6VE4Jk3D8F9bcgMSIY6aSsBuwS58EbWmGpqmoDPr8Y5iK84q1zAxdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789627237; c=relaxed/simple;
	bh=/lUyJrQOsEcQ2LLDS29EU3O8p0fu7SDGMtZO/LgCZq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZSQx01f8tTckIy6Y6Vh9/vQXJcGFIqcvhG2oAh+SGd2jTYYYiZVCxL7USuN8wxDRcpLzg4gVxEo6H0Ztpd7vl3Pwk+q6mzGoAHxNIUl4uJ8HKJzwhz3s0/JgVW0BQbkZ0ImdrwDyi+gqUrWvjrOLXR2fFcbb5Z6TTIC7Kzr7cQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RHGIiLex; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RHGIiLex"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789627234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YlcSCaOgVWAQsVp/37r62Fp85wjLzCNshdQoQFfZFUk=;
	b=RHGIiLexxFL6IqGieVRpYs6QBXMnBliOpRCKyWtPLzUjmtw19hA5oR+bQk5gKp/wh7DqhP
	wJFiG12XB8Sx4l3m2gvtF7+1BkK2eNrtygToJ/YqD9oJEy9J9AwOD3RvvXwVkejifQAEWA
	VSVajXHKdWsXYT5keaJ3IICDZBLO7Aw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-222-KKCv_-iXOf-U2idK-TwV8w-1; Thu,
 17 Sep 2026 02:40:31 -0400
X-MC-Unique: KKCv_-iXOf-U2idK-TwV8w-1
X-Mimecast-MFC-AGG-ID: KKCv_-iXOf-U2idK-TwV8w_1789627229
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E3C9C1954122;
	Thu, 17 Sep 2026 06:40:28 +0000 (UTC)
Received: from fedora.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DB82B3003EED;
	Thu, 17 Sep 2026 06:40:25 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jeff.johnson@oss.qualcomm.com
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	dolinux.peng@gmail.com,
	jjohnson@kernel.org,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	toke@toke.dk
Subject: Re: [PATCH v5 4/4] wifi: ath12k: implement custom wake_tx_queue with flow control
Date: Thu, 17 Sep 2026 08:40:23 +0200
Message-ID: <20260917064024.12175-1-jtornosm@redhat.com>
In-Reply-To: <0bac4c07-6c78-478c-b3ec-1d897cdd8acf@oss.qualcomm.com>
References: <0bac4c07-6c78-478c-b3ec-1d897cdd8acf@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hello Jeff,

Sorry for the late reply, I was on leave as noted in the v6 cover letter.

> I have a fixup for ath9k which does:
>       171 -  ratetbl = rcu_dereference(sta->rates);
>       171 +  ratetbl = rcu_dereference_bh(sta->rates);
>
> Should ath12k also use rcu_dereference_bh()?
I think the ath9k and ath12k situations are different. 

In ath9k, the rcu_dereference(sta->rates) is already inside the
spin_lock_bh(&sc->chan_lock) section, so BH is disabled and switching to
rcu_dereference_bh() directly satisfies lockdep without needing
rcu_read_lock().

In ath12k, narrowing the rcu_read_lock() scope would require changing the 4
existing rcu_dereference() calls inside ath12k_wifi7_mac_op_tx() to
rcu_dereference_bh(), since that function has an existing contract
(/* Note: called under rcu_read_lock() */) and is called from wake_tx_queue.
That is modifying working code beyond the scope of this series. Happy to do
it as a follow-up if you prefer.

Thanks

Best regards
José Ignacio

