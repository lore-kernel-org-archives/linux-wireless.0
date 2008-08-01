Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:29386 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbYHATZJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 15:25:09 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1214407rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 01 Aug 2008 12:25:08 -0700 (PDT)
Message-ID: <1ba2fa240808011225t50ab9e5am841ebd2305e35687@mail.gmail.com> (sfid-20080801_212514_326268_EC23A3B4)
Date: Fri, 1 Aug 2008 22:25:08 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: add direct probe before association
Cc: "John W. Linville" <linville@tuxdriver.com>, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1217613965.8621.48.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1216076865-9826-1-git-send-email-tomas.winkler@intel.com>
	 <20080801173044.GB14974@tuxdriver.com>
	 <1217613965.8621.48.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 1, 2008 at 9:06 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2008-08-01 at 13:30 -0400, John W. Linville wrote:
>> On Tue, Jul 15, 2008 at 02:07:45AM +0300, Tomas Winkler wrote:
>> > This patch adds a direct probe request as first step in the association
>> > flow. Motivation of this step is to make sure that the bss information
>> > we have is up to date, since last scan could have been done a while ago.
>> > beacons do not fully answer this need as there are potential differences
>> > between them and probe responses (e.g. WMM parameter element)
>> >
>> > Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
>> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>>
>> Does this fix a bug?  Seems likely...
>
> Could, if the AP changes something since we've last scanned, and we
> probably want to do this anyway.

This patch has a bug, not all  APs  answer direct packet in
unassociated state I will post another version.
Tomas
