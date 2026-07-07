Received: from meesny.iki.fi (meesny.iki.fi [195.140.195.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF483EB7FE
	for <linux-wireless@vger.kernel.org>; Tue,  7 Jul 2026 15:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=195.140.195.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783437472; cv=pass; b=MchlsARdfeDHsXW94gxAYaJFl8+Y4dZgaVlvRIPwsuolxCv2weyTbCxVab237TfpptWeCb2kAYI64l7Q0DVODEKyL87zMmfggw3MsOwPQlXXSeM4smPrH3DhqUDWyNhWvl6zkMzN/Vyg3JJF3XrdN15uZLX2psB3vJogRL09ohs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783437472; c=relaxed/simple;
	bh=dKWAO3QFtErg5ZVVjKvtV4CveN8ImjdgdFwwbRm5FAc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Ne5T/uSa/MtyxTvfJfbZnlLvGu1aL6RFJMpxf5GDuTznwbpZxoM12c86p3wYAslXQDnlkBQ5niV0oisOhf3RcukppEVfZgtThQQCyY8QpmAeMN/8f79+cMIbcyvHlrsfSZFVq9P/RH3bHVs6RxTvBygT0pfdstHKWIwrLh9Nhro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b=l8F8QZCY; arc=pass smtp.client-ip=195.140.195.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b="l8F8QZCY"
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: martin-eric.racine)
	by meesny.iki.fi (Postfix) with ESMTPSA id 4gvlGF6TLLzySY
	for <linux-wireless@vger.kernel.org>; Tue, 07 Jul 2026 18:17:41 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
	t=1783437462; h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
	bh=dKWAO3QFtErg5ZVVjKvtV4CveN8ImjdgdFwwbRm5FAc=;
	b=l8F8QZCYp0ySifyE8zUJoaUcqKB0eIjpdgF66eOe6Z6ZagGev4YcvI3RtlvR4GqZ6qsc3S
	lntfwMHGPoXMLDaRBj8COvF1VJ9ucUhYU3UAMGNR/1cBDof4wsxBRFyc+KAWCExnywLPxE
	tYLI7ejO5HkacvLoDNIk4PmCGdQK0ME=
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=meesny; cv=none; t=1783437462;
	b=uHA2m/j+8Wfw45jRK9ZDD/PkDeC2vxNHcqKmHb7lQDCDUlYxjZ+gmjU1yfSG3aMYnQOfaR
	47wx/+qp8pxecJ9d42DEjYLXxIGWD9yVa9W0u4TZz0FrQWzHu0D8mfkvK36s4d91mBxXqb
	8nszZq+B/N0KU6tuGWE/1p2fzl1yDlU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=meesny; t=1783437462;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dKWAO3QFtErg5ZVVjKvtV4CveN8ImjdgdFwwbRm5FAc=;
	b=AAr6+4zXkKVJfpembSU4CNtiZhUeFo7h9CWRNehOZbo8JoO8VPQafzZiOPQPSZEf41/wFz
	ITEWD6sqCVf6KFjFrY0p9MumjQncXhzf/NTO9Z0mKoaEUZdsVUQbaMEpHHAk35IIvaoBTF
	cnXlxkf5Si1SnYDBVUpQRRU4ujFSGTE=
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=martin-eric.racine smtp.mailfrom=martin-eric.racine@iki.fi
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5aebf120839so949408e87.0
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jul 2026 08:17:41 -0700 (PDT)
X-Gm-Message-State: AOJu0YzvIYtzU8ZN/6GhSkA4yTTMohZbna00vqSXpdWeRMsvzu7dET4o
	I5QxloVSonW20sY94f4dOnwXgWfgq0UPZzOlUTFGNnAL51wCMbwtsaobDuz5Z1bU1rMJ4JmgbK2
	x7gS3VFjwhY/MX4G7DppgHWR2J7kxJqE=
X-Received: by 2002:a05:6512:3e0d:b0:5ae:d72d:1000 with SMTP id
 2adb3069b0e04-5b00ac66f9cmr709442e87.1.1783437461314; Tue, 07 Jul 2026
 08:17:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Reply-To: martin-eric.racine@iki.fi
From: =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <martin-eric.racine@iki.fi>
Date: Tue, 7 Jul 2026 18:17:25 +0300
X-Gmail-Original-Message-ID: <CAPZXPQcg==8tT8ad7EvPYPJkmpha1_onQEae+opxYVY7HqnnLw@mail.gmail.com>
X-Gm-Features: AVVi8CfgncKsP9T2q1g_rs5PsfZpiK8gVkmriPeKyli97vbZt4MDUGYezYKgXn4
Message-ID: <CAPZXPQcg==8tT8ad7EvPYPJkmpha1_onQEae+opxYVY7HqnnLw@mail.gmail.com>
Subject: [Bug 221733] iwlegacy: iwl4965: kernel oops
To: linux-wireless@vger.kernel.org, Stanislaw Gruszka <stf_xl@wp.pl>, 
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Greetings,

As instructed via the kernel.org Bugzilla, I'm hereby contacting the
mailing list since Intel pointed out that they no longer maintain the
iwl4965 driver themselves and instead inquire on the mailing list.

Martin-=C3=89ric
