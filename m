Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6216E392C25
	for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2026 06:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782802266; cv=none; b=Ha9+k50DrMpOktIabxTphnzhvyiXC92YuWJKcx6cJUqXy0VZkK3Dp3HoY4F1++nls/PrhkQ92oroGZc6y6ePg+X9iVIgd5HrwYKQEy8sVAtaZ2VmYNHTt5CO9xp7YcVCfqCefBVLY+78VnkGJHy/UEkLG34GnineDGhe40KAjS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782802266; c=relaxed/simple;
	bh=0SLTnVFQYE/0EtCI2H6WZGIsKerglbl6i7efRla3+Ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JbZCLktPKoktzfOIzhTzQqEuS1Fy+8N+Uot/HnnhknmubSasSFDHakXK1YV11oHWz8k4awH26N2CLLSQo2RIa/Gw9ulASrVZ5MZRahQyiSnxj0bb/1Em4NSmvp1OoPVWmnZ9blFj7aDec2vV0AqLzofCVI6F3/NE9LCvZG7PIvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NSIecMeu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NSIecMeu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782802264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3wFM+qQ+PCpHfwmNDavlyB14ismXSTytrKAislY/Tc8=;
	b=NSIecMeufVcPwKKYZEV51HVAZnISlQ64G+y3E5sMn09Gq//YKZU1YOyAzIgB/X9HYAq5vC
	4mh0DNuD7SFFF7FaVAj/AMd7XsIJiGdGauKqTFEs7QrKIpGzKkwURyjSD0LjFFpfl2VsvI
	/SlqxSqmFK9tMbrBjtZ9U6m1WsfTpNQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-678-getOf6FbO_emDKuE31A4Ag-1; Tue,
 30 Jun 2026 02:51:00 -0400
X-MC-Unique: getOf6FbO_emDKuE31A4Ag-1
X-Mimecast-MFC-AGG-ID: getOf6FbO_emDKuE31A4Ag_1782802259
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F41211955DDB;
	Tue, 30 Jun 2026 06:50:58 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.35])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5B2AF180057F;
	Tue, 30 Jun 2026 06:50:55 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: johannes@sipsolutions.net
Cc: emmanuel.grumbach@intel.com,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	miriam.rachel.korenblit@intel.com
Subject: Re: [PATCH 1/2] wifi: iwlwifi: enable MFP_CAPABLE in FIPS mode
Date: Tue, 30 Jun 2026 08:50:53 +0200
Message-ID: <20260630065054.199048-1-jtornosm@redhat.com>
In-Reply-To: <11d449ef4691092dc669cdffb1bff72d2684b739.camel@sipsolutions.net>
References: <11d449ef4691092dc669cdffb1bff72d2684b739.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Hi Johannes,
  
Thank you for the detailed explanation about the firmware-handled robust
action frames (CSA, Block-Ack, etc.).

Now that I understand why MFP cannot work securely in FIPS mode on Intel
hardware, I'll drop the patches.

Thanks for your time

Best regards
José Ignacio

