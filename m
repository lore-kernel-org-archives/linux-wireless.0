Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3614E80B4
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 15:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788534147; cv=none; b=EweUv4s6nOSoi5absKvUkjjx5wpAo67RzGIHYQbHVWGI2BwCjVw6WkO/9WOV91Uqgs/aYJ2rxMt5mpcQr++VHMT3fdE0k9VcFHQz6Lh/HbzH3ro9dzhkEIrNDpenBxnCH2v6WWI5IdL3jFoQUnLijjCOIBVt94XcWJWoRaunadU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788534147; c=relaxed/simple;
	bh=AoSCxUGIEJPDsXCkrQEbi2OM+qazp8T1pDSS45pxtn4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=bLZzjYUBN+2BuoOLkQ9kas1hQnjkqPTHrDD4MuYrRkjelJmVEkkBgYsfeuQNtdxOBPL2dNFMVua8XVuK83P2wMBCxGPbIeTPk9LwwteDGUM08KIp8N+PTSF1DWFKJDVXXDLroagNjQSh0mTop3mW/ndqVPLDAX4JqkiIvYs+hJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=BE7D+vn/; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="BE7D+vn/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=AoSCxUGIEJPDsXCkrQEbi2OM+qazp8T1pDSS45pxtn4=; t=1788534146; x=1789743746; 
	b=BE7D+vn/3Bu//MsJZWRa6vCnsDWXmDz5XjVR6bBOAExlVxCSfg/RCDNDLO1UFBGH+DcRaZAhjsG
	NKlO/UMwEmlhhdGVl3Kug43gqrpPLhuMsCjTSgg8AiuQ1y9MQo2hT4fup/3yMeVzN2xQ0iJPcjPWe
	zC8nnU/nd5vRLvt/UUgjJiPn9Aes3QH95ejgnbGyiEn+Bla11Hm63O+bznb7URdyB/YWyPqPrvXb0
	NxpQrYNvHAgcMQ++Rl1owUe9eKKurlpeVdd/askauwJGhOYHeeHgE8eJODcU+vDLI1GGXtVSv2LlI
	z175SzIokOvA3ni30N5av6UQUsJeUaU+5Cxw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VQt-00000001Sh8-0zDV
	for linux-wireless@vger.kernel.org;
	Fri, 04 Sep 2026 17:02:23 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless 0/4] wifi network namespace fixes
Date: Fri,  4 Sep 2026 17:01:58 +0200
Message-ID: <20260904150220.427345-6-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Couple of the fixes go together as network namespace related.

johannes

