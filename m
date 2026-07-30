Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08BD3403E4
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785392059; cv=none; b=WpbiqGvszaSIHSXz72OUfKA0xVnOWqFYUW5aiixZaV/WgFaEVEh1Y5SKOubqACAmQRvpw6iTIM5/U3uJfOgwZBI/Pb+veJSa8cWxQzlkhFRkxUUJQ7gvhCglBANfAxnMEr9qy61KRw2euMr5U6orJpCE7qQHPi+q2zc1QAM0y78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785392059; c=relaxed/simple;
	bh=vVj4EbWBwb4Y1hd2TXCbIaVErH/W44BhoaI4UjcNeMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=suLxT4h2KQyqvbM35qwCQP8V2BchqBGnSEPoSzAmHnl4JRB53ZMnIoP+3GMmi8RWO/7mkSSl5bialfD4fmFEgWOrmdgImDmT1aRBtC77fs2Mqj+caAzsgrhak55G1p1ZafiaBtXMMkRsO6hOUoKPDvRP3NguOQirdN8s/JPXLY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eNndDsqR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eNndDsqR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785392045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VxR8UAJtcjYgK0Ks1J1kqZQ3imslT1g86zOzrovDsfo=;
	b=eNndDsqRbApuWtcTSWJxGi623iZcQkSuL/mxiLj2PAZpHwcl6CkubqmkNE2cYMYa+GCauo
	nZFDUxl95u4UyODrvJx4SUFZ+t4e1UqjnhqfaLsfzVf84fTz58U3sbQP/FbPIHxnPNzzLe
	BZaFmX/Rf58gSp+VLV9z15SRI83j7GU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-220-9olPWGfROyS3-zhNItRBAg-1; Thu,
 30 Jul 2026 02:14:02 -0400
X-MC-Unique: 9olPWGfROyS3-zhNItRBAg-1
X-Mimecast-MFC-AGG-ID: 9olPWGfROyS3-zhNItRBAg_1785392041
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 30A8B19560B4;
	Thu, 30 Jul 2026 06:14:01 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.33])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0C54F180049F;
	Thu, 30 Jul 2026 06:13:56 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: tamizh.raja@oss.qualcomm.com
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	jjohnson@kernel.org,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 1/4] wifi: ath11k: use queue mapping for WCN6750 ring selection
Date: Thu, 30 Jul 2026 08:13:53 +0200
Message-ID: <20260730061355.212639-1-jtornosm@redhat.com>
In-Reply-To: <CABkEBKZ7+Z=DL5scE7LnFQz==c3JKoUfFgfDYRf5HoLS_=fr=g@mail.gmail.com>
References: <CABkEBKZ7+Z=DL5scE7LnFQz==c3JKoUfFgfDYRf5HoLS_=fr=g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Hello Tamizh,

> Sure thanks for the information. Do we have throughput values with
> this change?

I don't have WCN6750 hardware, but since WCN7850 (ath12k) already
uses skb_get_queue_mapping() for ring selection, I tested on
WCN7850 comparing queue mapping vs hash based ring selection with
the following change:

  static u8 ath12k_wifi7_hw_get_ring_selector_wcn7850(struct sk_buff *skb)
  {
  -       return skb_get_queue_mapping(skb);
  +       return skb_get_hash(skb);
  }

The hash based test was done on top of the v3 tx flow control
series, which is needed to get stable throughput results.

Results (100s iperf3 TCP TX, open radio environment with VMs):

  skb_get_queue_mapping: 764 Mbits/sec (8.89 GB, 19 retries)
  skb_get_hash:          744 Mbits/sec (8.67 GB, 25 retries)

Throughput is comparable with no measurable regression from using
queue mapping based ring selection.

Note that VM-based testing may not reach peak hardware throughput,
but I think it is sufficient to compare the two ring selection
methods under identical conditions.

Thanks

Best regards
José Ignacio

