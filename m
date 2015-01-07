Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:65534 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbbAGNfn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 08:35:43 -0500
Received: by mail-wi0-f176.google.com with SMTP id ex7so7498563wid.15
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2015 05:35:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1420541693.1966.17.camel@sipsolutions.net>
References: <1420112563-3981-1-git-send-email-arik@wizery.com> <1420541693.1966.17.camel@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 7 Jan 2015 15:35:26 +0200
Message-ID: <CA+XVXfd+qhQh31LuSkdLvrrAUM6N6Z26rZU+ZXOBW8oij4vsWw@mail.gmail.com> (sfid-20150107_143546_027589_B62B7458)
Subject: Re: [PATCH 1/2] cfg80211: introduce sync regdom set API for self-managed
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 6, 2015 at 12:54 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2015-01-01 at 13:42 +0200, Arik Nemtsov wrote:
>> A self-managed device will sometimes need to set its regdomain synchronously.
>> Notably it should be set before usermode has a chance to query it. Expose
>> a new API to accomplish this which requires the RTNL.
>
>> +     ret = regulatory_set_wiphy_regd(wiphy, rd);
>> +     if (ret)
>> +             return ret;
>
> It seems to me you should refactor that and avoid scheduling the work
> struct when you're going to run the necessary work below by hand.

Sounds good.

Arik
