Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406DC41A4F5
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 12:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785499443; cv=none; b=MFU5PGJBfjvOjYv3zaR4fVGkfq/PjyLpVsp5JcW03k38X5ut9c52LQ6YOUt4TL6DSwyYIL5smBqEij6cYdfDIaJU6W24nEbPtfBwjKuTxqkyjz5VE9kKGhLLXp2t7vjafB85rb6SD5uw/vQOAcNYkix39VbXk2Qug0CUCCG435Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785499443; c=relaxed/simple;
	bh=kjLbtss4LOTuYlFrW0l71ihLZCxRVxB3wFJ64swH7II=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=nRMmyjDX9cZRkNPeX8olV97J0a739szuCOqceRwjZWqbzLB2eqXviaOMcc2+GZMuVJf9hfgdW4khRAFQztidhnKsUn51FO22CTSAYmgfD4VfTGUQCBUkkWIKF2ml0bwq5b3NlQzBZQQ9IymL8LhVX0AsjItBD+kcfClNMhdHwE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=OBnfdPgw; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="OBnfdPgw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=kjLbtss4LOTuYlFrW0l71ihLZCxRVxB3wFJ64swH7II=; t=1785499442; x=1786709042; 
	b=OBnfdPgwhaKzSoScsXQyGp5LV0DmlT920lpQN2zlLWebxDPl0uYo9NRAufKkKJERTD34yivusWD
	i605qQ1onZG/6Bg4MZT1JXVhGzC95Ddb1ufKAS6+z3p1dZ9eDU3566cz+H1uYzOm4eb4wTBAKoZ+9
	CT5eJP/2AY9mDQFtMTLEurSukvqgSkxnoU6S97yO4ifHZJ2wBQG/Qo3urpAdzEpqmji5jv4+loywa
	L7StEeKBl9gfuqmdX7MX/+OVVKiwDWSVrNb7qaZLNmM/1MLKKtz+bszCJuTu8D6V67WNHBDHN/mxy
	oE8EtJFYYNixu/Unsld81NOmozZBj/w3QbOA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wply2-00000001n1K-2bki
	for linux-wireless@vger.kernel.org;
	Fri, 31 Jul 2026 14:03:59 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 0/2] UHR fixes/updates
Date: Fri, 31 Jul 2026 14:02:31 +0200
Message-ID: <20260731120351.213903-4-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clearly we all missed the DUO parameters in the parsing.

Also update to D1.5, which will likely break tests without
the corresponding hostap changes.

johannes

