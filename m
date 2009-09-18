Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:49630 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbZIRHAZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 03:00:25 -0400
MIME-Version: 1.0
In-Reply-To: <646765f40909172337g74b419fegd2935cb28aedb220@mail.gmail.com>
References: <20090915174233.7db381cd@varda>
	 <200909151813.32223.IvDoorn@gmail.com>
	 <646765f40909172337g74b419fegd2935cb28aedb220@mail.gmail.com>
Date: Fri, 18 Sep 2009 09:00:28 +0200
Message-ID: <a32f33a40909180000m72d3f8cep3b97205e5ef1e26d@mail.gmail.com>
Subject: Re: [rt2x00] rt2500pci is spamming syslogd since upgrade to 2.6.31
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: =?ISO-8859-1?Q?Alejandro_Riveira_Fern=E1ndez?= <ariveira@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 18, 2009 at 8:37 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
> 2009/9/16 Ivo van Doorn <ivdoorn@gmail.com>:
>> Hi,
>>
>>>  Hi; my syslog has many entries like this since the upgrade to 2.6.31
>>>
>>>  phy0 -> rt2500pci_set_device_state: Error - Device failed to enter state 1 (-16).
>>>
>>>  Sometimes the driver just start spamming like crazy sometimes is at less rate
>>>  sometimes it does not appear.
>>>
>>>  I'm running 2.6.31 with a revert [1] config follows. If more info is needed
>>>  just ask
>>>
>>>  [1] http://bugzilla.kernel.org/show_bug.cgi?id=13362
>>
>> Try disabling powersaving,
>>
>>        iwconfig wlan0 power off
>
> I have an identical problem, which is fixed by this command.
>
> It is possible to detect that the chip doesn't, for whatever reason,
> support powersaving and disable it in the driver?

Well I simply have to:
a) fix the driver to handle powersaving better
b) disable powersaving support for the driver

It will probably be (b) first followed by (a) much later if I ever
get the time to look into the issue.

Ivo
