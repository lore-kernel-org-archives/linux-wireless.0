Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6C1267B89
	for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 13:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789824826; cv=none; b=X+f4jnsZZI4Qxi1SFe3LnoGLf3rt+vyHmZ8pVSd1cxORtTBVGK2ZIgEiTx2BYVCzvwxxSLNTzzWLBU30gSLtt9668XWTmAX6NXWMGi4zciNeW/4noj2yw2UfUA9yjiEqq5bS1RufCmlavl9MvAbNq5Tzld5IOZJafmF+3H6SG94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789824826; c=relaxed/simple;
	bh=SvravK9GvfHV9kOrQpmyuli3tRywjmkbVKLeFiMuddc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Vncd6953EJIOyFOcvc1PqRp1tfweTfB8XPgJDWp73LkQn4dlHiXdGNu/30rOWG1cBnU4DuGMFhnVfSHJ+Tcegeh8zZXpU1vPFqYA0RanUcJe2/TFKdlaP+1EN+bGTZf/i9XqyjZrik8cFA/1GVEENKd0X8eqcskioLGD6C5Wp5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=YpPgT+Wz; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="YpPgT+Wz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=up
	BSmdKlqxWRjgJWAJASXsX/Yn3R0fdgfwwvfM3+PxM=; b=YpPgT+WzUOuEeFydfm
	i4T1AYG9JFS//Jgmru9k6mAZUJR5CaCBM2BRiMyVI9Rz6bKvPl9CSkZSaJtt/6Rv
	QMpiMHdWlW/zmpG7W5RNXkgkyhe4STPUVjaiFEOnfYamvMYlFVgy1LtrnCIpIwph
	98vn/ReDExKsTEpaEpVXRmAG0=
Received: from LAPTOP-BJS5C4G0 (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgAH7sgtj65q0yXyAA--.31088S2;
	Sat, 19 Sep 2026 21:33:34 +0800 (CST)
From: Heyang Tan <thy15333007817@163.com>
To: chunkeey@googlemail.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] p54: validate firmware record lengths
Date: Sat, 19 Sep 2026 21:33:32 +0800
Message-ID: <20260919133333.317-1-thy15333007817@163.com>
X-Mailer: git-send-email 2.51.0.windows.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgAH7sgtj65q0yXyAA--.31088S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7XrWUZw18tF1UZFWfWr45Jrb_yoW8Jry3pF
	98t3yYqanYkFn3Z3WkCa18WasavFZ5GrWUXFn5Kw1vyF15ur1vqF10gr1kWay3Ww4UWF1f
	Crs8JF9akFZ8AaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRc6pdUUUUU=
X-CM-SenderInfo: 5wk1ikatttiiixyrlqqrwthudrp/xtbC-g413mqujy7PJQAA3U

Hi Christian,

Thanks for the PCI/USB testing and the review comments. I will simplify the
component-ID length check and the component-version handling in the next
revision.

Could you also help with one focused parser-only validation on Linux, if
convenient? The goal is to distinguish the malformed-record boundary from the
normal firmware compatibility testing:

1. Run the private truncated-descriptor fixture through the unpatched parser
   under a KASAN-enabled kernel (a small KUnit/test-module harness is fine;
   physical p54 hardware should not be required).
2. Record whether KASAN reports a read beyond the allocated firmware buffer
   (`fw->data + fw->size`), rather than merely crossing into a following
   record.
3. Run the same fixture with the revised patch and confirm it returns
   `-EINVAL` without a KASAN report.

Fixture SHA-256:
8dc5f14057d46ae0a08f2406d0119991c645365d2dcf8c71c6f5de6fe0f8ad53

This is a private derived parser-boundary fixture, not an official
linux-firmware image. I am not claiming a CVE or a completed dynamic
reproduction until this comparison is available. If the harness is too much
work, a brief statement that the test cannot be run is also useful.

Regards,
Heyang Tan

