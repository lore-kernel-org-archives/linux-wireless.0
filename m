Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A6A13CF82
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 23:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790984283; cv=none; b=Ut3QJIXhMZYOAki4OlYgITj/UOo6W4bEuSHRoqFbDYNvQQsC6qiMd4DpsNmqewj/gmo8liTGuYaBimbtUlTuBxS6OyKUxVa1ca+SfMYW8rvhLDC63ePFFl+PSMnbnSD39cMSQjFk1fZJAGkP3WeLJp/nuBtoONo/1blN//oxrSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790984283; c=relaxed/simple;
	bh=elSKe7gdsG6j07FULYQynlXK/a/lHvvudhL3V22NMO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urpAtaqOuAYpMCNJU/nMWOoWS4vlVKgf0uzNOYFTgz861Mim3iTRrBLjNdCEyMSdOkODGWllM/LkE7lttJhlcpUw+deUViGu8OHh1ztr0GttpeR+BIEYTdmmhOLxsm/HhCu7HWS/Gg5FOpFGrlMxLPKq7OFUt+nfXX1sK0WWvIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XwJxgWUQ; arc=none smtp.client-ip=74.125.225.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XwJxgWUQ"
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-48b042e00f7so219673f8f.0
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2026 16:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790984280; x=1791589080; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6HgSd8GXFkbo0tZ/m9bTVDJ3Tq+Vg5WbZHRrTzvOWsI=;
        b=XwJxgWUQMGqaQYktkJfuir7hEK0WaaaMRR0iIJiNSQCyenPpFhiNhP1bxv4lL1BEON
         Jmiqd6mG7CIkWJ/Qvg/GndizIpWWtAkYzQIhvwlPtA7yAFzADFslcB+FXWP45PYYqz1A
         ZXNkxtE7zg4u5zfYsH6kNGY9uGBCiDh+6gCV8xWXfBaKH0wLGPh6isZceUFmhrJpM3oG
         ZgCyqTgbc11X+R1zrOYGxqv5MWB4cOnW0t1JQIMat0vziHiS4JXcCaEMgZiaMG7SLCYJ
         hyeJbgppSVYlIWIx/pai+kUfVxBxkiBdoceAm56pp53Pf09FfClVW5bZof1s4+TQDEvk
         vQXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790984280; x=1791589080;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6HgSd8GXFkbo0tZ/m9bTVDJ3Tq+Vg5WbZHRrTzvOWsI=;
        b=bnBbgDi9CBiXWpY5oSvYKv5fhJdjDs0b7pw6508qErWTWoh9Zn0dbFBlqOYG9JzKy5
         XiBoKnBL7Amm2cNeY5s2YievWVnHDgTRxttMs5JTj4gMR6BluNAOMlDl9616Z3wihKPZ
         2YtQb+sDSyU3EdrQ+I3XFkyh6TOUP0MSw1i+1BkVPZeMoonbWC37LKFSzeQ4Xwyy3jw0
         4QMA/TqAjrfDC+/szHw9hKgfUKFnVngwunQY5cXBPIFu574n1MiMCVSLKOieuyY7B93N
         CaiOL8KmhxBr+Nb1yTN1uFuX7IsC5YIo6cu6xxLwqrCNVn8ZaENZMv2wLnsJrCV6gKbt
         fd1g==
X-Forwarded-Encrypted: i=1; AKwUvBwvahmVKqjwL/ad6Sa898CvlTeMuAuwAd7S3OEfJCLjijNyryDcfQ5tf64w6xQf0CPhXAYFhoFKPqZoCEJtyQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLU5fS8t5KV0Llaj8tKWfZAS1pzG7OlpkgAXfL6cvSyzkaHwUA/
	faKZWAWEZUN5dkaQZBGlpseZ7FtZn8SOp2XT88hzva1Fc65VEiiMsP8V
X-Gm-Gg: AYBFou1cBhshv6kPYOouMkBerOxQoEvBeFF3D3EISWr+rsalDh9H2d3Uz+Gr/aEXPXI
	iSe2e3QTFOA8gGV0/TAIaHsATWklY6CifulRhR3ZhPBr7m29Pk/PFF69JXFU3sdIjcdU580KVNX
	xSc0p7M7JBjtih/4fazCMfjOtZrslxWVZ+PD8w2TkK8sjWFRKU6pWUjSS6u2k+RID4b5fMZBgNO
	1VyYssB847MpXmxZVm9zhqg7+m2uaIo6Nb724hzkc7xdIjK6PfrKkOUT6tLtJnr3LGmSJJ1s+93
	6F6mwSDDi6xARY33xTtXDeEkDszCe1R1OBFT+ulSwX4P/Y1e2dCnRQMMqHtIIz3+FTf/prXbtsR
	ENQfYSrT+m0WrbQ9q98OkCV+DksbqXRMCGdrBPJHYqcbOeelRIE51yzaN/h+q1nJbjjuHTTWebR
	2vX4KL535853qGP7skKB1i61ej01YVnk/rv+RzsaRiKVORkSAuXOCHjZwvIVt/dWn9mRhRuCBn4
	93t9Szj/embOw8mINvoJzIhRjklL7KwPwOy4FtIxGtJa2O98goxjZWxF03+HyyBQHcuXvKDGUIb
	J9p6jGqd/rkJmYIRhvwXKA==
X-Received: by 2002:a05:6000:3c6:b0:487:370:45d3 with SMTP id ffacd0b85a97d-48b1272d20bmr6555365f8f.43.1790984280014;
        Fri, 02 Oct 2026 16:38:00 -0700 (PDT)
Received: from omarchy ([2a02:ff0:1e10:93f:ce47:40ff:fef1:ce77])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b380fad53sm9753429f8f.19.2026.10.02.16.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 16:37:59 -0700 (PDT)
From: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
To: briannorris@chromium.org,
	kvalo@kernel.org
Cc: pkshih@realtek.com,
	linux-wireless@vger.kernel.org,
	rtl8821cerfe2@gmail.com
Subject: Re: [PATCH rtw-next 0/2] rtw88: recover a stopped TX queue, and notice a stalled ring
Date: Sat,  3 Oct 2026 02:37:38 +0300
Message-ID: <20261002233738.29618-1-abdurrahmankaradag19@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261002231013.11792-1-abdurrahmankaradag19@gmail.com>
References: <20261002231013.11792-1-abdurrahmankaradag19@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Adding Brian Norris and Kalle Valo, who were missing from the
original Cc. The CI check is right: I generated the recipient list
with git history disabled, so the blamed authors were omitted.

The patches themselves are unchanged and are in the archive:

  https://lore.kernel.org/linux-wireless/20261002231013.11792-1-abdurrahmankaradag19@gmail.com/

Patch 1 is the one that touches lines you wrote: for a queue stopped by
the PCI TX ring-full path, the stop reason is released only from the
completion loop in rtw_pci_tx_isr(). Resetting the rings drops the
descriptors whose completion would have carried that wake, so
ieee80211_restart_hw() cannot recover a device that had stopped a
queue. It comes with a reproducer and an A/B measurement.

Sorry for the extra mail.
