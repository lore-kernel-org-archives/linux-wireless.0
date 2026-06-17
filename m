Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5244A13A1
	for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2026 15:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781711253; cv=none; b=qrs6FBEz6o83/7DQ+hm+rlxmRN5r8oXHEnKuP4xHAdPO8ISiQZy9abHPRnzbnfktpisjBHKC7IT5oDXDRoG33WpOXwtgAduSXVxR1y40AH9I6MagFBn6vTAVEOtQghGOokCg7Eef0jS692IWfexdBNLh5dtuUpIiu+9z5dZnVak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781711253; c=relaxed/simple;
	bh=UOoz0VXuftkcz9panXwsJDnWgJs0yaCPDgn5Os6izNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dNB3CUhWH7nbOOqLVUEnmZj4/soOEDlifmDuj2RCLVEhsaptR/fAVggoq7njYVnmpISZCLajf2Vlq2fvsFS9x7OYp8Ov1pogNNpCsNamN85iN51zGNjfSVdkSPFQTF+C/a1SAn3BDh9qne2vHrUoTXfNn9eDVgWmC75Gcsr5vPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J+Q0Kr+F; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J+Q0Kr+F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781711241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kZkkt7pTAcwVisdd5LWiHecZhGxj27GXnwp7KJTgyC4=;
	b=J+Q0Kr+FdNcBGwgye6JFbNVi10rq/24AVxHQZ5A2njrPzldFGzGA3IAHl3ApjTPxzkBo2b
	pyZiaIEoYylnow1aosKS99BURqQ+NnOpfQ5qW6nnj9sTEtsXbnOudZfgr0gsU9fTz4qN1D
	5BqA6yAGP4vxEU6yZhMXmRUd9CJAt+0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-661-X1sZflmnMEizcLDBGUmEqw-1; Wed,
 17 Jun 2026 11:47:17 -0400
X-MC-Unique: X1sZflmnMEizcLDBGUmEqw-1
X-Mimecast-MFC-AGG-ID: X1sZflmnMEizcLDBGUmEqw_1781711236
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C724519539BC;
	Wed, 17 Jun 2026 15:47:15 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.32.13])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B77E11771;
	Wed, 17 Jun 2026 15:47:10 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: mani@kernel.org
Cc: alex@shazbot.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	bhelgaas@google.com,
	jjohnson@kernel.org,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	mhi@lists.linux.dev
Subject: Re: [PATCH v9] PCI: Add device-specific reset for Qualcomm devices
Date: Wed, 17 Jun 2026 17:47:04 +0200
Message-ID: <20260617154709.186286-1-jtornosm@redhat.com>
In-Reply-To: <6nivb5fncfd5dwqkzlxwhtgbsiqvifazcbgpsgukp44iib45ke@65qpwgrvtkgn>
References: <6nivb5fncfd5dwqkzlxwhtgbsiqvifazcbgpsgukp44iib45ke@65qpwgrvtkgn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Hi Mani,

Thank you for the internal clarification and sharing this information.

I understand the behavior is firmware error recovery, not a proper reset.
However, these devices are widely used, and the inability to use them in VMs
is a significant problem. Could we explore options to achieve safe VFIO
operation?

  1. Are there ANY alternative reset mechanisms besides D3cold? For example:
     - Device-specific registers or commands?
     - MHI bus-level operations?
     - Firmware commands that could trigger proper reset?

     If such mechanisms exist, I'm willing to implement whatever is needed.

  2. If firmware error recovery is the only option available on platforms
     without _PR3, could we add software steps to make it VFIO-safe?
     For example, before/after the D3hot transition:
     - Explicit MHI state teardown?
     - Firmware commands to clear sensitive device state?
     - Additional verification or cleanup steps?

  3. The practical challenge is that _PR3 support is not available on most
     platforms where these devices need to be deployed (desktops, servers).
     Additionally, the general d3cold reset method has limitations and
     remains unimplemented due to the concerns raised earlier (ACPI
     portability, bridge issues, runtime PM complications).

     If D3cold is the only proper reset but requires _PR3, and no alternative
     mechanisms exist, could we consider accepting the firmware error recovery
     behavior as a last resort - clearly documented as a platform-specific
     workaround?

     Currently these devices have no reset capability on most platforms,
     making them completely unusable for VFIO. Even an imperfect reset is
     significantly better than no reset at all.

My goal is ensuring these devices can be safely reassigned between VMs.
I'm open to implementing any of the above approaches - or others you might
suggest.

Thank you

Best regards
José Ignacio

