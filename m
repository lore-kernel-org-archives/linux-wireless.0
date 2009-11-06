Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:57738 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbZKFQoR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 11:44:17 -0500
Received: by iwn10 with SMTP id 10so911148iwn.4
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 08:44:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e890911060830k56f9cdcbi14a03b1389351197@mail.gmail.com>
References: <fd145f7d0911060004j55b06482tca088685d0626249@mail.gmail.com>
	<43e72e890911060821r2703c186lbb75c40b449b2c55@mail.gmail.com>
	<43e72e890911060830k56f9cdcbi14a03b1389351197@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 6 Nov 2009 08:44:02 -0800
Message-ID: <43e72e890911060844y44070ddek8e70469434161903@mail.gmail.com>
Subject: Re: Getting random regulatory domains on boot-up with ath9k
To: Jeffrey Baker <jwbaker@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 6, 2009 at 8:30 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Fri, Nov 6, 2009 at 8:21 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>
>>  * The fix for the regression would be to either use an alpha2 which
>> does have an entry and put that first in the array *or* (my
>> preference) to check first the alpha2 set on cfg80211 and see if that
>> maps to a country allowed by your region code and if so get cfg80211
>> to request that regulatory domain to CRDA.
>
> I just thought of another possible solution for region code stuff --
> just make them static world roaming regulatory domains. But to do this
> it means we'd enable the world roaming features on cfg80211 and
> channels which would typically be disabled would then just become
> passive-scan/no-ibss. I'd have to get buy-in through our internal
> regulatory guys first. This also seems like a clean solution but it
> would mean more static tables define for each major region code we
> have and I am not sure how many of those we have.

Oh and the other solution is to just add AW to db.txt with the same
mappings as any other country in the region code group.

I'll out line this in an e-mail followup, still reviewing what option to take.

  Luis
