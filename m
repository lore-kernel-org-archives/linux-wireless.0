Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:36795 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600AbbJANSW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 09:18:22 -0400
MIME-Version: 1.0
From: =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Date: Thu, 1 Oct 2015 09:17:42 -0400
Message-ID: <CA+A7VXW02GyRaFYw34CSim=WJrvF_fff5oK73JT1+bhRbv_B9g@mail.gmail.com> (sfid-20151001_151834_830136_5247D206)
Subject: rtl8821ae bisected regression between 4.1 and 4.2
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Vincent Fann <vincent_fann@realtek.com>,
	Shao Fu <shaofu@realtek.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Stable <stable@vger.kernel.org>,
	Daniel Drake <drake@endlessm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello linux-wirelless (cc'ing stable since the original patch had
cc:stable as well),

I'm experiencing a CPU soft lockup while downloading when rtl8821ae is
loaded (even when downloading through other adapters) on a vanilla 4.2
kernel. The problem did not happen on vanilla 4.1. Bisecting shows the
first bad commit being "rtlwifi: Remove the clear interrupt routine
from all drivers" (1277fa2ab2f9a624a4b0177119ca13b5fd65edd0).
Reverting that commit makes the problem go away.

The system is perfectly stable until I start downloading, when the UI
becomes unresponsive, sometimes leading to a complete freeze. When the
system does not completely freezes and I'm able to kill the download,
everything seems to go back to normal after killing it, and I am able
to continue to use the computer as long as I do not download anything.
Most of the time either a soft or a hard lockup is detected, but not
always, although the freeze always occurs.

This is the kernel log with lockdep enabled (although sometimes the
problem does not occur with lockdep enabled):
https://gist.github.com/jprvita/3aa2c0c9a66793e1fad1

I have the laptop where this happens as a test machine sitting on my
desk, so I'm available to test any patches or gather more information
if needed. Please advise on how I can help debugging this further.

Regards,

--
João Paulo Rechi Vita
http://about.me/jprvita
