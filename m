Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793863500;
	b=zF8fV6Ui/S9z4cCuGPcYDOzs9fARE+11928R8LvufstAhONOVkAmFFvLU6m3NnRacFO0
	 UyY+1qw96DhWoOpgJtVaT2+dUF007zXi9pEUa5CUKQlawVXqVNYxEEqeclBn93UJCli1F
	 +uNTcFz8wXqq52caIqkhE4aV5627agDF9YNqV7ToFnARlZkZz81PlXRt0pqWVr1JGm5nY
	 BiY6vsHfYTi+jwKuBQo37sSG+bdMl+pWrKSLtO+HmnW/RTp6d3CW72mU3fNvVf4jj0qc+
	 yWFufWzxoDzhE76fQgWqK4lEfjbCYxNi8rv7AkoOdpUMhjOvQij6mQVgtt1/wscj49A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793863500;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TumIRDjDP7xpvZ8aC4HNMxV/sBJyLS9Jb8beUibaK0k=;
	b=sHBUewmlmEQn6FO0ZRpo8PS88M5sZRQxQetUAZs/WekOZhwzdQNDhIznr1pgTdCffBhN
	 pCAuf+Pw+AdDwV8nXJybHp+sueWg4W71wxH5xs1TUYrdLtkyBHBT5zg1rP/jgMxYiS6nx
	 N1/0fiFneWC9SUY3ArYIkd/2AqRPSoTUMdLG+zRa8KDS+RSg1ZEs2fSgn4+P2UIB1N7Qu
	 HVqqFOeCS0G58dvbEyM2P10NCnXI36hJPU3UNsKS0p3gVgjL/Wc2oAXmDoSFWqaimmhZI
	 eLz4K255+YZxYbbXYGquMbeJjtzgN/qVKdrzIgrwlNlCrwR73MSfAgz03sW0tSDA+gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=fqV5IwQw;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EC7606A326
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 07:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=fqV5IwQw
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=TumIRDjDP7xpvZ8aC4HNMxV/sBJyLS9Jb8beUibaK0k=; t=1793863498; x=1795073098; 
	b=fqV5IwQw2qdspBdPeOlri65oRy5hGQ31QQ/oJjXujxDRdzer2LQH/Cor7seuGjAZraFwQTQaq8E
	kQeLjA8OMBGr8ImJJn1zD0QExCr3cUYYggeG0xHl/yuArblqhkcwhRorGfxvwoB66VstJWWMggXDx
	6SmXJByuTj/g8Z5WNnxuZNwlNTstuzzM8fqJ1R1LFwLfKaTqJzbvB1XY3fgWERe0VvlmGaN9ADkA0
	RaU7vZ7sUsrfa09GmKGz7rJsbnS/108+E3m8bFcKyoCkaAwis42apOGg8XrWw0Mm1i2nkex2H9oUE
	jzvJ1WTG1aHe01SFYlwsNEUJTJ4eewSWzCqg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xOrqB-00000007Ped-0S0T;
	Thu, 05 Nov 2026 08:24:55 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Subject: [PATCH wireless-next v2 0/6] wifi: fix regulatory domain ordering
Date: Thu,  5 Nov 2026 08:23:48 +0100
Message-ID: <20261105072451.1710800-8-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Repost after the discussion about ath12k, no other changes.

v1:
https://lore.kernel.org/linux-wireless/20261022101836.148512-8-johannes@sipsolutions.net/

