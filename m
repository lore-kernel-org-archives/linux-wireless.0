Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A76D3CF662
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 16:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791132688; cv=none; b=GNujXSJWrZFKCgvuDKnCLRSnZ3tMM8yYF7zSlWgvabLWRM+QoyxK1NB/Cqr3VQQ0gl1zc52WhJRUkw7s/ooEj+iGap0oZgXon9FW9bqgMDsdRd9Ic6fiH4i12KVFW1FpprwrjpVBDOvsfL1FbaAruBcpEuXU4pwLujmxEQiNZuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791132688; c=relaxed/simple;
	bh=B1NQoDPcpD7pDGtYHOkFZsvr7R+guI6V8OnUcMpSaOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lMEHuaRAxGhLedI61BpmL0cvdxC8G9vdnht8cpsbe7RxjiYkCiYLOkdbIs9GHeYzvYc7UCY2Lt537RdTjNSWBfLYfASTw6M6eBcpALSwvwT6auOHWytD0XUVMuc/ZpIrNJ0vFVZofE8uq9sur/acBaOac5IInh0R5rx2cZO53y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QDKxW/BZ; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QDKxW/BZ"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a0286c981dso10093915e9.2
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 09:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791132684; x=1791737484; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=B1NQoDPcpD7pDGtYHOkFZsvr7R+guI6V8OnUcMpSaOk=;
        b=QDKxW/BZ2RUCQIvdERF0IzoPr+3IBkjZX3lvlSWmlv6Ydyd0SWPaYo59b5jnWAdVfT
         8GLD6JmlteUUbwKmfEqY5fFw1Sk5Hgjy5b0k+6yC1HRqUqvPxbO2hJmFXw+I2z1C3OQ3
         hcZEsVn3HRC856TBYQtmg3jxUIgacXJA6tl/k9zl2akmqATPvEygwYEn2Pw1op8w09tP
         jMqD80Dp02a/QyWq3ZpENd7CDOrKFIVtoMYvKqaPeO5+pr8xIAqNreI8emIQMfM1bsdw
         FS6a98ksWiJPEN190Y7emoosi6Dd8jlR5Q38NfvXnuDBGJ38ebUkGWGgFsJ9+X8e+kk5
         5esQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791132684; x=1791737484;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B1NQoDPcpD7pDGtYHOkFZsvr7R+guI6V8OnUcMpSaOk=;
        b=bek8etbP4ahFH/9S+9U3NilfvmoZuaeo68i39UiysTqmQydnw2P4PZMHfDgJo2HoXg
         u4ct9qFDnuy4IZ4y8eyE5rvXbVvvvCwRD9ZJR8V4R1vUfl62OQZYZjLAzOXpCrwnCQUQ
         3iIy2NBTpg1P4BGb/aDIJhRnkL3vlJdvKNwkZaCCRoYAZ/HSJzjMVJBz0SiuUpbBQFAw
         cwRhxQN/UYlWVxrcoHMpkXCblYBOKtgSMS/7j38UC89LYjF5Ld67GMCSP5FpGZf4xy5A
         GBOicE49Xt5dcvqSGQS8+jF3iwX9lqejN5y+THyCjpKVbnfVg2JAwwMzgumhom6nbkpp
         S4FA==
X-Forwarded-Encrypted: i=1; AKwUvBycZTXXHU10NLhure8Nh2G1dxQejsm9+Nzcu/1mOMm6guEUMiUnDDdwTsqNQTFake05Esue7cyK9yuPqgb3Fw==@vger.kernel.org
X-Gm-Message-State: AFuF++kZ1AD2/Mn6O9hY1Gl3x/tTD3KXt1uKCFJN6slhRGM1Vcc1vUYz
	eaJjzIezOi8vlTgEy7lhG3rjbZKrjncT4sLVOBP0BHOhCxSbvbQ6DYZ6
X-Gm-Gg: AYBFou1gNCW3emY4IQxI0cS34mQT7O+ZwfF9/4YtIQ+RODnG4bUKdFfMriBzmmUDp/9
	H4N1Ue5rMU433PRPxwzhUGvvZ8SIVTMwMXwXeED95rdJkufv5RCIZZZm0rueF0ufyjHAi3UncoQ
	yRoV/gHHT5X82xXDUZvuQijBzO4skWdrLts+37QNi4rU9sl78eMjZFtMgJMvMTYWfwo6hQBAlJJ
	wOHC/4pKdAZ4zDkfyYIWu52alxGzf1QSypHB659s7WfDtnq/RUuY5kFAE0W7le4ys8XqQWG/5pi
	RzKiO02lih1A+CBcuKexv5hx8B2gOPb3gXec4dyhSKf5vG61c2uz9zMJaXr9LK6HFxKJbXTZm+X
	nzjj8fVrsco8FVZ4x36bwc6969nvDDM57VobJfMsAmP0gwhvBYg7a/o0Qcn6GL2M2QGKo+u7LTn
	r02GdjOMZ5xSEWqqirzW7rpt7FaUgdj+gyh8oMECZPzN6x9g2JZ7QNX1AIopsJJDfragVQP6o9Y
	UB4h0uFmXr836LPsOx7Wg==
X-Received: by 2002:a05:600c:4594:b0:4a0:22d5:908c with SMTP id 5b1f17b1804b1-4a1680eee54mr65008155e9.12.1791132684137;
        Sun, 04 Oct 2026 09:51:24 -0700 (PDT)
Received: from FranzSP11.fritz.box ([31.31.60.25])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a027f2a4cfsm233973165e9.1.2026.10.04.09.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 09:51:23 -0700 (PDT)
From: =?UTF-8?q?Fran=C3=A7ois=20Roux?= <franzelfranzel@gmail.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Jeff Johnson <jjohnson@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Abel Vesa <abelvesa@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20de=20Bretagne?= <jerome.debretagne@gmail.com>,
	Dale Whinham <daleyo@gmail.com>,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 1/3] dt-bindings: net: wireless: qcom,ath12k: add disable-rfkill
Date: Sun,  4 Oct 2026 18:50:49 +0200
Message-ID: <20261004165049.4174-1-franzelfranzel@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <608f9f6c-a405-4903-a1bb-86ca8a0999f3@kernel.org>
References: <20261003091509.4822-1-franzelfranzel@gmail.com> <20261003091509.4822-2-franzelfranzel@gmail.com> <608f9f6c-a405-4903-a1bb-86ca8a0999f3@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 03/10/2026 11:27, Krzysztof Kozlowski wrote:
> Please do not duplicate work but build on top or reference previous
> discussions.

Sorry, I missed those threads. Having read them now: a DT property for
this was already rejected there, so please disregard this RFC series.

I will instead send a single ath12k patch following Manivannan's
suggestion from that discussion (board compatible plus device ID,
handled in the driver), with Jérôme and Dale in Cc.

On the tags in 2/3: understood. From now on I sign off with my full
name, and I use the Assisted-by format from
Documentation/process/coding-assistants.rst.

Thanks,
François Roux
