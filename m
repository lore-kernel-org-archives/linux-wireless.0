Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34408 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbcFMQmh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2016 12:42:37 -0400
MIME-Version: 1.0
From: David Binderman <linuxdev.baldrick@gmail.com>
Date: Mon, 13 Jun 2016 17:42:35 +0100
Message-ID: <CAMzoamZjA4XfL1b5Hqo7F+97PY-MEaijJ24iY+53L9ntNZromw@mail.gmail.com> (sfid-20160613_184255_379450_E01BCF8C)
Subject: linux-4.7-rc3/drivers/net/wireless/ath/ath9k/htc_drv_main.c: 2 *
 strange tests ?
To: ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello there,

1.

linux-4.7-rc3/drivers/net/wireless/ath/ath9k/htc_drv_main.c:798]:
(warning) Comparison of a boolean expression with an integer other
than 0 or 1.

Source code is

   if (common->ani.caldone <= 0) {

but

drivers/net/wireless/ath/ath.h:    bool caldone;

Maybe better code

  if (!(common->ani.caldone)) {

2.

linux-4.7-rc3/drivers/net/wireless/ath/ath9k/htc_drv_main.c:851]:
(warning) Comparison of a boolean expression with an integer other
than 0 or 1.

   if (common->ani.caldone <= 0)

Duplicate. Also in the same file:

drivers/net/wireless/ath/ath9k/htc_drv_main.c:228]: (style) Variable
'ret' is assigned a value that is never used.

This might be a case where a function return value is not checked.

Regards

David Binderman
