Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.223.194]:36160 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab0ADQpG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2010 11:45:06 -0500
Received: by iwn32 with SMTP id 32so168437iwn.33
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jan 2010 08:45:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201001041737.06761.mb@bu3sch.de>
References: <1262622502-27698-1-git-send-email-lrodriguez@atheros.com>
	<201001041737.06761.mb@bu3sch.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 4 Jan 2010 08:38:54 -0800
Message-ID: <43e72e891001040838w1cc38f06k1a5ea934b6435461@mail.gmail.com>
Subject: Re: [RFC] cfg80211: add regulatory hint disconnect support
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 4, 2010 at 8:37 AM, Michael Buesch <mb@bu3sch.de> wrote:
> On Monday 04 January 2010 17:28:22 Luis R. Rodriguez wrote:
>
>> diff --git a/net/wireless/core.c b/net/wireless/core.c
>> index c2a2c56..ae58c6a 100644
>> --- a/net/wireless/core.c
>> +++ b/net/wireless/core.c
>> @@ -580,6 +580,7 @@ void wiphy_unregister(struct wiphy *wiphy)
>>
>>       flush_work(&rdev->scan_done_wk);
>>       cancel_work_sync(&rdev->conn_work);
>> +     cancel_work_sync(&rdev->conn_work);
>>       flush_work(&rdev->event_work);
>>  }
>
> twice?

Yeah sorry about that, I had added some other lines there but forgot
to clear all the stuff I had added, thanks.

  Luis
