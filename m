Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F124B3F20ED
	for <linux-wireless@vger.kernel.org>; Wed, 27 May 2026 10:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779879171; cv=none; b=ePMlLR/S4fOPHt+mk/tnGpWfWPEbMTqF9jjIuEn6o7/lK9RljhjsvKU+PEWuDfxTXknf0LGzyi+l0OyvG0NiDrY6goBy0opbI6g1zjBBdprW+7HLMSygk0BHHNnIuLPqXHRnDiZFQjfGGAlNRZyaazNPV04QU2cC2TEUGWcTIoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779879171; c=relaxed/simple;
	bh=HOXuu4zPdvj+1LjmBJkKxUkIixOG1Jc82+V08GnRTaI=;
	h=Message-ID:Subject:From:To:Date:Content-Type:MIME-Version; b=VF4YBPJstYYJwCLmpQMgfKq9BdDsYUmOH1VNCbeIm7I0T5bEiVEn9Zg+Hs1mEG07Q3lU194Z4Ung1GlR1CRSZLRc2sy3Db4aJw1rtmcZC5cPf/GD8bw2MeV1JYQDDl+ZyKjvhVtgyNSq4XqPgtaHJPK2JnRJbMq1EA0TNj5kvaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=AnJ4KxWd; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="AnJ4KxWd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:Date:To:From:Subject:Message-ID:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=HOXuu4zPdvj+1LjmBJkKxUkIixOG1Jc82+V08GnRTaI=; t=1779879170; x=1781088770; 
	b=AnJ4KxWdLHNONcjcIReGg9CKq0iKxJUOPzCIZidO7r/KV0osFY+Xr7vwsAaWMRXAuL2SOK8TjQz
	xhmawzVMDJgueALm8QW/PPzpWhkc/NjfRcqvoXCjs5mrz66iD/X04hW1YrdoLiRtEA5nG1PRSesFU
	3CGGsRkup7haTjTdXioaudJ4+U4PhQomSluey1hqw7wXHEmKcWLEsMLRO1B/eDLfAy4fE/U5Fox4X
	z3U8+03Y1Q4DipRKqmjq0rqxJidStZgr/XV8cHWfVlrT59s/e54tYGDQ+lyJ0rzq4R7D9VA3tHUCb
	mFFIqZWzk+SEYzTZ0PkJ0kXKA91pYIsTTifg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wSBsV-000000062Xy-2Q26
	for linux-wireless@vger.kernel.org;
	Wed, 27 May 2026 12:52:47 +0200
Message-ID: <a5615f2658fe31a32836d02aa0f2d69027782bea.camel@sipsolutions.net>
Subject: NIPA/wifibot disappeared
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 27 May 2026 12:52:46 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

Hi,

Due to a mistake, the machine that was running our checks was
decommissioned and redeployed about two days ago.

I'd been planning to move the service to the servers that we have at the
netdev foundation for NIPA, but hadn't actually started doing that
because I've just been too busy with other things.

Right now there's very little point in bringing up a new machine in
Intel since that'll also take time, so for now we don't have it until I
can integrate it all with the infrastructure running on the netdev
foundation servers.

johannes
