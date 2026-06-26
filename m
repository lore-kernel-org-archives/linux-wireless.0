Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51343112BD
	for <linux-wireless@vger.kernel.org>; Sat, 27 Jun 2026 17:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782580455; cv=none; b=SNyODkSaq+DQ8suZ8m59nREfzwYyh+TNDMm3C4Lt8I8M7xL/U4QrwmcKI3RM0ZpEQW7fVRH3My7/yzs0xsxmInLSw1vzO8agCzmBN2w0n65I5pBhB4t4MWSySjs45PsnhTmwMHYgsLF9e8LUgsHpVEzuRjHN37ZwtrhbNiGvm+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782580455; c=relaxed/simple;
	bh=QDFyZHocWkxENJp1COzHVpR5fHLV0dBsGKtbxKxkCP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKfF2w4SMtkwLRsoonAz4ogg1p7VW+i1JE1GBlfH33tYcGRhfBRf5BfGyxTMVLpJLPltXO4XD5eSgMIVPO0OJpBzraTX2o/HF78gqoTYbPW60dV9w/zFLl/7cowyxI+I05GTZgOjuGb1KZRy1XRuW+tVDYoaN3KCgcr/nUJCe68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mag9dObb; arc=none smtp.client-ip=209.85.128.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mag9dObb"
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-4938d60c035so4538435e9.0
        for <linux-wireless@vger.kernel.org>; Sat, 27 Jun 2026 10:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782580452; x=1783185252; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QDFyZHocWkxENJp1COzHVpR5fHLV0dBsGKtbxKxkCP0=;
        b=mag9dObbcEBoH1+H6DWdvzW0foyFHxzX6lqKXY/wEr/8Do6MbhaBhMq8pesvRNxrKh
         44zIQuyFtCpcQyLmymevnkQBDbfBV/TtXbatsCI1XzxTsBl3IRlhIyCdDLR+uhf6wCpl
         d2qu+B7zg2a0va5B7BnNfVE6Ti3K7Lw9q+woS0mmUOiR2Z/h/peXuJTg9144rnsueaWf
         GkkKzZ/as1qiE+uTSNm7GDWUTt8U+BZIHOQPpVKupKki55+WgMFJhCbEd4SsfWVj5POi
         edlH9XUJDEidgh7EopK2Wi3O3Bt1DTRZGpmdLnp5bOIV8SA/ueAxX7u52XtTc0KQsBkd
         MNiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782580452; x=1783185252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QDFyZHocWkxENJp1COzHVpR5fHLV0dBsGKtbxKxkCP0=;
        b=FT7Dv5XaJQyZ0H7A6dd0LdfeA9LJ+db3IaSMj0wR4x9bjD06fqs4nSj5oDml9gfgqq
         25ZKaiZAyDVbx91lJo9cb49DMmosFWiOfH4031lCvDlg0Reln8NdsPVtJlaUwcHwfI/U
         jPMLooMEK0ZM3gPF/1dorPCFSjVc8oFdaD74gVCwwUOaNyYMwPvJ+dGa8ar6oW6pQ6O/
         PNjgNPd11zLm+BybAUHhMEuxWuOvQ/tBEIwyC8BiyovAVQUW+bhKgmAw6U917udMbwuL
         vsKLBoI7Hpm1RlmuWqGi+GC/dBsQ3nS1vZMjWZUXQhJr2lpXx8fAWDmZjAb+lQH7Ymq9
         Txig==
X-Forwarded-Encrypted: i=1; AFNElJ/sxcNQs+1HGXFTit07CUR/j9FfoIY83BvkxMEk+it2EN3pM/bAqF/BRvrYcVnMJbxlEAycfkgoOeUI9xECPw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxkPcoiFfGkZR2QwWCeQoMm+MaiFol0DSRwTARR6fvt1h8wckTW
	7z0vAFuH76zw9UTmm57oKZGAH24XM22NqdjTNoeYGwXQ5aP7JVNcyStn
X-Gm-Gg: AfdE7cn0j7iYfiFNh1v7wg7Rsrn8qv3hFp3t7U1SzkO84/gKuquOnJ+1Lm6F1EKWc3n
	AzQLkBxoBDk1WgDG//iQUBK1Z8yWfbgnq2O3w8kmH3o7pf2yG9XDdOeA7uxaiJyjSQl/UB+mxcF
	LOoQ4MHhSIiFXCpq6R4skQgBO0nB+4KWoUK89JUVQ9EFl+O3MbSFrEZ7g11XlBLzvzYV0cwjEXv
	4lzs7BkE4MoC8PE1aOCcZz3iTnc8dJKARR5lBAKHOUlANaGKgEc/A0zOnCCXk1jMhY/V18Gpzam
	o/AvNdjm8WErE6zQGD5DpJ5o7nXFRYY04h5NaTwf5SPFSd64OFRzh+gBEp45+JG1YbtHJFUWxlr
	qh9JSKMx7sxene28YJ9Vzu3WMVRtLDR/Om5AzBTmRzTO2Pnnzc9p+Uqt46AmHFjug/uLRmvczH3
	F/Pym4HPl3iM4=
X-Received: by 2002:a05:600c:8411:b0:492:3172:bcf0 with SMTP id 5b1f17b1804b1-4926683880emr154263455e9.3.1782580452046;
        Sat, 27 Jun 2026 10:14:12 -0700 (PDT)
Received: from fedora ([212.253.209.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46c221d9371sm36799668f8f.21.2026.06.27.10.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2026 10:14:11 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: ghwns6743@gmail.com
Cc: benjamin.berg@intel.com,
	johannes@sipsolutions.net,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	miriam.rachel.korenblit@intel.com,
	serhatkumral1@gmail.com,
	syzbot+21629c14aa749636db9d@syzkaller.appspotmail.com
Subject: Re: [PATCH wireless] wifi: mac80211_hwsim: avoid division by zero in mac80211_hwsim_write_tsf()
Date: Fri, 26 Jun 2026 10:37:38 +0300
Message-ID: <20260626073738.13014-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260627134827.12531-1-ghwns6743@gmail.com>
References: <20260627134827.12531-1-ghwns6743@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks a lot for the independent confirmation and for tracking down the
exact mechanism -- the OOB read landing inside struct mac80211_hwsim_data
(via sband->bitrates = data->rates) explains precisely why KASAN stays
quiet. Appreciate you sharing the reproducer too.

On hardening ieee80211_get_tx_rate() centrally: I'd defer to Johannes on
the preferred direction, since it touches callers across several drivers
(ath5k, adm8211, and likely others) that currently dereference the
return value without a NULL check -- any change there needs an audit of
all of them, which felt out of scope for this fix. If it's considered
worth doing, I'd be happy to help with that audit.
