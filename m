Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53318 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab1FVOSk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 10:18:40 -0400
Received: by iyb12 with SMTP id 12so700038iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2011 07:18:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1308709475.2196.67.camel@aeonflux>
References: <1308592212-5755-1-git-send-email-aloisio.almeida@openbossa.org>
 <1308592212-5755-3-git-send-email-aloisio.almeida@openbossa.org>
 <20110621215551.GF2628@joana> <1308709475.2196.67.camel@aeonflux>
From: Aloisio Almeida <aloisio.almeida@openbossa.org>
Date: Wed, 22 Jun 2011 11:18:20 -0300
Message-ID: <BANLkTi=s=BUUp=rHdPR57-sjQV-=5eLLmQ@mail.gmail.com> (sfid-20110622_161844_012651_B2EF4EF2)
Subject: Re: [RFC][PATCH v2 2/7] NFC: add nfc subsystem core
To: Marcel Holtmann <marcel@holtmann.org>
Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	sameo@linux.intel.com, johannes@sipsolutions.net,
	lauro.venancio@openbossa.org, marcio.macedo@openbossa.org,
	Waldemar.Rymarkiewicz@tieto.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marcel and Gustavo,

On Tue, Jun 21, 2011 at 11:24 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
>> > +config NFC_DEBUG
>> > +   bool "NFC verbose debug messages"
>> > +        depends on NFC
>> > +        help
>> > +     Say Y here if you want the NFC core and drivers to produce a bunch
>> > +     of debug messages to the system log. Select this if you are having a
>> > +     problem with NFC support and want to see more of what is going on.
>>
>> I think that use only dynamic debug is a lot nicer. I don't see a point to
>> have a NFC debug option in Kconfig. We've been using dynamic debug in the
>> Bluetooth subsystem for a while and it works fine. If we have dynamic debug
>> there is no need to recompile a module to add debug support to it.
>>
>> Also it's a good idea use macros for pr_debug, instead of calling it every
>> time with the same paramenters (__func__, for example). In the Bluetooth
>> subsystem we do like this:
>>
>> #define BT_INFO(fmt, arg...) printk(KERN_INFO "Bluetooth: " fmt "\n" , ## arg)
>> #define BT_ERR(fmt, arg...)  printk(KERN_ERR "%s: " fmt "\n" , __func__ , ##
>> arg)
>> #define BT_DBG(fmt, arg...)  pr_debug("%s: " fmt "\n" , __func__ , ## arg)
>
> I would clearly second this. Switching the Bluetooth subsystem to
> dynamic debug made so many things so much easier. And using a macro like
> NFC_DBG makes it pretty nice and clean.

That's definitively a good idea. I'll change that.

Aloisio
