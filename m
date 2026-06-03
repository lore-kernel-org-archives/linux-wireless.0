Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B324F39B95D
	for <linux-wireless@vger.kernel.org>; Wed,  3 Jun 2026 07:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780470965; cv=none; b=bvsKDARdXJQBeZP5kdB4S2kQiQsouuepKOb0q0F7e1l3jxxRgpKarggWcfnwk0H+ONokvXbfPE1y0lfAXDzC0AYkjBJkr50Cc9cpDlOfzww0AZOCXP90xySK11HmvOLMLduGEc5BOQn1untMJtEncd7Ns0MWFDg5omSO4h3e0VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780470965; c=relaxed/simple;
	bh=raSHNDbgRafiNuLcsLcimsX1g+XRFdTvEE8OqtsWBtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZrwPJDd2wW6kkCghUP/M91nDcTS4HZNhdNr8dqonXcPJVcyDkXm4RlhUI0+CeuEz+jvz8k/8HTZar2q/kq3XyGOFaHIvyl3N+JBCeUbInxld+8LRN9oJKacq2NFFg9rUWzCLn4wtXMp5ZJmUrThVEP3aZrEHGQjwOTZBYb2XJgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b96qsHc7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b96qsHc7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780470963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=raSHNDbgRafiNuLcsLcimsX1g+XRFdTvEE8OqtsWBtI=;
	b=b96qsHc7SfLx+Xi/i5CzN7pAp2nwr7R0IA5g+wEMUDAWiYbodomy8bNBdCXh+CmJc6EUVA
	XYtOgihifUPSe7zaLkkkv2YC6xBEb912tL416ICAmAIGDoJkSnXjE1WZ0oZ2bBVG0YUhuB
	dKMS4ikry0y5dXHuYAYGwxhHWZy3mGA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-190-vfAyz7OHMXCwR1IDKYu_Tg-1; Wed,
 03 Jun 2026 03:15:58 -0400
X-MC-Unique: vfAyz7OHMXCwR1IDKYu_Tg-1
X-Mimecast-MFC-AGG-ID: vfAyz7OHMXCwR1IDKYu_Tg_1780470956
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CF94D1956050;
	Wed,  3 Jun 2026 07:15:55 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.81])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 15EFD763;
	Wed,  3 Jun 2026 07:15:49 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jeff.johnson@oss.qualcomm.com
Cc: alex@shazbot.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	bhelgaas@google.com,
	jjohnson@kernel.org,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	mani@kernel.org,
	mhi@lists.linux.dev
Subject: Re: [PATCH v6 2/3] PCI: Add device-specific reset for Qualcomm devices
Date: Wed,  3 Jun 2026 09:15:37 +0200
Message-ID: <20260603071547.14673-1-jtornosm@redhat.com>
In-Reply-To: <dc836218-2f18-4465-882c-c41b5289c379@oss.qualcomm.com>
References: <dc836218-2f18-4465-882c-c41b5289c379@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Hello Jeff,

Thank you for the feedback.
I incorrectly referred to the drivers instead of the actual device names.
I'll send v7 with the corrections.

Thanks

Best regards
José Ignacio

