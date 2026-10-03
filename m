Received: from mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2811A3911AF
	for <linux-wireless@vger.kernel.org>; Sat,  3 Oct 2026 18:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050626; cv=none; b=U1a1UiHIfInVRu3dSI4849HkyKatbInkTpTOkJiThOI7zXOv+0tOUi/16Co5MBuuU7xcIYGK02h+kLqd8qeu2Sg3F8s1dL4fWH/nhiWT8PIbhxUzYiHQ+vemZE3WN1soV2SUQaeny+6lOivT1lAqFAM6JHhhRiqU13xHCnvZkRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050626; c=relaxed/simple;
	bh=MqfQmQPpVqKDB8QrNFhFRvqM+3chzQRjnc5dl+pTy3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TOhiocnpI+U1qoM4YRuS+4G+gVSB1hHI9pSJo0NxyzDlv65Elp17SQDYdgbTzB6eRUTZPo6dRMjC1TJg7RJWx0ZQ4BFFT7dc1fTOFXgKkz67pT/NEbNoay2gMSdXUCN4QBxgCJrw52H3nQPsLKduX0SZA3ERt8PTIWZavVb9xww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=BtNT9YMu; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="BtNT9YMu"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=MqfQmQPpVqKDB8QrNFhFRvqM+3chzQRjnc5dl+pTy3I=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791050621; v=1; x=1791655421;
 b=BtNT9YMu31hjnaQNL4xfydF2w7oX+qCOqnLDFY/AVbeAQpgyR7EI6L03BBVNUeU1JriB9DC/
 69rvNnkJeXCHF9FBHmWXyp/FtMLIfZyINzSv0puguB7StEKOBLqaiHc1EYC3cWHzN3QoAdAqp6f
 NG6nVYE0aOiskJPKyevx/LyzMgV23NyfQlPWYL8dwsVcTVdQseADfGtTIaZsACerGweRV5+PTu1
 94RzuLGSLBflZqVMLFzvLUBR8NfhuDxZ1C0Vq63CzP/+2Stj9q8Ak3+S/Obnxl7DpG8Is8PlXs4
 hEEEx+YMkIi58Dy7SATK9r+1T9kbGrqUf2Ffesye9N5zg==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d500d405151bf338;
	Sat, 03 Oct 2026 18:03:41 +0000
X-Mizu-Trace-ID: d500d405151bf338
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Jonas Hort <jonas.hort@posteo.de>,
	Sean Wang <sean.wang@kernel.org>,
	Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	lorenzo.bianconi83@gmail.com,
	Andrei Rusu de Castro <arc@empyreal.works>,
	regressions@lists.linux.dev,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [REGRESSION] mt7925: MLO connectivity silently stalls with 6GHz link active
Date: Sat,  3 Oct 2026 11:03:34 -0700
Message-ID: <20261003180334.83575-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <d245c4b1-dfba-4507-85a2-c6883f5eae64@posteo.de>
References: <503eb10e-80cf-493e-95fd-04fc0f94ce01@posteo.de> <e4bc5ce3-9a6f-4365-9d36-f6440ded0865@posteo.de> <c64f5fa6-4c61-45b6-a513-b971e59d7723@posteo.de> <476e7721-580e-4a6b-86e5-5ed782a2c7ec@leemhuis.info> <c9f984c4-e3c4-4e41-a502-99db97ce724b@posteo.de> <20260829221319.25334-1-lucid_duck@justthetip.ca> <d245c4b1-dfba-4507-85a2-c6883f5eae64@posteo.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, 2026-10-02 at 18:11 +0000, Jonas Hort wrote:
> I just came across this patch from Andrei Rusu de Castro, posted on
> 2026-09-02 with "Fixes: ff643b81bc38" (the commit I bisected to):
>
> Patch wifi: mt76: mt7925: stabilize STA_REC_MLD link selection
>
> Could this be the fix for this regression? Devin, you mentioned the
> link count undercount is real but likely not the root cause - does
> this patch change that assessment?

The patch you found does not fix this stall. Andrei never claimed it
would and it did no harm here, so this is not an argument against it.

  bench A   2 Sep   MT7925 PCIe, 7.2.0-rc5 + lockdep, morrownr @ 6b0ef22e
  bench B   3 Oct   MT7925U USB, 7.2.6, morrownr @ 8e9309b
  both      firmware 20260813113118, DevLabMLD on 5745 and 6135 MHz,
            iw scan every 4 s under bulk upload. Neither is in-tree.

  run                     bench   last worked   at 600 s
  stock                     A        120 s        dead
  + the patch               A        141 s        dead
  stock                     B        122 s        dead
  + the patch, run 1        B        123 s        dead
  + the patch, run 2        B        123 s        dead
  primary link only         B        583 s        alive

Every two-link run died between 120 and 141 seconds, patched or not, and
none recovered. Each stayed associated on both links, reporting a healthy
rate while the AP heard nothing from the client.

The patch describes both links on every update. In August I got to that
same record another way, dropping the undercounting update, and it
stalled then too.

The arm that stays up describes the primary link only. Not a fix, it
hides the second link, but the stall tracks whether that second link is
in the record.

Thanks for your patience, and for the bisect and for finding the patch
yourself.

Devin
