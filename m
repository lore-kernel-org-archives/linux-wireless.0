Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B5233BBB9
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 15:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788534077; cv=none; b=eu2iTN+l9NtVWTODOFE3SWDEXCD0AZgQ4F+po5BAdFWoGiH3D3Ei6r0sR6jNKYVhwSMj4qxBBsQGc5gO/1N7LzBaGterEsxFM6QvvyCZPUsIKOBdWUQ9gUfzElA8SS505f8Z7+nx+LUIHfFoe4LmlWiJ3Mlr8smdJlc+ZxIdc1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788534077; c=relaxed/simple;
	bh=Ae1P12HyG5tRBwMBW95UM+Lon0ODN5CVgKbKpf74KT8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=TTDHaLghimjNOd7HcggVY0iecrrcNCJnGSjvYIkKB+ugEtPTOYu+nRYWeNHx78fXjKZqO7bS/MTfkMWkZYJ7SB/onxiYSBcXwM93sSa044h1J39VQ/uSjaT2rYhiuvaI3ivzpMDkC4b/eI4ahmVUVIYQzFe1/k4EmwOjUJpgfgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=S0UNorH7; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="S0UNorH7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=Ae1P12HyG5tRBwMBW95UM+Lon0ODN5CVgKbKpf74KT8=; t=1788534074; x=1789743674; 
	b=S0UNorH7gdMZT+Em5/wQhHI0gFIOqsy/KC/Icr3wC8VXMWehAFM41g9ujIP9F60lupAowZUAw3Z
	Evr7gtTM+ECreUs5YhSURFQ5zFAj6ckP9WBJfYu2rnduKlR72vTNW/da4R8G37zWHKSGjTf2QSmtA
	QnuMyTprnG0jbtYXbyXeMIM3N4U71a2zzPIGsa4jNI/iXyQiLf9GofW4YsbhGLpGyD7aSdMsotUZH
	SchdCuzpTrEwQErDng2pBkH4xhpxEyFO+rq1d3a6ATx2mRMxtGBf04+pl7y+BQh7va3npTVv8IwNm
	jV3ka0ADiZzSLpEjCNX5Np2ZyE3n/aqszo6g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VPj-00000001SeL-0mkB
	for linux-wireless@vger.kernel.org;
	Fri, 04 Sep 2026 17:01:11 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless 00/10] mac80211 syzbot fixes - part 2
Date: Fri,  4 Sep 2026 16:57:59 +0200
Message-ID: <20260904150057.424369-12-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The last patch isn't really syzbot per se, but fell out because
I originally didn't have the leak fix (c3e7724b6bc2) and then
ended up with a better fix, this then just remained the userspace
side fix (to report the skb as failed).

johannes

