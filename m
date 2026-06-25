Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C2B3C2B9C;
	Thu, 25 Jun 2026 11:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386538; cv=none; b=iclXSAMvIN1UH3VM5c+xS/iVgA1bBTms0rYz2aBbmpmdPOOLL95EtrS0UmFacrt/UmqUOSqlAODUv79Qy22Yjl1/gVmPYKEzI35Dn6jxdI6etW3Fs5q515OnkJcK46Slt1MKmDKmriYtyEEDWCPbO90gExi42332y2m4ue/wk0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386538; c=relaxed/simple;
	bh=3MAxlbAg+83kx3PssMy/RSzbT4R3vIZ1wpn8AplK51Q=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G+XycAemmDSWUmq14XbbF4fwLTCvSvDXl5oI0jw3Z8qCzz+2KyW95Wa06LbmGM3GUoie/j4bxVqjuJP5N/Ft9ZF5lnHY4kuTOtrCjglr1lKmwwyn4SFa/TGKhnTs2XNK9bSkgmthTqzpWWbVv91W4ahBbfqjc/MAYw4kHTJ3f00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=LrjCy1My; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="LrjCy1My"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=3MAxlbAg+83kx3PssMy/RSzbT4R3vIZ1wpn8AplK51Q=;
	t=1782386536; x=1783596136; b=LrjCy1My/IfGdP5s//ELo8tlsb7pgdCKvBnXHQ59IYuwTq4
	hHhaNNJ8/V5CXkanp62YcFLJdBq890y2U/F79DbE38rlFcU9RAlgPAYymEl1x6Sq6dfNJVwKC+jKJ
	tXhMsCEW+LzRwFQ+JssBpMIcYsjCnzf7Zz5rzXlpuyk6MOdqiLXve4aaAACwEG8nmOqBJ8gdzSOFc
	d9kDBlx6XR93X4pg+bIU7CN0V9D+gf4DrNBDe56IfqQRvRVf4omFFac/4X50d2j1kHwPOD3SmOA6p
	WUeQf3AYF2LQDhrs+nIZxZqk0AJY740bn+AGrfnqbOiQ+BlbM1eMHcb3+UyZoraw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wci9n-00000001fk6-3b65;
	Thu, 25 Jun 2026 13:22:08 +0200
Message-ID: <d1db2391fe528c4e79b1afd9c80e49f44b948beb.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: cfg80211: replace BOOL_TO_STR macro with
 str_true_false()
From: Johannes Berg <johannes@sipsolutions.net>
To: Serhat Kumral <serhatkumral1@gmail.com>, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Thu, 25 Jun 2026 13:22:07 +0200
In-Reply-To: <20260624204938.15222-1-serhatkumral1@gmail.com> (sfid-20260624_225014_090719_0EFB4145)
References: <20260624204938.15222-1-serhatkumral1@gmail.com>
	 (sfid-20260624_225014_090719_0EFB4145)
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

On Wed, 2026-06-24 at 23:49 +0300, Serhat Kumral wrote:
> Remove the local BOOL_TO_STR macro and replace all its usages with
> the kernel's str_true_false() helper from <linux/string_choices.h>.
>=20
> No functional change intended.
>=20

I believe this breaks trace-cmd reporting. Please check and resend
indicating that you have.

johannes
