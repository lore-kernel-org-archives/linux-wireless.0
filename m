Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f169.google.com ([74.125.82.169]:37558 "EHLO
        mail-ot0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752484AbdLGQkj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 11:40:39 -0500
Received: by mail-ot0-f169.google.com with SMTP id s4so6865130ote.4
        for <linux-wireless@vger.kernel.org>; Thu, 07 Dec 2017 08:40:39 -0800 (PST)
Subject: Re: Where does rtlwifi/rtl8188ee identifies interrupt type?
To: Farhan Khan <khanzf@gmail.com>, linux-wireless@vger.kernel.org
References: <CAFd4kYCqPpL7HsOqkLsTVy8WGsiC7Dj0JnY1mNbKE3MZjcDBzQ@mail.gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <cb2c3c02-8d2d-b68f-9674-420e1a4f6a22@lwfinger.net> (sfid-20171207_174143_245904_71224D8C)
Date: Thu, 7 Dec 2017 10:40:37 -0600
MIME-Version: 1.0
In-Reply-To: <CAFd4kYCqPpL7HsOqkLsTVy8WGsiC7Dj0JnY1mNbKE3MZjcDBzQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/06/2017 11:01 PM, Farhan Khan wrote:
> Hi all,
> 
> I am reading through the rtlwifi code, specifically rtl8188ee code. I
> am trying to find the driver handles interrupts, reads from the card
> and identifies what type of interrupt it receives.
> 
> I believe it will utilize the REG_HISR and REG_HIMR registers, but
> only see writes to those register values, not reads which I was
> expecting.

Keep in mind that all of the rtlwifi family of drivers actually use the routines 
in rtlwifi, and either rtl_pci or rtl_usb. They employ a lot more code than is 
found in their specific directory.

I will not be answering every question like this, but in this case look at 
_rtl_pci_interrupt().

Larry
