Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A280322B9F
	for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 13:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789825033; cv=none; b=kwZwKo14ZmV+fioChqhBzt6Ik5AsgCfuD2MaM2HnObKnl4s5nO4RHV3q+Jj3YMBBhhH/N0Omav0ZbeYPvynbUCGpn+eqm4Fc7ia/P08U5wB21zja1U9qsYxlAwelcrWcS0g65L5FQZA1sGNY+x4EfayDQXCxG8Gj6bs97kzv87o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789825033; c=relaxed/simple;
	bh=DIQu53BVgoYZmaS7IWnk91aG1jm2j3ExKOoS2VAo6yU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gqFstKct66xuf3ZSyl93hrwSfz8/HwLviCynP3jEXFrs7WC1HHAbsYiP7Ro/SMFt1Au825xRkd3rf4pcgN+WZJtQpwa2oae+DAELgioscO859OSaTukcGrQJCAjzcBl9saoj87lbrW+5s+ac7bgEXDphaaN+3tjjjiwTal1TX4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Z1qR/nOa; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Z1qR/nOa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=gw
	rOsE2FCRE9zxYdhIk0AerwrKaXOijXWk81cWVGc5Q=; b=Z1qR/nOaiYMIPD4UrR
	c4xu/V9vW2WfO3/fuNsczy3xWosmAMkExbc4ZXktoVuJUPENnYUSEEwkHcPhEXGD
	Htkwd6nvTrDcz3oRgN03erekQt15y7OfhUJxdugkCsUeWGOdrsSNTRP+C+0g1tko
	MmjhCltT5VEoBRkWtyxhIIWVE=
Received: from LAPTOP-BJS5C4G0 (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wCHGxL8j65qTpeXBg--.61459S2;
	Sat, 19 Sep 2026 21:37:01 +0800 (CST)
From: Heyang Tan <thy15333007817@163.com>
To: chunkeey@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] p54: validate firmware record lengths
Date: Sat, 19 Sep 2026 21:36:59 +0800
Message-ID: <20260919133659.118-1-thy15333007817@163.com>
X-Mailer: git-send-email 2.51.0.windows.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCHGxL8j65qTpeXBg--.61459S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Wr4DuFy8Ar4UAw4DKFWfXwb_yoW8JrykpF
	Z8Cwn09Fs5Kr13Cwn2kw40gr1jyw4rJr45XFykWFyUZ3s8JFn7tFy3Kryjq3Z5CFsaq34j
	yr4DXr93GF1DAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zR7Ks8UUUUU=
X-CM-SenderInfo: 5wk1ikatttiiixyrlqqrwthudrp/xtbC4h1pE2quj-29bQAA3j

Hi Christian,

Thanks for the detailed review and for testing both the PCI and USB devices,
including the older firmware versions.

You are right that the v2 checks are more roundabout than necessary. I used
the structure-size expressions to avoid hard-coding the record sizes while
accounting for the fact that `len` counts 32-bit words, but the result is less
readable than the format warrants.

For the next revision I will:

- use the direct one-word check for the component-ID record (`len != 1`),
  with an error message that describes the required record size;
- define a typed local `struct bootrec_comp_ver *` for the component-version
  record, similar to the existing descriptor handling, and use it to keep the
  size and string access easy to follow;
- keep `len` in 32-bit-word units and avoid a broader byte-unit refactoring in
  this patch;
- leave the existing firmware-variant endianness interpretation unchanged,
  since I do not have evidence that changing the field type is required.

I agree that these changes make the parser easier to review. I have no other
substantive changes to propose at this point, and will send a v3 after the
compile check.

Thanks again for the testing and the `Tested-by` tag.

Regards,
Heyang Tan

