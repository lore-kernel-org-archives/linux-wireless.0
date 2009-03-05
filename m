Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:48658 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756781AbZCEQvd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 11:51:33 -0500
Message-ID: <49B00306.8050000@lwfinger.net> (sfid-20090305_175155_914120_936E7B2B)
Date: Thu, 05 Mar 2009 10:51:18 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Markus Feldmann <feldmann_markus@gmx.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: BCM4303 on HP zv5265ea
References: <gohr71$48f$1@ger.gmane.org> <49AC742D.9030309@lwfinger.net> <gom4ke$vle$1@ger.gmane.org> <49AE9BDD.7070603@lwfinger.net> <gomq5f$n64$1@ger.gmane.org> <49AEF58E.30302@lwfinger.net> <gon99n$b1t$1@ger.gmane.org>
In-Reply-To: <gon99n$b1t$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I can add a little more information. It turns out that I have one PCIe module
that will work with b43legacy as it uses ucode5 firmware. I modified my system
to load b43legacy, rather than b43, for this device. After I did that, the
RFKILL switch works correctly, just as it does in b43.

>From the above experiment, I conclude that the rfkill implementation in
b43legacy is correct. Any problems that you are having are the result of some
quirk in your hardware, therefore, none of us can debug it as we will not be
able to reproduce the problem.

Does your RFKILL switch generate a keycode? You can test that by switching to
console 1 (CTRL/ALT/F1), log in, run the command 'showkey', and operate the
radio switch. On my system, I get a keycode of 238. BTW, use CTRL/ALT/F7 to get
back to the X console.

Larry

