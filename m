Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.91
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793610354;
	b=cWEwMxuRc6R6OubZGr1TSS7q/PnR2um+EroBEzMOUGy13p4NdjN/By9QGPfMaVeNC0lC
	 CWp2QtYkOto+V9zkeMvl0SmOEBdieicMQBcNwWCZQUlOxYf9f6BB7SCZxLYQWPYvN4bpT
	 vmA/yNhArjt0aYdBB5ya1WrmxAKZ5B8F2si/qhdwoiS9LxTdi+9k2O0VIfwtLvgcIg3sk
	 sugddv0TERG8rT/OUY9ftjIZjvf2TItFiOMXzP680IBLeyCwO7qxJd0Uj4H2raf0ikP65
	 +GFnvm4AXep0mfAwrcFMaFcHryLCmNdCxgbjWhE1+g6Un/zAqmtd5lzv6BoavoXpa2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793610354;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=hFAPZJU1NpNmffumzVrKY0D5GwTTfxtDmIvR2zKxyHg=;
	b=l2LYIRulI8QPe17hgF47WIQ8mbqU/42bhFvSwnUfDXR512WTQ27KHskm5F2rrAinwhLZ
	 OebmFSR1WqXuUwVtc+Dc5fQwEeKyigWUzfAbGguaCKhgqARlWLbFa3Y3rlOlQJ0UXonRh
	 LDn8Gdn953EgTafyf6xmThSTKNzN3/HmnzmWzFk8VIjG77R8m/a3eDY4BO8EZjbtZICeW
	 plOdYGOVMI9HfLp19A3+fyHJsTXJqIdRQvVH4MO8eCRj7wYDzxkG7YXhUb4yEfQwym+1r
	 kR4C33c5uID31GvvucDxs7Kl37vqP8TKbzbgoDzsx/jgW3vn/XRfJ/nAjui0PcVg3KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kduObnTZ;
	arc=none smtp.remote-ip=91.218.175.91
Received: from mta0.migadu.com (out-91.mta0.migadu.com [91.218.175.91])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE446606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 09:05:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE446606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kduObnTZ
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=rj84BJmdv3Gf/7Ce/0swnvMv4/NDNGaDGlbZ9duKzio=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793610350; v=1; x=1794215150;
 b=kduObnTZugcFIi/wvqpUp2ODHgqMRLXt7gh7nQtigrietFXW/5/oakv5D3p0Rls0HTKuV0N5
 9U4BLtkjw+6sYySN0bRL3bhOUYM2toenkZl/pPPpqlyNKqazCnKx3fLd4ugFFGjlIf02jhpR/BJ
 EVm0+bsJFcnwyD9of2kLXnY8=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 45a05da21da06750;
	Mon, 02 Nov 2026 09:05:50 +0000
X-Mizu-Trace-ID: 45a05da21da06750
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
Date: Mon, 02 Nov 2026 09:05:50 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <89b76c1edf151f509a912f887d9fe0b93cc9e19c@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v2 2/2] wifi: rtw88: check the C2H payload
 length before reading it
To: "Huihui Huang" <hhhuang@smu.edu.sg>, linux-wireless@vger.kernel.org
Cc: "Huihui Huang" <hhhuang@smu.edu.sg>, "Ping-Ke Shih" <pkshih@realtek.com>
In-Reply-To: <20261031175621.2228762-3-hhhuang@smu.edu.sg>
References: <20261031175621.2228762-1-hhhuang@smu.edu.sg>
 <20261031175621.2228762-3-hhhuang@smu.edu.sg>

Hi Huihui,

Thanks for the v2. One comment below.

October 31, 2026 at 6:56 PM, "Huihui Huang" <hhhuang@smu.edu.sg> wrote:

> diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wire=
less/realtek/rtw88/fw.c
> index 0a909bf79cf5..6bc684726669 100644
> --- a/drivers/net/wireless/realtek/rtw88/fw.c
> +++ b/drivers/net/wireless/realtek/rtw88/fw.c

[ ... ]

> @@ -2381,6 +2386,9 @@ void rtw_hw_scan_status_report(struct rtw_dev *rt=
wdev, struct sk_buff *skb)
>       if (!test_bit(RTW_FLAG_SCANNING, rtwdev->flags))
>               return;
>
> +     if (rtw_c2h_payload_len(skb) < 3)
> +             return;
> +

As far as I can see, apart from the abort paths this report is the only
thing that completes a hw scan. So, a short report now leaves the scan
pending. RTW_FLAG_SCANNING stays set, scanning_vif is never cleared,
and I couldn't find anything in rtw88 that times the scan out.

Until something cancels it, e.g. a disconnect or the interface going
down, every new scan then fails with -EBUSY, since the old request is
still pending.

Before this patch the scan still completed, only with a return code read
past skb->len. Maybe it is better to complete it as aborted here instead
of dropping the report, something like:

        if (rtw_c2h_payload_len(skb) < 3) {
                rtw_hw_scan_complete(rtwdev, vif, true);
                return;
        }

Best regards,
Luka Gejak
