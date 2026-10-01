Received: from mta1.migadu.com (out-192.mta1.migadu.com [95.215.58.192])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D70418A3F
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 17:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.192
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790876863; cv=none; b=UdDgFGBUeKaSTCQTSmEAyd3jENUyTd5xYEdFJtdenyHc016cN04FArhGBAqBGjU9HoRWITGhhm57f1frAUDZSwWLlX4ihg3n+9pLvxSKQkC/n25w+8hSNK8FVYQiR5xgBeoRuc5DYzCIxNNswVYk2tBVIy+vdoPzlaJN+/HEX3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790876863; c=relaxed/simple;
	bh=3jPQWZokU0CVnOFAnYvzq3m2P8EO8T+sNiDdS4Hk398=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgI2XV5w3yf9MyC6y2k7gVG+M1xF0m2awADtcwikMMP9dwV584Upygzbp9L88ZDvSZ2ytZ2fS1fPJMfcT+uZvrtdnFTJYp4nGCVJlS/vNBfi1BSWBG8wmdfm4u84QgEGN20WHn62B1hqk+CIsDy4LcaJuC8/anGQWAJj8aehIDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=vGBZXZA1; arc=none smtp.client-ip=95.215.58.192
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="vGBZXZA1"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3jPQWZokU0CVnOFAnYvzq3m2P8EO8T+sNiDdS4Hk398=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790876853; v=1; x=1791481653;
 b=vGBZXZA1MDMylEvmNRwERNUAp6PWFRahEMbOYxGQxlxZnScxy+pDwkG1ezijYUUylm33Ab5R
 ahHZJxA733zc+zAXCZqHuZ0fkBHsT7wp+iuF7SvW7+guyvKjY7yeLQVbCRXaZM9ZqUZoz9enuKK
 AzhWygJzzSpkrqjE46OxwT48ZdyjvNNq4D1TMYir4TRIUg8WbOtiA2vSrIZMTonMqDzO9YuPoy7
 DzkOOy0wvFEbia8MlVyrg9sjFiI1qpkjRcjuVOVmqE7oBPeWfwpiKICXTQIrppvKtv/u4adyvrM
 stlHtOzfqkpkraArAP4DAglXPPUiHzCanMYrUxmInb2eA==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 194109c39f1f00f1;
	Thu, 01 Oct 2026 17:47:33 +0000
X-Mizu-Trace-ID: 194109c39f1f00f1
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Chris <hoopyfrood42@gmail.com>,
	linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Subject: Re: [BUG] wifi: mt76: mt7925u: skb_under_panic in EHT radiotap (monitor mode)
Date: Thu,  1 Oct 2026 10:47:30 -0700
Message-ID: <20261001174730.12879-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CAHaeJsTkLGnUhssCDCTsc3=y5FidHCsQ+_AwK_xsgeKw+TZCSg@mail.gmail.com>
References: <CAHaeJsTkLGnUhssCDCTsc3=y5FidHCsQ+_AwK_xsgeKw+TZCSg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Oct 1, 2026 at 10:06 AM Chris <hoopyfrood42@gmail.com> wrote:
> An MT7925 USB adapter (Netgear A9000) in monitor mode panicked my laptop
> with an skb_under_panic in the EHT radiotap code.

Hi Chris,

Checked your analysis against wireless-next and it holds, sizes
included.

I do not think it is USB only. The PCIe cards build the frame the same
way with nothing in front, and lay the descriptor out the same, so the
same floor is there. That is from reading, not a crash, but the shared
file you patched covers them.

I could not get the short descriptor here. An A9000 decoded 2.6 million
EHT frames with MediaTek parts at both ends of the link, and every one
came with the long descriptor, the smallest gap being 176 bytes.
Channel hopping and accepting bad-FCS frames made no difference.

So I forced the guard to fire on every frame instead and watched what
it costs

	                        control   guard firing
	EHT frames arriving        1562           1771
	their radiotap header       128             64
	all other frames             56             56

The missing 64 bytes are exactly the two fields, the frames still
arrive, and that function writes nothing else.

You are right about the first line too, it reads a field only the long
descriptor carries.

Send it as a patch and you can have my Tested-by.

Devin
