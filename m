Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FF53382CB;
	Wed, 15 Apr 2026 12:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776255112; cv=none; b=o7jwswYzhBHnHzmc0gHgKJVr1rPupVUfAmm5MK3ARbWeIuXArAgas+zujNEi7gp+Wod0UshC1ERMewexRNiY6xh0At465w+4u+6WwyUUMvqU7I/BfqIgnRnXIbPSB/ihW+KkerxrBG+BSL6X2ITy9uhz7WegnTLgyNsx/mzk7Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776255112; c=relaxed/simple;
	bh=4Uu9x+Wy2nBT3wpP+N7Z95qtJ+GomHU1dMyPdeiy+Zs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lb7psYF217jUWGn42E5fhneS8d9n7KAbBDUSmya8v+zSn0selgzV5/Dka7lrJwHf2MrXb8byHa0g+sIAUiQby/i5PCQ4TzgQ4TESk0020evS/mAgS6up3+aMeLQ9p4p6xtscxR7wjLJU9J5JGQnFnKeruc/ADBJK181AWZdid24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=PRN7VCte; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="PRN7VCte"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=4Uu9x+Wy2nBT3wpP+N7Z95qtJ+GomHU1dMyPdeiy+Zs=;
	t=1776255111; x=1777464711; b=PRN7VCte9JDO0ACP+G+XO3wRV5y7t90bWyBh+n6cINPZGtM
	PP2XoCEEqfA28SWhiZqSoFhKOEQvxuziX18o9001SDhXTPqnwvMxtK4VRh0eowq4C3aKcOwJBWnBT
	1ZH8vnK6/k++IlP5RG5ydtQzSEEp/zGOkxdcV/HXEgFBJi6X8+gTJD+8vw4Hnlzlf8xY1yLePMfVS
	N/orLpMG2crMhwVNfzIOkUceeMB2Dd0kqgPptD2HGKI/A6XbEMkR78/8tJBNNVblAJid5bcEs1JAj
	J5w4vcDBVH30MdhipRQP8DjtsWiSYXX6I3oHJqb/Gir4SEMKWsFi3XSyOSKYxiCA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wCz5s-00000006NlA-03uu;
	Wed, 15 Apr 2026 14:11:44 +0200
Message-ID: <57275e905a67e789ea438bf637be0aeb442fc880.camel@sipsolutions.net>
Subject: Re: [PATCH 1/1] add wake_up call inside if_usb_disconnect
From: Johannes Berg <johannes@sipsolutions.net>
To: Jakov Novak <jakovnovak30@gmail.com>, linux-wireless@vger.kernel.org
Cc: Kees Cook <kees@kernel.org>, Szymon Wilczek <swilczek.lx@gmail.com>, 
 Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@kernel.org>, "John W
 . Linville"	 <linville@tuxdriver.com>, Dan Williams <dcbw@redhat.com>, 
	libertas-dev@lists.infradead.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, 
	syzbot+c99d17aa44dbdba16ad2@syzkaller.appspotmail.com
Date: Wed, 15 Apr 2026 14:11:43 +0200
In-Reply-To: <20260410213241.1177592-2-jakovnovak30@gmail.com>
References: <20260410213241.1177592-1-jakovnovak30@gmail.com>
	 <20260410213241.1177592-2-jakovnovak30@gmail.com>
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

On Fri, 2026-04-10 at 23:32 +0200, Jakov Novak wrote:
> Fixes: 954ee164f4f45
> Reported-and-tested-by: syzbot+c99d17aa44dbdba16ad2@syzkaller.appspotmail=
.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dc99d17aa44dbdba16ad2
> Signed-off-by: Jakov Novak <jakovnovak30@gmail.com>

Please correct the fixes tag, have a commit message explaining the
change, and fix up the subject per the driver's convention (see older
patches).

johannes
