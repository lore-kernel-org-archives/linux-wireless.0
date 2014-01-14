Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:52876 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaANIef (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 03:34:35 -0500
Received: by mail-ig0-f179.google.com with SMTP id c10so979810igq.0
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jan 2014 00:34:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87d2jvnf4l.fsf@purkki.adurom.net>
References: <CA+V6dmh7Udn96GG0XGaabx-t6ZViu1RGk-xTawa_KbnCdro9Ew@mail.gmail.com>
	<1389007385.5891.9.camel@jlt4.sipsolutions.net>
	<CA+V6dmjoLx90vEwGZa8vRNHp0yWqKQnae+GcvEZHsCxR-oHnhg@mail.gmail.com>
	<87k3e3nk7f.fsf@purkki.adurom.net>
	<CANq1E4SrMVmEyLA1J9kQA565AZHBvB=5C7r0GSuhoK6UO5OVkQ@mail.gmail.com>
	<87d2jvnf4l.fsf@purkki.adurom.net>
Date: Tue, 14 Jan 2014 09:34:35 +0100
Message-ID: <CANq1E4SPwC5rDE8MKEdjNscuZHNZkdiNJFbQC-hgJ_fGLvxYkA@mail.gmail.com> (sfid-20140114_093439_468766_721380E5)
Subject: Re: Exporting the TSF to userland
From: David Herrmann <dh.herrmann@gmail.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Pierre Bourdon <delroth@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Tue, Jan 14, 2014 at 9:26 AM, Kalle Valo <kvalo@adurom.com> wrote:
> David Herrmann <dh.herrmann@gmail.com> writes:
>
>>> Either nl80211 or debugfs. Maybe debugfs is better because this is more
>>> or less a hack?
>>
>> It's supposed to be a real interface used to calculate timestamps for
>> mpeg streams, iirc. So debugfs is no option here.
>
> And how is sysfs any better? If you use sysfs right now I don't see why
> debugfs would be any worse. You just need to check from your application
> that it's mounted and find the location.

We don't guarantee debugfs API stability across kernel-releases. At
least my experience is that debugfs is highly discouraged to be used
as stable API interface, except for debug-applications. Anyhow, if you
have different rules in ./net/mac80211, feel free to put it there. At
least it's better than having no interface at all.

Thanks
David
