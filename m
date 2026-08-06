Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A5C363C77
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 16:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786033948; cv=none; b=UeRdGLR0RdlHWYIxO1lyn27p5sgJqC5OfxXG8mxnvvNo6G2CIl4MAUz0bmlbL53zcVxtFidysEJ+NMANvAITKHmm7DIzbjuGja9Fwc4YBldPh8+COXvNEUOvGeRiXRtoJUydlkA0txP1M1lTgFIPN/8cyx++7jt/T7WuJi9lakc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786033948; c=relaxed/simple;
	bh=F1rNhSmXWKkrN8wHxNtXlB6vvplRuhq8UDqB+/FccaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V2JcJvZbtUuZu8Kqw8mf+XdMLRSi0129fyn2VJk1XKDkNoKoffAQLeWjs+rz0G0FuVheGaAXxE/3RpFCBM+booginJu4fNTEaSTLBvB93TnFmqRt24tOcHSmgCysB5gwKXRr6LOjQWj/qSN+OB5pfLA84znZHJk69qj7oUyjO+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BNnSYidR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BNnSYidR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786033946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lDTtE7ZJ041O2p+3/1BOLbv1tA2gzleDMTuWzYpZu0w=;
	b=BNnSYidRU3Rxq1LLhag8KsQDApZaob4P5xiu99g2MshOplEQ5GdrkWsIeV+odFcnZftfOV
	Wx93EXDC1dq9+0tsTYN/1on5n6zg+6aZD0wXLYoioKf81xOQ/sEwhCy+wA68+DNq60R+eH
	k2A5d46qaf3HU+TSjC72RrlI2pxmcsE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-264-0VUa_VsgNuSjYgTsq7bxww-1; Thu,
 06 Aug 2026 12:32:19 -0400
X-MC-Unique: 0VUa_VsgNuSjYgTsq7bxww-1
X-Mimecast-MFC-AGG-ID: 0VUa_VsgNuSjYgTsq7bxww_1786033938
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4961C19560B0;
	Thu,  6 Aug 2026 16:32:18 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.115])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C2645427;
	Thu,  6 Aug 2026 16:32:15 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: johannes@sipsolutions.net
Cc: emmanuel.grumbach@intel.com,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	miriam.rachel.korenblit@intel.com
Subject: Re: [PATCH 1/2] wifi: iwlwifi: enable MFP_CAPABLE in FIPS mode
Date: Thu,  6 Aug 2026 18:32:12 +0200
Message-ID: <20260806163214.63077-1-jtornosm@redhat.com>
In-Reply-To: <20260630074702.202759-1-jtornosm@redhat.com>
References: <20260630074702.202759-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Hi Johannes,

Sorry for the delay.

Regarding the requested information, we can only say that our customers
are US government agencies and US government contractors, and these
entities are required to use FIPS.

From internal discussions, we understand and accept the firmware limitation
with robust action frames (CSA, Block-Ack) not being integrity-protected.
But these users are primarily concerned with the data encryption paths
being FIPS-compliant, which mac80211 software crypto already provided.
And they would accept the known management frame integrity gap as a
documented trade-off to restore WiFi connectivity.

Since no firmware modification might be expected to address this, 
would it be acceptable to introduce an opt-in exception (e.g. a kernel
parameter) that re-enables MFP with a clear warning, so users who
understand the limitation can explicitly choose connectivity over
strict compliance?
The default behavior would remain exactly as you implemented it.

For example, something like this:

   if (!fips_enabled) {
        ieee80211_hw_set(hw, MFP_CAPABLE);
  +} else if (fips_exception & FIPS_EXCEPTION_IWLWIFI_MFP) {
  +     ieee80211_hw_set(hw, MFP_CAPABLE);
  +     IWL_WARN(mvm, "FIPS: MFP enabled with known firmware limitation\n");
   }

If you think this approach could be acceptable, I can prepare a following
patch series with a concrete proposal for your review.

Thanks

Best regards,
José Ignacio

