Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hyde.gogi.tv ([87.106.167.24]:49107 "EHLO hyde.gogi.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932168Ab0HFA62 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 20:58:28 -0400
From: Daniel Haid <d.haid@gogi.tv>
To: linux-wireless@vger.kernel.org
Subject: Re: Capturing packets with bad FCS in monitor mode
Date: Fri, 6 Aug 2010 02:58:07 +0200
Cc: Qasim Javed <qasimj@gmail.com>
References: <201008051614.11546.d.haid@gogi.tv> <AANLkTikM_hyo71PyMLQ9z63FnOkusbKQb7OkRWfOvSTZ@mail.gmail.com>
In-Reply-To: <AANLkTikM_hyo71PyMLQ9z63FnOkusbKQb7OkRWfOvSTZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008060258.07539.d.haid@gogi.tv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> In order to receive frames with CRC errors in monitor mode, I just
> removed ATH9K_RXERR_CRC from the above snippet, recompiled and
> reloaded ath9k and was able to receive frames with CRC errors.

I assume this is the case because the driver is still being developed and
the correct behaviour would be that frames with CRC errors are recieved
in monitor mode if and only if the fcsfail flag is not set.

Will a patch be accepted that implements that behaviour? What else
must the patch contain for it to be accepted?

(For example, what about the radiotap header? Will it automatically
have the bad fcs flag set when for a corrupted packet? Or does that
have to be still implemented as well?)

Thank you
