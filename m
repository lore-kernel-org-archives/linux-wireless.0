Received: from mta1.migadu.com (out-7.mta1.migadu.com [95.215.58.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11E03AD516
	for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 10:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792320565; cv=none; b=j565cFU9iM1klwOQw4+RslCyGNqMcSIJ80cwxLYZ5krvk2kUAVxrKKA4OsQK4uAyG1xNMWdkkzpOcj+ZZwnrppINwLD/RjCACx7zmCfV+6OYHwPaqfZxDfh9h4UF5qN5F4bYhXeNyX7ze8L4prdoAKEG0Zeyq7xDgktCAJ75Uaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792320565; c=relaxed/simple;
	bh=qqDTKofDk02bpYbD0GeLNsPnMN2J0SlxzOB9NR0Kvhs=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=ECCGed85GbjQavPx849FoTrVib/OKXWWpIE/p9HQKkdor5EdykM4AVlKZiPY7rsAIsnW6WqXruR+o9PQLm/SFxI5XTAuynSSaV0i82TRClCPg+YjcLEM3wTZs5j6f9LIU37/yHAagWjh0c/n6nhkMsHp/7ok3kwd5d0tj1zXFKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EMUwW7kL; arc=none smtp.client-ip=95.215.58.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EMUwW7kL"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=qqDTKofDk02bpYbD0GeLNsPnMN2J0SlxzOB9NR0Kvhs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792320560; v=1; x=1792925360;
 b=EMUwW7kLtFH3eQAEahaXMaSfE5ETY68GnaNuU3znzBbBpFlU0gKUjqe13O/4b4aCSiNDQxtt
 c2D25L5TTdVKAhhwneZC5n0zTogyvB5KH0+Enj0M0I48uLPLPNfLzeAN0zZ3qrvATeDpdbpe0BS
 YHBWkAu1F/VCUE3VM2zZ2KGA=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ded2a5c735359f59;
	Sun, 18 Oct 2026 10:49:19 +0000
X-Mizu-Trace-ID: ded2a5c735359f59
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sun, 18 Oct 2026 10:49:19 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <4f7abd17d176b88bba7334d5416add23801f8a7d@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next] wifi: rtw88: 8723b: Read the package type from
 efuse
To: "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 linux-wireless@vger.kernel.org
Cc: "Ping-Ke Shih" <pkshih@realtek.com>
In-Reply-To: <d22c9202-d019-4ca1-8534-c23244d612d4@gmail.com>
References: <d22c9202-d019-4ca1-8534-c23244d612d4@gmail.com>

October 17, 2026 at 5:42 PM, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>=
 wrote:


>=20
>=20Some chip package types need different parts of the RF initialisation
> table, so read the package type from efuse.
>=20
>=20Also disable support for 40 MHz channel width based on some other bit=
s
> of the same efuse byte. This is not exactly the package type, but the
> vendor driver puts it in the same function.
>=20
>=20Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
> ---

Looks good to me, also tested on RTL8723BS.

Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
Tested-by: Luka Gejak <luka.gejak@linux.dev>

Best regards,
Luka Gejak
