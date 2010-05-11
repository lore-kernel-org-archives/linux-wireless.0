Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:34370 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab0EKX12 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 19:27:28 -0400
Received: by fg-out-1718.google.com with SMTP id d23so231861fga.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 May 2010 16:27:26 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "David H. Lynch Jr." <dhlii@dlasys.net>
Subject: Re: ar9170-fw II
Date: Wed, 12 May 2010 01:27:17 +0200
Cc: linux-wireless@vger.kernel.org
References: <4BDC001F.9050202@dlasys.net> <201005021452.01101.chunkeey@googlemail.com> <4BE9D3DB.7040005@dlasys.net>
In-Reply-To: <4BE9D3DB.7040005@dlasys.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201005120127.18837.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 12 May 2010 00:02:03 David H. Lynch Jr. wrote:
> On 05/02/2010 08:52 AM, Christian Lamparter wrote:
> > Well, then you have two more good reasons why to use carl9170:
> >   * carl9170 has the ability to store additional per-frame data.
> >     In fact, if you don't need to have a different retry rates
> >     you could realloc the 3 * 32 bit "rr" (as in retry rate)
> >     array in the carl9170_tx_superdesc and _carl9170_tx_superdesc
> >     struct (see wlan.h) for your purposes (storage for your time values).
> >
> >     And if you fetched all the data, everything will be sent
> >     with an ordinary tx status feedback report to the application
> >     (add the timer fields into carl9170_tx_status and _carl9170_tx_status
> >      struct - see fwcmd.h)
>      cmd.h __check() tests for sizeof(carl9170_tx_status) != 2
>      is there an assumption somewhere that carl9170_tx_status == 2 ?
good catch!

I have now replace some of those meaningless numerical values with
precalculated #defines *_SIZE.

This way, firmware and drivers can verify the structs sizes
and check whenever the compiler really did what it was supposed
to do.

Regards,
	Chr
