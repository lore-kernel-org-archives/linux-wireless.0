Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:53993 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaFKIpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 04:45:49 -0400
Received: by mail-pd0-f175.google.com with SMTP id z10so7033151pdj.34
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 01:45:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53980647.2070600@broadcom.com>
References: <1402469724-22358-1-git-send-email-arik@wizery.com>
 <1402469724-22358-2-git-send-email-arik@wizery.com> <53980647.2070600@broadcom.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 11 Jun 2014 11:45:33 +0300
Message-ID: <CA+XVXfcU0rG7Qtchsjgp2yOYPng6oxDjPLQ3tpjKHurZTJCXOw@mail.gmail.com> (sfid-20140611_104553_955711_A6557B50)
Subject: Re: [PATCH 2/5] cfg80211: allow drivers to provide regulatory settings
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2014 at 10:33 AM, Arend van Spriel <arend@broadcom.com> wrote:
> On 11-06-14 08:55, Arik Nemtsov wrote:
>>
>> Define a new wiphy callback allowing drivers to provide regulatory
>> settings.
>>
>> Only The first wiphy registered with this callback will be able to provide
>> regulatory domain info. If such a wiphy exists, it takes precedence over
>> other data sources.
>
>
> I should probably dig through linux-wireless archive for background info,
> but how is this different from the wiphy_apply_custom_regulatory() call. Is
> this for devices that have a regulatory database of sorts in the device
> firmware?
>

Yea that's basically it. And we want the get the info dynamically from
FW upon country changes.

Arik
