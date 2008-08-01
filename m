Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:32171 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbYHAC37 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 22:29:59 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1131765wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jul 2008 19:29:58 -0700 (PDT)
Message-ID: <3ace41890807311929w464c41femf30efc5441830d13@mail.gmail.com> (sfid-20080801_043012_773020_018F9422)
Date: Fri, 1 Aug 2008 03:29:57 +0100
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH V3] rtl8187: Fix lockups due to concurrent access to config routine
Cc: "John W Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Herton Ronaldo Krzesinski" <herton@mandriva.com.br>
In-Reply-To: <48925938.27Ki5NWyw4NzKtNf%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48925938.27Ki5NWyw4NzKtNf%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/1/08, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Some users of the RTL8187B have experienced difficulties since commit
>  8f87dd7e540d455f8e7f11478133b85edc969c67 that introduced the power
>  management wext hooks. This difficulty has not made much sense until
>  it was realized that it was possible for mac80211 to make a call to the
>  config routine while that routine was already being executed. On this
>  device, it is necessary to loopback the TX when changing channels. Unless
>  this is properly restored, the device will lockup. A mutex now protects
>  the device state, and the private data in several places.
>
>  The problem was found by Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
>  who also suggested this type of fix.

Thanks for the work. I think we need a few more mutex locks.

The one-line message/explanation is a bit mis-worded though. There isn't a
"lockup" though. I would describe the problem as the driver's internal
state getting garbbaged. It is probably a performance "feature" that
routines in either the mac80211 layer or the usb layer returns before
they are done. (i.e. actions are simply
queued for near-future to act on). Maybe somebody else can explain this better?

Hin-Tak
