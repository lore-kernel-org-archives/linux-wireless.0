Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:33203 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab3ARIv2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 03:51:28 -0500
Received: by mail-we0-f177.google.com with SMTP id x48so721595wey.22
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jan 2013 00:51:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <13A1CEB6-9E61-4F02-A273-5F45F40A5D2C@gmail.com>
References: <1358440472-26678-1-git-send-email-helmut.schaa@googlemail.com>
	<201301171816.15309.chunkeey@googlemail.com>
	<13A1CEB6-9E61-4F02-A273-5F45F40A5D2C@gmail.com>
Date: Fri, 18 Jan 2013 09:51:27 +0100
Message-ID: <CAGXE3d86-2bDmcZddU=3nFmhdoYsFf=Zis=50eeMXJz3DUG3yw@mail.gmail.com> (sfid-20130118_095133_588778_A99CCF2B)
Subject: Re: [PATCH] rt2x00: Improve TX status handling for BlockAckReq frames
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ivdoorn@gmail.com" <ivdoorn@gmail.com>,
	"stf_xl@wp.pl" <stf_xl@wp.pl>,
	"andihartmann@01019freenet.de" <andihartmann@01019freenet.de>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 17, 2013 at 7:42 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> On 17 jan. 2013, at 18:16, Christian Lamparter <chunkeey@googlemail.com> wrote:
>
>> On Thursday, January 17, 2013 05:34:32 PM Helmut Schaa wrote:
>>> Since rt2800 hardware isn't capable of reporting the TX status of
>>> BlockAckReq frames implement the TX status handling of BARs in
>>> rt2x00lib. We keep track of all BARs that are send out and try to
>>> match incoming BAs to the appropriate BARs. This allows us to report a
>>> more or less accurate TX status for BAR frames which in turn improves
>>> BA session stability.
>> ---
>> What about:
>>> commit 5b632fe85ec82e5c43740b52e74c66df50a37db3
>>> Author: Stanislaw Gruszka <sgruszka@redhat.com>
>>> Date:   Mon Dec 3 12:56:33 2012 +0100
>>> mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
>>
>> Should it be kept or dropped (as no driver uses it anymore?)
>
> I guess it should be dropped. I guess we could create a revert patch for that once this patch has been merged.

Agreed, if it's unused now I'm in favor of reverting it.
Helmut
