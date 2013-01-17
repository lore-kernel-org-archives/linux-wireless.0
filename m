Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:65148 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3AQSm5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2013 13:42:57 -0500
Received: by mail-ea0-f169.google.com with SMTP id d13so1172902eaa.28
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jan 2013 10:42:55 -0800 (PST)
References: <1358440472-26678-1-git-send-email-helmut.schaa@googlemail.com> <201301171816.15309.chunkeey@googlemail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <201301171816.15309.chunkeey@googlemail.com>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <13A1CEB6-9E61-4F02-A273-5F45F40A5D2C@gmail.com> (sfid-20130117_194259_868701_9A36E70D)
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ivdoorn@gmail.com" <ivdoorn@gmail.com>,
	"stf_xl@wp.pl" <stf_xl@wp.pl>,
	"andihartmann@01019freenet.de" <andihartmann@01019freenet.de>,
	Stanislaw Gruszka <sgruszka@redhat.com>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: Improve TX status handling for BlockAckReq frames
Date: Thu, 17 Jan 2013 19:42:52 +0100
To: Christian Lamparter <chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Sent from my iPad

On 17 jan. 2013, at 18:16, Christian Lamparter <chunkeey@googlemail.com> wrote:

> On Thursday, January 17, 2013 05:34:32 PM Helmut Schaa wrote:
>> Since rt2800 hardware isn't capable of reporting the TX status of
>> BlockAckReq frames implement the TX status handling of BARs in
>> rt2x00lib. We keep track of all BARs that are send out and try to
>> match incoming BAs to the appropriate BARs. This allows us to report a
>> more or less accurate TX status for BAR frames which in turn improves
>> BA session stability.
> ---
> What about:
>> commit 5b632fe85ec82e5c43740b52e74c66df50a37db3
>> Author: Stanislaw Gruszka <sgruszka@redhat.com>
>> Date:   Mon Dec 3 12:56:33 2012 +0100
>> mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
> 
> Should it be kept or dropped (as no driver uses it anymore?)

I guess it should be dropped. I guess we could create a revert patch for that once this patch has been merged.

---
Gertjan