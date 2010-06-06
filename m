Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65294 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab0FFJ3L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 05:29:11 -0400
Received: by vws5 with SMTP id 5so1900073vws.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jun 2010 02:29:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201006041025.08348.rossi.f@inwind.it>
References: <201006021129.43621.rossi.f@inwind.it> <AANLkTik0A8qhlIi1pjvo0DKXhxjBEYEwOCn6iIsLXFJi@mail.gmail.com>
	<201006041025.08348.rossi.f@inwind.it>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sun, 6 Jun 2010 02:28:50 -0700
Message-ID: <AANLkTim6tx9plm0tqqms64iUboSRxo9KnTGbHmwKrhQK@mail.gmail.com>
Subject: Re: WARNING: at drivers/base/core.c:130 device_release+0x82/0x90()
To: Fabio Rossi <rossi.f@inwind.it>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 4, 2010 at 1:25 AM, Fabio Rossi <rossi.f@inwind.it> wrote:
> On Wednesday 02 June 2010 23:42:14 Luis R. Rodriguez wrote:
>
>> On Wed, Jun 2, 2010 at 2:29 AM, Fabio Rossi <rossi.f@inwind.it> wrote:
>> > Compiling the kernel without ACPI (CONFIG_ACPI=n) gives the following
>> > warning:
>> >
>> > cfg80211: Calling CRDA to update world regulatory domain
>> > cfg80211: World regulatory domain updated:
>> >    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>> >    (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> > ath5k 0000:08:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
>> > ath5k 0000:08:01.0: registered as 'phy0'
>> > ath5k phy0: request_irq failed
>> > ------------[ cut here ]------------
>>
>> Since traces are printed reversed you will have to read my logic from
>> bottom to top:
>>
>> Seems we need to implement the dev_release() op for the class of our
>> devices.
>
> Shall I open a bug in kernel bugzilla to keep trace of this?

Nah something else is up...

struct class ieee80211_class = {
        .name = "ieee80211",
        .owner = THIS_MODULE,
        .dev_release = wiphy_dev_release,
        .dev_attrs = ieee80211_dev_attrs,
#ifdef CONFIG_HOTPLUG
        .dev_uevent = wiphy_uevent,
#endif
        .suspend = wiphy_suspend,
        .resume = wiphy_resume,
};
