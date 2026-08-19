Received: from mta0.migadu.com (out-214.mta0.migadu.com [91.218.175.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04653D6663
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 07:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.214
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787123986; cv=none; b=BiKL9VoUuCFFvn5hLnPo/hlc0GMTscIAZu+K4z+mml7ffz1JR54XkhQFKpVO/BX7viEqUGAivMmYdZj09Xp4NQ9GRkaPTPSazzwtO3Qq/kFF54WgUiaDHOdOxW4BZlwan13+M5bdYMr6vJyXl58iXxfbqOCEZ3yaLlZdbrJq/Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787123986; c=relaxed/simple;
	bh=7OymnQMSqaITx+XriCpleRuzzVznnX+Gq5ZhNgA7gLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LFLwRA/WN98XDm9KzsQmep5oq4rkW2it2AnQ/hmYHyI0W3+riLh9jaK5vcc1Si/2FK51QQ3ONmcGrBM+trT7ex39dl9Rb07ep8GV/dDVsCm+yYbmbfWqIGjlzNsYZyp091E5GhqhViQfdG1JkGXMrg1PtWpclm+mE6NqLMp4ag8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gCkLCLn8; arc=none smtp.client-ip=91.218.175.214
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gCkLCLn8"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=7OymnQMSqaITx+XriCpleRuzzVznnX+Gq5ZhNgA7gLM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787123982; v=1; x=1787728782;
 b=gCkLCLn8aIyp/gLjdzh0JCjm0xS9uHSwEphBn5ua2vQjnsbEAObud7Jhuu4iUTVZ9WUDJUQX
 C75tErz5wlkm5/t5z7gU/LAyZQXeVu2V2SFlL9G71fOH9Q7ZA/dGWRHFfJKB2ucran74nIln7AF
 cc6SdWZ6xSwcXDTeLgf6jeFg=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from kali (2a06:63c5:9b00:3900:e1b3:d7a6:6110:4f65)
	by smtp.migadu.com with ESMTPS id 2ef6158b7207060d;
	Wed, 19 Aug 2026 07:19:42 +0000
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: Re: [PATCH v5 0/6] wifi: rtw88: preparations for RTL8723B/RTL8723BS support
Date: Wed, 19 Aug 2026 07:19:37 +0000
Message-ID: <20260819071937.19622-1-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <99f04f89fb584e97807ef5470a37d0fd@realtek.com>
References: <20260814105327.6687-1-luka.gejak@linux.dev> <99f04f89fb584e97807ef5470a37d0fd@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Ping-Ke,

> If you can add these notes along my comments, it will be easier to me.
> Not only your reply, but also I can reference source code again to
> reconsider my comments if needed.

Done. Every patch in v6 carries its own changelog after the ---
delimiter, so the notes sit next to the code they describe. I used git
notes for it, so they stay attached if I have to regenerate the series.

Your acks on patches 1 to 5 are carried over. Only patch 6 changed, and
I have replied separately on that thread.

The rework there is behaviour preserving for this chip, so I ran the
short regression pass rather than a full characterisation: association,
idle pings with power save on, bidirectional load, throughput, scans and
reconnects. Everything matches v5 and the log is clean.

v6 follows shortly.

Best regards,
Luka Gejak
