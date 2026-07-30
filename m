Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308463839B7
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785391767; cv=none; b=sTrI6+VOvVZi+PpnFwT76tgCBoFzu4V8p/9j3/QFb1n1WUB85cmnl38holBd1oBvqUESuvlIE4vF16W/qEtFDyxJ8IbjJ+nxfOHYGdCp/XoHOK/wnlk3BraHDmkT7SUZJYzdcDruqFYGEDe62dnmJe2IwBU5D/BwGVDJ+36Q6Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785391767; c=relaxed/simple;
	bh=Te7eXEdq0nWs3o3I2T6+XhCe5R6R2KDAYn6ad6SFo0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRzYXecAbhUc+NYDDW7KaDU7HSGbmQwjBYAKFLBbbB+KlZd40ucxNVHcIU3uRTBWVgfCGQz+v4zC/NWWXmZuFIBmV5P68wTpjzFxtj7GJFJG07ZjlZY7C3+ULS71MhrFShGQoEYlCpEwRkWaOSwArwSDf9O3HDlF5jMyGpQBuPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=admpQ5AH; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="admpQ5AH"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785391759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Te7eXEdq0nWs3o3I2T6+XhCe5R6R2KDAYn6ad6SFo0o=;
	b=admpQ5AH+dXTpulLH6uu8JNIh63WkOoO9SrJ7fHR7Cb5GyQ94FL8kWnPU1PGm+JERrymTS
	wEVZZRt/O14vMzWdIPHHYYppvjc9t0XfXBUWR9pUhTZP9uFfOfZr1KM/XPGkyoNDdRMaKZ
	ty9HexQKA8YDS5Y+QmVT/eZnzj4R6BI=
From: luka.gejak@linux.dev
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>
Subject: Re: [PATCH 07/19] wifi: rtw88: fw: add the vendor firmware commands used by RTL8723BS
Date: Thu, 30 Jul 2026 06:08:52 +0000
Message-ID: <20260730060903.30187-5-luka.gejak@linux.dev>
In-Reply-To: <c767bcbb-a2d1-4ebb-bd67-0d9661b285cb@gmail.com>
References: <c767bcbb-a2d1-4ebb-bd67-0d9661b285cb@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

On 25/07/2026 13:17, Bitterblue Smith wrote:
> But rtw88 does implement the first two.

Yes. rtw_fw_send_wl_ch_info() produced byte for byte what
rtw_fw_wl_ch_info() already does, and MACID_CFG is the same H2C
command as rtw_fw_send_ra_info(). Both are gone in v2, and the
antenna select reserve became unused once the PHY patch was dropped,
so only GNT_BT remains.

Best regards,
Luka Gejak
