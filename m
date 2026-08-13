Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6951547CA76
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 13:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786626466; cv=none; b=ZlcrsiJ20Sa3Eydex3TIak5N5l+X6gVbfaUc/OFohZpagUUAf8SalBQrO0Km6PAxISFd0uFSZhJX45d0YIeJITGwddvwa01AC8jdQzzi0qajSgp83Ah2bCpnBWApfQWgZ8hktk/rdlsbHbnJV6B9dtNAv21cNKC50pa3I/YjHtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786626466; c=relaxed/simple;
	bh=PgCkBg+SaqY2ck5/bBDSS+1DtbuO8coJDwswlb7aiy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYmDNqf6Tx7g9AKLZ2i6dHrus7gbAH7sOvnjeLkQyPfPw/LBYViPVLwe8oyPlCkvF2CP0/Mq4f1fNR5iyRfbQUQhC2CkUlx+CFWjXDf8cRzojt+Zdnk+ZnUCG8WuEovkCFVi39IxifOEANBp0+95ERwCmyls4/Xu9UWkCQHpK8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EWcNec1z; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EWcNec1z"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4957eefd361so15763175e9.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 06:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786626463; x=1787231263; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fMxauQa/lOA4/+kENFd3ICiTI2KeojXJKd2HkM4Rljc=;
        b=EWcNec1zcJYAmde1PZCkNdU1cZKydSyQN+a3KKI+2CXow72LAXSvzDW9boxiz5zFuD
         NxR4xD+SZwVHvLuTMvjcliRS6cyLgkOiB6Wvxag5oP6ao4UO8Z3qkQAHq2HR4w8mcsRB
         UnvUFCczQDFg/vRwVAvZ9UT/AfBP5R56hGPlqnKywwMt3vS80DK68VN+NIhy5L8/Bt22
         z7Q+aVqcr7vACoC6Qi5/95f9EEunmqUdu/s5lLuiAH1YouBsHmXzBQ3eY5mhro+kIGRw
         XU5oaRv9eZGQnI96hNxUqQv/H3Eh+kUMkPG5iuuO6htwC5S5Re6gD8gZA0b2PEi6o89w
         ewwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786626463; x=1787231263;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fMxauQa/lOA4/+kENFd3ICiTI2KeojXJKd2HkM4Rljc=;
        b=T5hd2ePkfd1PVSQy7X14OH6d/w+xqfMlNM08eQ7v37iw6Lje4CHn0ir4ERJqh1PuFw
         zcGDDqwydVKkyGIMyy+JGJgRBkUnAHw8S4+VWRVDn+S6isrFkI1DCtAWMkGl3sSoR+eB
         3cNcywlUA0nNl3jdylId35oIIxVGnaE311VxvCqwkgY5uhDvKxVjAsrV1huiS7wTslXo
         ZttUtK1rNALoPOZ7B/hw0jDTJi9Q877OZVN15bb6Mw9QzUgq6nKKns3A8T8w1ZGmr2Yr
         QdaFYCbwtP7zdL3eMnTidNRi5GFtelJu81WD1WqGbMFJt5QonLdg4p/fmdMrtSZYhW24
         6Bww==
X-Forwarded-Encrypted: i=1; AHgh+RrNYgU6t8VF3X4DLf600go8DjjcZLG8efMIeDf44T/QB6jmk/mJiJ+xMHzPReG5XPCUBmYZGWFeL62YKNWEew==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8ZjkoHG2r99aDFgUwTzuWQWL/q/FWMfkLiVi+TOLTOTrg71Yi
	nyMkC5ZYuHox1ligBydRbYIBOW73rwbFrLFC6IdaaR7j+joQIXSpMXo2CUtfbsLal14=
X-Gm-Gg: AR+sD125UJ1lZbR/3KlN0hP7PpzHRpubVQ+eBdQLfIia93yNOrQHEC9NhUALpAkRTJC
	L47MiaTLFkec0npYSVFhlmSy1OinItOQMxbe93lEtTdyZbZRykWqiQrIv6NyLCHrhcnWLnNbAKs
	iFrLK6Sbz3fGON8+1plDBIfrwXs2boTsCm6puCo45zKfFV31exfB27cYp8M5szQw9mYijTNNidK
	oLlkO2/Cjp0XhyNif+F3nVoXjqcwKx688/melQuN7vUQUtyVJdFHECHormMoSNBmw3V+iSmmkUp
	vyQI3xhulb5BINeEtG8ykJtRPXPqREqg0HmlGQiOMMMqULrJ9y2dfl8GCvvoshvclTvmEVRfi4b
	jZZ27zWpPhVZRETEC1qxvtVwG8OWwEID0vXEZAc10IPH19cAXHKD2Q7kXr9q45B8I1/SNbaC/fS
	g+VgBzLsN/6jCJYEU3ECmkkVQPX/pNmYvCjed/3C4GvNOExPHodgxHFAqjlHnklA==
X-Received: by 2002:a05:600c:b99:b0:499:7a5e:4c3f with SMTP id 5b1f17b1804b1-4998215a94fmr60223455e9.1.1786626462572;
        Thu, 13 Aug 2026 06:07:42 -0700 (PDT)
Received: from linux ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49981abd6desm72030885e9.0.2026.08.13.06.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 06:07:42 -0700 (PDT)
From: Marco Crivellari <marco.crivellari@suse.com>
To: daniel@makrotopia.org
Cc: andrew@lunn.ch,
	dakr@kernel.org,
	davem@davemloft.net,
	driver-core@lists.linux.dev,
	edumazet@google.com,
	gregkh@linuxfoundation.org,
	horms@kernel.org,
	johannes.goede@oss.qualcomm.com,
	kuba@kernel.org,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	luiz.dentz@gmail.com,
	marcel@holtmann.org,
	miriam.rachel.korenblit@intel.com,
	netdev@vger.kernel.org,
	olteanv@gmail.com,
	pabeni@redhat.com,
	rafael@kernel.org,
	Marco Crivellari <marco.crivellari@suse.com>
Subject: Re: [RFC PATCH 1/4] driver core: add device_schedule_reprobe()
Date: Thu, 13 Aug 2026 15:07:06 +0200
Message-ID: <20260813130706.238544-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <anpxXANMYTlOHbPo@makrotopia.org>
References: <anpxXANMYTlOHbPo@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

> +	queue_delayed_work(system_unbound_wq, &rp->work,
> +			   msecs_to_jiffies(delay_ms));

Please note that system_unbound_wq is deprecated. The new unbound
workqueue is system_dfl_wq.


Thanks!

