Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40409 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932708Ab1IMVVC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 17:21:02 -0400
Received: by qyk7 with SMTP id 7so937203qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Sep 2011 14:21:01 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 13 Sep 2011 17:21:01 -0400
Message-ID: <CAEh_CyWGoaEsouDuLuAqD5K8xA0AqWEuf7S3HQwagrvz3DgajA@mail.gmail.com> (sfid-20110913_232106_690696_AD1D41AA)
Subject: Carl9170 firmware
From: J Igrap <jigrap.code@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While using the past days the carl9170 firmware with a USB card under
a linux guest running different kernel and driver versions I kept
running into the issue of a usb disconnect when the card was put under
load:
 usb 1-1: no command feedback received (-110).
 carl9170 cmd: 08 01 00 00 f0 36 1c 00 00 24 00 00              .....6...$..
 usb 1-1: restart device (6)

No matter what kernel driver/firmware I tried I will still get it. I
decided to look into it a bit more and I narrowed it down to be a
firmware issue with the following code snippet:

void handle_cmd(struct carl9170_rsp *resp) in src/cmd.c
        case CARL9170_CMD_WREG:
esp->hdr.len = 0;
                for (i = 0; i < (cmd->hdr.len / 8); i++)
                        set(cmd->wreg.regs[i].addr, cmd->wreg.regs[i].val);
                break;

That code appears to handle event 1 which is a write into a register.
In some cases that write appeared to cause a failure and a reset into
the card. I added a simple delay loop before the switch statement and
that seemed to fix the issue and I don't lose the card anymore even
under a lot of load. Obviously that's not a real fix and something
else more reliable needs to be in place.

-jigrap
