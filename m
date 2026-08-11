Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC31A3624C2
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 11:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786446864; cv=none; b=U6zqytQnSRftTlpgDB/JbkEGlbcxqpSt3QbKmnraw2ymUPMKZQjQDvc65DN5P/R/uFTn9tKFP6DpmiEi24ltpQbpWlb4s63e5J8/ltbFo1jxbn5156tP73hQGfoxXa0lJwXHyHzsUVGrsV6zk4tO54QLUfhozV+FOA2SsCYMxYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786446864; c=relaxed/simple;
	bh=i1F5Mb9N/56KREy/HXGSaoy0zpvmNvoZ/zvag2mumFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgxM+vi9HAATmPscpt2CC5mTgu3QquroXdsi4zC2YKCGLWRS6MwF9cl73d22qH8XJHpEZze+snGVuLdmbf/tAOZFDyYnBqFLBBgbTewIB23dmxVJaDNPggWbIE06fmNtT/XZQ89uw0V2tRZF6q6n1YtkhiKGnyXDD6qFaUzPLfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EbkFses/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EbkFses/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786446861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZevwHzhpm82rY3Q7CIME/Xq4cR9/ImEJ3tGIPz//zTk=;
	b=EbkFses/nNXCbwtzNSSU23JIBfXUWjeG/+1/KIcKWXW8aV+D/ASzDgSRmTF7PdHaeD3frt
	bBw01IPd97rnwsLSzZg/mx59k+IlZQZLRRjMlc8VzX6A/n5h9NTozKaF+05lJ6aUmBMmgj
	diLYhB+Bd7fM7eupT32qsO0HDkczH2E=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-331-2ONlxj_uPsi5N9kJgCxqag-1; Tue,
 11 Aug 2026 07:14:11 -0400
X-MC-Unique: 2ONlxj_uPsi5N9kJgCxqag-1
X-Mimecast-MFC-AGG-ID: 2ONlxj_uPsi5N9kJgCxqag_1786446850
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 30E1D1800644;
	Tue, 11 Aug 2026 11:14:10 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.32.68])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 44FB1195DF91;
	Tue, 11 Aug 2026 11:14:07 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jeff.johnson@oss.qualcomm.com
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	jjohnson@kernel.org,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5 4/4] wifi: ath12k: implement custom wake_tx_queue with flow control
Date: Tue, 11 Aug 2026 13:14:05 +0200
Message-ID: <20260811111405.397112-1-jtornosm@redhat.com>
In-Reply-To: <0b72231d-59f8-49bf-82a0-76d2c7862729@oss.qualcomm.com>
References: <0b72231d-59f8-49bf-82a0-76d2c7862729@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Thanks for the review, Jeff.

> Tested-on missing

Ok, I will add it in v6

> NAK, must be EXPORT_SYMBOL()
> The ath12k code was contributed under the license:
> // SPDX-License-Identifier: BSD-3-Clause-Clear

I did it in an automatic way, I will fix it in v6

>> +	rcu_read_lock();
> 
> does this lock really need to be held for the entire function including the tx
> loop?
> 
>> +
>> +	arvif = rcu_dereference(ahvif->link[link_id]);
>> +	if (!arvif || !arvif->ar) {
>> +		rcu_read_unlock();
>> +		return;
>> +	}
>> +
>> +	ar = arvif->ar;
>> +	dp = ar->ab->dp;
>
> or is it sufficient to cache these values and then rcu_read_unlock() here?
> my LLM reviewer seems to think that would be sufficient
>
> note the spinlock in the while loop will cause the RCU read lock to be held
> when invoking mac_op_tx(), satisfying the RCU lock requirement there.

Keeping rcu_read_lock() for the entire function is intentional. 
ath12k_wifi7_mac_op_tx() calls rcu_dereference() internally (on ahvif->link[]
and ahsta->link[]), and with CONFIG_DEBUG_LOCK_ALLOC, rcu_dereference() checks
lock_is_held(&rcu_lock_map) via rcu_read_lock_held(). 
Only an explicit rcu_read_lock() sets rcu_lock_map and spin_lock_bh() does not,
so releasing early would trigger lockdep warnings.

> using guard(spinlock_bh)(&tx_ring->wake_tx_lock) would eliminate the need for
> all the spin_unlock_bh(&tx_ring->wake_tx_lock) calls

Better, I will use it in v6

>> +
>> +		spin_lock(&tcl_ring->lock);
>
> seems this should be spin_lock_bh() to align with all other callers in the driver.

The outer spin_lock_bh(&tx_ring->wake_tx_lock); already disables BH, so
spin_lock() for the inner tcl_ring->lock is correct and sufficient. Using
spin_lock_bh() would redundantly disable BH again.

Best regards
Jose Ignacio

