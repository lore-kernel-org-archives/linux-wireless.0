Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824DE33A6E9;
	Thu, 30 Jul 2026 07:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785397539; cv=none; b=Onqd2nb0Cd1sROYMbBkXk1Mb9RZLxnNHI/imrRWEi27Lfz2PO5PKmF8bPDQkSy51rDJ7/o5wkS6mZvrgyDiIQV62ywWR1GL2tWZPRfBpQK24wBkyZskh9OMtiEAArYwB5w7Mh6QkZFgJbQf+3VURkJISejllf0WNyLGcMypZVNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785397539; c=relaxed/simple;
	bh=YCedUE7KErEw1BXN676SxahX64CLElnOpa2TolJBD90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mK1UM4JlRHCWHA+9963vBBXtCGjAeXyfsHNm3PbO/im8VnHsYnMlLoLf3gSu9g7Rg1XxsVX781vwN+Bm6bW+VRjW6No1G6gSOZSuDsLANSm6eg/2G0IkiupmevyHGwS0NShG189PAvWckOcbf78QeyD9O0DKx+lX2vt8y97YpFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xFve8Y5f; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xFve8Y5f"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785397535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xw9rOROEberHU0pIyKBWtUooSjG4p1hWdB6I+Whzyz4=;
	b=xFve8Y5fdsM3AOiraDbk8LOmkKa/retqxB5zJQpc3yp8l+LRqFmvf4BjKPODXz90SeDM1v
	QXyzhAmj/cd2OVk0WYhF+ifqjkPXu9b2ljkGyCGITboe+kQZpJJikhl9RMOVq9eCOmSOF+
	BLkeXmA1BBArsK3QTKiaoljmFbtXyCM=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH v2 01/11] wifi: rtw88: add the RTL8723B chip type and SDIO helper
Date: Thu, 30 Jul 2026 07:44:55 +0000
Message-ID: <20260730074504.19725-1-luka.gejak@linux.dev>
In-Reply-To: <774407603bef4fd38290f6b5d4b4a26c@realtek.com>
References: <774407603bef4fd38290f6b5d4b4a26c@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

On 27/07/2026 07:12, Ping-Ke Shih wrote:
>> +static inline bool rtw_is_8723bs(struct rtw_dev *rtwdev)
> 
> As RTL8723B generation is very different from other chips, you need to add
> this to deliver different flow. I'd think if we need a set of ops to make
> code clearer.

Agreed, and v3 starts on that. The largest offender was patch 11, which
had an if/else on the chip in ieee80211_ops::mgd_prepare_tx(). That is
now a chip_ops::prepare_tx callback dispatched from
rtw_chip_prepare_tx(), so the common path has no chip test left.

For the rest I reduced each site to a single entry point that the
common flow calls once and that returns as soon as it has handled the
notification, rather than the chip test being repeated in every helper
below it:

  rtw_coex_8723bs_scan_notify()
  rtw_coex_8723bs_connect_notify()

Everything below those now assumes RTL8723BS with BT disabled, which
also answers your "callers check this already" comments on patch 05.

The SDIO side is harder to express as ops, because it is the bus
driver rather than the chip driver that differs, and rtw_sdio has no
per-chip ops table today. If you would rather I add one there too I am
happy to do it; it would be four callbacks (free page check, page
accounting, output queue wait, transfer sizing) and I did not want to
introduce that structure without asking first.

Best regards,
Luka Gejak
