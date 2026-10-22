Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792646986;
	b=gBXgg8PfvcxNqDjsuj5WnzwrK/PJdTap2Y9hgS1oOFoT1hRmDnP8xmCsbwAcLH3vzVSn
	 uGoRMvFjALOAPk2lKrZWT6FyP8Xbqnbnym1M21xlN+TznkddKLRoDhlXSeu6HHfvhmKCS
	 gOo0OAx0umuYSy8LTxN4VEZ8eHEVkX0Kmcz0Idgemsj6zjsDPtCNH5AWBIxYxEJYAE8uJ
	 5/0eNTnx7YJBbz8ylUR+ODDQTMEbx3e4ExytbZXg8HsdHAaSsr20s7YNJNalHE/obfc/5
	 4r5IlWpdGWVIszbeuFTvmPUr4xXeCg+B4bkKX0bIgE51ZR/7etpDCxgsPuhyXEuLfXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792646986;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:MIME-Version:X-Received:Reply-To:Message-ID:Date:
	 Subject:From:To:Content-Type;
	bh=pI6D28stZuy0sJis4rbiap0J3U+zRBkO2AktA/0DEt8=;
	b=y9j++ypbHDQv1Msy53Dvm07PaFXbbMnI0Y6k4/uyq/HFjl/l3JO7N1YyaRcPO1wLgbML
	 CJlcQReSgcBrTOieYDlqwJAB3sx8ksEYcD1WNe7w4o9lMrB/oTr3GXh2EFVylwZaiCMn3
	 J6bsVkx5f71qjvIdkZdDVQVtWktXQ0VpJ8AWiYIx9my9Cq1FAJnYKZAofXN0gcbLj2nvL
	 O7rpuKcgczMzxSy+KBSQTgC18GuOMnYa2+6dQqUIxvxJAHMV4DUMARD/J3/lp5iyxBjQQ
	 zSf1VENe39gqgy12By9VHYPA71huwG7Ll2MRFCOFRbnVueyj7lQtrZPCEyuGSbYBYzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ieBCXsXN;
	arc=none smtp.remote-ip=209.85.219.71
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57823606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 05:29:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57823606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ieBCXsXN
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-91961d4b31bso34579586d6.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 22:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792646985; x=1793251785; darn=vger.kernel.org;
        h=content-type:to:from:subject:date:message-id:reply-to:mime-version
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pI6D28stZuy0sJis4rbiap0J3U+zRBkO2AktA/0DEt8=;
        b=ieBCXsXNBkTlY9PBUuJpPHg/3E12KzbA2DFnsoGltz8wg4QWac8cp3wROrvNQxZ4UH
         zfnbh0AiJh/5wSOuj9vxW86Xo5jbRCsz8HA5WwgmhjRYoqo03a12OiUMTPx5NSkfhxYI
         CWW4Vqi1U+S3LmAcnHvMmJ6vSjUYEuRrysinwfpY2veRxgIjemcshONsLtTHwlKjTM60
         4yvbfmQ/mHTVM6HdxlQVhphB7qvyMVQJhaxz76IGsbOthDFSXudBOtsuTwiSbT26M+QB
         n2OxEzC6JxLMnHEeS0V5u6b0a/3T8Si2fQcBqJNpZArWJLu2bJagmcAOtl6dHrfYC8lY
         gZng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792646985; x=1793251785;
        h=content-type:to:from:subject:date:message-id:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pI6D28stZuy0sJis4rbiap0J3U+zRBkO2AktA/0DEt8=;
        b=bbFtKe4hg8sjdZ5+gNtgiKBdvTMtavIWiNa96YydtbCUO/0/sGw/TJGtkfCq7hWq57
         m99EDVZi7KIxV+MyCJ0UDDdJtemAuqaMnZXjcdeTAi27eTXA6GUBVZkQIZ84yGE5YBUv
         sRp5Z3/HweJFJJH9KZ/jkE7jvQ4fYZLdsMv9wqHsQTTqgm8dzRZ7rL3H1cEIwllHNhsN
         FxHN8VXkRz/co36tPhglGg/HLEe1Uqw2GMP9WIa5oT4Uf3eEZNbEYSijysHXoRAeiJzz
         6gGWTQKR83Qo/wgsUEfrUvq9wtPZ+jsUH89op9nt2It15UjW6hD1cpDUxoQ3yRzaHFEU
         MiBw==
X-Gm-Message-State: AFq9FYKhDiJeWmWTspQsaVsrlw68ZkqDT0SaPQ9BT6GcRFhikF+atb2+
	wbanvBL6t3SN5ZRz+bURDXjZ7Uzv+sZ1Wqjpr3dtG8OJ1IALR/VNeMB5abZStn/flgGywd9mR7p
	75uo=
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6214:418a:b0:91b:8fc9:417d with SMTP id
 6a1803df08f44-91c12f33a28mr71708726d6.35.1792646985397; Wed, 21 Oct 2026
 22:29:45 -0700 (PDT)
Reply-To: editorjxu@gmail.com
Message-ID: <autogen-java-113fbe2a-67d4-45bf-8956-126cb54d6d83@google.com>
Date: Thu, 22 Oct 2026 05:29:45 +0000
Subject: Call for Papers - Journal of Xidian University (ISSN: 1001-2400)
From: krishnasinghjikoi9@gmail.com
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Dear linux-wireless,

We are pleased to invite you to publish your research in the Journal of  
Xidian University (ISSN: 1001-2400).

Key Journal Benefits:
- High-quality peer-review ensuring academic excellence.
- Open Access model for worldwide readership.
- Rapid editorial processing.
- Broad multidisciplinary coverage.
- Strong academic visibility and citation opportunities.

Manuscript submission link:
https://xadzkjdx.cn/

We welcome your valuable research contribution.

Best regards,
Editorial Team
Journal of Xidian University
