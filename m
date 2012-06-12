Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54314 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2FLTda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 15:33:30 -0400
Received: by obbtb18 with SMTP id tb18so8718599obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2012 12:33:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1339231815.4539.33.camel@jlt3.sipsolutions.net>
References: <1339122086-23190-1-git-send-email-ashok@cozybit.com>
 <1339122086-23190-3-git-send-email-ashok@cozybit.com> <1339231815.4539.33.camel@jlt3.sipsolutions.net>
From: Ashok Nagarajan <ashok@cozybit.com>
Date: Tue, 12 Jun 2012 12:33:10 -0700
Message-ID: <CACcxo+ptw_-fgnrROmQXBkRONLw_hwwuufgqK_rzDQa6Ge7xNQ@mail.gmail.com> (sfid-20120612_213334_665430_63D7C901)
Subject: Re: [PATCH 3/3] [nl,cfg,mac]80211: Allow user to configure basic
 rates when joining
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	javier@cozybit.com, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes,

On Sat, Jun 9, 2012 at 1:50 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2012-06-07 at 19:21 -0700, Ashok Nagarajan wrote:
>> Currently mesh uses mandatory rates as default basic rates. This patch
>> introduces basic rates to be configured at the time of joining mesh.
>
>> +     if (!sdata->vif.bss_conf.basic_rates)
>> +             sdata->vif.bss_conf.basic_rates =
>> +                     ieee80211_mandatory_rates(sdata, band);
>
> I think this default should come from cfg80211 instead, there's little
> point in imposing this calculation on all drivers that want to use mesh.
>

This default initialization uses the mac80211 utility function which
will not be accessible from cfg80211. Could you please explain what is
the advantage/purpose of imposing this calculation up in cfg80211.

Thank you,
Ashok
> johannes
>
