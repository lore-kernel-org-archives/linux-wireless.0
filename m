Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B457B382381;
	Tue, 30 Jun 2026 06:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782802454; cv=none; b=j7wZnfUjSYbdqATA+EP6GyLUlMYXxpRJX+Eh91pniSgiBQ3rfggwVK33TYks9KGQ+WhqluqNMX8m+RvmTjk0QAUl07wtvszFY3nlU2MUBRzDNM6EXlRlnNUZqYcHL/xMKeLGlZ9QcgXV9sE6XvyNZGgW1jHdj9TSnmtEI7e5KC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782802454; c=relaxed/simple;
	bh=uqgwxqqbZ2X5ae+FR5+rZDcIgWbEH7K6bTNFlz6G6z0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=R03mQ7anePZGeDGvkbhqdQm6lN/Nd9iDAto5zf+Z2qmO+SuxR5ZrgU5RNHDOZmpQWeExq1kEIPuWdEGJBKNbskYiXx+5MiBqA4PPZFFg+/jq9HCNocUGhwJa6lrpc0Q8K20mmlqwBg6RO9kKpq+8qJeRiFsacJ4zSg+NozNLD9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ibHgqiJW; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ibHgqiJW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=uqgwxqqbZ2X5ae+FR5+rZDcIgWbEH7K6bTNFlz6G6z0=;
	t=1782802451; x=1784012051; b=ibHgqiJW8xvRJg+vUJzN0bgtrIC5hZfn046M5QIsLRhex3l
	4iV3a8LunmXZKgLxhvherSAkLjXsAUBHSUeCb6UGihXAjaWY9KYEM5JULDp2jQpA4SMC9Izsl4Hqd
	KGMTT/cNaOyS2Oz8S8dXCwEJ0Il31jF5RVQeRYWXMVK6jcSkF948icoITNv3KWe8mxYnM9M3JzpKz
	WaX05E5+P3v7RfgnHakxWpPwsoq7EuXzkUgnnI98v2Y8PVLBSkyZoNAiblDqq+6B2e4cixwNRfTAU
	Xv3XIJ0/t6DTEXrLHaI1zi+UK1OVd8htdg/a7udjNjdbxRY9487EzMm0bhfAx4hg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1weSMC-00000003NAR-0WGP;
	Tue, 30 Jun 2026 08:54:08 +0200
Message-ID: <588f665e6c1e8a24d6cee56762ae754f39ab9703.camel@sipsolutions.net>
Subject: Re: [PATCH 1/2] wifi: iwlwifi: enable MFP_CAPABLE in FIPS mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: emmanuel.grumbach@intel.com, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, miriam.rachel.korenblit@intel.com
Date: Tue, 30 Jun 2026 08:54:07 +0200
In-Reply-To: <20260630065054.199048-1-jtornosm@redhat.com>
References: 
	<11d449ef4691092dc669cdffb1bff72d2684b739.camel@sipsolutions.net>
	 <20260630065054.199048-1-jtornosm@redhat.com>
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

> Now that I understand why MFP cannot work securely in FIPS mode on Intel
> hardware, I'll drop the patches.

There's probably something to be said for the second patch anyway.

Also, maybe we'd actually be interested in who's using this and why,
it's the first I hear of this outside of _very_ niche applications :)

johannes
