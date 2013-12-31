Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:36093 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab3LaI2Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 03:28:24 -0500
Received: by mail-ob0-f180.google.com with SMTP id wo20so12538289obc.11
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 00:28:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87sit9o2ct.fsf@purkki.adurom.net>
References: <CA+V6dmh7Udn96GG0XGaabx-t6ZViu1RGk-xTawa_KbnCdro9Ew@mail.gmail.com>
 <87sit9o2ct.fsf@purkki.adurom.net>
From: Pierre Bourdon <delroth@gmail.com>
Date: Tue, 31 Dec 2013 09:28:03 +0100
Message-ID: <CA+V6dmjqJUBtZvngh-Yp2gxmW=TS=GPqF2ZJ+x9HspmUao1aUw@mail.gmail.com> (sfid-20131231_092828_148592_6F33D7D7)
Subject: Re: Exporting the TSF to userland
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 31, 2013 at 9:23 AM, Kalle Valo <kvalo@adurom.com> wrote:
> Pierre Bourdon <delroth@gmail.com> writes:
>
>> I'm a developer of libdrc, a project that allows Linux computers to
>> control a Wii U GamePad. Because of how the device operates, our
>> library needs to be able to read the TSF value of the access point
>> device from userland.
>
> Just out of curiosity, how do you use TSF exactly?

The Wii U GamePad reads the TSF and uses that to configure its
internal clock. All video and audio packets sent to the device have to
contain a timestamp that roughly matches (1000us window) this internal
clock. This means our library has to be able to read the TSF from the
AP NIC to generate these timestamps.

-- 
Pierre "delroth" Bourdon <delroth@gmail.com>
Software Engineer @ Zürich, Switzerland
http://code.delroth.net/
