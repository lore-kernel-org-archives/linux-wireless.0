Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com [209.85.221.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D45C175A60
	for <linux-wireless@vger.kernel.org>; Wed, 27 May 2026 09:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779874643; cv=none; b=FmcJeirgGX9ns1dcKZuSkL4BCcy1eGzZkv9VDsjRqdMGqNY/gO05YpcAZ6hoMdsclLFyRwWKOuaLMdaFhM00zLZhvC/opPg1t3u6QDufdR+wuBim3I3U8c7yNlbRJwaIBfzgORfAed1lbKq8WtV2klHe2ve4dhCpUh+Enm36lpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779874643; c=relaxed/simple;
	bh=VP9oUQR7qOKFmA/NpYsLYqJ64Sdflb0IiAaSZ0fcDbg=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=IZ1WtzhIi0AKqUUZkxRqhxHZAhW+rrlUa9TiSbk9NsfqI/VDDz28GOIR7zlq9y6x0fuxN+jPVvy1w1dQ44SgIPLSoxFaQWVEuxSPPZzB5OvoODRpSm5c9Oe7f8tJ5IuelMP7UT/qk8LPi3ZeroPCw2XBfcU+3ShhvpgFhJNnqWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wt8+qCwJ; arc=none smtp.client-ip=209.85.221.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wt8+qCwJ"
Received: by mail-wr1-f68.google.com with SMTP id ffacd0b85a97d-43d75312379so9717870f8f.1
        for <linux-wireless@vger.kernel.org>; Wed, 27 May 2026 02:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779874641; x=1780479441; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:to:from:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=VP9oUQR7qOKFmA/NpYsLYqJ64Sdflb0IiAaSZ0fcDbg=;
        b=Wt8+qCwJtGEtm4mzRQ6N/OHbcRYQCMGsrx+I6eVbeXwe2nICJaO/gj28k+a6eUb4k1
         ssuCWoOa3JuHvgJ10F/4wmJjRVrESvYq8p0inZKH+64E2DVEOq+qEMF+5JaJZeC3DHr6
         llXedllGF//r1ngtO8CoBUpdGeUyCV9RJaLUF4PC5Uwhk/0bnhFpQX1i0OAjZsQHQhUM
         p591bP8FPAUDOkOH7vVDKdXIE1ZvQcFJrQ6BsKHLNHaEeaRlswIEQ2bJcEJE/WfZViF+
         h7wlvideZzgVwiGfzXEKs9X9VkYPQnFwaZBiiUya/apf0WntRd5SJXW/E9WDXXPHaNqg
         3lFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779874641; x=1780479441;
        h=content-transfer-encoding:subject:to:from:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VP9oUQR7qOKFmA/NpYsLYqJ64Sdflb0IiAaSZ0fcDbg=;
        b=jKnotwRkbxiFUVBC/YwzZ60hAstvJXZS8yFVqn5IqNcEU9vAnVWwW57ChlzQlNNMgi
         fhDA0ef5+13WszAcvqwZCgUFplPXrZydSo8M3ii+9AEbZe0tBEptz3LIltj7svtsV3Gd
         dqs7qJIqNCsIXeS8pePKVf1mFLgK7vO7aAvxoPG5At4Xp8eXe/2kWMnfA9EGLjbhgvLP
         woLDY7QW+QD5V2KUSExAjzT0xq3cWiWDtwBtOdiUa1sU72kFSbWDkCYEoyhlPvS0EqAY
         HKg6UYd3mkUSt2y5on7wC+/ysosvjwbaffRo/zTfqM5XskibSY05SecfYz049BCizYzB
         9k2g==
X-Gm-Message-State: AOJu0YxIsZBfSTY+uRsdVMrQddEKBSFTzvq79NtuZjMjMpfLGLqM61zl
	7+QNHeTtcnD3nVAYwl54Fq73c0ioY4dvQ+i2jCw5ojKp2DeJ0g1PU9N4eF1n5AuyVpB7YA==
X-Gm-Gg: Acq92OHPORvSz4ijV2Wsamw7wW9E9czSFh3r6LHEtqzKRN9FLKo5CpHGCd5OhRFKC18
	JzbVAFNsc+Hpa2UlgmcHfvUAXLwFRKdHezCNpzchOYiJ3/kkWBGHQSekdeoZWAs+UCJT42xK82d
	AYVg404kyPAcvbMD5pR1yg5EC1u35VwD/MmSnVoooP2eNHLynQkMoO3o4nrix7nglurGxNTDTCR
	+HmoNhR+D3Dtry/Xjqjd6dDTevfROBU9YbjJWE7snZl5DPErdSViTxJrH1g5IVaZb3D2wPeH1jS
	pHWJwr/0VdStaZdj7I5WEhK2cgnxUEnLJqigBHEWj3FekYc6nJK66awN8qY8QU8F+DF/OSmrNTT
	JsnLLzHF2FggNljl0F0bZK1C3Ni1ZE6Y7zHgXZV6gt5cCsuHndajiap8HCb9Lb9u8vMM52AtNCo
	QOu42mDGzLrm0X9aDUusT7QF9LRGiaCmMtvXCQC6G891DREvvTG27le79T
X-Received: by 2002:a05:600c:6992:b0:490:5000:917 with SMTP id 5b1f17b1804b1-49050000ae6mr303593465e9.1.1779874640785;
        Wed, 27 May 2026 02:37:20 -0700 (PDT)
Received: from DESKTOP-01OGNHT ([105.113.40.206])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490454ea134sm424639705e9.8.2026.05.27.02.37.19
        for <linux-wireless@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Wed, 27 May 2026 02:37:20 -0700 (PDT)
Message-ID: <6a16bb50.267d17c9.1df6fb.80ab@mx.google.com>
Date: Wed, 27 May 2026 02:37:20 -0700 (PDT)
X-Google-Original-Date: 27 May 2026 02:37:17 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: hq.bapcoenergies.br@gmail.com
To: linux-wireless@vger.kernel.org
Subject: Invitation to Participate in Bapco Energies Vendor EOI Program
 2026/2027
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable

Dear Supplier,=0D=0A=0D=0AI hope this message finds you well.=0D=0A=
=0D=0ABapco Energies is pleased to invite your esteemed organizat=
ion to participate in our Vendor Expression of Interest (EOI) Pro=
gram for the 2026/2027 cycle.=0D=0A=0D=0AThis program is designed=
 to identify and qualify competent, reliable, and reputable vendo=
rs capable of supporting our forthcoming business activities and =
projects. Selected participants may also be considered for future=
 opportunities involving strategic partnerships and equity partic=
ipation.=0D=0A=0D=0AOrganizations interested in participating are=
 kindly requested to respond to this email or contact our Procure=
ment Team at tender@bhbapco-energies.com to obtain the Vendor Que=
stionnaire and additional information regarding the program requi=
rements and process.=0D=0A=0D=0AWe value your interest in collabo=
rating with Bapco Energies and look forward to the opportunity of=
 establishing a long-term and mutually beneficial business relati=
onship.=0D=0A=0D=0AYours faithfully,=0D=0AMr. Firdaus Panthaki=0D=0A=
Procurement & Supply Officer=0D=0ABapco Energies

