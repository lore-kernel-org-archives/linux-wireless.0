Received: from mail-vs2-f40.google.com (mail-vs2-f40.google.com [74.125.227.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E56253B58
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 03:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790220476; cv=none; b=TIhjBLPamWhL44GvGaCfwcwDJ+xWfyDmios+anCRhHq5Fl8u0oXVoqsa9O57lIAxEwbWbJVVjOb/8O3+lg6dp0Twm42HyI1oMG4/dmcZCchowi1CtJd484OVmpFZcwdMk4JJDITTKf4032DSaFMQKyvhf8oHaH2VmSISQfpDD60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790220476; c=relaxed/simple;
	bh=IDWUGgI7HoAY5EzKTrGu9KmV8B6UKqlPrugtC1LIObw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L71s/bsoiN7JHVxxJzJ8tAkA2ytyI5Af3Buq8VLQnYrcIA7XrH1FBYj8ezVf8sC34KQHAbqc6HHm2qqSoeku5+n7i9/FUJaC4Xs+dRy3PGEADz7mQkOkufsEdOrrG/gVtaLeXcPLZb4W4fOrIgI4kTbiHFUabuPLbIVPBl/HSNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p7/4uzUE; arc=none smtp.client-ip=74.125.227.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p7/4uzUE"
Received: by mail-vs2-f40.google.com with SMTP id 71dfb90a1353d-5c9a1536864so1122628e0c.2
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 20:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790220474; x=1790825274; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IDWUGgI7HoAY5EzKTrGu9KmV8B6UKqlPrugtC1LIObw=;
        b=p7/4uzUEHzY50hG38aGjW30zNYnne5yTr/QalooNzAccod5ZCaGRp714/sraAqzGDj
         otozKWqDKgf2FXThyHF9WUdUlaIi+sFCZmr9yPU7YKbi01LIEBevTquIH3+f1ba/J5T4
         /1JzujqImxllm+3lxjA1cD3u8HTb7ZDJXuF0/ZQwl/t5KQinI7KDPwRUALf+U4k3LbcF
         wU2+98CA5FcWwPG5Bq4NuyMoICLqVW1zaTFvKBAuh4DDzA7gp17uQ9HSBlq/eo9NThBR
         bTfp9CLer/CZZfZdSzFWd9rY4QHwfz36nqKXoqrxHKZsMRDJX3e2QEaZmIYAgR/aMwZu
         RHwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790220474; x=1790825274;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IDWUGgI7HoAY5EzKTrGu9KmV8B6UKqlPrugtC1LIObw=;
        b=Rv8ecCO9rANnHTbvlZkjMCNNuPGkibftZ6IVANGQ6zS3U6e6bXk0BplVH/t4mkS5mf
         ggSOa22VrJUWD7Bhk9lWSlaKV/zXpUGOqi+3tKHR5yeZ3tfEwpFhOxvTdMrDTNBHRDwi
         BEiq0DX9dgbFgeogoKf+Cw0aWSBAK5EMnNCdJ9O7U8qCtd0G7ANtGk7xql/LigwKAs0Z
         VxNRq2Xpfp62dsuJKRFMLmLVXFRC/EWtknb7xG91OR3jpMG2pCHknOSZXWZNc1+TnXzL
         GFftvCUkB5KBWt702o4W5esHjY+0rkaJi1fMQN63v+BGlyBjMYvLPT45Ya2TseSMuj8k
         vDGg==
X-Gm-Message-State: AFuF++kZTgeFidGA2LPKqpx+/xxv+A7tY4xTZJykDANVSxZ7gSoY2SVo
	7wvfZ1HWUqRrgAm8LFxS6W/ujtLZjloH1ZOGp8KiI9pwjWl7KDjQ8oHB9OmDpRGM
X-Gm-Gg: AYBFou26zmSGbE1Oqul2JH5GAiQCWCeqSbeBaP4++b9d6Gfgovps0hE84Fgh9mD95tN
	3tLUoIwC8jwFxNGBohSdNs9SjPJHdxmW12XMO0FVWYBEiKgn9FsM/zTpwwx7sF6SAvqtg6ybpYH
	dlMapQg1/qSWmN/0He/WLun1mth7pIqGEmWSqmAdjSDVAuP/kMzGRfJ2QwUMRbblkY0D6DJtChM
	QxvjJ+rBzycUmL39zydEWzt9/K69F1SziYw5CmWvIYqmlrdTyYjpNtlWRg9wdt0HNVJBrQQrk2D
	9QN6rdn6VwoVLhaeOOiSPjD7IcMLpaO2grYT0Z37w2iC06hOIqbffvbj6nNItcknA58fqSi1spf
	ym87psR+Ln+O6EVwrnPZow62pYksRRW3+r52JZZoX7rO2OV/jdMwtQZaQAFsiP3NP217AsSBZ5i
	uItRL5OrFtPZlEVeP8F8JFtA4o8RXMefs7iGiT+TQ/s3tOwJQHxLJviQGycamAkAZu3qDd1VU0f
	yGQkM+AMlyTGIdFTYUWkxjtvX1O+2aGvG40DutxyyVthXc=
X-Received: by 2002:a05:6122:17a7:b0:5c9:a60c:2738 with SMTP id 71dfb90a1353d-5cb0ba6895cmr877405e0c.16.1790220474422;
        Wed, 23 Sep 2026 20:27:54 -0700 (PDT)
Received: from localhost.localdomain ([190.177.169.131])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c9f0551688sm5152866e0c.15.2026.09.23.20.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 20:27:53 -0700 (PDT)
From: Cristian Papa <pcristian292@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	shayne.chen@mediatek.com,
	sean.wang@mediatek.com,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] wifi: mt76: mt7603: initialize global station WCID
Date: Thu, 24 Sep 2026 00:27:51 -0300
Message-ID: <20260924032751.28278-1-pcristian292@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260904010702.16306-1-pcristian292@gmail.com>
References: <20260904010702.16306-1-pcristian292@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Gentle ping on this one: the oops is still there in mt76.git at
be5ce79105 and in wireless-next at 10cfa109c880.

Another Archer XR500v owner (NetviperZ) hit the same oops with
aireplay-ng -9 on the 2.4 GHz radio and confirmed that this patch fixes
it, and I have repeated the injection test on top of be5ce79105: the
frames go out and complete, with no oops.

Thanks,
Cristian
