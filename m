Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53087 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892Ab1KHWbp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 17:31:45 -0500
Received: by iage36 with SMTP id e36so1058617iag.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 14:31:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1320790500.23056.0.camel@jlt3.sipsolutions.net>
References: <1299609930-14011-1-git-send-email-scott@netsplit.com> <1320790500.23056.0.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 8 Nov 2011 14:31:24 -0800
Message-ID: <CAB=NE6VxED4+-YshhJbO1S-i-Yg646zCN-2PyiP1Ztt4c54yOw@mail.gmail.com> (sfid-20111108_233149_370417_7A4ECFDF)
Subject: Re: [PATCH] net/wireless: add COUNTRY to to regulatory device uevent
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Scott James Remnant <scott@netsplit.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Sam Leffler <sleffler@chromium.org>, keybuk@google.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 8, 2011 at 2:15 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2011-03-08 at 10:45 -0800, Scott James Remnant wrote:
>> From: Scott James Remnant <keybuk@google.com>
>>
>> Regulatory devices issue change uevents to inform userspace of a need
>> to call the crda tool; however these can often be sent before udevd is
>> running, and were not previously included in the results of
>> udevadm trigger (which requests a new change event using the /uevent
>> attribute of the sysfs object).
>>
>> Add a uevent function to the device type which includes the COUNTRY
>> information from the last request if it has yet to be processed, the
>> case of multiple requests is already handled in the code by checking
>> whether an unprocessed one is queued in the same manner and refusing
>> to queue a new one.
>>
>> The existing udev rule continues to work as before.
>
> Luis points out that it looks like this caused the crash I reported
> earlier today -- in the module exit path we have a use-after-free of
> last_request now.

Sent patch.

  Luis
