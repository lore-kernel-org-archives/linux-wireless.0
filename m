Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:32977 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbYJVM2Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 08:28:16 -0400
Received: by yx-out-2324.google.com with SMTP id 8so533534yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 05:28:15 -0700 (PDT)
Message-ID: <1ba2fa240810220528w6b2e4e60k7d2390328d9b5c49@mail.gmail.com> (sfid-20081022_142821_216455_BD18E072)
Date: Wed, 22 Oct 2008 14:28:14 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: New iwlwifi 3945 uCode available
Cc: "reinette chatre" <reinette.chatre@linux.intel.com>,
	"Marcel Holtmann" <holtmann@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20081022100758.GA27595@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1224613633.10863.43.camel@rc-desk>
	 <1224624324.28639.9.camel@johannes.berg>
	 <1ba2fa240810211433q2e7a13b2p45cb8d38a74393c9@mail.gmail.com>
	 <1224624899.28639.17.camel@johannes.berg>
	 <20081021213814.GM17268@tuxdriver.com>
	 <1ba2fa240810211453y40739183v84999364c89886ee@mail.gmail.com>
	 <1224627187.9386.103.camel@californication>
	 <1224628088.10863.100.camel@rc-desk>
	 <20081022100758.GA27595@infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 22, 2008 at 12:07 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Oct 21, 2008 at 03:28:08PM -0700, reinette chatre wrote:
>> I do not believe our request is unreasonable. If a user runs a new
>> kernel the log will print a message that the firmware is incorrect ...
>> all the user needs to do is go to
>> http://intellinuxwireless.org/?n=Downloads and download the latest
>> firmware. This does not require any subtle changes that may affect other
>> aspects of the system ... just the firmware file that is only used by
>> the driver.
>
> with the wireless that doesn't work.  Nice.  Sorry guys, but requiring
> a new firmware version for a new driver release is completely
> unreasonable.  You can drop support for older firmware ABIs after a few
> years,but not immediately.

Years.. this HW will be obsolete in year or two, hopefully recycled.
I personally don't want people using this buggy firmware for years.

This is development branch after all, it's not even scheduled for 2.6.28.

Ucode API for 4965 was changed to -2 without much pain, So there is a
precedence this work quite well. This time there were some hiccups in
handling this since the API version wasn't updated it as should be.
really our fault. But I don't think this situation is so dramatic as
you describe it.

The objective of the objections is not that we want to immensely hurt
users but rather the trade off between maintain even uglier code and
users running buggy firmware versus logging into older kernel and
downloading new firmware in 5 minutes looks to me not proportional.
Distro users that pull updates won't even notice. I might be wrong
though.

Tomas
