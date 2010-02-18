Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f194.google.com ([209.85.222.194]:58436 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab0BRU1j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 15:27:39 -0500
Received: by pzk32 with SMTP id 32so499420pzk.4
        for <linux-wireless@vger.kernel.org>; Thu, 18 Feb 2010 12:27:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <878waqgvv8.fsf@purkki.valot.fi>
References: <1266437114.23447.0.camel@jlt3.sipsolutions.net>
	<1266447118.12365.21.camel@mj> <1266494831.6261.1.camel@jlt3.sipsolutions.net>
	<201002181541.45835.holgerschurig@gmail.com> <1266504527.6261.2.camel@jlt3.sipsolutions.net>
	<878waqgvv8.fsf@purkki.valot.fi>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 18 Feb 2010 12:27:18 -0800
Message-ID: <43e72e891002181227n1420fa5esc7e19d57bdf41876@mail.gmail.com>
Subject: Re: [PATCH v3] mac80211: deprecate RX status noise
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Holger Schurig <holgerschurig@gmail.com>,
	linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 18, 2010 at 11:57 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>
>>> I'm not saying that I understand this completely, but for me it
>>> would make sense to disable iwlwifi's broken noise reporting
>>> only. No reason to disable it for everyone if some of them are
>>> broken.
>>
>> Well it's kinda bound to be broken elsewhere too because we don't even
>> know how various devices gather the values. With iwlwifi at least we
>> know how it gets the value.
>
> Also wl1251 is more or less broken related to noise reporting. I even
> tried to find information how to use it properly but didn't get
> anything.

For Atheros its only busted since we don't distinguish noise per
channel, but otherwise I can't think of anything bogus about it. Last
time I looked into how its computed is it was calculated during SIFS
time, but that was a while back and based on some patent stuff.

 Luis
