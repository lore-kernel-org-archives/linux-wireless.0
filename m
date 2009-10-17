Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:57050 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbZJQJkf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2009 05:40:35 -0400
Received: by iwn8 with SMTP id 8so1519957iwn.33
        for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2009 02:40:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1255685492.4095.309.camel@johannes.local>
References: <1255481442-27130-1-git-send-email-lrodriguez@atheros.com>
	<1255562895.4095.297.camel@johannes.local> <20091014233528.GA4172@tux>
	<1255685492.4095.309.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sat, 17 Oct 2009 02:40:20 -0700
Message-ID: <43e72e890910170240m2e2131ebl82cefc6654b5587f@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix SME warning by removing stale BSS upon
	assoc failure
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ic.felix@gmail.com" <ic.felix@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 16, 2009 at 2:31 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2009-10-14 at 16:35 -0700, Luis R. Rodriguez wrote:
>
>> Well sure, but why do we want to keep the authentication present if
>> association failed? And as a matter of fact it lingers there forever.
>> Is that desired behaviour?
>
> Yes, well, the SME is supposed to clean it up or try the association
> again (possibly with different parameters in the IEs, e.g. different WPA
> settings). The cfg80211 SME certainly does so (it deauthenticates).

Ok so that's what's busted then it seems.

  Luis
