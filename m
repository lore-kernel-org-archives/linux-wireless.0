Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:64681 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab2KSXCR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 18:02:17 -0500
Received: by mail-wg0-f42.google.com with SMTP id fm10so1348170wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 15:02:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ-VmomL6g1LfTNsk6HPeKEySS57-646L6i9rcOT0V9cDK0b9w@mail.gmail.com>
References: <1352832488-21516-1-git-send-email-thomas@cozybit.com>
 <1353361141.18299.36.camel@jlt4.sipsolutions.net> <CAJ-VmomL6g1LfTNsk6HPeKEySS57-646L6i9rcOT0V9cDK0b9w@mail.gmail.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 19 Nov 2012 15:01:56 -0800
Message-ID: <CAG6hwVPVbyL+6HTUv+4=zNMvb4KSPMowXwbb1B2H5ugYBuo0gQ@mail.gmail.com> (sfid-20121120_000221_008985_89BD6BEB)
Subject: Re: [PATCH v2 1/2] ath9k: RX timestamp is reported at end of frame
To: Adrian Chadd <adrian@freebsd.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	ath9k-devel@lists.ath9k.org, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 19, 2012 at 2:32 PM, Adrian Chadd <adrian@freebsd.org> wrote:
> On 19 November 2012 13:39, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>> Before you repost though I think it would make sense to fix the
>> calculation issue that Simon pointed out on the radiotap list? I hope he
>> comes up with some code though as I'm not good enough at bitrate
>> calculations :-)
>
> What was his comment?

Since it's not on gmane yet:

"Unfortunately this patch does not do a very accurate calculation, so
it makes the problem worse. It simply multiplies rate by the number of
bits to get a time. This does not take into account the limited
accuracy in rate (11n has fractional rates), nor does it consider the
rounding into blocks caused by FEC, or symbols. As a result the data
is made worse by the current code. Either the code should do an
accurate fix, or it should record the raw value and let the end user
correct it properly."

---

Thomas
