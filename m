Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF207352030
	for <linux-wireless@vger.kernel.org>; Wed,  1 Jul 2026 05:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782884860; cv=pass; b=vDKv3EG5MB2osupxa50mHXCce6hluGkYT8L9rYgvjmfo0xm5N5FnQU90sMevLQBUxqJfI+FOLY8duv9FtxikfIREQxeRfkeq2uImPG3Egc4pRg1BdljWe+LwmH9ULAcyLe8So1bfE+jdaKuP3J1NhgZ/0cEASd1QUDDjDcbFweU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782884860; c=relaxed/simple;
	bh=Z8MMvzWc5l7KrAoeoQfilkzZ8PvRt5ywLENhSc4mJS8=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=Q2AW7lmcfVb0bmuGWFiZSuhJSfyLaeRJ808Zc08Fr90sOXbHp16o7hPq2MtrfNVtfk2BkoR+0NM8oTXxJ421jIjQqsBcUBlbFK+YCQAGa6MEuiOATE0EDrRIiI+F1qYoqAaBj0ZrFJM165EEDCufvXviUEnwdyZzWC25oo1OmU8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FJTDNI/L; arc=pass smtp.client-ip=74.125.82.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FJTDNI/L"
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-30c591fb1cbso323059eec.1
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2026 22:47:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782884858; cv=none;
        d=google.com; s=arc-20260327;
        b=NGZiVnWRXlw8/GiOijsVMp90gFIQWa3HSPSQ3kJp5PqQjSH/X2Go7vyZscQTgU27ai
         9yQW33KDfzYhboMQVrPuuuIBrst61u1WuexxwN6uANwb541Rcjifx/T9S4eCqwaLtwr9
         SAmtK4Epx3wkR9adoUZjnk/amh2xgBCDMMSS5nYRzJ9NNeOst22FUgKg+4odPRd3gqme
         b9BRJ5gMBnbKWiUPOyaSIkJxH/cAYWSB8sMj4Fe2avtX4MroIfXwny55CpeE7mFuZQH3
         bq0jO8Ug8t6fQNIfrc1TIDqx0l+ZXE2rPn6Iwnbe/Hs+29+of+R7ykoNgyVT4vimdOZq
         ejgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:from:dkim-signature;
        bh=Z8MMvzWc5l7KrAoeoQfilkzZ8PvRt5ywLENhSc4mJS8=;
        fh=QH+DOqO8uRm3AYeZPeHBFyvTqLF4Yta5I2vaTqWUJPo=;
        b=caqgvNm8dW9MJSxcuPesNDE8UF41yds/HZh7Xcw+7woLii+zHO/erze7X9OWDhqaNo
         cp0FR1LXy5u9baykanrJn/D80JRtbrHSObQ1EKkyNxVgARs3arxXFZoUSUF+bSYKR217
         QrcjFOj6aZuBXP+ISQJBr8HSH1kDKEyAz5e2LV3MFI2ZYAvY1v/h++zjp8Y0ta2Cx3Ge
         HXp8fodVd+jdIaTeJtwRXV4EeRJyh4v6Cp7VhilF4EUtKNjHzFUW2/vMp96eRG68+KP4
         Z7ux1PkFdZelbJ2/DGnJr9fRXfqMgM2Gj8SeaPOpBTQobuL4k3PG4qmp7qOh9LfjW3wt
         JMYw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782884858; x=1783489658; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Z8MMvzWc5l7KrAoeoQfilkzZ8PvRt5ywLENhSc4mJS8=;
        b=FJTDNI/L8zlf1BM3MrRJoQCu3XXVyobtZdJkWXVsboMpWBvLVcgGJTPlsVmkloKOi9
         wAjFHazK8UqGadxWkkrf86d2kN67GNpuX3Yv7unpcjAsVwyxrvKDCZ6viFA7dHuk8Iz0
         yMw9u6xrDD9tgptMH/RRaBn/OPW+ZBVXDTynvX9/PYhkY+8dcxFVcLqIIm8ICTm4o7Ym
         5yltIm1EuVXJppQHDPaAJtDrR+kUfdOZe4D5AkXoCKfSGGO2gRiys1F9oaH4SgnPw78u
         3lqUil8UYhEH3t6JcnamvtG/GI8yhUsQRHQ0WnQLjxBtEsscNmjnSvI95r1rK/UFSlkG
         cC7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782884858; x=1783489658;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Z8MMvzWc5l7KrAoeoQfilkzZ8PvRt5ywLENhSc4mJS8=;
        b=k/fngsLQO788UzlUCZzrjI0QteySM3POvsSHdj+URyiWsr7n7jKG0NzUYCjs3qHOOp
         p4QL1nm8cv0yYlVzHcnm8ZGQTB1v06Xz9AgQm2wHLbtJ01XYaKl2mCjqMjbvVbwjfRoP
         6muaWMULJZHtu0yt5pVDSQtVgyKCGHngw6rQ9Knk0kqwnVHCwPGvDza1K39tsvBaQcDC
         2412/zlteXHWoFn6Ih12mAjshqHz7MFTrV3P6XTz0LvncCiAT7y8yYwgez4iPHWCtUB1
         boZGmI2CgLI72W3d9pHAcbH5lNvD9VzWKPPBKR+r0r91BFBWdbYsNKLm6/kpGB9febG0
         qrwA==
X-Gm-Message-State: AOJu0Yybw9UD/YaNVfuXYAh4BDKi95Ms7C55o7l+CqztEDZ0fnWLV87g
	Rpjx4cenJf4xdLcpsMY8O8+mv95p8xNy3v/85UmKXN+CJYVAUw1yjllBXLXzZf59EfY0OwNMBL/
	ORy9HsHf2Abp3cVnxXU4QrvqF3qeD7xQ=
X-Gm-Gg: AfdE7clVyuh7lWytmNqIgeWYReXJxA11aocO8bvmrn2zGaKfdEroo6bu11BUkbqOPN0
	RaZeNHMMtlDECF4Cr9qCFktUX9iSAE5Y4b0spfCPZmAtWQxhyw9mEgLbOHSbIULoGJjaXFSBOA5
	BEA+Ys8Su411CTjSAc7J8+/55lU39NxZsny4xFeIZSjAScjVopi6I/229Y6u+WID2U9kPghQ+Sb
	4IW0OuBQGUdIlEXZKNEp2FCazKGOz8UyGZqJ0awPXMOFHPnX3dQVhvOQAf00ZAgTrXrBdNhC8ov
	Y7J+jXjPL7YIh8DoNbRt39bjePjs+yiOVw0H47qL
X-Received: by 2002:a05:7301:3d12:b0:30c:ab4d:3818 with SMTP id
 5a478bee46e88-30eff3717b4mr332767eec.36.1782884857858; Tue, 30 Jun 2026
 22:47:37 -0700 (PDT)
Received: from 266303231514 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 1 Jul 2026 00:47:37 -0500
Received: from 266303231514 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 1 Jul 2026 00:47:37 -0500
From: synicalkid@gmail.com
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 1 Jul 2026 00:47:37 -0500
X-Gm-Features: AVVi8Ce2w6HVBExRenKsbi_-y9dVoqyjDGIg97rIfoQiaAI2nB7U3QLk6igUakg
Message-ID: <CAD_8ym9gtjYJPPBRtm=birBj3CWipgY=k5=YwSqEMfaETkibYA@mail.gmail.com>
Subject: Re: [PATCH v4] wifi: mac80211: fix monitor mode frame capture for
 real chanctx drivers
To: lucid_duck@justthetip.ca
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net, 
	oscar.alfonso.diaz@gmail.com, fjhhz1997@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested v4 logic (applied as v3 diff, functionally identical for the
real-chanctx path) on bare metal =E2=80=94 no VM, no hypervisor.

Setup:
- Host: MacBook Air (kali-rolling, kernel 6.19.14+kali-amd64)
- Adapter: Alfa AWUS036AXML =E2=80=94 MT7921U USB (0e8d:7961), mt7921u driv=
er
- phy1: wlan1 (monitor) + wlan2 (managed, connected to 2.4 GHz AP on same p=
hy)
- mac80211.ko built from linux-source-6.19, v4 patch applied, loaded via in=
smod

Test:
Injected 802.11 beacon frames from wlan1 (monitor) while wlan2 held
the sole chanctx on phy1. Used scapy sendp() + concurrent sniff() on
the same interface.

Result: 3/3 injected frames received back on wlan1. No crash, no kernel
warning, dmesg clean throughout.

The managed+monitor coexistence case on bare-metal MT7921U USB is
stable with this patch.

Tested-by: Glitch <synicalkid@gmail.com>
