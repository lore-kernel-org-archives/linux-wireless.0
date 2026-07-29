Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273353CA4BB
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 07:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785309236; cv=pass; b=GoDxmzT9aKezlBSocfoop1CeQ/hwqjGjcDTmLZayEL9BafFtl/qJf4di/08BxgBrEI1RzIvXeFQDuTLey2UVZN0UmGwOpQdiE4GdejywRUHS0hUEvgmm2dR2i1ELW7TXKBa55Kh7GPhI+UpY96oMdUqvWw4O6nYuRXI1QYMO//Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785309236; c=relaxed/simple;
	bh=KpYULavbjtKvFdrpkXDnK1yzhJE4jkFyhzzm/kEvt24=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=kt65kcZGC3CTMBrOd3dDE88LgmAqCzhKVh/Wq8QLxDmtBkNB+XjVl4vccCP+F/7fJt/qq+1dO6Ms5pTIZUaD6cmnwXlaT77uaY1mfErWAOyNn7QmbcfZErz3tf80VAwzSWnImmo5NBWgweUDbzbfTWjbpCdue9NrDJmIAX4WEZ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HjqWwqFW; arc=pass smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HjqWwqFW"
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-977bbf2eb3aso51625241.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 00:13:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785309229; cv=none;
        d=google.com; s=arc-20260327;
        b=Wd43PK2W9KdiEL7TyDBCZLab+rgJ6+vAANOhxeLlHwDBhZbfnJLFd7LjloKhivunp3
         lzdYhMGVO8fKdEAC6WjbBQ72AfLOFv1hdnIGSCgUGv8zwKWyJwo1QN0P1wKd4atgq2Q+
         uUS9kZhLqb8keLj8kDGwxePxFxCwLw/MQetltODR434MHb2CNuuK56lo+cLExTXHRU7k
         yPBCS05RuJZcLuab7MC9i34NsnviQuI4sd+iSi0DyCZSlzjCYCh6UYN72lP9vDQRayqv
         O4Nev/BVqtd1YjapkKZ9NJYqlD0oyI5rzR1tujMoEs4DQdapWw2LkpOyEY27mpgneMmT
         evQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=fs+jIt+cbjSuNDysNWabBfq+6b6qQltF4ClvU4rx7Ok=;
        fh=gzC/TNff/zuzRK2t9Gt+IJJWAif67sIXy0gGiAhDyjg=;
        b=YQrdTgEuzgvZvYA6inqScxCprFURHxLgoWS1K8sjMAGhFPerhhh2dMLcuUeT9Jfl0s
         0b+JU4dnbqWqKA5LhS/2YbiYc67Tqqso/CVexeR7OCAqzUHpHqrrGWvp1qN7i7Qepz/s
         pWe8ok1xYx2/FH7FIemHHM6kPR/yx6vI+ldChnadD742ysBFDSakk03EcM9ejkaAkVWe
         WH/mHNiHjpNY67iQH+vEZuIq4zimQne/kpj3PMUXXX1COk/l0Qzr5FWsPA2e0qmAxROn
         FToFbg3wpWGFRZQN/gifOTLB4guy0p184SwzEsR6cX8uvtmNyHravobpnvwXsBPa7Vcg
         swEQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785309229; x=1785914029; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fs+jIt+cbjSuNDysNWabBfq+6b6qQltF4ClvU4rx7Ok=;
        b=HjqWwqFW50lFsIh+zCFIefctJoVSKID/vgVd7k522W4UeM/Zdwq7qO+Hu6OmZBEAjx
         LPMXzqk9Obn2zHrJNZ0CSTA/KieQ7IniyGDp59K+SG0gISx/9OFJt/ihLEN7ZGiISjH8
         ha5w24AeG0V2e++ljHw7UAp5yngqWI8wiw62vOB6PtSAKxHimaWXnOBaM0pE6WJpnr7q
         UeuT9Zz0hqsSnp+kyI111FRPWW205yGb3GZq3fZ4VcrrslRVDu8psaRFx9MsTn6fRyr+
         olcL/QswZW5/0fkh0FwhHGK4K0za6a361C3tewH1V0ntUsIpaoSZoppPXOrI20+v6KZX
         kagw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785309229; x=1785914029;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=fs+jIt+cbjSuNDysNWabBfq+6b6qQltF4ClvU4rx7Ok=;
        b=VdFVbqlF9UI0AKM6pjr9WlnFRs+DfDrFOUuVSqPopZrYkZx57mZcTE93HttrR4iFXj
         aHJFfIwjGmhtl00xM2H9WVmV6ywf4fU0QRb1Tk3L7JpH9J+N7VYa/JO5FKaktLPynK0o
         CXof+9MpIMWGDgPEf4qHCBioVV6zxcrPV3q+lJeNmR1d/+9ryGJirkuA1VeJul+leodT
         Eq8UtfKQifxnd7TY/MqcCy7w8UGxjMUGmrsKyJTeYgkziRhn/6HrfrDURcgF4KAnAv1r
         wt4agd817l0Dd1LkEfXhyJUpRPk2R7bRDs98MZhfkUctD6kC3sSNSQbVIX1WpOi4yFzX
         rRhA==
X-Gm-Message-State: AOJu0YzYGoHnDy6I/n9dxEbXAZ9+uWSct2dbWvvDSunVkpuAm6QwO8Nj
	zNo95qfKNpP8jI7CQzmYS9Pqpugqkm2Z5YJfqyLeDxXbMtTKYAZo6lyiZesiDZZP/fKZ79Yeq7P
	z6ilTz0LtdBpdclph/sA0sh2BHkappV4dYVG3gOg=
X-Gm-Gg: AR+sD13AByrvYcXXaXPe+vsjd+Y+wDJozxKPVz+Y7+zbD43fHy9xGhXqtCwvsoybwfz
	hx6AIgMBL2fBHAScnGKG7DFGrrU5hVSUv2GeP/auSce6Mdzu/wHY0qR074qwPL0B5F+o2qp+Jgu
	JecPul7jdWaaGv6Z0kPgLhPs0HaPBObCbi1SZYRJfU29ug9VTk7nBN6ti6JbNwA8cJw8Fe+j7Yo
	Z4XJ01dPhHyIeL8abjjvJ/rt86eclN5E5bq/6thcs45Ot1QDU/tEvIO0c89YazCj98X1d68Ij5s
	FbHwAX4M9HWCILAG0Dg3ZMmk1PPi7LV6Xi/ObXq2VAVVvrOCMYvx6FlgPQ==
X-Received: by 2002:a05:6102:571b:b0:740:22ba:8a4e with SMTP id
 ada2fe7eead31-7549f657d0emr2248081137.6.1785309227977; Wed, 29 Jul 2026
 00:13:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Snake Pilot <snakepilot10@gmail.com>
Date: Wed, 29 Jul 2026 01:13:36 -0600
X-Gm-Features: AUfX_mw9EhIxqweqSgEi1AawCPL0kcmUZ0QCkalyp2e3NkfvGdVYFyBPcptR2Ug
Message-ID: <CA+fxq6gPCQOYr6mh+_1ReOGzaiTULzMazXhs5q0PXc8PsjRJEQ@mail.gmail.com>
Subject: [BUG] rtw88_8723de: Wi-Fi and Bluetooth fail after warm reboot
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com, linux-usb@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

I would like to report a reproducible warm-reboot issue affecting the
Realtek RTL8723DE combo device.  I have included the reproduction steps,
relevant logs, and a tested workaround below.

The RTL8723DE combo device in this HP laptop is unusable after a warm
reboot.  The PCIe Wi-Fi function fails to power on and the USB Bluetooth
function fails to enumerate.  A cold boot restores both functions.

This prevents the laptop from using either Wi-Fi or Bluetooth after a
normal reboot.  The problem is reproducible.  I have also observed the
same behavior while using other Linux distributions.

System information:

  Laptop:             HP Laptop 15-da1xxx
  Product SKU:        18K59LA#ABM
  BIOS:               Insyde F.48, 2024-04-26
  Wi-Fi:              10ec:d723, subsystem 103c:8319
  Bluetooth:          USB 0bda:b009
  Distribution:       Soplos Linux Tyron RC4
  Kernel:             7.1.3+deb14-amd64
  Kernel package:     Debian 7.1.3-1
  Kernel taint:       0
  Driver:             in-tree rtw88_8723de
  Wi-Fi firmware:     48.0.0
  firmware-realtek:   20260622-1

The failing boot used the packaged Debian kernel with the in-tree driver,
no rtw88 module options, and no local shutdown workaround.  The kernel
reported taint value 0 when the failure was captured.

Steps to reproduce:

  1. Start the laptop after a complete power-off.  Wi-Fi and Bluetooth
     work normally.
  2. Reboot Linux normally.
  3. Wi-Fi and Bluetooth are both unavailable after the reboot.
  4. Power off the laptop and hold the power button for about 30 seconds.
  5. Start the laptop.  Wi-Fi and Bluetooth work again.

Expected result:

  Both functions should initialize after a warm reboot.

Actual result:

  The Wi-Fi PCI function remains visible at 02:00.0, but the driver does
  not bind.  The relevant kernel messages are:

  rtw88_8723de 0000:02:00.0: Firmware version 48.0.0, H2C version 0
  rtw88_8723de 0000:02:00.0: failed to poll offset=0x5 mask=0x1 value=0x0
  rtw88_8723de 0000:02:00.0: mac power on failed
  rtw88_8723de 0000:02:00.0: failed to power on mac
  rtw88_8723de 0000:02:00.0: failed to setup chip efuse info
  rtw88_8723de 0000:02:00.0: failed to setup chip information
  rtw88_8723de 0000:02:00.0: probe with driver rtw88_8723de failed with
  error -16

  During the same boot, the Bluetooth USB function fails before btusb can
  bind:

  usb 1-10: device descriptor read/64, error -71
  usb usb1-port10: attempt power cycle
  usb 1-10: device not accepting address 6, error -71
  usb 1-10: device not accepting address 7, error -71
  usb usb1-port10: unable to enumerate USB device

On a successful cold boot the same hardware produces:

  usb 1-10: New USB device found, idVendor=0bda, idProduct=b009
  rtw88_8723de 0000:02:00.0: Firmware version 48.0.0, H2C version 0
  rtw88_8723de 0000:02:00.0 wlo1: renamed from wlan0

Disabling ASPM with the following module option did not change the result:

  options rtw88_pci disable_aspm=1

The option was confirmed active during the test and was removed
afterwards.

The failure can be prevented by stopping NetworkManager and Bluetooth,
unloading btusb and rtw88_8723de, waiting three seconds, and then
rebooting.  On the same system, this workaround completed three
consecutive warm reboots without either failure:

  modprobe -r btusb
  modprobe -r rtw88_8723de
  sleep 3
  reboot

The fact that both bus functions fail together, while an explicit driver
shutdown prevents the failure, appears to indicate that the combo device
retains an invalid power or reset state across warm reboot.

An older report describes the same behavior on an HP 15-da0xxx with the
same PCI and USB identifiers.  It used the driver available in 2018, but
also reported USB error -71, MAC initialization failure after warm reboot,
and recovery after a cold boot:

  https://bbs.archlinux.org/viewtopic.php?id=240675
  https://bugzilla.kernel.org/show_bug.cgi?id=201239

A related RTL8723DE rtw88 power-sequence report is archived here:

  https://www.spinics.net/lists/linux-wireless/msg200831.html

Please let me know which additional traces or tests would help determine
whether the shutdown sequence belongs in rtw88 or requires a platform
quirk.

Thank you for your time and help.
