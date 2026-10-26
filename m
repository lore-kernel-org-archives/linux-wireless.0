Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793015511;
	b=SuANLD8E0/aE0Rx3P/VV+iNWeBdgCvzNU622/XZ2Oh6bJewaVhggP4WmTT82mA2hy7SV
	 iuQ2Mnj39DP1AhQd/xOtpE9EXYe204WVOyQb3b+P7Bssvqx2Yr8wnvOod2vG6+APCTFJh
	 lFZLpt+M5K6MQztCp+6TGrUmRN2D2A9KLbGjEBVpx+Qo00BvEta02S6MKaX9wqoIuvH0I
	 w5688GZqV/tC7qh2lGxTiS1u19OwWtIi0ATqtbsWi37tuyQsnPWf+skufLZEay1aKvQ9F
	 pkVNce0t3xFmvGE+hCpGbPIyfjQyD037OIKuov3R3MfIDHzx3YNW7D3O74iO4qxbjPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793015511;
	h=DKIM-Signature:Received:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8U7mH7XhMUR3hbC/WqTVDbZHhnk5jJWl1PX/0lwhiiM=;
	b=mcxEjlY0+7OVrkKaKt2nI9gm7qEF22tOpikwAeBzeO7X4Sv3tcUMN5cUPvdhhWkiZtVS
	 JcWpR0kJOzLteDFQPNkOlU+7WivDuyOxyrZy5unwMQ/N+CetdATEmzOMlxjhNwZcjCssp
	 rY/k3iH/Adksr/zoxU3iXF1RGX8GJmtijYRLX0C7JJ0mhZa150/MpuUnFIQWJoD2RZ3bS
	 f+wpALTKi0jlPxWyID4PV/JQXrKZPKfqOISZF2iRWuq1rmxVdvbGgb7IRJG8AuW23mvRH
	 HafhvgqKa3RyzgTFsZfn+HwklunQpn7tyz7EMvaPKJ6VXkp0ITgAXTfIX9WT2Fffgcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=miAWbKmE;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D343606A337
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 11:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=miAWbKmE
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=8U7mH7XhMUR3hbC/WqTVDbZHhnk5jJWl1PX/0lwhiiM=; t=1793015510; x=1794225110; 
	b=miAWbKmEGyG0P1CqdQGxOp2aQPIUWbNHfW0mmYAXq0lUaNnTxD+l0VvWQgeFHI5Tpr8QBg6+R9g
	U6DFhvXfAQTQGYIENey5xQoao0UsIxVuYUVAYYbFONskNwXL/OApyjYTSt0r9Yz+8z61JRsDRnIMK
	vbUnu/htGsRRBZrdZC5SV9vEY2alTo/kR9NP0q/2Pn0J6vOmcJB8gHROBTKe/SKQ3/772phgevENf
	oPW/wLvK3YsPhRKzo5upIEJlG85JHaOCe3VLBe3BcxSDV87JgpEnh3q+sP3m3dtGOj+ZOijxB8Pp6
	AaREsqunQUsg73jf37D+t54WBt+C3BhZBDxA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xLJEy-0000000BDPs-3c6U
	for linux-wireless@vger.kernel.org;
	Mon, 26 Oct 2026 12:51:49 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 0/6] wifi: mac80211: key RCU improvements
Date: Mon, 26 Oct 2026 12:48:34 +0100
Message-ID: <20261026115144.189706-8-johannes@sipsolutions.net>
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

The synchronize_net/rcu in key handling is expensive, and was really
only needed because we tried to be precise with the tailroom handling.

As I'd mentioned earlier, it gets a lot simpler if we just accept the
SKB realloc in SW crypto race cases. The race should be rare (often
impossible, but in ways that's difficult to put into code), and even
SW crypto should be rare already.

So this set of patches changes that to accept the race, and then we
can clean up a lot of the key RCU sync, which should make installing
keys quite a lot cheaper.

johannes

