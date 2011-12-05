Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50652 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912Ab1LELaZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Dec 2011 06:30:25 -0500
Received: by faar15 with SMTP id r15so431864faa.19
        for <linux-wireless@vger.kernel.org>; Mon, 05 Dec 2011 03:30:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ED77C85.1050705@broadcom.com>
References: <4ED77C85.1050705@broadcom.com>
Date: Mon, 5 Dec 2011 12:30:24 +0100
Message-ID: <CACna6rznu8d1BjG0EWjP1VRCPdYAGJv1q+fi1X+XF_Bf-Cx+Mg@mail.gmail.com> (sfid-20111205_123029_741664_72E99EF7)
Subject: Re: bcma usage in isr context
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Sorry for late reply, I was a little busy recently...

W dniu 1 grudnia 2011 14:09 użytkownik Arend van Spriel
<arend@broadcom.com> napisał:
> I am doing some final testing on our brcmsmac driver, which I tinkered
> to become a bcma device driver. During testing an issue popped up in the
> ISR code.

Do you mean interrupts code?


> Looking into the bcma read/write functions in host_pci.c I conclude that
> bcma itself does not provide protection for concurrency. Am I correct in
> that? How is this solved in b43?

I think I mean the fact that core driver can switch BCMA to
ChipCommon, while interrupt handler will try to access 80211 core?

You're right, we don't handle this properly. I'll try to send patch
today to make use of fixed windows. I've it here for some time
already, just didn't clean it enough.

-- 
Rafał
