Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33212 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab2FZRp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 13:45:27 -0400
Received: by bkcji2 with SMTP id ji2so195361bkc.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jun 2012 10:45:26 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Michal Kudelski" <michal@idsia.ch>
Subject: Re: carl9170 driver - reducing the output power
Date: Tue, 26 Jun 2012 19:45:08 +0200
Cc: linux-wireless@vger.kernel.org
References: <web-69364863@ti-edu.ch> <201206251933.10999.chunkeey@googlemail.com> <web-69401031@ti-edu.ch>
In-Reply-To: <web-69401031@ti-edu.ch>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201206261945.08250.chunkeey@googlemail.com> (sfid-20120626_194531_338089_481AEB17)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, June 26, 2012 02:10:25 PM Michal Kudelski wrote:
> Thank you for the response! Indeed, when I used the latest 
> compat-wireless, I was able to control the output power.

I'm glad I could help.
 
> Now, another question arises: what is the lowest supported 
> power level? Do you have any hardware specifications of 
> AR9170 that would say what is the lowest power level 
> supported by the hardware?

No, I'm sorry, but I don't have such a thing (Maybe Adrian
knows more). From what I knot, the lowest possible value
for the "tpc" registers and the tx descriptor tpc is "0"
(there's no "sign" bit so I'm afraid anything lower than
0 is not possible).
 
> With iw/iwconfig commands, the lowest achievable power is 
> 1 dbm. But I'm thinking about modifying your code in order 
> to write fixed values to the corresponding registers. And 
> I need to know what to write into the registers in order 
> to obtain the lowest possible power :-) .

The power is set by:
carl9170_tx_rate_tpc_chains in tx.c (for most outgoing frame -
except control frames like ACKs/ERP/... which are
controlled by carl9170_set_mac_tpc in mac.c)

Regards,
	Christian
