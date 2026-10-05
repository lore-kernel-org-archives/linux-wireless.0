Received: from mail-pz2-f37.google.com (mail-pz2-f37.google.com [74.125.228.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086644A4EE6
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 15:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791214172; cv=none; b=juK/LzjyeYb94QabHfc21UCEK0hhVpLcgwPtV8YYGA+uOGE8CdGVPByCzlxPOw2PopGKhjb2O4iPdcOI5u5mmqvQSa7rQbpgupDUvlIOQC9GytHp3DgZujvg8gl8bV7Ro0p1Jd/U/XDufHiTTUNXlbgI6dgICEKYjumOAK3llmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791214172; c=relaxed/simple;
	bh=SswjrzyVPI5dmo6NNJt9y9emlKltQuLGpCcU65AkvAo=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=plnlkILkMpznpjGNOj7OeHXvgA+OKFa956mCLZzjcaFACiAfKMFq4pQvdQfdy2CH6RP9B6i2HsbPCYX2simBqyK+enGZTquH+j787zgVfsUBVqiqI4we8fDocwEpSoDqWH8msPDl7YZ83+4cfOSe7DbfJEcMmPa6ULk+F5tQDks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ime.unicamp.br; spf=pass smtp.mailfrom=dac.unicamp.br; dkim=pass (2048-bit key) header.d=unicamp.br header.i=@unicamp.br header.b=MkJBBuuO; arc=none smtp.client-ip=74.125.228.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ime.unicamp.br
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dac.unicamp.br
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unicamp.br header.i=@unicamp.br header.b="MkJBBuuO"
Received: by mail-pz2-f37.google.com with SMTP id 41be03b00d2f7-cc7c9c2df74so443500a12.0
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 08:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unicamp.br; s=google; t=1791214166; x=1791818966; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type:date
         :cc:to:reply-to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jlSLnvmArAMm+EgC4qUUQAIYauoQJFzatzKh0cwYl7g=;
        b=MkJBBuuO2sAbBZGSH/dnd9pFSPzp/cVMlVZYQsblT1unUp9wLUHZiJtZo6kQOdasPe
         cKXx4ZymFZFXq56MoH5MPRmWlxP+tMOfMPG6rfJRo2XI2WQ59H3KlbjAztE0ySAsNfz3
         2Tdupo39+WJygcPsBNJeEr961bnxxadtdsCjhFsrMmTCx2AwsdCzohIzM4jsqryfyjAs
         pGlIv/hxOeqxeztUZn9/DbfzM7YDsyBBOTQuGaEN7h6i9jvlKTPhsWqtyvsZeqRm3M//
         kFY95mehmY9+AUOhf+N777CkvoK7QkZE0zwQXv/LQhO3WrWi9MHFUObzHP93SLkcFRQV
         OrAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791214166; x=1791818966;
        h=mime-version:user-agent:content-transfer-encoding:content-type:date
         :cc:to:reply-to:from:subject:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jlSLnvmArAMm+EgC4qUUQAIYauoQJFzatzKh0cwYl7g=;
        b=iEEiPQa7VtxuRHh4rcDGqHt7JnSXhvV7k0MmVBL/iA9A3QVcQwhC+B/vt4W3Bvq8DF
         /90i5beKXN5Air8VV7z2mXt+jHK1/3BeyzUrxzL+GqHm9hdp8PfKdMrFMkcXZhgBL+F+
         gT+niktmYHxNltTP2g+c0ZN0JX/rM2rVyOnZeGRPX35DANxIlzO3D8M4fLdNZvcHcJq4
         1kD4t+dO9QDleMfju5Fu90TzGzC3FUVzn2CfScIHSXhhYZZkonm0Yvzl0AheEn3VpZwb
         zXLnLTJzMTtnZPjz/GbMx29IsWVpqFeyi+xYm2a30eJYLfWsg/i3pBYLqOJCM8RogIaC
         VJ+w==
X-Gm-Message-State: AFq9FYLKTDVZ6rVsjfiSsD3RZkVRGm9x3pdUiq6+En1kOpPc+83bI0jQ
	xRsjQ5IYMq4bSGwY/k39YzHj1nZxzuZcPwKR89RPdmcDBpC8GOt016y8LW7z763XvYb5sCS+Fyp
	nOt5IIlnkzCvEfbsDf/hDN9CXgJqg4ifTrvGMjxPr9bYgS6Gpvk0RJDavipHyxKQfV3m/ELminE
	Bp+tcbeUzzteB5T4CrNVEGKK4KyiNVyq3H7SagKN4fibDRAcESLQ69DNUMMA==
X-Gm-Gg: AYBFou3tp0nKn5SPMLYyRJxwxKHGSiyk+OcuPQpSzlzJm1kYNpHy1jtruUBLvfyY7Io
	2BDAgA7U9fONI6GwmdAbLsKgSAd8XbbTli7ZT83lHGrXo/GwtS2rtQtUowh6oItPLkAoj3/TknJ
	3ZfJIcRd+UqyW89FULjSF7rMkyjobfJab+TJg4TKTf1b39fp8r8Lh4AodQp0TrPIliI6/1VaIFS
	oiHcEoduHU4x1GWfdYYOc6Bgko5RnHEd7JOsCaye6IcntpMsHt7C4w92zhn8aDHZCqcxuyuZibr
	+OiN7Zyz4hY7gzOusT43plZ7ukgjzoWC8Qesk8keKWPy57Xoxgnu4RSWI3CODaeI890xOFTVSXd
	ZQlCrOH8yIxWmIjtJymPe2F/rp+OPRmfO3iBkxzgi9gxSTGHnTMztnysKWtkYqfA6+vuA0Xsoch
	gLPYI42YXLvWHohb0sYxW0m3wQdlhC2vVUtRt/7vD6ImlrTAI/vzScxdg3ROjhrUCybwgAwer46
	ZRBy40MCjT/QQN4jb7QyBzGk03N2CTHPT4563ahwp+HLLxm0s+p5u+tzjgvNsrPjxCLu38gD/U=
X-Received: by 2002:a17:90a:a97:b0:3a6:d850:bf16 with SMTP id 98e67ed59e1d1-3a6d850c29fmr4023147a91.23.1791214165274;
        Mon, 05 Oct 2026 08:29:25 -0700 (PDT)
Received: from ?IPv6:2804:14c:49a:128d:187b:535:5bc2:6d0f? ([2804:14c:49a:128d:187b:535:5bc2:6d0f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e5a5ef2323sm9443005ad.69.2026.10.05.08.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 08:29:24 -0700 (PDT)
Message-ID: <ac639c3600dd0013fcea402cb79772839f600e4e.camel@ime.unicamp.br>
Subject: [BUG] wifi: ath9k: QCA9565 Wi-Fi degrades severely when Bluetooth
 is active
From: =?ISO-8859-1?Q?Andr=EAs?= Oliveira <andres@ime.unicamp.br>
Reply-To: andres@ime.unicamp.br
To: linux-wireless@vger.kernel.org
Cc: toke@toke.dk
Date: Mon, 05 Oct 2026 12:29:18 -0300
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi,

I'm seeing a Wi-Fi/Bluetooth issue with ath9k on an Acer Aspire
ES1-572 with a QCA9565.

With Wi-Fi enabled, the connection works but is somewhat weak and
unstable. When Bluetooth is enabled without any device connected, the
Wi-Fi signal becomes noticeably weaker. As soon as I connect a
Bluetooth device, the Wi-Fi connection usually drops completely.

While investigating the issue, I collected the following information.

Hardware

Laptop:
  Acer Aspire ES1-572
  BIOS: Insyde Corp. V1.18

Wi-Fi:
  Qualcomm Atheros QCA9565 / AR9565
  PCI ID: 168c:0036
  Subsystem: Foxconn 105b:e091
  Driver: ath9k

Bluetooth:
  Foxconn / Hon Hai 0489:e095
  Kernel modules observed: btusb, ath3k

Software

Distribution: Linux Mint 22.3
Kernel: 7.0.0-38-generic

Diagnostic information

ath9k reports at boot:

  ath: phy0: WB335 2-ANT card detected
  ath: phy0: Set BT/WLAN RX diversity capability
  ath: phy0: Enable LNA combining

"iw phy phy0 info" reports:

  Available Antennas: TX 0x1 RX 0x3
  Configured Antennas: TX 0x1 RX 0x3

The current ath9k module parameters are:

  btcoex_enable=3D0
  bt_ant_diversity=3D0
  ps_enable=3D0

ath9k debugfs reports:

  BTCOEX is disabled

While looking through the ath9k source, I noticed that subsystem
105b:e091 is listed as:

  ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV

I don't know whether this is related to the problem, but I thought it
might be useful information.

Possibly related reports

I found a few reports that seem related:

[1] Another Acer Aspire ES1-572 with a QCA9565 had unstable and
    disconnecting Wi-Fi under Linux, while the same laptop worked
    normally under Windows:
    https://plus.diolinux.com.br/t/linux-pop-os-com-problemas-de-
conexao-wifi-oscilando-e-desconectando/44353

[2] A QCA9565 user reported very slow Wi-Fi when Bluetooth was
    enabled. Enabling ath9k btcoex_enable=3D1 reportedly fixed the issue
    in that case:
    https://forums.linuxmint.com/viewtopic.php?p=3D2458380

[3] Another QCA9565/ath9k user reported Wi-Fi being repeatedly
    deactivated/reactivated when Wi-Fi and Bluetooth were used
    together. The same hardware worked normally under Windows.
    Enabling btcoex_enable=3D1 did not resolve the issue in that case:
    https://bbs.archlinux.org/viewtopic.php?id=3D311508

I have not changed these module parameters; the values above are the
current state on this installation.

I'm reporting this in case it is useful for identifying an ath9k issue
with this hardware.

If additional logs, hardware information, or tests would be useful,
please let me know and I can provide them.

Thanks,
Andr=C3=AAs
