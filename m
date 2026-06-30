Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347D737E2E5
	for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2026 07:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782804056; cv=none; b=PEv6/UFC3dUYM6LwWypaL5uXRwdZY/q4F9ONpkYUYxv+ys7wRiiYE/L+ciVghC5XznLL2YJKAgloEBkIB1ARlarhkxHXPgSrt/rAec/TUYDDZaUFTzo3L/K0tLG3xdeS9Q1PmXxqGk1uB3ipT9s4a8HbQmKGixwKvX4HYWpZPxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782804056; c=relaxed/simple;
	bh=R5xzPinaxWKLBNx8Ajs7eIAFt/4mO2TmdBKEBSXOxAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qs6ZDWDvNViccPfoPOb5LJoE207cQ1nT34I4zyZe2cWLCfW9BtZueYpy6YX62VK1ZuIwQZgPCIfoY+9gO6W+5OtgsVDOKdV3Y748nJUJGIJ07CnP+ehj/KSnQoI4ElTJsqBFpApZjaX8e62CX/jsyY79XCE+LQJPpWrBg0xf6ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ELUfd88z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ELUfd88z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782804054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R5xzPinaxWKLBNx8Ajs7eIAFt/4mO2TmdBKEBSXOxAI=;
	b=ELUfd88zar+feji/zMA5/wAOrVB0W/bcz4Zfe53NBhd7Vxd12NpLmpUBL6VirsHFkO9iW4
	gd5lN4J1D7PMwuMFbfOwfGol5s76ejjUqoxVxaUIQXvzJ3a4FUpXutBP2M2QAGJ3eev/y2
	mxKw31GE6dVU6SoXjV4/CJXei4iSjLE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-531-6ScyCiW5PNSxNU_bXmBlEA-1; Tue,
 30 Jun 2026 03:20:52 -0400
X-MC-Unique: 6ScyCiW5PNSxNU_bXmBlEA-1
X-Mimecast-MFC-AGG-ID: 6ScyCiW5PNSxNU_bXmBlEA_1782804051
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1CF591955DD9;
	Tue, 30 Jun 2026 07:20:51 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.35])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CCB33195604E;
	Tue, 30 Jun 2026 07:20:48 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: johannes@sipsolutions.net
Cc: emmanuel.grumbach@intel.com,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	miriam.rachel.korenblit@intel.com
Subject: Re: [PATCH 1/2] wifi: iwlwifi: enable MFP_CAPABLE in FIPS mode
Date: Tue, 30 Jun 2026 09:20:43 +0200
Message-ID: <20260630072046.201393-1-jtornosm@redhat.com>
In-Reply-To: <588f665e6c1e8a24d6cee56762ae754f39ab9703.camel@sipsolutions.net>
References: <588f665e6c1e8a24d6cee56762ae754f39ab9703.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Hi Johannes,

> There's probably something to be said for the second patch anyway.
Good to know, should I resend patch 2/2 separately, or would you like me
to wait until I have the customer use case information?

> Also, maybe we'd actually be interested in who's using this and why,
> it's the first I hear of this outside of _very_ niche applications :)
I'm collecting that information from our support team now and I'll share
what I can once I have it.

Thanks

Best regards
José Ignacio

