Received: from out203-205-221-205.mail.qq.com (out203-205-221-205.mail.qq.com [203.205.221.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2C14949F1;
	Mon, 12 Oct 2026 14:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791816147; cv=none; b=nwyeefXopqbd6G9Nr9N4u4QtbcxEqqjDpCHoaGcqnpuPdPGnfO+Jn3PcXc5hXV+9i4mGILRVveYY2r0mBGaLsE+bdV12P5Kxd9ADVRI0NXa9S1wR89lDDBDV9r6JkVZzf+1iGc6xHr7We55jOXoWfJ2nF8+jVDMctGArDKcRbQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791816147; c=relaxed/simple;
	bh=PVEwYHklGLWAZuFoyY81aDvq5AOiMo4HhqyvJLq9tuM=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=k4Zj2yd1drYp/x9xFhAjC4CpiEdXNOJ7qfRCNQEbD7L5G3sYT5yZE/z40Boukbb2Ui6UzCO8v0XGnnTzLywHlNq4szdtQdZqRU4Mmsn6srBd8zkHyVMFtWHt8G2p2zlhfqUDMje82x99paq8jGOxHRCgK/OODGYQ+p43Fg5mvlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=EGApePle; arc=none smtp.client-ip=203.205.221.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="EGApePle"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1791816141; bh=2VEm7q/HIkYpzW+SEVecgzfCZuKc+GEETju1hsbGD/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EGApePle6AyqmyUiLLqjhLwJqVCYtEWYIgf6kZJ/3J7FH5d45Ojeu0L9NNAFb9uY+
	 T9VJRT6eMbOchquJ20aaZXCX4GnQVkWROTULTHfhXRavwFtW4JYxb6ZXydJs5rTwTt
	 iESlTbcbYikeKMPCoD7EORnf7aPVd0Zz2zdZA50s=
Received: from chichu-arch.localdomain ([27.38.246.181])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id A940E078; Mon, 12 Oct 2026 22:42:20 +0800
X-QQ-mid: xmsmtpt1791816140t9znfmw8p
Message-ID: <tencent_BDAFB5F66ABB48BD69F6E3DA67A99678E50A@qq.com>
X-QQ-XMAILINFO: NnYhxYSyuBnLke0xbi5hjiZejB50zyzEvmbVAoVlJD/lOrGpUxNXa8XwRYjFrE
	 DjecvH61Xx8HObzJxVWVW4t0guYgIp+UESZLUqBKGt/9V4ie+4Rd9EbFp+ScSGdNkaVGDY9vU1YX
	 J8frPl/rCxmSePE2REL1lYGZ2d5Mwwz3iKYcCeCyQHCLlvTzfYaSj9C5sOYN7yHZNwSpTcNqes+Z
	 pM4fQPWcA+P3IcJ/D6wW32qEnAPqPIO1Z+g8anv9inaYgG6lTRj4iBmJKe8t0cgnTkb5mEbA6t1S
	 MIEPzj4ZGYusTAUOLiqotzuIyL7/qjxKL2ZktXH7XOzBDPMxT67R5mJnGimzezqf04jUa39dLf9r
	 btRl1Md3ftvQ7nqZtrQKQBTeQaURlh2nDwK4Dw1nzD7CjEsg8Qw5QTJQdbITzu68yGVRzkXw2TP/
	 kKIOVceiGds3JcN3nXN1rigO48dD8sIKKQnxjlX7yVQ006tJ+KeJ09rEOHzCYgzBUooQQole0X/9
	 0yxRsWGDOwzD6rssCgmYG5KvWLfOQk4EbjSVFfZCj9Yd615m1+OJlNaAQ9dUXUU7oWf7zY771bCn
	 UanwfAHCPlTUOnUR7W3YzT3OnAopQ+UC4fhE7V/197xXnKsNkgxwr2s/7acZgTxeOzsyoNPLQU7r
	 nkwze3yIRaGOfky/sqHKB2ORKmojofQ9xdW+oFY1PckC/KVP97J6VOMsGYO9oyjAZ6rPWRKHSvJG
	 9ibju5WxaJW7XN3rOwfN1RXVZ2qTMhPWgaC96g/PAnImCiOE/ZX6hexibBWx9gaHfouIcFb1qqNE
	 4EHPTlxO1B2+Z13+MXMdI+iixRbS8i2c8lOBQ2ImOINSasqQUoQJsPm320D30fnx/91sVBuUin6U
	 BmoZFQpGclPKqfI+x8Tb+jWR2RUXwD3o3R2JmCGycvGpvUjxEo7OGIuanJX2Sg9o84oyT8w8eHwO
	 uYYFnxxb2onXRO3g3s7a+4rrfCdwDfDj7aczN0KndWSGSba56pP5cYHCc9mq1y8DLRWTx13m4eZx
	 TY2agcUukZoJeAqJgOWZF74ker2MpHLagmiUF3D+LFoDxt/UCy20SwXgb28Hw=
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
From: TangYi <1914018426@qq.com>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, johannes@sipsolutions.net, 1914018426@qq.com
Subject: Re: [PATCH] wifi: cfg80211: allow IR on a channel the wiphy already
 operates on
Date: Mon, 12 Oct 2026 22:42:20 +0800
X-OQ-MSGID: <179181614019.1582433.13387085985919889800@qq.com>
In-Reply-To: <0361e4f89508eaf9fea291d949e4eb21f8d6e839.camel@sipsolutions.net>
References: <tencent_2B956CE56BB4DE6A4748896922E04666FD0A@qq.com>
 <0361e4f89508eaf9fea291d949e4eb21f8d6e839.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hello,

First of all, apologies for the broken threading in my previous reply,
and thank you for the patient guidance. The cause is now found: the
SMTP relay (QQ mail) rewrites Message-Ids in transit, and git
send-email generated its own threading headers on top, so my references
pointed at ids that never existed on the list. This reply is threaded
against the ids as recorded on lore/patchwork.

On the substance, I'd like to make sure I understand correctly, and I
truly appreciate the correction. The concrete observation that led to
the patch:

 - after the station associates on ch149, the learned domain (iw reg
   get, phy section) marks 5735-5775 MHz as IR-CONCURRENT;

 - the channel itself (iw phy) shows plain "no IR" without the
   IR_CONCURRENT flag;

 - and the iwlwifi source contains no IR_CONCURRENT handling at all.

So the domain rules and the per-channel flags disagree, and the
reg_can_beacon relaxation cannot trigger (it requires the channel
flag). If this is worth addressing at all, I would be glad to learn
where the right place is - e.g. the driver propagating the domain's
IR_CONCURRENT rule onto the channel flags - or whether AP operation on
such channels is simply not intended until the device properly learns
a regulatory domain. Any pointer would be greatly appreciated, and I
am happy to do the work on the driver side if that's where it belongs.

Thank you again for your time.

Best regards,
TangYi

