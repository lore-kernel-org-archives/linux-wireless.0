Received: from sirius.syn-flut.de (sirius.syn-flut.de [94.125.25.230])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830C7335066;
	Fri, 14 Aug 2026 20:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.125.25.230
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786740688; cv=none; b=hmbzzwfwAVVy2rRzhVTv7SmoCOHZANcjTWBW+yFPCJVNFg/I1/3K6dCdP9rLRxtLXZAySMMbwRvXJprgB3cQdlI8nm88aRfc1jC4M4o1lkApEP3/lsk4n5fjvwrjISXOGsXyVl87FojdA+q0wQMrKBAsuZDQ7nayTEkBuEZgVrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786740688; c=relaxed/simple;
	bh=7ayo5nJGyogBsWpyv0eKBuChmpmMiGcLLcmWFWKK/Lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPck/RvWqP63gdpxycWsfY+3ikaPE8hjEiBUP2KX28jd08ETuEJ7v3OGEVKlNrR/u/jAYM/DB0qUSfKXBzzsXy88qviIjhTF2eDqJGjRb+v3GUmO5m7Y/nmkPKhRvKmsmBabR5xRU/PiGnkCzwsZ92yKkpnIDlWiI7YgYP7cExY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fischermail.me; spf=pass smtp.mailfrom=fischermail.me; dkim=pass (1024-bit key) header.d=fischermail.me header.i=@fischermail.me header.b=Is6b0Eu5; arc=none smtp.client-ip=94.125.25.230
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fischermail.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fischermail.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fischermail.me header.i=@fischermail.me header.b="Is6b0Eu5"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id E6422140286;
	Fri, 14 Aug 2026 22:51:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fischermail.me;
	s=default; t=1786740679; h=from:subject:date:message-id:to:cc:mime-version:
	 content-transfer-encoding:in-reply-to:references;
	bh=7ayo5nJGyogBsWpyv0eKBuChmpmMiGcLLcmWFWKK/Lw=;
	b=Is6b0Eu53+Z6bo7rQDCK9GR8BWDqRHPq6g5aKfe82kdYTpK4HYuEiRdefljcgCpufxcYP0
	b7PwlY8i2djcihOHDy5+PUO0wn2zxJHs9uFYMwALkBqqrvfgKluaB3Dr9FFj7zMjlBjMvI
	WjhBA7nRR3kRxIZwQsrm4kt0BGvl4eY=
From: Alexander Fischer <alexander@fischermail.me>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Andre Eikmeyer <dev@deq.rocks>,
	Alexander Fischer <alexander@fischermail.me>
Subject: Re: [PATCH wireless-next] wifi: brcmfmac: allow opting into PM_MAX power management
Date: Fri, 14 Aug 2026 22:51:15 +0200
Message-ID: <20260814205115.799977-1-alexander@fischermail.me>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260810150552.25375-1-alexander@fischermail.me>
References: <20260810150552.25375-1-alexander@fischermail.me>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3

Hello,

I would like to withdraw this patch.

Further testing on BCM4364 showed intermittent latency spikes of about
50-250 ms with PM_MAX. The connection can work normally for extended
periods, but the issue is reproducible and disappears after switching
back to PM_FAST. This invalidates my earlier statement that I had
observed no latency regression.

Given this trade-off, I no longer think exposing PM_MAX through this new
module parameter is worthwhile, and I do not plan to send a v2. Please
drop the patch.

pw-bot: changes-requested

Sorry for the noise, and thanks for your time.

Regards,
Alexander
