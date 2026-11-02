Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793606919;
	b=a9wRcCmgKP5p5JeolgVco5Dok1KxDr18LRD5WqjxA/i7xlD9JL404IMw716oEu0f4Hrs
	 lOibQCqs44TdHicK2dOq/acV2Qe/qMBrKGfb7xGGwAFxBvLrlLBT7zBgcK31rmADcFokw
	 VooRuSCKCR0/T6tMOdg2Ur9eywbIe/X1Qg3XnygqqTjmaDutguq250VsxWhxZqs5EHzya
	 j4kG12BGuUOTyh0qwRLtkBUcjSjdf5N8goxdHv9tr0hBHMvUHVb4QaIPMAlHz8uvkuJZd
	 56CZulQlxlYO/sSOe+H9ALr4tGUJXj8DAML1CE3SVeTzVq1K6Ao4nDIVudCV7zKihDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793606919;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=jPSyxXcjXQWggNaZrZPuVmJwfE2uHWt70X9U8lGvWyg=;
	b=NmqiNp36ULWcDBL7ZJ3Zt8cEK0CkTXfLRcrPPyxEbJQxideG++k9P0+Qakkl/yCx1W8O
	 SKbCYYJW40UGqz6L3shp/w5y7OMBsBpDq9cXS+Xw7st9J0THtCcCwm80uF9C20SLXgfOk
	 J4OectdQvH80JxIUwubE/V/WL5yyn3A6KY1z6pWggf+HIKwNr81Wv6YmNJgrEWAsNbBsG
	 6g/I1ogy0wwyQnL0DyHLGEipjrtLTgUUtzpL0pA/LLRC/MbMswh1hA3hAv01y0nXAfOde
	 PsC8/vAWNJYK560vctUggrAYCkUYa7zZ3lwAo3HfkaHvIhwqMUasES9rsFOjOteSt1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ghFKnmPQ;
	arc=none smtp.remote-ip=91.218.175.9
Received: from mta0.migadu.com (out-9.mta0.migadu.com [91.218.175.9])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D5C606A326
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 08:08:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8D5C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ghFKnmPQ
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=jPSyxXcjXQWggNaZrZPuVmJwfE2uHWt70X9U8lGvWyg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793606917; v=1; x=1794211717;
 b=ghFKnmPQjfuWJaBWvRduNQ2bqaEAnVRVqs4PFP3dxohse1cOrMu8JxRIOKMxfud9Ao3bDR18
 56bTaf6wkor7MGiGlPHz2A7Qcbu+PNM1l0gBDm29RX1ZWPyGJoc6gEPSwwaaICL6KIaYV5PTTSj
 ZFkSX41Ib9HvfQ6o0rYGpwXE=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6835a011e88f04d1;
	Mon, 02 Nov 2026 08:08:36 +0000
X-Mizu-Trace-ID: 6835a011e88f04d1
X-Migadu-Flow: FLOW_OUT
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Mon, 02 Nov 2026 08:08:36 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <32fc50aea1cb1bc7029177093913dc08a890f9fb@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v2] wifi: rtw88: usb: stop RX work before unregistering
 hardware
To: "Zhao Li" <enderaoelyther@gmail.com>, "Ping-Ke Shih" <pkshih@realtek.com>
Cc: "neo_jou" <neo_jou@realtek.com>, "Sascha Hauer" <s.hauer@pengutronix.de>,
 "Kalle Valo" <kvalo@kernel.org>, "Hans Ulli Kroll" <linux@ulli-kroll.de>,
 "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
In-Reply-To: <20261101134314.39340-2-enderaoelyther@gmail.com>
References: <20261101134314.39340-2-enderaoelyther@gmail.com>

November 1, 2026 at 2:43 PM, "Zhao Li" <enderaoelyther@gmail.com> wrote:

>=20
>=20Disconnecting an rtw88 USB device while RX traffic is active can leav=
e
> the RX worker running after mac80211 hardware is unregistered. A firmwa=
re
> event can then queue C2H work onto a destroyed workqueue.
>=20
>=20rtw_usb_disconnect() kills the RX URBs but does not cancel rx_work,
> which their completions may already have queued. rxwq is destroyed only
> after rtw_unregister_hw().
>=20
>=20Cancel rx_work synchronously after killing the RX URBs. Only a
> successful RX completion queues rx_work, and no RX URB can be
> resubmitted at this point: rtw88 does not set soft_unbind, so the USB
> core disables the endpoints before it calls rtw_usb_disconnect().
>=20
>=20LLM assistance was used to find the bug and review.
>=20
>=20Fixes: a82dfd33d123 ("wifi: rtw88: Add common USB chip support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
> ---

Looking good to me.

Reviewed-by: Luka Gejak <luka.gejak@linux.dev>

Best regards,
Luka Gejak
