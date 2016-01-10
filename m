Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36185 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbcAJQnc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jan 2016 11:43:32 -0500
Received: by mail-wm0-f47.google.com with SMTP id l65so185774152wmf.1
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jan 2016 08:43:32 -0800 (PST)
From: poma <pomidorabelisima@gmail.com>
Subject: ath10k QCA6174 firmwares match
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Message-ID: <56928A30.6010803@gmail.com> (sfid-20160110_174355_713833_FF6BB17F)
Date: Sun, 10 Jan 2016 17:43:28 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


It's not that they fully correspond,
however here is a brief overview

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

"Ath10k drivers can't find firmware"
https://bugzilla.redhat.com/show_bug.cgi?id=1208986


- dmesg -2:
  ath10k/QCA6174/hw2.1/board.bin
  ath10k/QCA6174/hw2.1/firmware-2.bin
  ath10k/QCA6174/hw2.1/firmware-3.bin
  ath10k/QCA6174/hw2.1/firmware-4.bin


- linux-firmware-20151214-60.gitbbe4917c:
  /usr/lib/firmware/ath10k/QCA6174/hw2.1/
  board.bin
  firmware-5.bin


- github.com/kvalo/ath10k-firmware.git:
  ath10k-firmware/QCA6174/hw2.1/
  board.bin
  firmware-5.bin


- modinfo ath10k_pci | grep QCA6174/hw2.1
  firmware:       ath10k/QCA6174/hw2.1/board-2.bin
  firmware:       ath10k/QCA6174/hw2.1/board.bin
  firmware:       ath10k/QCA6174/hw2.1/firmware-5.bin
  firmware:       ath10k/QCA6174/hw2.1/firmware-4.bin

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

"Qualcomm Atheros QCA6174 not working"
https://bugzilla.redhat.com/show_bug.cgi?id=1294263


- dmesg -2:
  ath10k/QCA6174/hw3.0/board.bin
  ath10k/QCA6174/hw3.0/firmware-5.bin


- linux-firmware-20151214-60.gitbbe4917c:
  /usr/lib/firmware/ath10k/QCA6174/hw3.0/
  board.bin
  firmware-4.bin


- github.com/kvalo/ath10k-firmware.git:
  ath10k-firmware/QCA6174/hw3.0/
  board-2.bin
  board.bin
  firmware-4.bin


- modinfo ath10k_pci | grep QCA6174/hw3.0
  firmware:       ath10k/QCA6174/hw3.0/board-2.bin
  firmware:       ath10k/QCA6174/hw3.0/board.bin
  firmware:       ath10k/QCA6174/hw3.0/firmware-5.bin
  firmware:       ath10k/QCA6174/hw3.0/firmware-4.bin

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

"Qualcomm Atheros QCA6164 not working"
https://bugzilla.redhat.com/show_bug.cgi?id=1257500

  firmware?


