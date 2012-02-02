Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:44623 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932106Ab2BBQGh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 11:06:37 -0500
Received: by mail-we0-f180.google.com with SMTP id l4so3319846wer.39
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 08:06:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F277F85.1090901@sipsolutions.net>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
	<1327581484-22047-4-git-send-email-victorg@ti.com>
	<4F277F85.1090901@sipsolutions.net>
Date: Thu, 2 Feb 2012 18:06:36 +0200
Message-ID: <CAK80WHbAE0+NhLgLAxE+6BmkHFy2hw=sNV1TBjjOTajhHcdxRw@mail.gmail.com> (sfid-20120202_170640_938821_B76BE1B7)
Subject: Re: [RFC 3/9] nl80211/cfg80211: add ability to enable TX on op-channel
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 31, 2012 at 7:43 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On 1/26/2012 4:37 AM, Victor Goldenshtein wrote:
>>
>> The dfs master device should monitor radar channels
>> for potential radar interference for a minimum of
>> CAC (channel availability check) time, during this
>> period no tx can occur. If no radar interference
>> is detected the dfs master may initiate the tx with
>> new NL80211_CMD_DFS_ENABLE_TX command.
>
>
> So do we think that no safeguards here at all are acceptable? Not even
> checking that radar detection was enabled, CAC time expired, etc.?

We can add a check whether dfs is supported by the driver
(rdev->wiphy.features & NL80211_FEATURE_DFS).

The nl/cfg/mac doesn't have the info whether the radar detection is
enabled and definitely doesn't heard about CAC time, on other hand the
driver which starts/handles radar detection know whether it started or
not. I think the driver should perform this simple "sanity" checks,
otherwise we"ll need to save different DFS states in the mac, not sure
that this is what we want.



-- 
Thanks,
Victor.
