Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D8E3793CA
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 16:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784737579; cv=pass; b=o+rCbLbpQDV9BTuD1UFRcllPP5KB5KyOry8jZztZPj3wqyiNUPoLcZol8JVIz2bhWRAkS2JHJ7wUJPVhuK08IWEC96gcE5MAK94BppzVvFRsCWRdCsjT5/+rJg9cLck8Ra0PUHMt7KyqWjJkeJ0+gE5OD7OXLr+IOC1RsQjWkc4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784737579; c=relaxed/simple;
	bh=pWc0M+jErI73FmlKZ/DUEDEglfkRJR2q2yTZ4vJVIFc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=C+6Zqf7+LDU4NbCPdF40wTLoI5sM2k4W8RFzxKpcZA6OOCdBf/G9ZKyvH9LJxadz9w9Qlxjq+oTyhU7nWchG9Sv0/CcLomjnn1mYJOhBtpNjrTJ8rWCLIZbsKMc3jC5bwy78qk/E18sx5aWyzPaJ7AhwCw0fqho9e/CiHz8cm28=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ol6SiL8L; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ol6SiL8L"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c197f968b3cso21591366b.2
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 09:26:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784737576; cv=none;
        d=google.com; s=arc-20260327;
        b=AjO5iKaxlvXl/HhOYV1okxPXtMI8XG/1uAA6PeiVNTQzCCQGCjdEAbY3uJpWvsfY66
         IaFr0C+lvLxZ+rYcbZEbosCalXW1nuYnTNWskeQn9xtm5V17jZs1WwaX0f8qXnx+dvjb
         QeCTQgTCA3ptMJHVgThTmhIHxWcxOX2s9hJICiD72GvB+SlMMDij8VmfPnu2cAL6t4Py
         2VN4yDLXTDYEPAv75qksyV0rLaLk2hvyChdG4SNLR4m+gnh0TTgYT2UvBv6We4KRKo+j
         QuugtCCmkaEvpKHVxrV4K3ecaVr0I4y2XDotPk/JZ5OSpJXU73zJiDKOJebLJU3Ikruk
         M8yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=E2pSLr7HjdVS9hPbGsmpbm0rxJU1j2pVmqhGSruiCps=;
        fh=qW0phhq3fb3oiohK/Mu9j1KY1zyRNiiioKFc5anvatM=;
        b=YwNxhcopIDX8Aa2Vohx5XO1dlyDFQG3pn/kQ/5siNZnHbug1N6dAMViSzYbLGjnf0j
         PMZihw9jYyfrCW9ymnnA4Kj2S6jnGAMUXGvJUH68RFWpNhVqbpwr0O3xTUiHiGS3F884
         L8iKFfiLPYmzLd5s0Y0V6iZZfHtw71dP5I5pg82I5DU+swlOTwVWH+cPFuMzpENqNh3f
         galkYi7KkaTVMDnfee//2S6kRubFCrul3qQnE8gBX2aPc8gsQH8VEl+B2QOFSfKIppb0
         zqTFS7W1viOTW3zxx0ceXoAd2vYZnedZLRjORWI4fakPZ3cPwTo6zE1hyyIrWybga99V
         JqPA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784737576; x=1785342376; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E2pSLr7HjdVS9hPbGsmpbm0rxJU1j2pVmqhGSruiCps=;
        b=Ol6SiL8LfGIVZ9onlyRJDC9i/ovnCnjC9c9p0rAgSONV8W/i64g1ndSVi8V61HBtSq
         RoCqHV/RsN41oUtqNv4BQrSj5clX3+HQ2a9PXKfv/TPweQlR7NwWGg1aH6U8iUsjDtJa
         PqzkNevwNlOQCsMlQ+KJlYCo22Brzvu5g/tav8pWasUl8d92K2Prz98/pTbXvT/uMXVc
         9E6QMxQbrIA2VNav8d/9PdWDNhHq931gOLAS5dvEwgWYy5cofoACA3cyE1qhmYt2y9Z+
         6TiMrZiCFGzOlqHGd54uF082snvstTo4hvtzIUWeDkImwYnqZHm4qEfhOW+XT6PJ0Gaz
         b7DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784737576; x=1785342376;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=E2pSLr7HjdVS9hPbGsmpbm0rxJU1j2pVmqhGSruiCps=;
        b=KMsJPRGvnMYimOXL6mjZmkVI9ovH0R6PUdJuc/y+DY6ptcjgdXO548UA73FkrWZ4JK
         v9OJ4+fMrbhDKADAqYfm3uUzMKyCSIv5mimgtT4NJdjmbmcKa1Ac1HY9PovEOE4pQKYi
         GtGRsMv711noQXdTGCp5nYOg+Wz3tuohahfzsriaOgFiZTBS51IJJNIZn0Tnn6vS2x0n
         yWwyl2NxBFn4GXrHkYWbl7zpU9pDQwcuDcHN9cJR+WueCX93h7fyyEkaYhg2qXywBDdf
         KQ1KkR6MCSscM8oiMNyHWnHGygYg150U9hDA7Lal1FyXly6teVVRXZVdDiWJVobGKyZW
         PcoQ==
X-Gm-Message-State: AOJu0Yy/x6qjueMxAnpS4p808B8LMlTfah+zcGZ8Farnt1/vDrnjlHuP
	u6sa5I3UM4yAdosh7hXL+isVxL8WDymNO/OxKgPwEs2goegrbISzED0FsxDSgPwrgc5f6pU/S3L
	G9HuCts2U6Z6niyiqlr3lJm/gwdrPNTUGFUrN
X-Gm-Gg: AR+sD11mZmJ2X9D7nsYsoi02jKzjY9qResBdDozEwmZHUHddDbKVVNFz3swtXMUlqaP
	zV13vQQDv9mewKS0TZgCAvS6MZFrWuh/4TbXuehHtdQucORqFSaWYOw9An8fd7pBcPLtNLjm378
	VsjpmgA3SVxJeRM9uaZnqoB+3Z/XZJ6slx5RgUHFR0/R1ozvf+UkN0mLp14yjKW0sPLoIwsi0w/
	IWiGXN3gno9FO8fxkRw650KC0eWMa/qiEkqjdF5ynXeEK1mEzpJylibAQNWUIWx1UkS7PTG14CE
	S2I/qAbIvo1BtmKLJ83WuWwLj1v0bFdqew5tTvJA98dlUe1FweFZKHHOCg0goA==
X-Received: by 2002:a17:907:c00d:b0:c1c:1e4e:f924 with SMTP id
 a640c23a62f3a-c1c1e4efa62mr343945666b.34.1784737575699; Wed, 22 Jul 2026
 09:26:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Vladimir Popovic <vladazemunac@gmail.com>
Date: Wed, 22 Jul 2026 18:26:04 +0200
X-Gm-Features: AUfX_mxup_Z1p4LfIXuUttl_Rb907ohiqtyhLKhFbMGjFqYGFJHEJQ1IjCa-7fc
Message-ID: <CAA_bARL2E2bOtf+Sontp93-Xk8CZ+k7GfbearRf8WyEMgnue6A@mail.gmail.com>
Subject: Related report: https://github.com/lwfinger/rtw89/issues/412
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

I am reporting an intermittent connectivity problem with the
rtw89_8852be driver and a Realtek RTL8852BE PCIe wireless adapter.

During normal network activity, all network traffic occasionally stops.
The Wi-Fi interface still appears connected to the access point, but no
data is transmitted or received.

The connection does not recover automatically. Disabling and enabling
Wi-Fi manually restores connectivity:

    nmcli radio wifi off
    nmcli radio wifi on

The problem occurs intermittently and may take a long time to reproduce.

System information:

    Distribution:
    Fedora Linux 44

    Kernel:
    7.1.3-201.fc44.x86_64

    linux-firmware:
    20260622-1.fc44.noarch

    NetworkManager:
    1.56.1-2.fc44.x86_64

Hardware:

    Network controller:
    Realtek Semiconductor Co., Ltd.
    RTL8852BE PCIe 802.11ax Wireless Network Controller
    PCI ID: 10ec:b852

    Subsystem:
    Lenovo Device 17aa:4853

    Driver:
    rtw89_8852be

    Firmware loaded:
    rtw89/rtw8852b_fw-2.bin

    Firmware version:
    0.29.29.18 (9e3d777f)

Observed behavior:

1. Connect to a Wi-Fi network.
2. Use the connection normally, for example video streaming, downloads
   or communication with local development services.
3. After an unpredictable period, network traffic stops completely.
4. NetworkManager may still show the interface as connected.
5. The connection does not recover by itself.
6. Toggling Wi-Fi off and on restores connectivity.

Expected behavior:

The wireless connection should continue transmitting and receiving data
without requiring a manual Wi-Fi reset.

Power-management testing:

NetworkManager Wi-Fi power saving is disabled:

    [connection]
    wifi.powersave=3D2

The following valid rtw89 module parameters were also tested:

    options rtw89_pci disable_clkreq=3Dy disable_aspm_l1=3Dy disable_aspm_l=
1ss=3Dy
    options rtw89_core disable_ps_mode=3Dy

The active values were confirmed after reboot:

    disable_clkreq=3DY
    disable_aspm_l1=3DY
    disable_aspm_l1ss=3DY
    disable_ps_mode=3DY

This configuration initially appeared to improve stability, but the
traffic stall later occurred again on the existing Fedora installation.

The kernel also reports during boot:

    ACPI FADT declares the system doesn't support PCIe ASPM, so disable it

Therefore, the ASPM-specific options may be redundant on this machine.
The remaining possible power-management factors include CLKREQ and the
internal rtw89 power-saving mode.

Comparison with a fresh installation:

A freshly installed Fedora 44 system on a secondary drive, running on
the same laptop, wireless adapter and kernel version, has remained
stable during testing so far.

The older existing Fedora installation still experiences intermittent
traffic stalls.

This may indicate an interaction between rtw89 and an existing system,
NetworkManager or power-management configuration rather than a simple
hardware failure. However, both installations use the same physical
adapter and kernel driver.

I have not yet captured kernel messages at the exact moment of failure,
because the most recent monitoring session did not reproduce the issue.
I can provide the complete dmesg, NetworkManager log and iw event output
when the next stall occurs.

Related report:

https://github.com/lwfinger/rtw89/issues/412

Please let me know which additional debug information or driver
parameters would be most useful.

Regards,
Vladimir

--=20

All the best,

Vladimir Popovi=C4=87

Save trees. Don=E2=80=99t hit print.
