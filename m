Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57966 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab0ECVUb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 17:20:31 -0400
Received: by fxm10 with SMTP id 10so2581298fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 May 2010 14:20:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <l2m6cf6b73e1005031410t7c6d3148x832ddd405fc482ec@mail.gmail.com>
References: <1272907549-25847-1-git-send-email-linville@tuxdriver.com>
	<87k4rkk9tz.fsf@purkki.valot.fi> <AANLkTimf_aZyUSZInOzUPZ8KRR6oDs3Re4pSGGn541fM@mail.gmail.com>
	<1272920504.4907.5.camel@mj> <l2m6cf6b73e1005031410t7c6d3148x832ddd405fc482ec@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 3 May 2010 23:20:10 +0200
Message-ID: <AANLkTinXzUpwE4cGifJmUHCzY1rz4AZEsu7eYjLxI28u@mail.gmail.com>
Subject: Re: [PATCH] iwlagn: Change the TPT calculations sanity-check to
	WARN_ON
To: Adel Gadllah <adel.gadllah@gmail.com>
Cc: Pavel Roskin <proski@gnu.org>, Kalle Valo <kvalo@adurom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, johill@sipsolutions.net,
	reinette.chatre@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 3, 2010 at 11:10 PM, Adel Gadllah <adel.gadllah@gmail.com> wrote:
> 2010/5/3 Pavel Roskin <proski@gnu.org>:
>> On Mon, 2010-05-03 at 22:48 +0200, Gábor Stefanik wrote:
>>
>>> One exception I can think of: major misconfiguration can cause a
>>> wireless device to DMA data into sensitive memory locations. When
>>> evidence of this is detected, it might make sense to BUG_ON()
>>> (especially if the bogus DMA operations can be exploited remotely to
>>> overwrite arbitrary memory addresses). However, in that case, the
>>> attacker may have already overwritten panic() with malicious code as
>>> well, so even this case doesn't hold.
>>
>> And then there is a case when encryption fails and there is a risk of
>> transmitting data without encryption or accepting data without
>> verification.
>
> So kill the connection rather than the whole system.

Or maybe just drop the packet, as mac80211 AFAIK usually does. Perhaps
print a WARN_ON to let developers know of the issue. But a BUG_ON is
still excessive - I can't think of any way a WARN_ON + interface down
may fail in preventing unencrypted data leak.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
