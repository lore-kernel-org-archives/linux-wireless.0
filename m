Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.ralinktech.com.tw ([211.75.121.152]:33608 "HELO
	smtp.ralinktech.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751064Ab1BJFad convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 00:30:33 -0500
From: RA-Jay Hung <Jay_Hung@ralinktech.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>, Kalle Valo <kvalo@adurom.com>
CC: "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	RA-Dennis Lee <Dennis_Lee@ralinktech.com>,
	RA-Eddy Tsai <Eddy_Tsai@ralinktech.com>
Subject: RE: [RFC] rt2x00: Add autowakeup timer for receiving beacons while
 in powersave mode
Date: Thu, 10 Feb 2011 05:24:11 +0000
Message-ID: <B7288B2B5878D747BA031EF4B170D7F6092D2727@TWHCMBS01.tw.ralinktech.ad>
References: <201101311600.39486.IvDoorn@gmail.com>
	<874o8mbaec.fsf@purkki.adurom.net>
 <AANLkTikKevPWkWMu=HLPHt-jACLZLQzqN6thr-2LNk59@mail.gmail.com>
In-Reply-To: <AANLkTikKevPWkWMu=HLPHt-jACLZLQzqN6thr-2LNk59@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ivo,

> Well the official Ralink driver also uses a timer to wakeup the hardware,
> there are however registers which suggest support for autowake functionality.

> Jay, Dennis, Eddy, can you explain a but how the autowake functionality is
> implemented in the rt2800usb firmware?

Current power saving and wake up procedure as below.

PCI:
1. Driver sends power-save command to firmware to turn off RF/BBP and configure
mac register (AUTO_WAKEUP_CFG) to set a hardware timer counter.
2. When hardware timer timeout, issue an interrupt and notify the driver.
3. Driver send wake up command to firmware to turn on RF/BBP and ready to process
packets

USB:
1. Driver sends power-save command to firmware to turn off RF/BBP and set
a software timer to emulate the purpose of hardware timer.
2. When software timer timeout, driver sends wake up command to firmware to
turn on RF/BBP and ready to process packets.

Note: for future projects, hw or firmware will take more psm mechanism to reduce
some latency between firmware and host to save more power.

BR,
Jay
CONFIDENTIALITY STATEMENT : The information, attachments and any rights attaching in this e-mail are confidential and privileged; it is intended only for the individual or entity named as the recipient hereof.Any disclosure, copying, distribution, dissemination or use of the contents of this e-mail by persons other than the intended recipient is STRICTLY PROHIBITED and may violate applicable laws.If you have received this e-mail in error, please delete the original message and notify us by return email or collect call immediately. Thank you.
