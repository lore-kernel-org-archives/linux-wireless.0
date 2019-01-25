Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D63BC282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 23:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 531B0218D0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 23:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548458956;
	bh=Fusw28bcBDAQvBTF5cF5haf82A6MCzEIGEDdOERrVtg=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=d0D6D9qV1ffcob99jTTMnoSILk8i/ZCNwaJritS6fHEL5TVOizLl5vQRU44D7seWS
	 TpcRbO2PEisX+eXu3B/re3v8Am77PD7RSkK4Zq/ExBPxpVzz+JTCEjf+Ybssglb92Y
	 /udTaAVUMJdl3UTJxL8nmY50eiIQb7Z/DQWrFjpA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729500AbfAYX3K (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 18:29:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:53600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbfAYX3K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 18:29:10 -0500
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 138CE2184B;
        Fri, 25 Jan 2019 23:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548458948;
        bh=Fusw28bcBDAQvBTF5cF5haf82A6MCzEIGEDdOERrVtg=;
        h=From:To:Cc:Subject:Date:From;
        b=Ix+ao/bcSHUmvsekLZ4cQdEXaO8uwoNMX8E4Rj/i91lgxIXjw4SCNvi8SmptY0T7Q
         iHbnIz204LWdL+5eDzPS6DkCWMttPUkF1IqZF0jFzv5PhL4GE1pzs6jVMSFxYDJnjZ
         dt47oHq9n6QDprmM6ohJ8ZRbu+kJ2ZeAJAiLbSRc=
From:   Shuah Khan <shuah@kernel.org>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, w.d.hubbs@gmail.com,
        chris@the-brannons.com, kirk@reisers.ca,
        samuel.thibault@ens-lyon.org, gregkh@linuxfoundation.org,
        robh@kernel.org, jslaby@suse.com, sameo@linux.intel.com,
        davem@davemloft.net, arnd@arndb.de,
        nishka.dasgupta_ug18@ashoka.edu.in, m.maya.nakamura@gmail.com,
        santhameena13@gmail.com, shuah@kernel.org, zhongjiang@huawei.com,
        viro@zeniv.linux.org.uk
Cc:     linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        speakup@linux-speakup.org, devel@driverdev.osuosl.org,
        linux-serial@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] tty: Fix WARNING in tty_set_termios
Date:   Fri, 25 Jan 2019 16:29:05 -0700
Message-Id: <20190125232905.21727-1-shuah@kernel.org>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

tty_set_termios() has the following WARMN_ON which can be triggered with a
syscall to invoke TIOCGETD __NR_ioctl.

WARN_ON(tty->driver->type == TTY_DRIVER_TYPE_PTY &&
                tty->driver->subtype == PTY_TYPE_MASTER);
Reference: https://syzkaller.appspot.com/bug?id=2410d22f1d8e5984217329dd0884b01d99e3e48d

A simple change would have been to print error message instead of WARN_ON.
However, the callers assume that tty_set_termios() always returns 0 and
don't check return value. The complete solution is fixing all the callers
to check error and bail out to fix the WARN_ON.

This fix changes tty_set_termios() to return error and all the callers
to check error and bail out. The reproducer is used to reproduce the
problem and verify the fix.

Reported-by: syzbot+a950165cbb86bdd023a4@syzkaller.appspotmail.com
Signed-off-by: Shuah Khan <shuah@kernel.org>
---
 drivers/bluetooth/hci_ldisc.c       |  8 ++++++--
 drivers/staging/speakup/spk_ttyio.c |  4 +++-
 drivers/tty/serdev/serdev-ttyport.c | 20 +++++++++++++++-----
 drivers/tty/tty_ioctl.c             | 14 ++++++++++----
 net/nfc/nci/uart.c                  |  1 +
 5 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index fbf7b4df23ab..643c4c75f86d 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -321,6 +321,8 @@ void hci_uart_set_flow_control(struct hci_uart *hu, bool enable)
 		status = tty_set_termios(tty, &ktermios);
 		BT_DBG("Disabling hardware flow control: %s",
 		       status ? "failed" : "success");
+		if (status)
+			return;
 
 		/* Clear RTS to prevent the device from sending */
 		/* Most UARTs need OUT2 to enable interrupts */
@@ -369,13 +371,15 @@ void hci_uart_set_baudrate(struct hci_uart *hu, unsigned int speed)
 {
 	struct tty_struct *tty = hu->tty;
 	struct ktermios ktermios;
+	int ret;
 
 	ktermios = tty->termios;
 	ktermios.c_cflag &= ~CBAUD;
 	tty_termios_encode_baud_rate(&ktermios, speed, speed);
 
-	/* tty_set_termios() return not checked as it is always 0 */
-	tty_set_termios(tty, &ktermios);
+	ret = tty_set_termios(tty, &ktermios);
+	if (ret)
+		return;
 
 	BT_DBG("%s: New tty speeds: %d/%d", hu->hdev->name,
 	       tty->termios.c_ispeed, tty->termios.c_ospeed);
diff --git a/drivers/staging/speakup/spk_ttyio.c b/drivers/staging/speakup/spk_ttyio.c
index c92bbd05516e..ded6f8089fc8 100644
--- a/drivers/staging/speakup/spk_ttyio.c
+++ b/drivers/staging/speakup/spk_ttyio.c
@@ -165,7 +165,9 @@ static int spk_ttyio_initialise_ldisc(struct spk_synth *synth)
 	get_termios(tty, &tmp_termios);
 	if (!(tmp_termios.c_cflag & CRTSCTS)) {
 		tmp_termios.c_cflag |= CRTSCTS;
-		tty_set_termios(tty, &tmp_termios);
+		ret = tty_set_termios(tty, &tmp_termios);
+		if (ret)
+			return ret;
 		/*
 		 * check c_cflag to see if it's updated as tty_set_termios may not return
 		 * error even when no tty bits are changed by the request.
diff --git a/drivers/tty/serdev/serdev-ttyport.c b/drivers/tty/serdev/serdev-ttyport.c
index fa1672993b4c..29b51370deac 100644
--- a/drivers/tty/serdev/serdev-ttyport.c
+++ b/drivers/tty/serdev/serdev-ttyport.c
@@ -136,7 +136,9 @@ static int ttyport_open(struct serdev_controller *ctrl)
 	ktermios.c_cflag |= CRTSCTS;
 	/* Hangups are not supported so make sure to ignore carrier detect. */
 	ktermios.c_cflag |= CLOCAL;
-	tty_set_termios(tty, &ktermios);
+	ret = tty_set_termios(tty, &ktermios);
+	if (ret)
+		return ret;
 
 	set_bit(SERPORT_ACTIVE, &serport->flags);
 
@@ -171,12 +173,14 @@ static unsigned int ttyport_set_baudrate(struct serdev_controller *ctrl, unsigne
 	struct serport *serport = serdev_controller_get_drvdata(ctrl);
 	struct tty_struct *tty = serport->tty;
 	struct ktermios ktermios = tty->termios;
+	int retval;
 
 	ktermios.c_cflag &= ~CBAUD;
 	tty_termios_encode_baud_rate(&ktermios, speed, speed);
 
-	/* tty_set_termios() return not checked as it is always 0 */
-	tty_set_termios(tty, &ktermios);
+	retval = tty_set_termios(tty, &ktermios);
+	if (retval)
+		return retval;
 	return ktermios.c_ospeed;
 }
 
@@ -185,13 +189,16 @@ static void ttyport_set_flow_control(struct serdev_controller *ctrl, bool enable
 	struct serport *serport = serdev_controller_get_drvdata(ctrl);
 	struct tty_struct *tty = serport->tty;
 	struct ktermios ktermios = tty->termios;
+	int retval;
 
 	if (enable)
 		ktermios.c_cflag |= CRTSCTS;
 	else
 		ktermios.c_cflag &= ~CRTSCTS;
 
-	tty_set_termios(tty, &ktermios);
+	retval = tty_set_termios(tty, &ktermios);
+	if (retval)
+		return;
 }
 
 static int ttyport_set_parity(struct serdev_controller *ctrl,
@@ -200,6 +207,7 @@ static int ttyport_set_parity(struct serdev_controller *ctrl,
 	struct serport *serport = serdev_controller_get_drvdata(ctrl);
 	struct tty_struct *tty = serport->tty;
 	struct ktermios ktermios = tty->termios;
+	int retval;
 
 	ktermios.c_cflag &= ~(PARENB | PARODD | CMSPAR);
 	if (parity != SERDEV_PARITY_NONE) {
@@ -208,7 +216,9 @@ static int ttyport_set_parity(struct serdev_controller *ctrl,
 			ktermios.c_cflag |= PARODD;
 	}
 
-	tty_set_termios(tty, &ktermios);
+	retval = tty_set_termios(tty, &ktermios);
+	if (retval)
+		return retval;
 
 	if ((tty->termios.c_cflag & (PARENB | PARODD | CMSPAR)) !=
 	    (ktermios.c_cflag & (PARENB | PARODD | CMSPAR)))
diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index 9245fffdbceb..93e6531573ad 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -316,8 +316,9 @@ int tty_set_termios(struct tty_struct *tty, struct ktermios *new_termios)
 	struct ktermios old_termios;
 	struct tty_ldisc *ld;
 
-	WARN_ON(tty->driver->type == TTY_DRIVER_TYPE_PTY &&
-		tty->driver->subtype == PTY_TYPE_MASTER);
+	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
+		tty->driver->subtype == PTY_TYPE_MASTER)
+		return -EINVAL;
 	/*
 	 *	Perform the actual termios internal changes under lock.
 	 */
@@ -411,7 +412,9 @@ static int set_termios(struct tty_struct *tty, void __user *arg, int opt)
 			return -ERESTARTSYS;
 	}
 
-	tty_set_termios(tty, &tmp_termios);
+	retval = tty_set_termios(tty, &tmp_termios);
+	if (retval)
+		return retval;
 
 	/* FIXME: Arguably if tmp_termios == tty->termios AND the
 	   actual requested termios was not tmp_termios then we may
@@ -588,7 +591,10 @@ static int set_sgttyb(struct tty_struct *tty, struct sgttyb __user *sgttyb)
 						termios.c_ospeed);
 #endif
 	up_write(&tty->termios_rwsem);
-	tty_set_termios(tty, &termios);
+	retval = tty_set_termios(tty, &termios);
+	if (retval)
+		return retval;
+
 	return 0;
 }
 #endif
diff --git a/net/nfc/nci/uart.c b/net/nfc/nci/uart.c
index 78fe622eba65..9978c21ce34d 100644
--- a/net/nfc/nci/uart.c
+++ b/net/nfc/nci/uart.c
@@ -447,6 +447,7 @@ void nci_uart_set_config(struct nci_uart *nu, int baudrate, int flow_ctrl)
 	else
 		new_termios.c_cflag &= ~CRTSCTS;
 
+	/* FIXME tty_set_termios() could return error */
 	tty_set_termios(nu->tty, &new_termios);
 }
 EXPORT_SYMBOL_GPL(nci_uart_set_config);
-- 
2.17.1

