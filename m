Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9E6241E4
	for <linux-wireless@vger.kernel.org>; Thu, 18 Jan 2024 11:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705576794; cv=none; b=VUgsawd7LJ3WXBXHs6eqfr8xoaur1jdbdClJntBUA1k9PSVQf+3IfbLUBRz690AFKzLEqwYVvhdDy6nPQSRYJm32C6Yobmnzo/GZrqNvIgSXXYMGBi0m/u2VyTlL59o9ez6IzCUN78CK8VhICJOVYU9crTdGFJuh9v3Du5PThbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705576794; c=relaxed/simple;
	bh=9UFv85CXyZhadbcU/5dGWk0TxNX+QrWpN2fT67eMbbs=;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding; b=dJjhqyVJ2vKt4lYNhCsS0+28RcOCOp+1fOo5PIsbqNz3ITGrg2V2kynUVgPGmbDRA6bxAb2Sq6OUUF4DkfaPXMCTTTPKAx+G3N0NA09gN48mf6jUIp4FzrA6BCP3BSzBQgDgYaP6MOjFKqIQUufbAVUAugSDo/dznsTh5imKFCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=VkkWcRYA; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="VkkWcRYA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=9UFv85CXyZhadbcU/5dGWk0TxNX+QrWpN2fT67eMbbs=; t=1705576791; x=1706786391; 
	b=VkkWcRYATwi4szuPKw/JMlAKhpkdTTPl4SPGicixs6RqD09ihTyP3AoTwObshMFPp/zNKKGA8DP
	hyWRwtMLUZRfE5DPYirt9RhjPErPkx5rI4zOj85X8oNu2npBgNXYyQoUh+qjH0p0hpXA2sHy/Zdfx
	u08FTf1BdbL0dYf7asgClLfvhElO1rCAZ1b5XN+DYIx1mJ/F3sGDt6/TGLTqvCr3FCDjEDP39zqti
	hDFoIFQPoIyTh8RqgeUEUHG80Vm8NVwlC3G9QwQ+SRJu1vJaeYubRtFs8cSjWlV1UQulgdGQLuIAl
	Wcv0Grp+NupA2m6Ll70cWBSXrwFfYPhoJo0Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.97)
	(envelope-from <johannes@sipsolutions.net>)
	id 1rQQR2-00000007wVW-0Uy2;
	Thu, 18 Jan 2024 12:19:48 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: coldolt <andypalmadi@gmail.com>
Subject: [RFC PATCH 0/2] wifi: detect stuck ECSA
Date: Thu, 18 Jan 2024 12:16:26 +0100
Message-ID: <20240118111941.549593-4-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a pretty specific workaround for what's going on with the Asus
AP codolt has (btw, could you actually mention the specific model and
maybe firmware version, just so we have a record of it?). But I've also
asked around internally and while we had encountered this with Windows
(too bad we didn't check before, sorry!), no other case is known.

Could you try these patches? I didn't (yet) attempt to reproduce this
scenario.

Sending as RFC to see if this addresses the issue - I will probably
refine the logic a bit, e.g. if there's no quiet and the channel is
the same, we might still want to connect? Not sure entirely.

johannes

