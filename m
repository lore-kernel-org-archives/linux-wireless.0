Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E3540EBA9
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 15:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785770344; cv=none; b=EXtWEhP22LYyij7GUmCPBWpWXLopWvSpW5Oqs+Czrhe1I1DvzeaDBT18AkkNqIORaxx4klxEOpISQOX1oh8jUxpOrvjXB5VwGQG55TzWYHadnw0elGIkFUMqJl/oUvtmoXYkSGk/8kG3rxqz7RMKlAw9rgHkrBqkjVFlBA4PC2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785770344; c=relaxed/simple;
	bh=Fwo7ln4mMlWPfTQKRsYazrT8UricXwcCjKeDs9xlLgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BIiIg6UywsFKcGn/cUF4GXTwMb3ly5tts61t3fndGJrXyWHMO3FzKULxm21lSi13w+LPIa+U/9UrIjcg9+L4TKZ4a39Lxw2H1MHHTV3IbRsXw0snHnbW5WKcgNHJSJXepSTIGFexFMKn+g2ckZHaNuu2RHNMSLE6VNhEXwvpMDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TUTXpYbo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TUTXpYbo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785770342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fwo7ln4mMlWPfTQKRsYazrT8UricXwcCjKeDs9xlLgo=;
	b=TUTXpYboX4fUt1fh8W1DUy9ZeYNKxuQ52fI+TIUPEUxHWWbjQM9W3acmmwX3LRc586z1a8
	sBmwmpnJ/uk5iKZORR6/HbXoxXP5gyU4cVr51luxLG69koKjGvYt/UKm87sTY3JdDZd27M
	tzEbauTjAy9YALCu7FCUuxfJVyDTehA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-690-6uoixE_1PSGDw-LxHnr54w-1; Mon,
 03 Aug 2026 11:18:57 -0400
X-MC-Unique: 6uoixE_1PSGDw-LxHnr54w-1
X-Mimecast-MFC-AGG-ID: 6uoixE_1PSGDw-LxHnr54w_1785770336
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2482C19560AE;
	Mon,  3 Aug 2026 15:18:56 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.107])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E435B195608E;
	Mon,  3 Aug 2026 15:18:52 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: baochen.qiang@oss.qualcomm.com
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	jjohnson@kernel.org,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/5] wifi: ath12k: fix MLO beacon handling using per-link addressing
Date: Mon,  3 Aug 2026 17:18:50 +0200
Message-ID: <20260803151851.29268-1-jtornosm@redhat.com>
In-Reply-To: <87f02c36-6257-4713-8d39-370f575ecd1a@oss.qualcomm.com>
References: <87f02c36-6257-4713-8d39-370f575ecd1a@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Ok, since ieee80211_connection_loss() is per-VIF, it makes more sense to
move connection_loss_work from ath12k_link_vif to ath12k_vif.
I will try do like that in v2.

Thanks

Best regards
José Ignacio

