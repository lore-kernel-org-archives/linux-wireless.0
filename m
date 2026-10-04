Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506A54252A8
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 10:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791110985; cv=none; b=jsbW46VeFC8daIZUTL4Vl2/xIfBbZ///eBl6yEl3Yu5QeH1FGGifWyCXWv0LNOVgFVgfyBtmEsWPoQ6a8OyalHwbSBwi1uYT6sJUSTi5NNGvY0UxDCFUHaP4pchVQXOfZMqxDLpIGRHqdU9tU/Xv1bV69EKZA5Yshoq7P37Tcl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791110985; c=relaxed/simple;
	bh=tgO0UziCRSqx8OwnsQOjQsXxmCvNwyKIV/iOaaRvEnY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GAULTiXvYYzfuPCzlkTwEZk+CLkyeE8Ww4KztnnnzOuWL4JMPgDvLZ5/C93Q8nectUGbvUfUBON9dVI2ckJQGMre6MvSpRkLnkwSLrUfzfZltpKa26EuwzfvK0HJ2bBvipHyLseAyJADDcHHYixrSHvhuZD+JOjqtSUh2+m0jN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=fX0VZGEI; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="fX0VZGEI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=lvzpOhT+m4foSWjV4mevvTo3/IuoivwR6XfY6ttGzAA=;
	t=1791110980; x=1792320580; b=fX0VZGEIfl/Q/hY+fv8RaiDoEtgeA+87MWAipKhwOVQdLqr
	HAXtvBWD8LRqMv+EiMDYByJVgdYiUAekL20PISiA8sNt7tYfEDm0Z0UFo5FgXpIhIFTlrVBBBTuwE
	YBpC4mfG77isdZtrO38QXIsfVLEGVpajFymui3bDntkCU6yz+HwyrwYbokj7NKB3DoGDEO+s106/h
	3txIF3r/vpWJ7qmuvqb2obWWV0dPbwCNnZf8sta5anGit/iIVEcbcRXt5zZnFoEk2r+sGW0b9T80R
	vPPJU2q+urRtkVLq/mZb5VzEi2N+wNFvwfyWj+bReW+u5Ov0lYbu9qda8YotGu4g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDJmh-000000040H8-16qy;
	Sun, 04 Oct 2026 12:49:35 +0200
Message-ID: <3d6e053b4f9c4f3cb91a2ea91a0c3abfa7c7025f.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v2 00/16] wifi: Add Seamless Mobility
 Domain (SMD) AP support
From: Johannes Berg <johannes@sipsolutions.net>
To: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 04 Oct 2026 12:49:34 +0200
In-Reply-To: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
References: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Thu, 2026-09-24 at 08:10 +0530, Pooventhiran G wrote:
> IEEE P802.11bn introduces the Seamless Mobility Domain (SMD) - a mobility
> domain uniquely identified by the SMD identifier MAC address - where
> a non-AP MLD that is associated to the SMD Management Entity (SMD-ME) can
> transition from its current AP MLD to a non-colocated target AP MLD
> without requiring reassociation via SMD BSS Transition (ST) procedure.
>=20
> This series implements the nl80211, cfg80211, and mac80211 support for
> SMD BSS Transition in AP mode. Along with a summary of the ST procedure,
> the design of this series and patch structure are presented below.

OK I'm wondering ... more things:

   1. How is this supposed to update the DS correctly? mac80211 normally
      does this via cfg80211_send_layer2_update() and I don't think
      you're changing that, but then it's the wrong place?
     =20
   2. In the kernel here the state is the per-AP MLD state of the STA,
      not the SMD-ME state, so 4a isn't _really_ "AUTHORIZED", is it?
      Ties in with 1. though, I guess.
     =20
   3. I commented a few minutes ago about handling of 4a in rx.c, but
      now I'm beginning to think we also need to handle 4b/4c
      explicitly.
     =20
   4. Adding a station in 4a should have _something_ about powersave, at
      the very least some documentation that it must be done by drivers
      (and then perhaps also hwsim changes)?


johannes
