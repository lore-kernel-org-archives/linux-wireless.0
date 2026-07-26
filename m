Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC19B30F938
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 16:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785084127; cv=none; b=TOfc256jVxtk9vPpnAZTz4sOZvInIthfXF9VTfrbwUR9SW6zw88jASk/AoejGNely53nNoPFsDfWThG3hVZTs94NFQZl1xjUDT6u67wXE35SxggBVCr9lB2BRZmn0fzQ4WecV+2I/hMPq+MFSbfjSZNBfpQj0jlZRpxByiV4aus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785084127; c=relaxed/simple;
	bh=5ayzNmnRWCbzWEek0cUnWmGqhJIO1oU83wMkBfmlKfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0jYhcXdjQsvyARL32ESuj7tyBUeeg+aAeiNOB52aPzqiDIujcqdP9ubZkd0hEjAUnQppVdf2JxHQBjgJVh6tHpaSG6XBLHS16wwOdWdEsw4KGyyCmMtv3nxZaPJhd0AbyTFL5j4LQs5OD6LcN+bbSNPsc1ErTQdXvd+HvfqqRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MPViRCvH; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MPViRCvH"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c99eaa1f020so1782208a12.2
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 09:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785084125; x=1785688925; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5ayzNmnRWCbzWEek0cUnWmGqhJIO1oU83wMkBfmlKfk=;
        b=MPViRCvHXVpOwuEkYs/ECEGyWeIOyNIogMUlmqhOqsHX7Xt35jqXRXrxe8X1VHwyf+
         4ADrwlCb3QGLFh7L3Z/izQ6mfcxom/B5uIEBAIAdwir8wvFNMTPSPm72/2t3KFXGNp3F
         TL94bjnvFfdeOZ3IOv533zxf2CXD8xeQC/D2M/MC44yIvshqRqLeDS8m+0jNhHEpUA9c
         LJ8kB3mZAosyh+9x+QaQIvgwnIGD7muaf+0kG//2KolTY4QE4oIFIAw0Hz3vmusdOy9x
         U0+520pR4xb7fpj+X2wsaMHvupeEGhTlBrru+6Nd4qRm+VcFZInKpCaNydqjEq8HotE4
         6zGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785084125; x=1785688925;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5ayzNmnRWCbzWEek0cUnWmGqhJIO1oU83wMkBfmlKfk=;
        b=CUo+7TQzkEBCebaoQj98WRT4BDx3IHSKgKxYyebYF7uNHaU42Mmv4Z1X6uUQszY9Xn
         rr6nsvuW7HeNBArnwYY43KsfvBCmhVLFWM5NUywrnv4MMN1X6haU6W03K6KY5m93dkAt
         6XnOBBl3BpvIHZZSwzs3yEhA7caIYD2ir3oxE/hxzrNVdzG5BWwehoOezhhRsZMQcIAS
         BHGuXMj8cwLwq6nJ2e5Vz8v65ZG6JCrIBPAz4P531Wd+DHn9l3eeyIaE9bq1Mf7hfDfH
         UFy9KSQaKRTs5aW0BQx55jBX7qSxKfbTD0Z8n0fcj99BkkzlRPCgZUYO6DRNKj4aI2+7
         NZhQ==
X-Forwarded-Encrypted: i=1; AHgh+RrKnTicVEyLgifocxmJBrbQ4vXUwY9IB83YpHDDhsxpLfoLWv5xY8ILS7FUQkeyxg9TSzQRlZmtWBcB8UJQqA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxiIBlGRC0KO1ykPZBNoQYEO7yxFi9oKo4JyZkLKqOM+XAYvDTj
	9+fs2remkJIGbHrQBt3pfvqMfQaBNIJClV+5URwToNkjovO/3ORNzcfl
X-Gm-Gg: AR+sD11B7PJ62NFvR/04/80KV0B7auw3ANz3mGQ9wjDlt0DHFb0h0QEIDFwFOe2sKaP
	wm89eL7ezbq0GLZlf63PDd9crfPwsB0VP9EgX7aoaFLPJ8k09IZY0wi4tWRp9Su6ojle1xbv4MX
	QfMH7K5s2fys1vrcvhm//KoKm2Pp2PqSgB3kbq43OLhHhBGLI7PKXn/Ogv/oDrWopiI5LppwaMq
	9VJ/PuHkqZeJD94meNrG5k6FNaVP/wzZThBoH3Kp5uCGTCpFX/yiCI3XAQJVahFAA4K7NWJy+Kj
	nmGbPxVPs/kA6LuP/yFZj1KlW7xDtTpG2/TUtMNavVbC8HCe7Ay/wT6GPlJat1rudCkS/a/IFHU
	GA7jvZxigdHYaBEtZMq3v+hHz1LCdlZArbiu4MA1lZFClITII3knC9QyZwwZgH4yniJ/FdhlHFY
	Qtayz2xB0fi+8MLHuSe4fTyzbBuDeRbfm+t2ocCJbvDM0CvHXNqfw=
X-Received: by 2002:a05:6a21:2d8b:b0:3c4:46ca:3339 with SMTP id adf61e73a8af0-3c67df119a4mr5107306637.39.1785084125253;
        Sun, 26 Jul 2026 09:42:05 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([203.208.189.11])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d13015052sm42934152c88.5.2026.07.26.09.42.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 26 Jul 2026 09:42:04 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mark Brown <broonie@kernel.org>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	linux-kernel@vger.kernel.org,
	linux-next@vger.kernel.org,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Subject: Re: linux-next: manual merge of the wireless-next tree with the origin tree
Date: Mon, 27 Jul 2026 00:41:56 +0800
Message-ID: <20260726164156.71624-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <b99e4a1428546030b61883063b9542dd953a69f2.camel@sipsolutions.net>
References: <b99e4a1428546030b61883063b9542dd953a69f2.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, 26 Jul 2026 12:33:13 +0200, Johannes Berg wrote:
> But because I don't think (a) we should fix that in the merge, and (b)
> it's actually very important, I'm just going to leave it as
> "notify_driver".

I traced both paths again and I agree with you. Retrying against a broken
AP is the better failure mode than confusing the driver, and the trigger
needs an AP that reports success without an AID Response element, so it is
not worth changing the merge resolution.

> If we actually observe this in practice and want to get rid of the time
> wasting, I guess we could add a path out that does both, but I'm not
> sure it's worth it.

For the record, destroy_assoc_data already does both. Since f13e573ab3f12
moved drv_mgd_complete_tx() into ieee80211_destroy_assoc_data(), that label
notifies the driver before the link is torn down, then abandons. No
additional path would be needed. The impact is negligible either way, so I
agree it is not worth touching now.

Thanks for looking at it.

Zhao
