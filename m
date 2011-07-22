Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:37595 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab1GVHbn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 03:31:43 -0400
Received: by fxd18 with SMTP id 18so4831783fxd.11
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jul 2011 00:31:42 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Stanislav Demakov <s.demakov@gmail.com>
Subject: Re: rt2x00, AP mode, 802.11n is not working properly
Date: Fri, 22 Jul 2011 09:29:35 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <CAN=pzdLRaRHkg4NquUpDhEwRzq-roKQXMtMcwnr031maDSLRfw@mail.gmail.com> <CAN=pzd+EFcyRnexjiMMLNR86hT_UKiePr=yCkZZk5dD4sqYSew@mail.gmail.com> <CAN=pzdL596WrhmaWWE6s_ouAmR-zSr1bUki2YVzLKgE1Y2VijQ@mail.gmail.com>
In-Reply-To: <CAN=pzdL596WrhmaWWE6s_ouAmR-zSr1bUki2YVzLKgE1Y2VijQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201107220929.35836.helmut.schaa@googlemail.com> (sfid-20110722_093146_772430_28CF450F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 21. Juli 2011 schrieb Stanislav Demakov:
> Quick note: changed .entry_num value back to 64 and the speed raised
> even more! Now it's about 2.5 MB/s.

64 is not a safe value in this case and rt2800usb_txdone_entry_check tries
to protect against a special case where the tx status for single frames
gets "lost". But at least we now know a little more about this issue.

> But still there is still room for improvement. :)
> Looks like rt2800usb_txdone_entry_check was the major cause for the delay.

Ok, thanks for trying. I'll think about a proper solution without causing
regressions ...

Helmut
