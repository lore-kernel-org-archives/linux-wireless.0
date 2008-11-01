Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:11336 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbYKAQGr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 12:06:47 -0400
Received: by qw-out-2122.google.com with SMTP id 3so772408qwe.37
        for <linux-wireless@vger.kernel.org>; Sat, 01 Nov 2008 09:06:45 -0700 (PDT)
Message-ID: <69e28c910811010906y1ab8ea6ydf43671a73eae9@mail.gmail.com> (sfid-20081101_170655_546978_CD6CD631)
Date: Sat, 1 Nov 2008 17:06:45 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Michael MIC failures in AP mode?
Cc: "Jouni Malinen" <j@w1.fi>, "Kalle Valo" <kalle.valo@nokia.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1225554697.3619.13.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <87wsfnldq9.fsf@nokia.com> <20081101151938.GA4857@jm.kir.nu>
	 <1225554697.3619.13.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 1, 2008 at 4:51 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sat, 2008-11-01 at 17:19 +0200, Jouni Malinen wrote:
>
>> Anyway, if you just want to test Michael MIC error processing on a
>> client, force mac80211 to do software encryption
>
> On that matter, should we put a debugfs control knob in place to
> completely disable HW encryption in mac80211, so we don't need this
> override in all drivers?
>
> johannes
>

Good idea.

Also, we might want to auto-disable HW encryption on a PHY that has
one of the following configurations:
-both station and AP interfaces on a single PHY with different
encryption on the station and the AP (do we already do this?)
-only a monitor interface present
-(possibly) multiple monitor interfaces on the same PHY

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
