Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7CC2773D8
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 10:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785062366; cv=none; b=sDn7P69J937VARbmi2bWRMtEi/RY+KQo96+npJVq4idC/t137T8zQro4y3t1emjzpVtTT270KxUKiCXDFOINMXS2FnTOjtrhAAZBfIwMp7s7Vtqul2Frq1slbdvKJoSmJvFxutDhzcTHA7cFKZeCLBKZ9eo+lCpyojlV6uMyVik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785062366; c=relaxed/simple;
	bh=EMKJB9lu5DWtyNAtEzJ/mvLUCAA5V4vfd2B8Ov3I6UI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FHlVtffaoeEJhNkEzDjR5djhq3lBYobFOI9VDhgTDRTtMQ7JCHQ3mAYYBfVL0dCNRdhxtYB5FUMsEdNc7G1ADrAgNbQIQ1LMq+gatCO/D353E9RS//uxT+JFVtizcsnXlCmmyYFbeai5zgYQziz0ZhJAcSJ3QQ4IisXxB+FntaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=NkJBlxMx; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="NkJBlxMx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=BkrYqBExGveWMtSxZsWdjLo9JnV6Qu52dlQ62YXtkv8=;
	t=1785062365; x=1786271965; b=NkJBlxMxML56PiDgtU4XW5Zyk+hhOLwaN9v0EYWlhm+pwV0
	B0WTezxX0Yz9F4Xzp941Idjy4DUuPn0a3O7IEcEutKmzuGgeclvgkXYlwayBsr1TX3oUZAlp6Mm6d
	VZQ3hV9JIPunIDkYUHm+T17F0BVMa+ZluEqL+zMx+EP+R/YfH3wML50/gX8ftQOXpgLrPu8am3IOl
	mLHOjmwTRfcasWQHoU+xyY7HmxcP2aCFRPrpKpcElMUtp6h38NDrFIqyKpZj5CIw2TZH6ej7hFqYW
	bOE3wZ5CvXWlTb7iG/lsFApm0UUs3iosyL+dgm8qwEtLdk+S4KzwVOf8FgniClYA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wnwGP-0000000AZjs-0KkC;
	Sun, 26 Jul 2026 12:39:21 +0200
Message-ID: <f5daf31604eddf9098b3310cff85409b60b0333a.camel@sipsolutions.net>
Subject: Re: [wireless-next:main] BUILD REGRESSION
 90883c513ca01e77c56b8d94be7de11420c1dacf
From: Johannes Berg <johannes@sipsolutions.net>
To: kernel test robot <lkp@intel.com>
Cc: linux-wireless@vger.kernel.org, Jeff Chen <jeff.chen_1@nxp.com>
Date: Sun, 26 Jul 2026 12:39:19 +0200
In-Reply-To: <202607251212.6TdnMBFC-lkp@intel.com>
References: <202607251212.6TdnMBFC-lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

+Jeff

> On Sat, 2026-07-25 at 12:56 +0800, kernel test robot wrote:
> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wir=
eless-next.git main
> branch HEAD: 90883c513ca01e77c56b8d94be7de11420c1dacf  Merge tag 'ath-nex=
t-20260722' of git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath
>=20
> Unverified Error/Warning (likely false positive, kindly check if interest=
ed):
>=20
>     drivers/net/wireless/nxp/nxpwifi/scan.c:2034:1: internal compiler err=
or: in final_scan_insn_1, at final.cc:2823
>=20
> Error/Warning ids grouped by kconfigs:
>=20
> recent_errors
> `-- csky-allmodconfig
>     `-- drivers-net-wireless-nxp-nxpwifi-scan.c:internal-compiler-error:i=
n-final_scan_insn_1-at-final.cc
>=20

Jeff, could you please take a look at this? I don't see anything
obviously wrong, but also the function has some weird stray inline
blocks, so probably wants some cleanup anyway, which might make it go
away.

johannes
