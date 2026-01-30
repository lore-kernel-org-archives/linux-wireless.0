Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F159330337
	for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2026 15:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769787785; cv=none; b=aO8rrcP3kkE8d6PeglIGyRECAwMGbk14XUcRAgX5k8s4jYzySydgCLWAroWFsaqJr4f5IfFDVIKiEQSEnwGzXlUMQoikTS5MVOCVjY/J9KPu4pEdRytdg+sFwO+nKjskvsW0QSwsey59mNXxCnTuh9+qFHUpafIpnI2Ec404+SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769787785; c=relaxed/simple;
	bh=au5HVi2q1Pl90AHdlciRGZvP5EyHvZhF5dvk6dlh3ig=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=LtfVp0zXF9X+J6U778ro3DNsZhz6bRDdNU2qaMtpcjArbQP/WtDSWZcGq8FktDjMu92+TBDiQJ54SQFO1E0loby0kP79R3gVHboD/lmBAZ0y+UVHzRIe/Q8I5ELheA16LAILnaaeFglVXqZjEWKCVQGf49pIlc0jPRvyt/ruV/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=iyo9Da16; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="iyo9Da16"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=au5HVi2q1Pl90AHdlciRGZvP5EyHvZhF5dvk6dlh3ig=; t=1769787784; x=1770997384; 
	b=iyo9Da16WfHyIQaBVeJa09Q9GNpSzuZ/e8I1xqB6gopN7YW7v8/C9YPFpz/CNNQP4Kx37NoIjGr
	OSg9+UzZCs2N181duHFa2o7VFpNeEtY6N3vJgBqxksKW7ZTrS4whcjodqRj4EOXWOPFI+SxPzKWOr
	7M1FbrZ7COnICaVhIDWq5JgVAEt/9/wRRyDG8nupMcAhEsEvQ+G34nb5uZZMvJGBagT2OoUACFBAV
	KFy26N+JgfrBv24oBytCTT3x2IDOhaGDiZR8kBv5Od64iHYgiQgrc7EEYa2ZeO3f6qmJFlUiJuc/W
	bqmLhMQ+EORCOWp9Iy134UFT5Roj6zt5fseg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vlqeE-00000007wej-1rv3
	for linux-wireless@vger.kernel.org;
	Fri, 30 Jan 2026 16:43:02 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next v8 0/3] wifi: initial UHR support
Date: Fri, 30 Jan 2026 16:21:04 +0100
Message-ID: <20260130154259.265130-5-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Should probably just not be trying to do this while I have a fever...

Maybe this one's going to be the last respin despite that.

FWIW, I'm also working on further NPCA support, both rudimentary AP
(just configuration of the NPCA chandef) and non-AP side. But I'm
not going to post _that_ until I get through my fever ;-)

johannes

