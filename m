Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07B237A83B
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 22:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791239397; cv=none; b=KxzOV6cP4tcZebH6bU78Teg7yX5W4j7P3t8sRxqupdGLsWQ/58eJI/MlMujCxlql5Z3aWkzfeClqAHwSwccchssjbZN7tc6ooH/oVHu4+APy8W8+IM1aYsjKfICVFNDKsM5Oy5JuKcZ9pJNFAWp7NX0nMjBkr5MimzYvRwFxoCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791239397; c=relaxed/simple;
	bh=mdHvhyFo1rJejCLVAFas+ZSfVLCCeDVi4Hma0O+uQZ8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=D0KO7TMHW+9onWeVCuAoD8lo4y5nWmychRq4oc4anYYNz4bhqtzRVUJNcHlerFtHQZ6c0QESoYYLTIB867tGG9ID1wnABIgWmYI5ecQsy6A0jrmbszAFdOWoCNSEbNGDmX5OlpY+u1qoaLN5lBzaUVY7tFi/OB8LSgNJ4Srtuso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=tztJFs3N; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="tztJFs3N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=mdHvhyFo1rJejCLVAFas+ZSfVLCCeDVi4Hma0O+uQZ8=;
	t=1791239395; x=1792448995; b=tztJFs3NjBZQGrDyFYMb5OoPhVh3Zclzufj8FK4sBtXciXr
	SquGgRp5AsWb79ickVlxd1eqxG3IWk5k6ezx48t7oIsw4Z/hy1KUnTmxCpYn2XDMA5h+0eJNOypYh
	Jx106/jOybTbMUo4PIbr+jJ+K7ELIfa26cbbebPwpZQN0AWqE9FNgHmznjFzsvp2kxRadyGPDCIFE
	+zMjmSnTCFgF0V+dvbrFbpav6JaPV3QwN9uqRhc6c+L+F6KHhiut1c/xvXRxiFT40aaTOJ32yuOL2
	XM7tH3la1QFLYr3HEz59SetVuEAx6zi+UmVc0ZAp+8krqLlN8s0MskRK3c8G/AyQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDrBv-00000005h0o-3rOG;
	Tue, 06 Oct 2026 00:29:52 +0200
Message-ID: <0259bf70fe78796c7b57477c48e8a9cb90e2d2f8.camel@sipsolutions.net>
Subject: Re: [PATCH RFC wireless-next] wifi: mac80211: deauth the old AP MLD
 when roaming without FT
From: Johannes Berg <johannes@sipsolutions.net>
To: caio.jcalisto@gmail.com
Cc: linux-wireless@vger.kernel.org, Miri Korenblit
	 <miriam.rachel.korenblit@intel.com>
Date: Tue, 06 Oct 2026 00:29:51 +0200
In-Reply-To: <20261005-mlo-roam-deauth-v1-1-a863e35a190b@gmail.com>
References: <20261005-mlo-roam-deauth-v1-1-a863e35a190b@gmail.com>
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

On Mon, 2026-10-05 at 15:13 -0700, Caio Jord=C3=A3o Calisto via B4 Relay
wrote:
> From: Caio Jord=C3=A3o Calisto <caio.jcalisto@gmail.com>
>=20
> When userspace SME (wpa_supplicant) roams, it requests authentication
> with the new AP while we are still associated.

As it is going to do reassociation, that's _required_ by the spec, too
bad your AP is broken.

Please don't send pure LLM output.

johannes
