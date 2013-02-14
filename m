Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:43932 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758666Ab3BNUJq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 15:09:46 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org, IvDoorn@gmail.com,
	gwingerde@gmail.com, helmut.schaa@googlemail.com
Subject: [PATCH] rt2800usb: Add support for eeprom writing
Date: Thu, 14 Feb 2013 15:09:39 -0500
Message-Id: <1360872580-24334-1-git-send-email-pizza@shaftnet.org> (sfid-20130214_210950_140949_7437ABEA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Due to a vendor sending us a batch of boards with bad eeprom data, we needed
a way of rewriting the eeproms.  This hooks the device's eeprom write support
up to a debugfs file, since there's no existing command path to trigger eeprom
writes in the generic rt2x00 driver.

If there's a better way to accomplish this (ethtool?) I'm all ears, but 
this solves my immediate problem.
