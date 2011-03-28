Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33857 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab1C1N37 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 09:29:59 -0400
Received: by bwz15 with SMTP id 15so2393287bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2011 06:29:58 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Maciej Sujkowski <maciej.sujkowski@gmail.com>
Subject: Re: potential error in p54usb driver?
Date: Mon, 28 Mar 2011 15:29:37 +0200
Cc: linux-wireless@vger.kernel.org
References: <AANLkTinf20Ss3XAZpyP8PrnVkt9ahL4iqRYrWgEafywA@mail.gmail.com>
In-Reply-To: <AANLkTinf20Ss3XAZpyP8PrnVkt9ahL4iqRYrWgEafywA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103281529.38289.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 28 March 2011 14:44:50 Maciej Sujkowski wrote:
> Can you please take a look at the below error report?
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/736490
>
> I have also tried to connect to the AP without network-manager using
> only iwconfig commands (WEP network) and had the same issue.
iwconfig (in fact all wext tools in general) are obsolete.
Use "iw" instead.
<http://wireless.kernel.org/en/users/Documentation/iw>

> The last kernel where it worked fine for me was the one included in
> ubuntu 10.10 (2.6.35).
try compat-wireless stack+drivers:

<http://wireless.kernel.org/en/users/Download>
<http://wireless.kernel.org/en/users/Download#Getting_compat-wireless_on_Ubuntu>

Also, the first gen p54usb devices [yours is one] share the same firmware
identifier with the miniPCI firmwares. [Obviously, USB devices don't work
with pci firmwares and vice versa.]

Also, you have to install crda. It's even highlighted in the bugreport as a
crucial missing component. "CRDA: Error: [Errno 2] No such file or directory".

Regards,
	Chr
