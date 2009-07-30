Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f183.google.com ([209.85.211.183]:44756 "EHLO
	mail-yw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbZG3OzB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 10:55:01 -0400
Received: by ywh13 with SMTP id 13so728656ywh.15
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 07:55:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1248939781.8925.2.camel@johannes.local>
References: <1248914792-6010-1-git-send-email-lrodriguez@atheros.com>
	<1248914792-6010-3-git-send-email-lrodriguez@atheros.com>
	<1248939781.8925.2.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 30 Jul 2009 07:54:41 -0700
Message-ID: <43e72e890907300754v7ed8cb66w9b1bdbfe9917486c@mail.gmail.com>
Subject: Re: [PATCH 2/2] cfg80211: decouple regulatory variables from
	cfg80211_mutex
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 30, 2009 at 12:43 AM, Johannes
Berg<johannes@sipsolutions.net> wrote:
> On Wed, 2009-07-29 at 17:46 -0700, Luis R. Rodriguez wrote:
>> We change regulatory code to be protected by its own regulatory
>> spinlock and alleviate cfg80211_mutex to only be used to protect
>> cfg80211_rdev_list, the registered device list.
>>
>> By doing this we will be able to work on regulatory core components
>> without having to have hog up the cfg80211_mutex. An example here is
>> we no longer need to use the cfg80211_mutex during the country IE
>> regulatory hint; by doing so we end up curing this new lockdep warning:
>
> This is ok with me, but be sure that it changes the API between drivers
> and cfg80211 -- the reg notifier can no longer sleep now.

We could use a mutex as well.

  Luis
