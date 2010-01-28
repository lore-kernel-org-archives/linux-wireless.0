Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:35471 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab0A1P6o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2010 10:58:44 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: scan does not work
Date: Thu, 28 Jan 2010 16:58:09 +0100
Cc: Sriram V <vshrirama@gmail.com>
References: <8bf247761001280439u59a9b6ch1128d42a83116594@mail.gmail.com> <201001281528.37342.holgerschurig@gmail.com> <8bf247761001280737v135c8fbfj7a5e1b7eea881d5c@mail.gmail.com>
In-Reply-To: <8bf247761001280737v135c8fbfj7a5e1b7eea881d5c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201001281658.09944.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> How do i check if the communication between the host and
> libertas is proper? 

The communication between your device and the CPU on the libertas
device seems to be correct, otherwise you'd have error messages
in your dmesg.

You can also turn run "lbsdebug +enter +host +cmd +hex" to get
even more info, but apparently the libertas device doesn't give
you any scan results back.

Please consider a broken antenna, antenna socket or otherwise
some error in your RF setup. Or maybe you have 802.11a
access-points on 5 GHz, while you card can only run 2.4 GHz.


Here's for example a dmesg output of a successful scan:

libertas cmd: DNLD_CMD: command 0x0010, seq 239, size 18
libertas cmd: CMD_RESP: response 0x8010, seq 239, size 18
libertas cmd: DNLD_CMD: command 0x0028, seq 240, size 12
libertas cmd: CMD_RESP: response 0x8028, seq 240, size 12
libertas cmd: DNLD_CMD: command 0x0006, seq 241, size 67
libertas cmd: CMD_RESP: response 0x8006, seq 241, size 109
libertas cmd: DNLD_CMD: command 0x0006, seq 242, size 67
libertas cmd: CMD_RESP: response 0x8006, seq 242, size 11
libertas cmd: DNLD_CMD: command 0x0006, seq 243, size 67
libertas cmd: CMD_RESP: response 0x8006, seq 243, size 351
libertas cmd: DNLD_CMD: command 0x0006, seq 244, size 53
libertas cmd: CMD_RESP: response 0x8006, seq 244, size 11

See how big the size-numbers for the scan-responses are. That's
because my device find some APs and returns all the data back.

In your case, with 11-bytes-only response, it doesn't find 
anything. For example, when I deliberately scan only one 
channel, where no AP is available, I'll get back the same 11 
bytes as you. In the following example, I also turned 
on "lbsdebug +hex". Then I get back:

libertas cmd: CMD_RESP: response 0x8006, seq 246, size 11
libertas CMD_RESP: 06 80 0b 00 f6 00 00 00 00 00 00

And that is:

   06 08    CMD_802_11_SCAN (actually a response, because the
            high bit is set)
   0b 00    size of response (== 11 bytes)
   f6 00    sequence number
   00 00    result of command exection (== success)
   00 00    buffer size of scan response
   00 00    number of APs in response set

Best regards,
Holger

-- 
http://www.holgerschurig.de
