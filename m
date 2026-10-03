Received: from mail-dl2-f41.google.com (mail-dl2-f41.google.com [74.125.229.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CAB8395D8E
	for <linux-wireless@vger.kernel.org>; Sat,  3 Oct 2026 22:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791067042; cv=none; b=oRfGfrBWAfeG05c6drq848LXJwNkFw33A50Hm5CIiDoilWdVL4vNRqgPJ6fVe5fH1OCf0nnOimW77MDlAqkW/ay1GSmWHLcpT9mk1hue9uQeTlDiaw+anrAdDUOVCvDLLoLqGb38TQMbzuQt7J0MC93DMDC78KR+HNsXebPT+cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791067042; c=relaxed/simple;
	bh=kz9Gv08Ifi67EI1jeifT4K+itNfN1SXPlehL2hJ15qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOH/6R3F9NuEU2skPMYmm4vLxSFvmvpRllEZttUwOGKT91HWn6mSvu1rqavyFJNb4D4CzwzFl4od3aUBE7QlmcHDL/dDOAkwwshjkmnjALo2aJLShMJFoUTf5baUgedFqQ4UfW9/bjjwtZ91tn2fET1XDKuq6mpfANOFZWIeYY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mzYGMJqY; arc=none smtp.client-ip=74.125.229.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mzYGMJqY"
Received: by mail-dl2-f41.google.com with SMTP id a92af1059eb24-148bc4a87eeso31508c88.2
        for <linux-wireless@vger.kernel.org>; Sat, 03 Oct 2026 15:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791067040; x=1791671840; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kz9Gv08Ifi67EI1jeifT4K+itNfN1SXPlehL2hJ15qc=;
        b=mzYGMJqYcmhDURPdRu67LBEZ+o1PfXPH4pe1/jxtzAuCR6d9HhiPdJw9H138nYYOqt
         ccp4KsbuOPug02leV3wC9moW0ffXBzfIKDRhTBQ2C+tVmBrrUp2UDrtbL05in+458glc
         HSTbvsCUKByBuqhOvunudS0z/3TtLV0lNxNNlWztd5lgsc7/dzGt8kw3R8OZSGYVH5dA
         Zy5LQNhpd7jhDclG2z4tzdPHDTJOFOGRqdphdtFk/GLUdkxDMTmcqyx/QeiDOPPHzYot
         p25t2E3aw5WyjV6TPEsRAoyH5fYtjVmmMoNHlpRpri6/2AK6lqgZL7yGwccqc3IzFNlz
         16Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791067040; x=1791671840;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kz9Gv08Ifi67EI1jeifT4K+itNfN1SXPlehL2hJ15qc=;
        b=cFYHDYhaIxZX/RHqO7bVCKN3ZJLQHsi1An13AVVx5JJU1h6X07GZ2e/QBIcsUNV9e2
         ogmcPY16FrqGu6R3SmBYIBFe4KMu7m+DoA+u5mmbrkCUuG2W/UrPYAWyAYs4NwApsJzu
         KUAJwHG6xbN3mX+3hyXFPqGd+nqETxdl/45uElke0+U1PurW8lJaLu+wJ4D0FtrIOBeW
         7i5U+U64OiZgfMqnSclsIbbHE9xRHe+v3WKxomifLQQUNnY82cFd3ZTp/Syzigv72RgI
         xiLdIprzFS2Y3ykyH6miaWB7d3BXhWApK2xiTzd5q1zlYHO6zZAp24Pt8lt9NXQq9lEF
         T1Cw==
X-Forwarded-Encrypted: i=1; AKwUvBz1x075BR5N2EJLWKUlS/5ZwmX5lSjqIM81El6c5HOrBeaxcmKLoCJi7QxTSSWogCjfUK5k0VeqkCOsH0BwmQ==@vger.kernel.org
X-Gm-Message-State: AFuF++nWAbei82j+TByCQldzShhbz51V3FhEL78ZuKxrG/pAlQ+/nqn1
	IeAyd8P8uJbWnvmNWZX3DiMfTVYQN/EFXRi3XJNDzzC71d/8sfyNKf82HITaQIDtGiA=
X-Gm-Gg: AYBFou0nYMrcFcOHP8EDQzcSayzdXPEPK2yeYEJOb7xlQ07o97kMJfdYqzC6OvUOybI
	esYgW1eVrS0IkDd4drYoaSYVK2VBT4YQXgbtlglknsvoFuJYbHRWfKd1RwX8D++hSxt0/oxtW2x
	G9JasLTCJFrXrbRPKJ+PGDlZalZON1teM7NgPrDZc01N30rxAeBy3HLkBYybavKwvZe0SMYg4wu
	guL5l3OGZ+NRUSo5y7Mag7aEAx/Wm/TfhOMuD5ayb/9H7Rs7TkPecqf2bNU6Hr4UwMpDvB5X1dz
	O5vcRdErYgQB+q11TICkpVCYChukSIG7zacs5L4aasOfcpdftrGyQ0nVnPTWhG8C8zgNTcwyvl/
	elKQTyWSKEQpzwEBl2Lv/54oIMFAz5w/tSs2tNWRaT1COz5tPpRBKWS/nhjB0XVdJihlOgXG4Mk
	ZPdnynp7eBFCSVNNl3to8mEYLL0WSQvGTHoJ3N03/Tc3X1mD+74e1qZ4+Olw5j/cppUhkI9lgAm
	VW2mLMvS1wZ+xKdVsgwGzdlaXAT3mbwn1kvms8Z31MBq4bhpE1/jI2/Bq2OcsWINpZh0REkXQ4y
	/XGJitK3ufcXdbxjZw==
X-Received: by 2002:a05:701b:2516:b0:144:ff51:2d73 with SMTP id a92af1059eb24-14f5b11e751mr11364239c88.2.1791067040090;
        Sat, 03 Oct 2026 15:37:20 -0700 (PDT)
Received: from cachyos-aura ([45.112.148.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-151fa751693sm21283370c88.2.2026.10.03.15.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 15:37:19 -0700 (PDT)
From: Navon John Lukose <navonjohnlukose@gmail.com>
To: miriam.rachel.korenblit@intel.com,
	linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	helgaas@kernel.org,
	ilpo.jarvinen@linux.intel.com,
	emmanuel.grumbach@intel.com,
	nika@nikableh.moe,
	mpearson-lenovo@squebb.ca,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless v3 0/4] wifi: iwlwifi: recover the BE200 after D3cold removes its power
Date: Sun,  4 Oct 2026 04:07:12 +0530
Message-ID: <20261003223712.14003-1-navonjohnlukose@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1789333511.git.navonjohnlukose@gmail.com>
References: <cover.1789333511.git.navonjohnlukose@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Miri,

Ping on this series. It is still needed on 7.2.8: when _PR3 removes
the card's rail in s2idle, BE200 (and others) comes back reading all
ones and Wi-Fi stays down until reboot.
