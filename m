Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA2925776;
	Mon, 16 Feb 2026 11:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771241392; cv=none; b=ck9Pk5c9+kkLMBVFj/DW2HxpKrtdNeFBidwObWkEzug1kc96wMJjAfDNbHX3r5CzzjxwI8Y0O+wYdIoFPOaa5zgSQqqMgCKwl7UuiqaB+jpmbYf8gpRirfXP1MDEbxThfOt+bC7njWKH657UoDjdg9ovB7C2V3eeTq6bUSZFgUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771241392; c=relaxed/simple;
	bh=JSOPM402Sb2RJKqRtDXCSA272pKh5JAjEr8x/YfeOxE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jgFcBFQrGweGZvHr3qvWAk2eM+fAUynbuh3pdWKOijWF8aH79Rxaruranxl7UxBrWrcr4jLK4ceK5C2chUXBza5zK88ML7pOIZ2GBdOZwSZyg9loRgVLXSP/8mQlmxmpM7onvs9ZqI4XahbTie/7YcalmVKSXF6ZaC89RyrBSZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=EBPyG7tk; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="EBPyG7tk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=JSOPM402Sb2RJKqRtDXCSA272pKh5JAjEr8x/YfeOxE=;
	t=1771241391; x=1772450991; b=EBPyG7tk85dKYU+kLtCJit5wklWVfpx5zJ3LnxSq8MFv28s
	MVhFpCNuG1gTAdtTl4FdenqFRv1s+Sr5XzleoJOBYL6gqTrw9KY8o/4PI/1sq3bM6KUqBlao/hmzW
	iKfMLHyDQmsNiyqdMGynFn0atriGctBV//UNq/6oanyrHOtv5dIsnLjClbbrsFXZ/VpgB9cKq6N9K
	jBy25ysAspxeipIx4qgbQyh0OR6h72PMjd0pbpESEOUuaVIoUydD51Lq2AjdnfZV00KfAwFvNAKlE
	YH9MTCq/jPLcAliIpNIkGCJ4TNyjQHLC7O3JBut7o+OMznaXy+kHCTVkX9IxQz5Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vrwnT-0000000ARa4-1poQ;
	Mon, 16 Feb 2026 12:29:47 +0100
Message-ID: <692cd223edafb53133d35894d4ff7b3d0dbbf253.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: iwlwifi: mld: stop mac80211 TX queues on firmware
 error
From: Johannes Berg <johannes@sipsolutions.net>
To: Cole Leavitt <cole@unwrap.rs>, Miri Korenblit
	 <miriam.rachel.korenblit@intel.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Date: Mon, 16 Feb 2026 12:29:46 +0100
In-Reply-To: <20260214060716.16394-1-cole@unwrap.rs>
References: <20260214060716.16394-1-cole@unwrap.rs>
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

On Fri, 2026-02-13 at 23:07 -0700, Cole Leavitt wrote:
> When firmware encounters an error in the iwlmld driver, nothing prevents
> mac80211 from continuing to feed TX packets. The mvm driver uses atomic
> status bits (IWL_MVM_STATUS_HW_RESTART_REQUESTED) checked in its TX path
> to gate transmissions, but the mld driver has no equivalent check --
> iwl_mld_tx_from_txq() only checks mld_txq->status.stop_full.
>=20
> This allows TX to proceed while firmware is unresponsive, causing
> spinlock contention and soft lockups lasting 22-26 seconds.
>=20
> Add ieee80211_stop_queues()

Using stop_queues()/wake_queues() seems a bit awkward, that API doesn't
interact all that well with the TXQ-based APIs that we use in this
driver. Shouldn't it just stop pulling from the TXQs in that case?

johannes
