Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:17585 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbYK0JbK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2008 04:31:10 -0500
Received: by ug-out-1314.google.com with SMTP id 39so1645186ugf.37
        for <linux-wireless@vger.kernel.org>; Thu, 27 Nov 2008 01:31:08 -0800 (PST)
Message-ID: <eb3ff54b0811270131k7348b031j642fde5219ace758@mail.gmail.com> (sfid-20081127_103115_892667_54423101)
Date: Thu, 27 Nov 2008 11:31:08 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] zd1211rw: enable an AP that can't support fully PS clients (wireless-testing).
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org, j@w1.fi,
	"Daniel Drake" <dsd@gentoo.org>
In-Reply-To: <1227776790.3809.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <eb3ff54b0811232344t665fe6abp9ca2be85cfcbd855@mail.gmail.com>
	 <1227522918.3599.63.camel@johannes.berg>
	 <eb3ff54b0811240309u31944469xa444ee25f8ac8496@mail.gmail.com>
	 <1227525694.3599.95.camel@johannes.berg>
	 <eb3ff54b0811240338t7b11a1bam669f1ffa841a5e87@mail.gmail.com>
	 <1227776790.3809.5.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
  - Thanks a lot for this info!

  - I will adjust my patch accordingly and preform tests to see that
multicast buffering works properly.

Regards,
Rami Rosen


On Thu, Nov 27, 2008 at 11:06 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-11-24 at 13:38 +0200, Rami Rosen wrote:
>> Hello,
>>   I indeed intend to fix the driver to do the buffering and use
>> _get_buffered_bc() (and also add sequence numbering, which is easier).
>
> Sequence numbers are provided by the firmware, I think? At least beacons
> do have sequence numbers.
>
> Anyway, so I got some information, to fix this use _get_buffered_bc()
> when in zd_process_intr you get INT_CFG_NEXT_BCN; but this indicates
> that the beacon has _just_ been sent so you need to use _get_beacon()
> *after* _get_buffered_bc().
>
> johannes
>
