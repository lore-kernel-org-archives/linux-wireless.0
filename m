Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0193F2475CB;
	Sun, 14 Jun 2026 22:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781476413; cv=none; b=GYwRsGyI+6KR/3fsbM3x9ww39KWZrAvPNbjjrzPbIP2KkC3OzVuzyo/SJJN3yXKLmjycL7tDNQ5pePXMF4hFQL3TpzN5Oe4/w/xcRxc0X2g+dRoeClrPw+p651swB7RijNiDz3d90RqOtsZFIOAwp8iY/huWUXEuIXmtVVL6AmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781476413; c=relaxed/simple;
	bh=+zEHZDzJQtQKUninfL0hHh7G8Cm4+WJrtjMGTXgWkvU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Message-ID:Date; b=ASxydaoF3Eh6joZ8GuNr6zp13W2JQdZqbqvMYPS+ZSGa1Szm/76QtsUpI8suTlwR1XrRQwj1jYbdhEX1JEyLCC9k92/UmDMrbaZ8FZ7ARGFaau296w6bc+JEYRnKrVqLF0ZBgv1Sa5U68bXIPr6VcqGuJiBLl4yK9rlGH419o2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PNZCR7lU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PNZCR7lU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792731F000E9;
	Sun, 14 Jun 2026 22:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781476412;
	bh=+zEHZDzJQtQKUninfL0hHh7G8Cm4+WJrtjMGTXgWkvU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=PNZCR7lUBZ7A85gTo+oVchsId1gl48v3CJZFjLEq1mBembB/UpVSjdsaRMKD5dvty
	 KReC9a/rYHS551IrHfGA8BX3A23fc/E6xOJGLm2hRsSG20XNO6oOrvvlANDw8Jo9c8
	 45QteygvAUh8Rhejf+RL1umHvB/+XSsWe0lCwOQLybU4AMup4PwIIJChWjGToHL8Vi
	 MlQIdoF1a3Hzg6+PkngHN4z6tlHS6eGWWZrB3EU2BaZo9bMBXQwDc6M6Ov9aqEhcAW
	 zFwNGJ3M5m3LdQ2xOcrfhLBhHhe0bnY+xd/qvMHygnDHaZykfbPYubrS2uczZ+Gp+4
	 2jG5RNWb/I58A==
From: Tejun Heo <tj@kernel.org>
To: wuyankun <wuyankun@uniontech.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: johan@kernel.org, kees@kernel.org, linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, sumanth.gavini@yahoo.com, syzbot+f80c62f371ba6a1e7d79@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH v2] wifi: ath6kl: fix invalid workqueue flags in ath6kl_usb_create()
In-Reply-To: <20260611015545.111157-1-wuyankun@uniontech.com>
References: <075511fc-1136-4208-84d0-9214e761f8ba@I-love.SAKURA.ne.jp> <20260611015545.111157-1-wuyankun@uniontech.com>
Message-ID: <wq-applied-ath6kl-23b81fcab247@kernel.org>
Date: Sun, 14 Jun 2026 12:31:43 -1000
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>

Applied to wq/for-7.2, thanks.

Holler if there are any concerns.

--
tejun
