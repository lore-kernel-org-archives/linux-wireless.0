Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailsrv0.aau.at ([143.205.180.48]:33807 "EHLO
	mailsrv.uni-klu.ac.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751963AbaFDG3Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 02:29:16 -0400
Received: from mailsrv.uni-klu.ac.at (localhost [127.0.0.1])
	by mailsrv.uni-klu.ac.at (Postfix) with ESMTP id D15C41608DC
	for <linux-wireless@vger.kernel.org>; Wed,  4 Jun 2014 08:23:03 +0200 (CEST)
Received: from [192.168.0.103] (91-114-145-220.adsl.highway.telekom.at [91.114.145.220])
	by mailsrv.uni-klu.ac.at (Postfix) with ESMTPSA id B62901608D8
	for <linux-wireless@vger.kernel.org>; Wed,  4 Jun 2014 08:23:03 +0200 (CEST)
Message-ID: <538EBB1C.3060106@aau.at> (sfid-20140604_082920_030895_697AA1E9)
Date: Wed, 04 Jun 2014 08:22:20 +0200
From: Severin Kacianka <severin.kacianka@aau.at>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: A question about monitor mode
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have a question about monitor mode and the monitor interface: When
will a frame show up in the monitor interface?

If I understand 802.11 correctly, there will first be a Request to Send
(RTS), then a Clear to Send (CTS) signal. Then the actual frame will be
send followed by an ACK.
I did some testing and it seems, that the frame shows up in the
monitoring interface after the ACK is received.
My test setup was to record the socket.send call of an UDP packet with
an unique ID and then measure the time it takes for that packet to be
read on the monitor interface.
As the measured time was not constant, but seemed to vary in relation to
the network conditions I suppose that the frame only shows up after its
delivery was acknowledged.

Is this observation correct and where in the kernel's source (or
elsewhere) should I look for more details?

Thank you for your time and best regards,
Severin
